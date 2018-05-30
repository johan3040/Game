package as3.game.gameobject.gems
{
	
	import assets.gameObjects.RubyGFX;
	

	public class Ruby extends Gem{
		
		public function Ruby(player){
			super(player);
			value = 30;
		}
		
		override public function init():void{
			
			this.initSkin();
			this.initHitBox();
			addChild(this.m_skin);
			addChild(hitBox);
			
		}
		
		
		
		private function initSkin():void{
			this.m_skin = new RubyGFX();
			this.m_skin.x = -15;
			this.m_skin.y = -15;
		}
		
		private function initHitBox():void{
		
			//hitBox.graphics.beginFill(0xFF0000);
			hitBox.graphics.drawRect(-15,-15,25,25);
			//hitBox.graphics.endFill();
		
		}
		
		override public function dispose():void{
			this.m_skin = null;
			hitBox = null;
		}
		
	}
}