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
		
		private var flagPole:FlagPole;
		private var flagBlue:FlagBlue;
		private var flagWhite:FlagWhite;
		private var flagRed:FlagRed;
		private var firework:FlagFirework;
		private var currentFlag:MovieClip;
		private var flagVector:Vector.<MovieClip>;
		public var visitors:Vector.<Player>;
		private var owner:Player;
		private var currentPlayer:Player;
		private var percentOwned:Number = 100;
		private var go:Boolean;
		private var givenPoint:Boolean = false;
		
		private var lockdown:Boolean = false;
		private var lockdownTimer:Timer;
		private var lockdownShake:Effect;
		
		private var flagTimer:Timer;
		
		[Embed(source = "../../../../../assets/audio/LockdownAUmp3.mp3")] 	// <-- this data..
		private const LOCKDOWN_AUDIO:Class;					// ..gets saved in this const
		protected var lockdownAudio:SoundObject;
		
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
		
		private function initFlagPole():void{
			this.flagPole = new FlagPole();
			this.flagPole.x = this.obj_width/2;
			this.flagPole.y -= this.flagPole.height;
			addChild(this.flagPole);
		}
		
		private function initFlags():void{
			this.flagBlue = new FlagBlue();
			this.flagRed = new FlagRed();
			this.flagWhite = new FlagWhite();
			this.flagVector.push(this.flagBlue);
			this.flagVector.push(this.flagWhite);
			this.flagVector.push(this.flagRed);
			this.positionFlags();
		}
		
		private function initFirework():void{
			this.firework = new FlagFirework();
			this.firework.y = -100;
			this.firework.x = 30;
			addChild(this.firework);
			this.firework.stop();
			this.firework.visible = false;
		}
		
		private function initAudio():void{
			Session.sound.soundChannel.sources.add("lockdown", LOCKDOWN_AUDIO);
			this.lockdownAudio = Session.sound.soundChannel.get("lockdown", true, true);
		}
		
		private function initLockedPlat():void{
			this.lockedPlat = new OrgPlatLock();
			this.lockedPlat.visible = false;
			addChild(this.lockedPlat);
		}
		
		private function positionFlags():void{
			
			for(var i:int = 0; i<this.flagVector.length; i++){
				this.flagVector[i].x = 25;
				this.flagVector[i].y = -60;
				this.flagVector[i].visible = false;
				addChild(this.flagVector[i]);
			}
			this.initStartFlag();
		}
		
		private function initStartFlag():void{
			this.currentFlag = this.flagWhite;
			this.currentFlag.visible = true;
		}
		
		public function playerOnPlat(player:Player):void{
			var i:int = this.visitors.indexOf(player);
			if(i == -1){
				this.visitors.push(player);
				this.checkVisitors(player);
			}
			
		}
		
		private function checkVisitors(player:Player):void{
			
			if(this.visitors.length == 1 && this.lockdown == false){
				this.go = true;
				this.currentPlayer = player;
				this.checkLockdownTimer();
				if(this.owner != this.currentPlayer){
					//this.flagTimer = this.startTimer(this.countDown);
					this.countDown();
				}
				if(this.owner == this.currentPlayer && this.percentOwned < 100){
					//this.flagTimer = this.startTimer(this.countUp);
					this.countUp();
				}
			}else{
				this.go = false;
				if(this.lockdownTimer != null) this.lockdownTimer.stop();
				if(this.flagTimer != null) this.flagTimer.stop();
			}
			
		}
		
		private function startTimer(f:Function):Timer{
			return Session.timer.create(32,f,0,true);			
		}
		
		private function countDown():void{
			if(this.go && this.currentPlayer.frozen == false){
				this.percentOwned-=5;
				if(this.percentOwned <= 0) return this.flagReachedBottom();
				this.moveFlags();
				this.flagTimer = this.startTimer(this.countDown);
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
			if(this.go && this.currentPlayer.frozen == false){
				this.percentOwned+=5;
				if(this.percentOwned >= 100) return this.givePoint();
				this.moveFlags();
				this.flagTimer = this.startTimer(this.countUp);
			}
		}
		
		private function givePoint():void{
			this.percentOwned = 100;
			if(this.givenPoint == false) this.currentPlayer.numFlags++;
			this.givenPoint = true;
			this.playFirework();
			this.startLockdownCounter();
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
		
		private function checkLockdownTimer():void{
			if(this.lockdownTimer && this.currentPlayer != this.owner){
				this.stopTimer();
			}else if(this.lockdownTimer && this.currentPlayer == this.owner){
				this.lockdownTimer.start();
			}
		}
		
		private function startLockdownCounter():void{
			this.lockdownTimer = Session.timer.add(new Timer(6000, this.lockItDown, 0),true);
			//this.lockdownTimer.start();
		}
		
		private function stopTimer():void{
			this.lockdownTimer.removeCurrentTimer();
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
			
			if(i != -1){
				
				this.visitors.splice(i,1);
			
				if(this.visitors.length == 1){
					this.checkVisitors(this.visitors[0]);
				}else{
					this.go = false;
				}
			}
		}
		
		private function playFirework():void{
			this.firework.visible = true;
			this.firework.play();
		}
		
		override public function update():void{
			this.checkFirework();
			
		}
		
		private function checkFirework():void{
			if(this.firework.currentFrame == this.firework.totalFrames){
				this.firework.gotoAndStop(1);
				this.firework.visible = false;
			}
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