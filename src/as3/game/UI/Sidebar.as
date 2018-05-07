package as3.game.UI{
	
	import assets.gameObjects.sideBar;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Sidebar extends DisplayStateLayerSprite{	
		
		private var sidebar:sideBar;
		
		public function Sidebar(){
			this.initSidebar();
		}
		
		private function initSidebar():void{
		
			this.sidebar = new sideBar();
			addChild(this.sidebar);
		
		}
		
		override public function dispose():void{
			this.sidebar = null;
		}
	}
}