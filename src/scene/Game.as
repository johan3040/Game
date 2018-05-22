package scene
{	
	
	import flash.geom.Rectangle;
	
	import as3.game.GameBoard;
	import as3.game.UI.Hud;
	import as3.game.gameHandler.PlatformHandler;
	import as3.game.gameHandler.SoundHandler;
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.player.Player;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.system.Session;
	
	public class Game extends DisplayState{
		
		private var mode:int; // 1 = singleplayer 2 = multiplayer
		private var m_gameBackgroundLayer:DisplayStateLayer;
		private var gb:GameBoard;
		private var mp_winner:Player;
		
		public var gameLayer:DisplayStateLayer;
		
		protected var m_gameHudLayer:DisplayStateLayer;
		protected var m_playerLayer:DisplayStateLayer;
		protected var m_hud:Hud;
		protected var player1:Player;
		protected var player2:Player;
		protected var tempHazardRect:Rectangle;
		protected var platformhandler:PlatformHandler;
		protected var soundHandler:SoundHandler;
		
		//------------------------------------------
		// Public vectors
		//------------------------------------------
		public var playerVector:Vector.<Player>;
		public var hazardVector:Vector.<GameObject>;
		public var collidableObjects:Vector.<GameObject>;
		
		
		
		
		/**
		 * 
		 * Constructor method for Game
		 * 
		 * @param int - 1 == singleplayer mode, 2 == multiplayer mode
		 * 
		 */
		public function Game(mode:int){
			super();
			this.mode = mode;
			//this.gameObjectVec = new Vector.<GameObject>;
			this.playerVector = new Vector.<Player>;
			this.hazardVector = new Vector.<GameObject>;
			this.collidableObjects = new Vector.<GameObject>;
			this.m_initLayers();
			this.initBackground();
		}
		
		override public function init():void{
			
		}
		
		/**
		 * 
		 * Initializing game layers
		 * 
		 */
		private function m_initLayers():void{
			this.m_gameBackgroundLayer = this.layers.add("background");
			this.gameLayer = this.layers.add("game");
			this.m_gameHudLayer = this.layers.add("HUD");
			this.m_playerLayer = this.layers.add("playerLayer");
		}
		
		/**
		 * 
		 * Adds background on dedicated background-layer
		 * 
		 */
		private function initBackground():void{
			this.gb = new GameBoard();
			this.m_gameBackgroundLayer.addChild(this.gb);
		}
		
		/**
		 * 
		 * Calls effects methods on winner/looser depending on mode
		 * Sets timeout to call gameOver method
		 * 
		 */
		protected function prepareGameOver(player:Player):void{
			var go_delay:int = 2000;
			this.mode == 1 ? this.gameOverSp(player, go_delay) : this.gameOverMp();
			Session.timer.dispose();
			Session.timer.create(go_delay, gameOver, 0);
		}
		
		/**
		 * 
		 * For single player mode
		 * 
		 * Plays sound effect for game over and sets flicker effect
		 * 
		 */
		private function gameOverSp(player:Player,delay:int):void{
			this.soundHandler.gameOverSp();
			Session.effects.add(new Flicker(player, delay, 30, true));
			player.alive = false;
		}
		
		/**
		 * 
		 * Activates correct audio for multiplayer winner
		 * 
		 * Effect is called in 'MultiPlayerGame' sub class
		 * 
		 */
		private function gameOverMp():void{
			this.soundHandler.gameOverMp();
		}
		
		/**
		 * 
		 * Sets new state to 'GameOver'
		 * 
		 * Passes player as argument (Match winner in multiplayer mode)
		 * 
		 */
		protected function gameOver():void{
			var p:Player;
			Session.tweener.dispose();
			this.mode == 1 ? p = this.player1 : p = this.getMpWinner();
			Session.application.displayState = new GameOver(p, mode);
			
		}
		
		
		/**
		 * 
		 * Checks which player is winner in multiplayer mode
		 * 
		 */
		protected function getMpWinner():Player{
			return this.player1.roundsWon > this.player2.roundsWon ? this.player1 : this.player2;
		}
		
		
		override public function dispose():void{
		
			this.platformhandler.dispose();
			this.playerVector = null;
			this.hazardVector = null;
			this.collidableObjects = null;
			this.m_gameBackgroundLayer = null;
			this.gameLayer = null;
			this.m_gameHudLayer = null;
			this.m_playerLayer = null;
			this.m_hud = null;
			this.gb = null;
			this.player1 = null;
			this.tempHazardRect = null;
			this.mp_winner = null;
			
			
		}
		
		
	}
}