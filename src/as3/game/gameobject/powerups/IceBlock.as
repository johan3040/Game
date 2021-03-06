package as3.game.gameobject.powerups{
	
	import assets.gameObjects.PowerupIce;
	
	import se.lnu.stickossdk.system.Session;
	
	public class IceBlock extends PowerUp{
		
		public function IceBlock(){
			super();
			this.duration = 3000;
		}
		
		override public function init():void{
			this.initSkin();
			this.initHitbox();
			this.scaleX = 0.8;
			this.scaleY = 0.8;
			this.m_skin.rotation = 10;
			Session.timer.create(10000, this.initDrop);
		}
		
		private function initSkin():void{
			m_skin = new PowerupIce();
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