package as3.game.gameobject.gems
{
	
	import assets.gameObjects.RubyGFX;

	public class Ruby extends Gem{
		
		private var m_skin:RubyGFX;
		
		public function Ruby(){
			super();
			value = 250;
		}
		
		override public function init():void{
			
			this.m_skin = new RubyGFX();
			
			this.initHitBox();
			this.x = xCoor;
			this.y = yCoor;
			
			addChild(this.m_skin);
			addChild(hitBox);
			
		}
		
		private function initHitBox():void{
		
			//hitBox.graphics.beginFill(0xFF0000);
			hitBox.graphics.drawRect(0,0,25,25);
			//hitBox.graphics.endFill();
		
		}
		
	}
}