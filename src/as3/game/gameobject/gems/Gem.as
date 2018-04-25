package as3.game.gameobject.gems
{
	//import se.lnu.stickossdk.system.Session;
	import as3.game.gameobject.GameObject;
	
	public class Gem extends GameObject{
		
		protected var xCoor:int;
		protected var yCoor:int;
		public var value:int;
		
		public function Gem(){
			super();
			setCoordinates();
		}
		
		private function setCoordinates():void{
		
			this.xCoor = Math.floor(Math.random()*800);
			this.yCoor = Math.floor(Math.random()*400);
			
		}
		
		public function getX():int{
			return this.xCoor;
		}
		
		public function getY():int{
			return this.yCoor;
		}
		
		public function prepareReposition(callback):void{
		
			//this.parent.removeChild(this);
			this.setCoordinates();
			callback(this);
			
		}
		
	}
}