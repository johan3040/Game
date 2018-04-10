package scene
{	
	import as3.game.GameBoard;
	import as3.game.UI.Hud;
	import as3.game.gameobject.hazards.Arrow;
	import as3.game.gameobject.platforms.OriginalPlatform;
	import as3.game.gameobject.platforms.Platform;
	import as3.game.gameobject.player.Cannibal;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;

	//import se.lnu.stickossdk.display.DisplayStateLayers;
	
	public class Game extends DisplayState{
		
		private var m_gameLayer:DisplayStateLayer;
		private var m_gameHudLayer:DisplayStateLayer;
		private var gb:GameBoard;
		private var m_hud:Hud;
		private var gameHud:Hud;
		private var player1:Player;
		private var player2:Player;
		private var plat:OriginalPlatform;
		private var pv:Vector.<Platform>;
		private var arr:Arrow;
		
		public function Game(){
			super();
			this.pv = new Vector.<Platform>();
		}
		
		override public function init():void{
			this.m_initLayer();
			this.initBackground();
			this.initPlayer();
			this.initPlayer2();
			this.initPlatforms();
			this.initArrow();
			this.initHud();
		}
		
		private function m_initLayer():void{
			this.m_gameLayer = this.layers.add("game");
			this.m_gameHudLayer = this.layers.add("HUD");
		}
		
		private function initBackground():void{
			this.gb = new GameBoard();
			//this.m_gameLayer = this.layers.add("gameBackground");
			this.m_gameLayer.addChild(this.gb);
		}
		
		private function initPlayer():void{
			this.player1 = new Explorer(this.pv);
			this.player1.x = 0;
			this.player1.y = 600 - this.player1.height;
			this.m_gameLayer.addChild(this.player1);
		}
		
		private function initPlayer2():void{
			this.player2 = new Cannibal(this.pv);
			this.player2.x = 100;
			this.player2.y = 600 - this.player2.height;
			this.m_gameLayer.addChild(this.player2);
		}
		
		private function initPlatforms():void{
			for(var i: int = 0; i<8; i++){
				this.plat = new OriginalPlatform(this.positionPlatform);
				this.m_gameLayer.addChild(this.plat);
				this.positionPlatform(this.plat);
				this.pv.push(this.plat);
			}
		}
		
		private function positionPlatform(obj:Platform):void{
			obj.x = obj.getX();
			obj.y = obj.getY();
		}
		
		
		private function initArrow():void{
			this.arr = new Arrow();
			this.m_gameLayer.addChild(this.arr);
			trace(this.arr.hitBox.x);
		}
		
		
		private function initHud():void{
			this.m_hud = new Hud();
			this.m_gameHudLayer.addChild(this.m_hud);
		}
		
		override public function update():void{
			this.arr.hitTest(this.player1);
			this.arr.hitTest(this.player2);
		}
		
	}
}