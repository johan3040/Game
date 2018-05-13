package scene
{	
	
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import as3.game.GameBoard;
	import as3.game.UI.GameBonusPoints;
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
	import as3.game.gameobject.powerups.IceBlock;
	import as3.game.gameobject.powerups.Immortality;
	import as3.game.gameobject.powerups.PowerUp;
	import as3.game.gameobject.powerups.Superjump;
	
	import assets.gameObjects.RoundFinal;
	import assets.gameObjects.RoundOne;
	import assets.gameObjects.RoundTwo;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Game extends DisplayState{
		
		private var mode:int; // 1 = singleplayer 2 = multiplayer
		private var m_gameBackgroundLayer:DisplayStateLayer;
		public var gameLayer:DisplayStateLayer;
		private var m_gameHudLayer:DisplayStateLayer;
		private var m_playerLayer:DisplayStateLayer;
		private var m_hud:Hud;
		private var m_gameBonusPoints:GameBonusPoints;
		private var gb:GameBoard;
		private var player1:Player;
		private var player2:Player;
		private var pu_superjump:Superjump;
		private var pu_immortal:Immortality;
		private var pu_iceblock:IceBlock;
		private var tempHazardRect:Rectangle;
		private var gem_ruby:Ruby;
		private var gem_emerald:Emerald;
		private var mp_winner:Player;
		private var mp_rounds:int = 0;
		private var mp_roundsGFX:Vector.<MovieClip>;
		
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
		
		
		//
		// Constructor method
		//
		public function Game(mode:int){
			super();
			this.mode = mode;
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
			
			//this.mainAudio.play(999); //Loopar musiken 999 gånger
			this.mainAudio.volume = 1;
			
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
			this.initPowerUps();
			this.initHud();
			this.initMpUI();
			this.initRoundGFX();
		}
		
		private function initPlayer():void{
			this.player1 = new Explorer(this.playerPush);
			this.m_playerLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		private function initPlayer2():void{
			this.player2 = new Cannibal(this.playerPush);
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
		
			gem.x = gem.xVal;
			gem.y = gem.yVal;
		
		}
		
		private function addGemToVector(gem:Gem):void{
			
			this.hazardVector.push(gem);
			this.collidableObjects.push(gem);
		
		}
		
		private function initPowerUps():void{
			
			this.mode == 1 ? this.initSpPowerUps() : this.initMpPowerUps();
			
		}
		
		private function initSpPowerUps():void{
			this.pu_superjump = new Superjump();			
			this.collidableObjects.push(this.pu_superjump);
			this.gameLayer.addChild(this.pu_superjump);
			
			this.pu_immortal = new Immortality();
			this.collidableObjects.push(this.pu_immortal);
			this.gameLayer.addChild(this.pu_immortal);
		}
		
		private function initMpPowerUps():void{
			this.pu_iceblock = new IceBlock();
			this.collidableObjects.push(this.pu_iceblock);
			this.gameLayer.addChild(this.pu_iceblock);
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
		
		private function initRoundGFX():void{
			this.mp_roundsGFX = new Vector.<MovieClip>;
			var r1:RoundOne = new RoundOne();
			var r2:RoundTwo = new RoundTwo();
			var r3:RoundFinal = new RoundFinal();
			this.mp_roundsGFX.push(r1);
			this.mp_roundsGFX.push(r2);
			this.mp_roundsGFX.push(r3);
			this.showMpRound();
		}
		
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
					if(this.mode == 2) this.updatePoints(this.playerVector[i]);
				}
			}
		}
		
		private function m_updateCollission(player:Player):void{
			
				var a:Rectangle = player.hitBox.getRect(this.gameLayer);
				
				for(var i:int = 0; i<this.collidableObjects.length; i++){
					
					this.tempHazardRect = collidableObjects[i].hitBox.getRect(this.gameLayer);
					
					if(a.intersects(this.tempHazardRect)){
						if(this.collidableObjects[i] is Hazard){
							this.hazardCollission(player, this.collidableObjects[i] as Hazard);
							break;
						}
						if(this.collidableObjects[i] is Gem){
							this.gemCollission(player, this.collidableObjects[i] as Gem);
							break;
						}
						if(this.collidableObjects[i] is PowerUp){
							this.powerCollission(player, this.collidableObjects[i] as PowerUp);
							break;
						}
						
					}//End if intersect
				}//End hazardloop
		}//End function
		
		private function hazardCollission(player:Player, hazard:Hazard):void{
			//this.gameOverAudio.play();
			if(player.immortal != true && hazard.lethal == true){
				this.prepareGameOver(player);
			}
		}
		
		private function gemCollission(player:Player, gem:Gem):void{
			player.setBonusPoints(gem.value);
			this.m_gameBonusPoints.setVisibleBonusPoints(gem.value);
			gem.prepareReposition(this.positionGems);		
		}
		
		private function powerCollission(player:Player, pw:PowerUp):void{
			this.mainAudio.fade(0.3, 700, this.resetVolume);
			this.powerUpAudio.play();
			pw.reposition();
			this.mode == 1 ? player.setPowerUp(pw) : this.attack(pw, player);
		}
		
		private function attack(pw:PowerUp, player:Player):void{
			var receiver:Player;
			this.playerVector.indexOf(player) == 0 ? receiver = this.playerVector[1] : receiver = this.playerVector[0];
			receiver.setFrozen();
		}
		
		private function resetVolume():void{
			this.mainAudio.fade(1, 700);
		}
		
		private function playerPush(player:Player):void{
			if(this.mode == 1) return;
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
			if(player.numFlags == 1){
				player.roundsWon++;
				this.mp_rounds++;
				if(this.player1.roundsWon == 2 || this.player2.roundsWon == 2){
					this.prepareGameOver(this.getMpWinner());
					return;
				}
				this.showMpRound();
				this.newMpRound();
			}
		}
		
		private function showMpRound():void{			
			this.gameLayer.addChild(this.mp_roundsGFX[this.mp_rounds]);
			this.mp_roundsGFX[this.mp_rounds].x = 180;
			this.mp_roundsGFX[this.mp_rounds].y = 200;
			this.mp_roundsGFX[this.mp_rounds].gotoAndPlay(1);
			this.roundCountDown();
		}
		
		private function newMpRound():void{			
			this.player1.numFlags = 0;
			this.player2.numFlags = 0;
			this.resetMpRound();
			this.checkIfFrozen();
			this.positionPlayers();
			this.positionPowerUps();
		}
		
		private function resetMpRound():void{
			this.platformhandler.repositionAndNeutralizeMpPlatforms(this.mp_rounds);
		}
		
		private function checkIfFrozen():void{
			if(this.player1.frozen) this.player1.resetFrozen();
			if(this.player2.frozen) this.player2.resetFrozen();
		}
		
		private function positionPlayers():void{
			var p1:Explorer = this.player1 as Explorer;
			p1.startPosition();
			var p2:Cannibal = this.player2 as Cannibal;
			p2.startPosition();
		}
		
		private function positionPowerUps():void{
			this.pu_iceblock.resetPosition();
		}
		
		private function roundCountDown():void{
			this.player1.autoUpdate = false;
			this.player2.autoUpdate = false;
			this.pu_iceblock.autoUpdate = false;
			Session.timer.create(2000, this.setAutoUpdate);
		}
		
		private function setAutoUpdate():void{
			this.player1.autoUpdate = true;
			this.player2.autoUpdate = true;
			this.pu_iceblock.autoUpdate = true;
			this.gameLayer.removeChild(this.mp_roundsGFX[this.mp_rounds]);
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
			var p:Player;
			this.mode == 1 ? p = this.player1 : p = this.getMpWinner();
			Session.application.displayState = new GameOver(p, mode);
			
		}
		
		private function getMpWinner():Player{
			return this.player1.roundsWon > this.player2.roundsWon ? this.player1 : this.player2;
		}
		
		override public function dispose():void{
		
			this.platformhandler.dispose();
			if(this.hazardhandler != null) this.hazardhandler.dispose();
			this.playerVector = null;
			this.hazardVector = null;
			this.collidableObjects = null;
			this.m_gameBackgroundLayer = null;
			this.gameLayer = null;
			this.m_gameHudLayer = null;
			this.m_playerLayer = null;
			this.m_hud = null;
			this.m_gameBonusPoints = null;
			this.gb = null;
			this.player1 = null;
			this.player2 = null;
			this.pu_superjump = null;
			this.pu_immortal = null;
			this.pu_iceblock = null;
			this.tempHazardRect = null;
			this.gem_ruby = null;
			this.gem_emerald = null;
			this.mp_winner = null;
			this.p1_leaf = null;
			this.p2_leaf = null;
			this.gameOverAudio = null;
			this.powerUpAudio = null;
			this.mainAudio = null;
			
		}
		
		
	}
}