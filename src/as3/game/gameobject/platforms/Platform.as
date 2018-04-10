package  as3.game.gameobject.platforms{

	import as3.game.gameobject.GameObject;
	
	public class Platform extends GameObject{
		
		private var xVal:int;
		private var yVal:int;
		protected var platPosX:Array = [70, 140, 210, 280, 350, 420, 490, 560, 620];
		protected var platPosY:Array = [120, 240, 360, 480];
		
		public function Platform() {
			setData();
		}
			
		protected function setData():void{
			this.xVal = setX();
			this.yVal = setY();
			}	
			
		private function setX():int{
			var index:int = Math.floor(Math.random() * platPosX.length);
			return platPosX[index];
			}
			
		private function setY():int{
			var index:int = Math.floor(Math.random() * platPosY.length);
			return platPosY[index];
			}	
		
		public function getX():int{
			return this.xVal;
			}
		
		public function getY():int{
			return this.yVal;
			}
			

	}
	
}
