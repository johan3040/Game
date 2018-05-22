package as3.game.gameobject.powerups{
	
	import assets.gameObjects.PowerupSnail;
	
	import se.lnu.stickossdk.system.Session;
	
	public class Snail extends PowerUp{
		
		public function Snail(){
			super();
			
		}
		
		override public function init():void{
			this.initSkin();
			this.initHitbox();
			this.x = 300;
			this.y = -100;
			this.scaleX = 0.8;
			this.scaleY = 0.8;
			Session.timer.create(9000, this.initDrop);
		}
		
		private function initSkin():void{
			m_skin = new PowerupSnail();
			addChild(m_skin);
		}
		
		private function initHitbox():void{
			super.setHitBox();
		}
		
		private function initDrop():void{
			super.setPosition();
			super.startTween();
		}
		
		override public function dispose():void{
			m_skin = null;
			hitBox = null;
		}
		
	}
}