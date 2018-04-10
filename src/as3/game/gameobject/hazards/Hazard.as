package  as3.game.gameobject.hazards{
		
	import as3.game.gameobject.GameObject;
	
	import assets.gameObjects.P1;
	
	public class Hazard extends GameObject{
		
		public var target:P1;
		
		public function Hazard() {
			this.target = player;
			lethal = true;
		}
		
		protected function hitBoxTest():void{
			
			
			
			}

	}
	
}
