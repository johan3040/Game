package  as3.game.gameobject.platforms{

	import as3.game.gameobject.GameObject;
	
	public class Platform extends GameObject{
		
		private var xVal:int;
		private var yVal:int;
		public var pos:Array;
		
		/**
		 * 
		 * Constructor
		 * 
		 * Superclass for all platforms
		 * 
		 * @param Array
		 * 
		 */
		public function Platform(pos:Array){
			super();
			this.setData(pos);
			
		}
			
		public function setData(pos:Array):void{
			this.xVal = pos[1];
			this.yVal = pos[0];
		}	
		
		public function get xPos():int{
			return this.xVal;
		}
	
		public function get yPos():int{
			return this.yVal;
		}
		
		public function setNewData(arr:Array):void{
			this.pos = arr;
			this.setData(arr);
		}
			

	}
	
}
