package as3.game.gameobject.gems
{
	import flash.display.Sprite;

	public class Sapphire extends Gem{
		
		public function Sapphire(){
			super();
			value = 250;
			initSapphire();
		}
		
		private function initSapphire():void{
		
			m_skin = new Sprite();
			m_skin.graphics.beginFill(0x0000FF);
			m_skin.graphics.drawRect(0,0,15,15);
			m_skin.graphics.endFill();
			this.initHitBox();
			this.x = xCoor;
			this.y = yCoor;
			
			addChild(m_skin);
			addChild(hitBox);
		
		}
		
		private function initHitBox():void{
		
			hitBox.graphics.drawRect(0,0,15,15);
		
		}
		
	}
}