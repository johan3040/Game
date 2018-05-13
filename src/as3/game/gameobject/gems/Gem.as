package as3.game.gameobject.gems
{	
	import flash.display.MovieClip;
	
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.player.Explorer;
	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Back;

	//import se.lnu.stickossdk.tween.easing.Bounce;
	
	public class Gem extends GameObject{
		
		protected var xCoor:int;
		protected var yCoor:int;
		protected var m_skin:MovieClip;
		private var callback:Function;
		private var reposDelay:int = 1500;
		private var player:Explorer;
		public var value:int;
		
		public function Gem(player:Explorer){
			
			super();
			this.player = player;
			this.setCoordinates();
			this.setFx();
			this.setFxTimer();
		}
		
		private function setCoordinates():void{
			this.setX();
			this.setY();
		}
		
		private function setX():void{
			if(this.player.x > 400){
				this.xCoor = Math.floor(Math.random()*350) + 50;
			}else{
				this.xCoor = Math.floor(Math.random()*350) + 350;
			}
		}
		
		private function setY():void{
			if(this.player.y > 300){
				this.yCoor = Math.floor(Math.random()*200) + 60;
			}else{
				this.yCoor = Math.floor(Math.random()*200) + 200;
			}
		}
		
		public function get xVal():int{
			return this.xCoor;
		}
		
		public function get yVal():int{
			return this.yCoor;
		}
		
		public function prepareReposition(callback:Function):void{
		
			this.x = -100;
			this.y = -100;
			this.callback = callback;
			this.reposDelay += 200;
			Session.timer.create(this.reposDelay, setNewPosition);
			
		}
		
		private function setNewPosition():void{
			this.setCoordinates();
			this.callback(this);
			this.setFx();
		}
		
		private function setFx():void{
			
			this.scaleX = 0;
			this.scaleY = 0;
			this.alpha = 0;
			
			Session.tweener.add(this,{
				transition: Back.easeOut,
				scaleX: 1,
				scaleY: 1,
				alpha: 1,
				duration: 900
			});
		}
		
		private function setFxTimer():void{
			var delay:int = (Math.random()*1000) + 1000;
			Session.timer.create(delay, playClip);
		}
		
		private function playClip():void{
			this.m_skin.gotoAndPlay(1);
		}
		
		override public function update():void{
			if(this.m_skin.currentFrame == this.m_skin.totalFrames) this.setFxTimer();
		}
		
	}
}