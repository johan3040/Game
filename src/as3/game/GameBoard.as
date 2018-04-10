package  as3.game{
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	//import assets.gameObjects.BackgroundImageGFX;
	import flash.display.Sprite;
	
	public class GameBoard extends DisplayStateLayerSprite{

		private var gb:Sprite;
		
		public function GameBoard() {
			
			this.gb = new Sprite();
			this.gb.graphics.beginFill(0xFFFFFF);
			this.gb.graphics.drawRect(0,0,800,600);
			this.gb.graphics.endFill();
			addChild(this.gb);
		}
		
		override public function dispose():void{
			this.gb = null;
		}
		
	}
	
}
