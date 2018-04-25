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
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Game extends DisplayState{
		
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
		
		public function Game(){
			super();
			//this.gameObjectVec = new Vector.<GameObject>;
			this.playerVector = new Vector.<GameObject>;
			this.hazardVector = new Vector.<GameObject>;
			this.collidableObjects = new Vector.<GameObject>;
		}
		
		override public function init():void{
			this.m_initLayers();
			this.initBackground();
			this.initPlayer();
			this.platformhandler = new PlatformHandler(this, this.playerVector);
			this.hazardhandler = new HazardHandler(this);
			//this.initPlayer2();
			this.initGems();
			this.initHud();
			this.initAudio();
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
		
		private function initPlayer():void{
			this.player1 = new Explorer();
			this.player1.x = 160;
			this.player1.y = 520 - this.player1.height;
			this.m_playerLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		private function initPlayer2():void{
			this.player2 = new Cannibal();
			this.player2.x = 100;
			this.player2.y = 600 - this.player2.height;
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
		
			this.gem_ruby = new Ruby();
			this.positionGems(this.gem_ruby);
			this.gameLayer.addChild(this.gem_ruby);
			this.hazardVector.push(this.gem_ruby);
			this.collidableObjects.push(this.gem_ruby);
		}
		
		private function initSapphire():void{
		
			this.gem_emerald = new Emerald();
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
		
		private function initHud():void{
			
			this.initSidebars();
			this.initGameTimer();
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
			m_updateCollission();
			this.platformhandler.update();
		}
		
		private function m_updateCollission():void{
			
			for(var j:int = 0; j<this.playerVector.length; j++){
				var a:Rectangle = this.playerVector[j].hitBox.getRect(this.gameLayer);
				
				for(var i:int = 0; i<this.collidableObjects.length; i++){
					
					this.tempHazardRect = collidableObjects[i].hitBox.getRect(this.gameLayer);
					
					if(a.intersects(this.tempHazardRect)){
						if(this.collidableObjects[i] is Hazard){
							this.hazardCollission(this.playerVector[j], this.collidableObjects[i]);
							break;
						}
						if(this.collidableObjects[i] is Gem){
							this.gemCollission(this.playerVector[j], this.collidableObjects[i]);
							break;
						}
						
					}//End if intersect
				}//End hazardloop
			}//End playerloop
		}//End function
		
		private function hazardCollission(player, hazard):void{
		
			//this.gameOverAudio.play();
			Session.application.displayState = new GameOver();
		
		}
		
		private function gemCollission(player, gem):void{
			
			player.setBonusPoints(gem.value);
			this.m_gameBonusPoints.setVisibleBonusPoints(gem.value);
			gem.prepareReposition(this.positionGems);
			//this.collidableObjects.splice(this.collidableObjects.indexOf(gem),1);
			//this.hazardVector.splice(this.hazardVector.indexOf(gem),1);
		
		}
		
		
		
		private function removeFromVector(obj:GameObject):void{
			//var index:int = platformVector.indexOf(obj);
			//this.platformVector.splice(index, 1);
		}
		
		override public function dispose():void{
		
			this.platformhandler.dispose();
			this.hazardhandler.dispose();
			
		}
		
		
	}
}