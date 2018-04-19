package as3.game.gameobject.gems{
	import assets.gameObjects.EmeraldGFX;
	
	public class Emerald extends Gem{
		
		private var m_skin:EmeraldGFX;
		
		public function Emerald(){
			super();
			value = 500;
		}
		
		override public function init():void{
		
			this.m_skin = new EmeraldGFX();
			
			this.initHitBox();
			addChild(this.m_skin);
			addChild(hitBox);
		}
		
		private function initHitBox():void{
		
			//hitBox.graphics.beginFill(0x000000);
			hitBox.graphics.drawRect(0,0,25,25);
			//hitBox.graphics.endFill();
		
		}
		
	}
}