package scene
{	
	
	import flash.geom.Rectangle;
	
	import as3.game.GameBoard;
	import as3.game.UI.GameBonusPoints;
	import as3.game.UI.GameTimer;
	import as3.game.UI.Hud;
	import as3.game.UI.Sidebar;
	import as3.game.UI.TopBar;
	import as3.game.gameHandler.HazardHandler;
	import as3.game.gameHandler.PlatformHandler;
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.gems.Emerald;
	import as3.game.gameobject.gems.Gem;
	import as3.game.gameobject.gems.Ruby;
	import as3.game.gameobject.hazards.Hazard;
	import as3.game.gameobject.platforms.Bungalow;
	import as3.game.gameobject.player.Cannibal;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	import as3.game.gameobject.powerups.Immortality;
	import as3.game.gameobject.powerups.PowerUp;
	import as3.game.gameobject.powerups.Superjump;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Game extends DisplayState{
		
		private var mode:int; // 0 = singleplayer 1 = multiplayer
		private var m_gameBackgroundLayer:DisplayStateLayer;
		public var gameLayer:DisplayStateLayer;
		private var m_gameHudLayer:DisplayStateLayer;
		private var m_playerLayer:DisplayStateLayer;
		private var m_hud:Hud;
		private var m_gameTimer:GameTimer;
		private var m_gameBonusPoints:GameBonusPoints;
		private var m_hudTopBar:TopBar;
		private var gb:GameBoard;
		private var player1:Player;
		private var player2:Player;
		private var lb_bungalow:Bungalow;
		private var pu_superjump:Superjump;
		private var pu_immortal:Immortality;
		
		//------------------------------------------
		// Public vectors
		//------------------------------------------
		public var playerVector:Vector.<GameObject>;
		//public var gameObjectVec:Vector.<GameObject>;
		public var hazardVector:Vector.<GameObject>;
		public var collidableObjects:Vector.<GameObject>;
		
		private var tempHazardRect:Rectangle;
		
		private var gem_ruby:Ruby;
		private var gem_emerald:Emerald;
		
		// Audio
		[Embed(source = "../../assets/audio/gameOverAU.mp3")] 	// <-- this data..
		private const GAME_OVER_AUDIO:Class;					// ..gets saved in this const
		private var gameOverAudio:SoundObject;
		//
		private var platformhandler:PlatformHandler;
		private var hazardhandler:HazardHandler;
		
		public function Game(num:int){
			super();
			this.mode = num;
			//this.gameObjectVec = new Vector.<GameObject>;
			this.playerVector = new Vector.<GameObject>;
			this.hazardVector = new Vector.<GameObject>;
			this.collidableObjects = new Vector.<GameObject>;
		}
		
		override public function init():void{
			this.m_initLayers();
			this.initBackground();
			this.mode == 1 ? this.singleplayerGame() : this.multiplayerGame();
			/*this.initPlayer();
			this.platformhandler = new PlatformHandler(this, this.playerVector);
			this.hazardhandler = new HazardHandler(this);
			//this.initPlayer2();
			this.initGems();
			this.initPowerUps();
			this.initHud();
			this.initAudio();*/
		}
		
		private function initAudio():void{
		
			Session.sound.soundChannel.sources.add("gameOver", GAME_OVER_AUDIO);
			this.gameOverAudio = Session.sound.soundChannel.get("gameOver", true, true);
		
		}
		
		private function m_initLayers():void{
			this.m_gameBackgroundLayer = this.layers.add("background");
			this.gameLayer = this.layers.add("game");
			this.m_gameHudLayer = this.layers.add("HUD");
			this.m_playerLayer = this.layers.add("playerLayer");
		}
		
		private function initBackground():void{
			this.gb = new GameBoard();
			this.m_gameBackgroundLayer.addChild(this.gb);
		}
		
		private function singleplayerGame():void{
			this.initPlayer();
			this.platformhandler = new PlatformHandler(this, this.playerVector);
			this.hazardhandler = new HazardHandler(this);
			this.initGems();
			this.initPowerUps();
			this.initHud();
		}
		
		private function multiplayerGame():void{
			this.initPlayer();
			this.initPlayer2();
			this.platformhandler = new PlatformHandler(this, this.playerVector);
			this.hazardhandler = new HazardHandler(this);
			this.initGems();
			this.initPowerUps();
			this.initHud();
		}
		
		private function initPlayer():void{
			this.player1 = new Explorer();
			this.player1.x = 160;
			this.player1.y = 560 - this.player1.height;
			this.m_playerLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		private function initPlayer2():void{
			this.player2 = new Cannibal();
			this.player2.x = 600;
			this.player2.y = 560 - this.player2.height;
			this.m_playerLayer.addChild(this.player2);
			this.playerVector.push(this.player2);
		}
		
		private function initBungalows():void{
			var pos:Array = [530,240];
			this.lb_bungalow = new Bungalow(pos);
			this.lb_bungalow.x = 240;
			this.lb_bungalow.y = 530;
			this.platformhandler.platformVector.push(this.lb_bungalow);
			this.gameLayer.addChild(this.lb_bungalow);
		}

		private function initGems():void{
			this.initRuby();
			this.initSapphire();
		
		}
		
		private function initRuby():void{
		
			this.gem_ruby = new Ruby(this.player1);
			this.positionGems(this.gem_ruby);
			this.gameLayer.addChild(this.gem_ruby);
			this.hazardVector.push(this.gem_ruby);
			this.collidableObjects.push(this.gem_ruby);
		}
		
		private function initSapphire():void{
		
			this.gem_emerald = new Emerald(this.player1);
			this.positionGems(this.gem_emerald);
			this.gameLayer.addChild(this.gem_emerald);
			this.addGemToVector(this.gem_emerald);
		}
		
		private function positionGems(gem:Gem):void{
		
			gem.x = gem.getX();
			gem.y = gem.getY();
		
		}
		
		private function addGemToVector(gem:Gem):void{
			
			this.hazardVector.push(gem);
			this.collidableObjects.push(gem);
		
		}
		
		private function initPowerUps():void{
			this.pu_superjump = new Superjump();			
			this.collidableObjects.push(this.pu_superjump);
			this.gameLayer.addChild(this.pu_superjump);
			
			this.pu_immortal = new Immortality();
			this.collidableObjects.push(this.pu_immortal);
			this.gameLayer.addChild(this.pu_immortal);
		}
		
		private function initHud():void{
			
			this.initSidebars();
			//this.initGameTimer();
			this.initGameBonusPoints();
			this.initTopBase();
		}
		
		private function initSidebars():void{
		
			var leftSidebar:Sidebar = new Sidebar();
			var rightSidebar:Sidebar = new Sidebar();
			rightSidebar.scaleX = -1;
			rightSidebar.x = 800 - rightSidebar.width;
			this.m_gameHudLayer.addChild(leftSidebar);
			this.m_gameHudLayer.addChild(rightSidebar);
		
		}
		
		private function initGameTimer():void{
		
			this.m_gameTimer = new GameTimer();
			this.m_gameHudLayer.addChild(this.m_gameTimer);
		
		}
		
		private function initGameBonusPoints():void{
		
			this.m_gameBonusPoints = new GameBonusPoints(this.player1);
			this.m_gameHudLayer.addChild(this.m_gameBonusPoints);
			
		}
		
		private function initTopBase():void{
		
			this.m_hudTopBar = new TopBar();
			this.m_gameHudLayer.addChild(this.m_hudTopBar);
			
		}
		
		override public function update():void{
			for(var i:int = 0; i<this.playerVector.length; i++){
				if(this.playerVector[i].alive){
					m_updateCollission(this.playerVector[i]);
					this.platformhandler.update(this.playerVector[i]);
					if(this.playerVector[i].y >= 600) this.prepareGameOver(this.playerVector[i]);
				}
			}
		}
		
		private function m_updateCollission(player):void{
			
				var a:Rectangle = player.hitBox.getRect(this.gameLayer);
				
				for(var i:int = 0; i<this.collidableObjects.length; i++){
					
					this.tempHazardRect = collidableObjects[i].hitBox.getRect(this.gameLayer);
					
					if(a.intersects(this.tempHazardRect)){
						if(this.collidableObjects[i] is Hazard){
							this.hazardCollission(player, this.collidableObjects[i]);
							break;
						}
						if(this.collidableObjects[i] is Gem){
							this.gemCollission(player, this.collidableObjects[i]);
							break;
						}
						if(this.collidableObjects[i] is PowerUp){
							this.powerCollission(player, this.collidableObjects[i]);
							break;
						}
						
					}//End if intersect
				}//End hazardloop
		}//End function
		
		private function hazardCollission(player, hazard):void{
			//this.gameOverAudio.play();
			if(player.immortal != true && hazard.lethal == true){
				this.prepareGameOver(player);
			}
		}
		
		private function prepareGameOver(player):void{
			player.alive = false;
			Session.timer.dispose();
			Session.tweener.dispose();
			var go_delay:int = 1000;
			Session.effects.add(new Flicker(player, go_delay, 30, true));
			Session.timer.create(go_delay, gameOver, 0);
		}
		
		private function gameOver():void{
			
			Session.application.displayState = new GameOver(this.player1, mode);
		
		}
		
		private function gemCollission(player, gem):void{
			
			player.setBonusPoints(gem.value);
			this.m_gameBonusPoints.setVisibleBonusPoints(gem.value);
			gem.prepareReposition(this.positionGems);
			//this.collidableObjects.splice(this.collidableObjects.indexOf(gem),1);
			//this.hazardVector.splice(this.hazardVector.indexOf(gem),1);
		
		}
		
		private function powerCollission(player, pw):void{
			pw.reposition();
			player.setPowerUp(pw);
		}
		
		override public function dispose():void{
		
			this.platformhandler.dispose();
			this.hazardhandler.dispose();
			
		}
		
		
	}
}