package as3.game.gameobject.powerups{
	
	import assets.gameObjects.PowerupShield;
	
	import se.lnu.stickossdk.system.Session;
	
	public class Immortality extends PowerUp{
		
		public function Immortality(){
			super();
		}
		
		override public function init():void{
			this.initSkin();
			this.initHitbox();
			this.scaleX = 0.8;
			this.scaleY = 0.8;
			this.m_skin.rotation = 10;
			Session.timer.create(4000, this.initDrop);
		}
		
		private function initSkin():void{
			m_skin = new PowerupShield();
			addChild(m_skin);
		}
		
		private function initHitbox():void{
			super.setHitBox();
		}
		
		private function initDrop():void{
			super.setPosition();
			super.startTween();
		}
		
		public function reposition():void{
			this.x = -100;
			this.y = -100;
			var delay:int = Math.floor(Math.random()*7000) + 7000;
			Session.timer.create(delay, super.setPosition);
		}
		
		override public function dispose():void{
			m_skin = null;
			hitBox = null;
		}
	}
}