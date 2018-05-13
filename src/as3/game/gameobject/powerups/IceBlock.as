package as3.game.gameobject.powerups{
	
	import assets.gameObjects.PowerupIce;
	
	import se.lnu.stickossdk.system.Session;
	
	public class IceBlock extends PowerUp{
		
		public function IceBlock(){
			super();
		}
		
		override public function init():void{
			this.initSkin();
			this.initHitbox();
			this.x = 300;
			this.y = -140;
			this.scaleX = 0.8;
			this.scaleY = 0.8;
			Session.timer.create(6000, this.initDrop);
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
		
		public function resetPosition():void{
			this.x = -100;
			this.y = -100;
			this.drop = false;
			Session.timer.create(6000, initDrop);
		}
		
		override public function dispose():void{
			m_skin = null;
			hitBox = null;
		}
		
	}
}