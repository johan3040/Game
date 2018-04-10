package  as3.game.gameobject{
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	
	public class GameObject extends DisplayStateLayerSprite{
		
		public var hitBox:Sprite = new Sprite();
		//public var touchable:Boolean = true;
		protected var lethal:Boolean = false;
		
		public function GameObject() {
			// constructor code
		}
		
		public function hitTest(obj:GameObject):void{
			
			var a:Rectangle = this.hitBox.getRect(Session.application.stage);
			var b:Rectangle = obj.hitBox.getRect(Session.application.stage);
			
			if(a.intersects(b)){
				trace("hit");
				if(this.lethal == true || obj.lethal == true){
					trace("game over");
					}
				};
			
			}

	}
	
}
