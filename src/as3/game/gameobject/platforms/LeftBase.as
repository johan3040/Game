package as3.game.gameobject.platforms{
	
	import assets.gameObjects.island1;
	
	
	public class LeftBase extends Platform{
		
		private var platform:island1;
		
		public function LeftBase(pos){
			super(pos);
			initLeftBase();
		}
		
		/*override protected function setData():void{
			this.x = 140;
			this.y = 550;
		}*/
		
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