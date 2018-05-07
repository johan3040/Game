package as3.game.gameobject.powerups
{
	import assets.gameObjects.PowerupJump;
	
	import se.lnu.stickossdk.system.Session;

	public class Superjump extends PowerUp{
		
		public function Superjump(){
			super();
		}
		
		override public function init():void{
			this.initSkin();
			this.initHitbox();
			this.x = 300;
			this.y = -100;
			this.scaleX = 0.8;
			this.scaleY = 0.8;
			Session.timer.create(6000, this.initDrop);
		}
		
		private function initSkin():void{
			m_skin = new PowerupJump();
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