package as3.game.UI
{
	
	import as3.game.UI.Sidebar;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.ArenaSideLeft;
	import assets.gameObjects.ArenaSideRight;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Hud extends DisplayStateLayerSprite{
		
		private var leftSidebar:Sidebar;
		private var rightSidebar:Sidebar;
		private var arenaBarRight:ArenaSideRight;
		private var arenaBarLeft:ArenaSideLeft;
		
		private var m_hudTopBar:TopBar;
		private var players:Vector.<Player>;
		private var m_gameBonusPoints:GameBonusPoints;
		private var p1_leaf:MultiplayerHud;
		private var p2_leaf:MultiplayerHud;
		private var sb:MpScoreboard;
		
		public function Hud(players:Vector.<Player>){
			super();
			this.players = players
			this.players.length == 1 ? this.initSpHud() : this.initMpHud();
		}
		
		private function initTopBase():void{
			this.m_hudTopBar = new TopBar();
			addChild(this.m_hudTopBar);
		}
		
		private function initSpHud():void{
			this.initTopBase();
			this.initSidebars();
			this.initGameBonusPoints();
		}
		
		private function initSidebars():void{
			this.leftSidebar = new Sidebar();
			this.rightSidebar = new Sidebar();
			this.rightSidebar.scaleX = -1;
			this.rightSidebar.x = 800;
			addChild(this.leftSidebar);
			addChild(this.rightSidebar);
		}
		
		private function initGameBonusPoints():void{
			
			this.m_gameBonusPoints = new GameBonusPoints(this.players[0]);
			addChild(this.m_gameBonusPoints);
			
		}
		
		private function initMpHud():void{
			this.initMpLeafs();
			//this.initMpSidebars();
			this.initScoreboard();
		}
		
		private function initMpLeafs():void{
			this.p1_leaf = new MultiplayerHud(this.players[0]);
			this.p2_leaf = new MultiplayerHud(this.players[1]);
			addChild(this.p1_leaf);
			addChild(this.p2_leaf);
		}
		
		private function initMpSidebars():void{
			this.arenaBarLeft = new ArenaSideLeft();
			this.arenaBarRight = new ArenaSideRight();
			this.arenaBarRight.x = 800;
			addChild(this.arenaBarLeft);
			addChild(this.arenaBarRight);
		}
		
		private function initScoreboard():void{
			this.sb = new MpScoreboard(this.players);
			addChild(this.sb);
		}
		
		override public function update():void{
			if(this.sb!= null) this.sb.update();
		}
		
		override public function dispose():void{
			if(this.sb != null) this.sb.dispose();
			this.arenaBarLeft = null;
			this.arenaBarRight = null;
			this.p1_leaf = null;
			this.p2_leaf = null;
			this.m_gameBonusPoints = null;
			this.m_hudTopBar = null;
			this.leftSidebar = null;
			this.rightSidebar = null;
			this.players = null;
		}
	}
}