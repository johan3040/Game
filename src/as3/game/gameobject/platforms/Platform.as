package  as3.game.gameobject.platforms{

	import as3.game.gameobject.GameObject;
	
	public class Platform extends GameObject{
		
		private var xVal:int;
		private var yVal:int;
		public var pos:Array;
		
		public function Platform(pos:Array){
			super();
			this.setData(pos);
			
		}
			
		protected function setData(pos:Array):void{
			this.xVal = pos[1];
			this.yVal = pos[0];
		}	
		
		public function getX():int{
			return this.xVal;
		}
	
		public function getY():int{
			return this.yVal;
		}
		
		public function setNewData(arr:Array):void{
			this.pos = arr;
			this.setData(arr);
		}
			

	}
	
}
