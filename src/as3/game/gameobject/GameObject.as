package  as3.game.gameobject{
	
	import flash.display.Sprite;	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class GameObject extends DisplayStateLayerSprite{
		
		public var hitBox:Sprite = new Sprite();
		public var lethal:Boolean = false;
		public var exists:Boolean = true;
		public var obj_width:int;
		public var obj_height:int;
		
		public function GameObject() {
			// constructor code
		}

	}// End GameObject
	
}
