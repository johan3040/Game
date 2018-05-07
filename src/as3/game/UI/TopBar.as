package as3.game.UI
{
	import assets.gameObjects.hudBase;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class TopBar extends DisplayStateLayerSprite{
		
		private var topbar:hudBase;
		
		public function TopBar(){
			super();
			this.topbar = new hudBase();
			this.topbar.x = 0;
			this.topbar.y = 0;
			this.scaleY = 0.6;
			addChild(this.topbar);
		}
		
		override public function dispose():void{
			this.topbar = null;
		}
	}
}