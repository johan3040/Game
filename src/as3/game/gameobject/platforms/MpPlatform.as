package as3.game.gameobject.platforms{
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import as3.game.gameobject.player.Cannibal;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.FlagBlue;
	import assets.gameObjects.FlagFirework;
	import assets.gameObjects.FlagPole;
	import assets.gameObjects.FlagRed;
	import assets.gameObjects.FlagWhite;
	import assets.gameObjects.OrgPlatLock;
	
	import se.lnu.stickossdk.fx.Effect;
	import se.lnu.stickossdk.fx.Shake;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	public class MpPlatform extends OriginalPlatform{
		
		public var lockedPlat:OrgPlatLock;
		public var visitors:Vector.<Player>;
		
		private var flagPole:FlagPole;
		private var flagBlue:FlagBlue;
		private var flagWhite:FlagWhite;
		private var flagRed:FlagRed;
		private var firework:FlagFirework;
		private var currentFlag:MovieClip;
		private var flagVector:Vector.<MovieClip>;
		private var owner:Player;
		private var currentPlayer:Player;
		private var percentOwned:Number = 100;
		private var givenPoint:Boolean = false;
		private var lockdown:Boolean = false;
		private var lockdownTimer:Timer;
		private var lockdownTimerActive:Boolean = false;
		private var lockdownShake:Effect;
		private var flagTimer:Timer;
		
		[Embed(source = "../../../../../assets/audio/LockdownAUmp3.mp3")] 	// <-- this data..
		private const LOCKDOWN_AUDIO:Class;					// ..gets saved in this const
		protected var lockdownAudio:SoundObject;
		
		[Embed(source = "../../../../../assets/audio/PointAU.mp3")] 	// <-- this data..
		private const POINT_AUDIO:Class;					// ..gets saved in this const
		protected var pointAudio:SoundObject;
		
		/**
		 * 
		 * Class contructor
		 * 
		 * @param Array (coordinates of position)
		 * 
		 */
		public function MpPlatform(pos:Array){
			super(pos);
			this.flagVector = 	new Vector.<MovieClip>;
			this.visitors = 	new Vector.<Player>;
			this.initFlagPole();
			this.initFlags();
			this.initFirework();
			this.initAudio();
			this.initLockedPlat();
		}
		
		/**
		 * 
		 * Initializes flag pole graphics
		 * 
		 */
		private function initFlagPole():void{
			this.flagPole = new FlagPole();
			this.flagPole.x = this.obj_width/2;
			this.flagPole.y -= this.flagPole.height;
			addChild(this.flagPole);
		}
		
		/**
		 * 
		 * Adds all 3 flags to Vector
		 * 
		 */
		private function initFlags():void{
			this.flagBlue = new FlagBlue();
			this.flagRed = new FlagRed();
			this.flagWhite = new FlagWhite();
			this.flagVector.push(this.flagBlue);
			this.flagVector.push(this.flagWhite);
			this.flagVector.push(this.flagRed);
			this.positionFlags();
		}
		
		/**
		 * 
		 * Adds firework animation
		 * 
		 * Sets visibility to false
		 * 
		 */
		private function initFirework():void{
			this.firework = new FlagFirework();
			this.firework.y = -100;
			this.firework.x = 30;
			addChild(this.firework);
			this.firework.stop();
			this.firework.visible = false;
		}
		
		/**
		 * 
		 * Initializes class's audio
		 * 
		 */
		private function initAudio():void{
			Session.sound.soundChannel.sources.add("lockdown", LOCKDOWN_AUDIO);
			this.lockdownAudio = Session.sound.soundChannel.get("lockdown", true, true);
			Session.sound.soundChannel.sources.add("point", POINT_AUDIO);
			this.pointAudio = Session.sound.soundChannel.get("point", true, false);
		}
		
		
		/**
		 * 
		 * Adds platform graphics
		 * 
		 */
		private function initLockedPlat():void{
			this.lockedPlat = new OrgPlatLock();
			this.lockedPlat.visible = false;
			addChild(this.lockedPlat);
		}
		
		/**
		 * 
		 * Sets startposition for flags
		 * 
		 */
		private function positionFlags():void{
			
			for(var i:int = 0; i<this.flagVector.length; i++){
				this.flagVector[i].x = 25;
				this.flagVector[i].y = -60;
				this.flagVector[i].visible = false;
				addChild(this.flagVector[i]);
			}
			this.initStartFlag();
		}
		
		/**
		 * 
		 * Starting flag of every game (flagWhite) is set to visible
		 * 
		 */
		private function initStartFlag():void{
			this.currentFlag = this.flagWhite;
			this.currentFlag.visible = true;
		}
		
		/**
		 * 
		 * Callback when a player collides with platform
		 * 
		 * @param Player
		 * 
		 */
		public function playerOnPlat(player:Player):void{
			var i:int = this.visitors.indexOf(player);
			if(i == -1){
				this.visitors.push(player);
			}
		}
		
		/**
		 * 
		 * Game update loop
		 * 
		 */
		override public function update():void{
			this.checkFirework();
			this.checkPlayers();
		}
		
		/**
		 * 
		 * Sets visibility to false when firework animation is complete
		 * 
		 */
		private function checkFirework():void{
			if(this.firework.currentFrame == this.firework.totalFrames){
				this.firework.gotoAndStop(1);
				this.firework.visible = false;
			}
		}
		
		/**
		 * 
		 * Calls methods depending on how many players is on the platform
		 * 
		 */
		private function checkPlayers():void{
			if(this.visitors.length == 1 && this.lockdown == false){
				this.takePlatformAction();
			}else if(this.visitors.length == 2){
				this.checkMultipleVisitors();
			}
		}
		
		/**
		 * 
		 * Method when platform only has one current player
		 * 
		 */
		private function takePlatformAction():void{
			this.currentPlayer = this.visitors[0];
			if(this.owner != this.currentPlayer){
				if(this.lockdownTimer != null) this.stopTimer();
				this.countDown();
			}
			if(this.owner == this.currentPlayer && this.percentOwned < 100){
				this.countUp();
			}
			if(this.owner == this.currentPlayer && this.lockdownTimer != null && this.percentOwned == 100){
				if(this.lockdownTimer.active == false){
					this.startLockdownTimer();
				}
			}
		}
		
		/**
		 * 
		 * Method when two players are on plat
		 * 
		 */
		private function checkMultipleVisitors():void{
			if(	this.lockdownTimer != null 		&& 
				this.lockdown == false 			&&
				(this.visitors[0] != this.owner 	|| 
				this.visitors[1] != this.owner)){
				
					if(this.lockdownTimer) this.stopTimer();
			}
		}
		
		/**
		 * 
		 * Counts owned percentage down
		 * 
		 */
		private function countDown():void{
			if(this.currentPlayer.frozen == false){
				this.percentOwned-=2.5;
				if(this.percentOwned <= 0) return this.flagReachedBottom();
				this.moveFlags();
			}
		}
		
		private function flagReachedBottom():void{
			this.percentOwned = 0;
			if(this.owner != this.currentPlayer && 
				this.owner != null 				&& 
				this.percentOwned == 0 			&& 
				this.givenPoint==true){
				
				this.owner.numFlags--;
				
			}
			this.owner = this.currentPlayer;
			this.givenPoint = false;
			this.changeFlag();
			this.countUp();
		}
		
		private function countUp():void{
			if(this.currentPlayer.frozen == false){
				this.percentOwned+=2.5;
				if(this.percentOwned >= 100) return this.givePoint();
				this.moveFlags();
			}
		}
		
		private function givePoint():void{
			this.pointAudio.play();
			this.lockdownTimerActive = true;
			this.percentOwned = 100;
			if(this.givenPoint == false) this.currentPlayer.numFlags++;
			this.givenPoint = true;
			this.playFirework();
			this.startLockdownTimer();
		}
		
		//------------------------------------
		// Lockdown methods
		//------------------------------------
		private function lockItDown():void{
			this.lockdown = true;
			this.platform.visible = false;
			this.lockedPlat.visible = true;
			this.lockdownAudio.play(0);
			this.lockdownEffect();
		}
		
		private function startLockdownTimer():void{
			this.lockdownTimer = Session.timer.create(6000,this.lockItDown,0,true);
		}
		
		private function stopTimer():void{
			
			if(this.lockdownTimerActive == true){
				this.lockdownTimer.stop();
				this.lockdownTimerActive = false;
			}
		}
		
		private function lockdownEffect():void{
			var effect:Point = new Point(3,3);
			var endPos:Point = new Point(0,0);
			this.lockdownShake = Session.effects.add(new Shake(this.lockedPlat, 600, effect, endPos));
		}
		
		//------------------------------------
		// End lockdown methods
		//------------------------------------
		
		private function moveFlags():void{
			for(var i:int = 0; i<this.flagVector.length; i++){
				this.flagVector[i].y = -60 +(50-(this.percentOwned*0.5));
			}
		}
		
		private function changeFlag():void{
			if(this.currentPlayer is Explorer) this.setCorrectVisibleFlag(this.flagBlue);
			if(this.currentPlayer is Cannibal) this.setCorrectVisibleFlag(this.flagRed);
		}
		
		private function setCorrectVisibleFlag(flag:MovieClip):void{
			for(var i:int = 0; i<this.flagVector.length; i++){
				if(this.flagVector[i] != flag) this.flagVector[i].visible = false;
				else{
					this.flagVector[i].visible = true;
				}
			}
		}
		
		public function visitorLeft(player:Player):void{	
			var i:int = this.visitors.indexOf(player);
			if(i != -1)	this.visitors.splice(i,1);
		}
		
		private function playFirework():void{
			this.firework.visible = true;
			this.firework.play();
		}
		
		public function resetFlag():void{
			this.owner = null;
			this.currentPlayer = null;
			this.percentOwned = 100;
			this.givenPoint = false;
			this.lockdown = false;
			if(this.lockdownTimer) this.lockdownTimer.stop();
			if(this.flagTimer) this.flagTimer.stop();
			this.lockdownAudio.dispose();
			this.resetVisitors();
			this.firework.gotoAndStop(1);
			this.firework.visible = false;
			this.positionFlags();
		}
		
		private function resetVisitors():void{
			for(var i:int = 0; i<this.visitors.length; i++){
				this.visitors.splice(i, 1);
			}
		}
		
		override public function dispose():void{
			this.flagPole = null;
			this.flagBlue = null;
			this.flagWhite = null;
			this.flagRed = null;
			this.firework = null;
			this.currentFlag = null;
			this.flagVector = null;
			this.visitors = null;
			this.owner = null;
			this.currentPlayer = null;
			this.lockdownShake = null;
			this.flagTimer = null;
			this.lockdownTimer = null;
		}
		
	}
}