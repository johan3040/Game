package scene
{	
	
	import flash.geom.Rectangle;
	
	import as3.game.GameBoard;
	import as3.game.UI.GameBonusPoints;
	import as3.game.UI.GameTimer;
	import as3.game.UI.Hud;
	import as3.game.UI.MultiplayerHud;
	import as3.game.gameHandler.HazardHandler;
	import as3.game.gameHandler.PlatformHandler;
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.gems.Emerald;
	import as3.game.gameobject.gems.Gem;
	import as3.game.gameobject.gems.Ruby;
	import as3.game.gameobject.hazards.Hazard;
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
		//private var m_gameTimer:GameTimer;
		private var m_gameBonusPoints:GameBonusPoints;
		private var gb:GameBoard;
		private var player1:Player;
		private var player2:Player;
		private var pu_superjump:Superjump;
		private var pu_immortal:Immortality;
		private var tempHazardRect:Rectangle;
		private var gem_ruby:Ruby;
		private var gem_emerald:Emerald;
		private var mp_winner:Player;
		
		//------------------------------------------
		//MP hud
		//------------------------------------------
		private var p1_leaf:MultiplayerHud;
		private var p2_leaf:MultiplayerHud;
		
		//------------------------------------------
		// Public vectors
		//------------------------------------------
		public var playerVector:Vector.<Player>;
		public var hazardVector:Vector.<GameObject>;
		public var collidableObjects:Vector.<GameObject>;
		
		//------------------------------------------
		// Audio
		//------------------------------------------
		[Embed(source = "../../assets/audio/gameOverAU.mp3")] 	// <-- this data..
		private const GAME_OVER_AUDIO:Class;					// ..gets saved in this const
		private var gameOverAudio:SoundObject;
		
		[Embed(source = "../../assets/audio/PowerupAU.mp3")] 	// <-- this data..
		private const POWER_UP_AUDIO:Class;						// ..gets saved in this const
		private var powerUpAudio:SoundObject;
		
		[Embed(source = "../../assets/audio/gameMusicAU.mp3")] 	// <-- this data..
		private const GAME_MAIN_AUDIO:Class;					// ..gets saved in this const
		private var mainAudio:SoundObject;
		//
		private var platformhandler:PlatformHandler;
		private var hazardhandler:HazardHandler;
		
		public function Game(num:int){
			super();
			this.mode = num;
			//this.gameObjectVec = new Vector.<GameObject>;
			this.playerVector = new Vector.<Player>;
			this.hazardVector = new Vector.<GameObject>;
			this.collidableObjects = new Vector.<GameObject>;
		}
		
		override public function init():void{
			this.m_initLayers();
			this.initBackground();
			this.initAudio();
			this.mode == 1 ? this.singleplayerGame() : this.multiplayerGame();
		}
		
		private function initAudio():void{
		
			Session.sound.soundChannel.sources.add("gameOver", GAME_OVER_AUDIO);
			this.gameOverAudio = Session.sound.soundChannel.get("gameOver", true, true);
			Session.sound.soundChannel.sources.add("powerUp", POWER_UP_AUDIO);
			this.powerUpAudio = Session.sound.soundChannel.get("powerUp", true, true);
			Session.sound.soundChannel.sources.add("main", GAME_MAIN_AUDIO);
			this.mainAudio = Session.sound.soundChannel.get("main", true, true);
			
			this.mainAudio.play(999); //Loopar musiken 999 gånger
			this.mainAudio.volume = 0.5;
			
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
			this.initSpUI();
		}
		
		private function multiplayerGame():void{
			this.initPlayer();
			this.initPlayer2();
			this.platformhandler = new PlatformHandler(this, this.playerVector);
			//this.hazardhandler = new HazardHandler(this);
			//this.initPowerUps();
			this.initHud();
			this.initMpUI();
		}
		
		private function initPlayer():void{
			this.player1 = new Explorer(this.playerPush);
			this.player1.x = 160;
			this.player1.y = 560 - this.player1.height;
			this.m_playerLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		private function initPlayer2():void{
			this.player2 = new Cannibal(this.playerPush);
			this.player2.x = 600;
			this.player2.y = 560 - this.player2.height;
			this.m_playerLayer.addChild(this.player2);
			this.playerVector.push(this.player2);
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
			this.m_hud = new Hud(this.mode, this.playerVector);
			this.m_gameHudLayer.addChild(this.m_hud);
		}
		
		private function initSpUI():void{
			this.initGameBonusPoints();
		}
		
		private function initMpUI():void{
			this.p1_leaf = new MultiplayerHud(this.player1);
			this.p2_leaf = new MultiplayerHud(this.player2);
			this.m_gameHudLayer.addChild(this.p1_leaf);
			this.m_gameHudLayer.addChild(this.p2_leaf);
		}
		
		
		/*
		private function initGameTimer():void{
		
			this.m_gameTimer = new GameTimer();
			this.m_gameHudLayer.addChild(this.m_gameTimer);
		
		}
		*/
		
		
		private function initGameBonusPoints():void{
		
			this.m_gameBonusPoints = new GameBonusPoints(this.player1);
			this.m_gameHudLayer.addChild(this.m_gameBonusPoints);
			
		}
		
		override public function update():void{
			for(var i:int = 0; i<this.playerVector.length; i++){
				if(this.playerVector[i].alive){
					m_updateCollission(this.playerVector[i]);
					this.platformhandler.update(this.playerVector[i]);
					if(this.playerVector[i].y >= 600) this.prepareGameOver(this.playerVector[i]);
					if(this.mode == 1) this.updatePoints(this.playerVector[i]);
				}
			}
		}
		
		private function m_updateCollission(player:Player):void{
			
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
		
		private function hazardCollission(player:*, hazard:*):void{
			//this.gameOverAudio.play();
			if(player.immortal != true && hazard.lethal == true){
				this.prepareGameOver(player);
			}
		}
		
		private function prepareGameOver(player:Player):void{
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
		
		private function gemCollission(player:Player, gem:*):void{
			player.setBonusPoints(gem.value);
			this.m_gameBonusPoints.setVisibleBonusPoints(gem.value);
			gem.prepareReposition(this.positionGems);		
		}
		
		private function powerCollission(player:Player, pw:*):void{
			this.mainAudio.fade(0.2, 700, this.resetVolume);
			this.powerUpAudio.play();
			pw.reposition();
			player.setPowerUp(pw);
		}
		
		private function resetVolume():void{
			this.mainAudio.fade(0.5, 700);
		}
		
		private function playerPush(player:Player):void{
			var opponent:Player;
			player is Explorer ? opponent = this.player2 : opponent = this.player1;
			if(	player.x > opponent.x - 25 &&
				player.x < opponent.x + 25 &&
				player.y > opponent.y - 25 &&
				player.y < opponent.y + 25){
				opponent.gotPushed(player.faceRight);
			}
		}
		
		private function updatePoints(player:Player):void{
			if(player.numFlags == 6) this.prepareMpGameOver(player);
		}
		
		private function prepareMpGameOver(player:Player):void{
			this.mp_winner = player;
			Session.timer.dispose();
			Session.tweener.dispose();
			var go_delay:int = 1000;
			//Session.effects.add(new Flicker(player, go_delay, 30, true));
			Session.timer.create(go_delay, gameOverMp, 0);
		}
		
		private function gameOverMp():void{
			Session.application.displayState = new GameOver(this.mp_winner, mode);
		}
		
		override public function dispose():void{
		
			this.platformhandler.dispose();
			if(this.hazardhandler != null) this.hazardhandler.dispose();
			
		}
		
		
	}
}