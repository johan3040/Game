package  as3.game{
	
	import assets.gameObjects.GradientBack;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class GameBoard extends DisplayStateLayerSprite{

		private var gb:GradientBack;
		
		public function GameBoard() {
			
			this.gb = new GradientBack();
			addChild(this.gb);
		}
		
		override public function dispose():void{
			this.gb = null;
		}
		
	}
	
}
