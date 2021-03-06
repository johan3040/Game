package as3.game.gameobject.platforms{
	
	import assets.gameObjects.island2;
	
	
	public class RightBase extends Platform{
		
		private var platform:island2;
		
		/**
		 * 
		 * Constructor
		 * Right Island for SP-mode
		 * 
		 * @param Array
		 * 
		 */
		public function RightBase(pos:Array){
			super(pos);
			initRightBase();
		}
		
		private function initRightBase():void{
			
			this.platform = new island2();
			initHitBox();
			obj_width = 200;
			obj_height = 10;
			addChild(this.platform);
			addChild(hitBox);
			
		}
		
		private function initHitBox():void{
			
			//hitBox.graphics.beginFill(0x0000FF);
			hitBox.graphics.drawRect(4,10,200,20);
			//hitBox.graphics.endFill();
		
		}
		
		override public function dispose():void{
		
			this.platform = null;
		
		}
		
	}
}

