package as3.game.gameobject.platforms{
	
	import flash.display.MovieClip;
	
	import as3.game.gameobject.player.Cannibal;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.FlagBlue;
	import assets.gameObjects.FlagFirework;
	import assets.gameObjects.FlagPole;
	import assets.gameObjects.FlagRed;
	import assets.gameObjects.FlagWhite;
	
	import se.lnu.stickossdk.system.Session;
	
	public class MpPlatform extends OriginalPlatform{
		
		private var flagPole:FlagPole;
		private var flagBlue:FlagBlue;
		private var flagWhite:FlagWhite;
		private var flagRed:FlagRed;
		private var firework:FlagFirework;
		private var currentFlag:MovieClip;
		private var flagVector:Vector.<MovieClip>;
		private var visitors:Vector.<Player>;
		private var owner:Player;
		private var currentPlayer:Player;
		private var percentOwned:int = 100;
		private var go:Boolean;
		
		public function MpPlatform(pos:Array){
			super(pos);
			this.flagVector = 	new Vector.<MovieClip>;
			this.visitors = 	new Vector.<Player>;
			this.initFlagPole();
			this.initFlags();
			this.initFirework();
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
		
		private function positionFlags():void{
			
			for(var i:int = 0; i<this.flagVector.length; i++){
				this.flagVector[i].x = 25;
				this.flagVector[i].y = -68;
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
			this.visitors.push(player);
			this.checkVisitors(player);
		}
		
		private function checkVisitors(player:Player):void{
			if(this.visitors.length == 1){
				this.go = true;
				this.currentPlayer = player;
				if(this.owner != this.currentPlayer) this.startTimer(this.countDown);
				if(this.owner == this.currentPlayer && this.percentOwned < 100) this.startTimer(this.countUp);
			}else{
				this.go = false;
			}
		}
		
		private function startTimer(f:Function):void{
			Session.timer.create(40, f);
		}
		
		private function countDown():void{
			if(this.go && this.currentPlayer.frozen == false){
				if(this.owner != this.currentPlayer && this.owner != null && this.percentOwned == 0){
					this.owner.numFlags--;
				}
				if(this.percentOwned > 0){
					this.percentOwned-=5;
					this.moveFlagsDown();
					startTimer(this.countDown);
					return;
				}
				this.owner = this.currentPlayer;
				this.changeFlag();
				startTimer(this.countUp);
			}
		}
		
		private function countUp():void{
			if(this.go && this.currentPlayer.frozen == false){
				if(this.percentOwned < 100){
					this.percentOwned+=5;
					this.moveFlagsUp();
					startTimer(this.countUp);
					return;
				}
				this.currentPlayer.numFlags++;
				this.playFirework();
			}
		}
		
		private function moveFlagsDown():void{
			for(var i:int = 0; i<this.flagVector.length; i++){
				this.flagVector[i].y+=2.2;
			}
		}
		
		private function moveFlagsUp():void{
			for(var i:int = 0; i<this.flagVector.length; i++){
				this.flagVector[i].y-=2.2;
			}
		}
		
		private function changeFlag():void{
			if(this.currentPlayer is Explorer) this.setCorrectVisibleFlag(this.flagBlue);
			if(this.currentPlayer is Cannibal) this.setCorrectVisibleFlag(this.flagRed);
		}
		
		private function setCorrectVisibleFlag(flag:MovieClip):void{
			for(var i:int = 0; i<this.flagVector.length; i++){
				if(this.flagVector[i] != flag) this.flagVector[i].visible = false;
				else this.flagVector[i].visible = true;
			}
		}
		
		private function playFirework():void{
			this.firework.visible = true;
			this.firework.play();
		}
		
		override public function update():void{
			if(this.firework.currentFrame == this.firework.totalFrames){
				this.firework.gotoAndStop(1);
				this.firework.visible = false;
			}
		}
		
		public function visitorLeft(player:Player):void{
			this.visitors.splice(this.visitors.indexOf(player),1);
			if(this.visitors.length == 1){
				this.go = true;
				this.checkVisitors(this.visitors[0]);
			}else{
				this.go = false;
			}
		}
		
		public function resetFlag():void{
			this.owner = null;
			this.percentOwned = 100;
			this.currentPlayer = null;
			this.firework.gotoAndStop(1);
			this.firework.visible = false;
			this.positionFlags();
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
		}
		
	}
}