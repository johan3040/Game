package as3.game.UI{
	
	
	public class Sidebar extends Hud{
		
		import assets.gameObjects.sideBar;
		
		private var sidebar:sideBar;
		
		public function Sidebar(){
				
		}
		
		override public function init():void{
		
			this.sidebar = new sideBar();
			
			addChild(this.sidebar);
		
		}
	}
}