package as3.game.gameobject.platforms{
	
	import assets.gameObjects.island1;
	
	
	public class LeftBase extends Platform{
		
		private var platform:island1;
		
		/**
		 * 
		 * Constructor
		 * Left Island for SP-mode
		 * 
		 * @param Array
		 * 
		 */
		public function LeftBase(pos:Array){
			super(pos);
			initLeftBase();
		}
		
		private function initLeftBase():void{
		
			this.platform = new island1();
			setHitBox();
			obj_width = 150;
			obj_height = 10;
			addChild(this.platform);
			addChild(hitBox);
		
		}
		
		private function setHitBox():void{
		
			//hitBox.graphics.beginFill(0x0000FF);
			hitBox.graphics.drawRect(4,10,150,20);
			//hitBox.graphics.endFill();
			
		}
		
		override public function dispose():void{
			this.platform = null;
		}
		
	}
}