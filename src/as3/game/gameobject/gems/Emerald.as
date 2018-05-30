package as3.game.gameobject.gems{
	import assets.gameObjects.EmeraldGFX;
	
	public class Emerald extends Gem{
		
		//private var m_skin:EmeraldGFX;
		
		public function Emerald(player){
			super(player);
			value = 50;
		}
		
		override public function init():void{
		
			
			this.initSkin();
			this.initHitBox();
			addChild(this.m_skin);
			addChild(hitBox);
		}
		
		private function initSkin():void{
			this.m_skin = new EmeraldGFX();
			this.m_skin.x = -15;
			this.m_skin.y = -15;
		}
		
		private function initHitBox():void{
		
			//hitBox.graphics.beginFill(0x000000);
			hitBox.graphics.drawRect(-15,-15,25,25);
			//hitBox.graphics.endFill();
		
		}
		
		override public function dispose():void{
			this.m_skin = null;
			hitBox = null;
		}
		
	}
}