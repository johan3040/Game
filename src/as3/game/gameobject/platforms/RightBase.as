package as3.game.gameobject.platforms{
	
	import assets.gameObjects.island2;
	
	
	public class RightBase extends Platform{
		
		private var platform:island2;
		
		public function RightBase(){
			super();
			initRightBase();
		}
		
		override protected function setData():void{
			this.x = 500;
			this.y = 550;
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
			
			hitBox.graphics.beginFill(0x0000FF);
			hitBox.graphics.drawRect(4,10,200,10);
			hitBox.graphics.endFill();
		
		}
		
		override public function getX():int{
			return this.x;
		}
		
		override public function getY():int{
			return this.y;
		}
		
	}
}

