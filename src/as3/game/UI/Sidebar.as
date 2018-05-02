package as3.game.UI{
	
	import assets.gameObjects.sideBar;
	
	public class Sidebar extends Hud{	
		
		private var sidebar:sideBar;
		
		public function Sidebar(){
				
		}
		
		override public function init():void{
		
			this.sidebar = new sideBar();
			
			addChild(this.sidebar);
		
		}
		
		override public function dispose():void{
			this.sidebar = null;
		}
	}
}