package as3.game.UI
{
	import assets.gameObjects.hudBase;
	
	public class TopBar extends Hud{
		
		private var topbar:hudBase;
		
		public function TopBar(){
			super();
			this.topbar = new hudBase();
			this.topbar.x = 0;
			this.topbar.y = 0;
			this.scaleY = 0.6;
			addChild(this.topbar);
		}
	}
}