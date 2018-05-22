package scene{
	import flash.geom.Rectangle;
	
	import as3.game.UI.GameBonusPoints;
	import as3.game.UI.Hud;
	import as3.game.gameHandler.HazardHandler;
	import as3.game.gameHandler.PlatformHandler;
	import as3.game.gameHandler.SoundHandler;
	import as3.game.gameobject.gems.Emerald;
	import as3.game.gameobject.gems.Gem;
	import as3.game.gameobject.gems.Ruby;
	import as3.game.gameobject.hazards.Hazard;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	import as3.game.gameobject.powerups.Immortality;
	import as3.game.gameobject.powerups.PowerUp;
	import as3.game.gameobject.powerups.Superjump;
	
	import se.lnu.stickossdk.media.SoundObject;
	
	public class SingleplayerGame extends Game{
		
		private var m_gameBonusPoints:GameBonusPoints;
		private var gem_ruby:Ruby;
		private var gem_emerald:Emerald;
		private var hazardhandler:HazardHandler;
		private var pu_superjump:Superjump;
		private var pu_immortal:Immortality;
		
		[Embed(source = "../../assets/audio/PointAU.mp3")] 	// <-- this data..
		private const POINT_AUDIO:Class;						// ..gets saved in this const
		private var pointAudio:SoundObject;
		
		
		/**
		 * 
		 * Class constructor
		 * 
		 * @param mode == 1
		 * 
		 */
		public function SingleplayerGame(mode:int){
			super(mode);			
		}
		
		override public function init():void{
			this.initPlayer();
			this.platformhandler = new PlatformHandler(this, this.playerVector);
			this.hazardhandler = new HazardHandler(this);
			this.soundHandler = new SoundHandler(1);
			this.initHud();
			this.initSpUI();
			this.initAudio();
			this.initGems();
			this.initPowerUps();
		}
		
		/**
		 * 
		 * Adds player1 to dedicated player-layer
		 * 
		 */
		private function initPlayer():void{
			this.player1 = new Explorer(0, this.playerPush);
			this.m_playerLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		/**
		 * 
		 * Adds Hud to dedicated hud-layer
		 * 
		 */
		private function initHud():void{
			this.m_hud = new Hud(this.playerVector);
			this.m_gameHudLayer.addChild(this.m_hud);
		}
		
		/**
		 * 
		 * Starts main game-music via soundHandler
		 * 
		 */
		private function initAudio():void{
			this.soundHandler.playMainAudio();
		}
		
		/**
		 * 
		 * Adds graphics for bonus points
		 * 
		 */
		private function initSpUI():void{
			this.initGameBonusPoints();
		}
		
		private function initGameBonusPoints():void{
			
			this.m_gameBonusPoints = new GameBonusPoints(this.player1);
			this.m_gameHudLayer.addChild(this.m_gameBonusPoints);
			
		}
		
		/**
		 * 
		 * Initializes classes 'Ruby' and 'Sapphire'
		 * 
		 */
		private function initGems():void{
			this.initRuby();
			this.initSapphire();
		}
		
		/**
		 * 
		 * Adds Ruby-object to game-layer
		 * Calls position method for that object
		 * 
		 */
		private function initRuby():void{
			
			this.gem_ruby = new Ruby(this.player1);
			this.positionGems(this.gem_ruby);
			this.gameLayer.addChild(this.gem_ruby);
			this.hazardVector.push(this.gem_ruby);
			this.collidableObjects.push(this.gem_ruby);
		}
		
		/**
		 * 
		 * Adds Sapphire-object to game-layer
		 * Calls position method for that object
		 * 
		 */
		private function initSapphire():void{
			
			this.gem_emerald = new Emerald(this.player1);
			this.positionGems(this.gem_emerald);
			this.gameLayer.addChild(this.gem_emerald);
			this.addGemToVector(this.gem_emerald);
		}
		
		/**
		 * 
		 * Positions objects of type 'Gem'
		 * 
		 * gem.xVal / yVal == dedicated getter in class 'Gem'
		 * 
		 */
		private function positionGems(gem:Gem):void{
			
			gem.x = gem.xVal;
			gem.y = gem.yVal;
			
		}
		
		/**
		 * 
		 * Adds gem to vector
		 * 
		 * @param Gem
		 * 
		 */
		private function addGemToVector(gem:Gem):void{
			
			this.collidableObjects.push(gem);
			
		}
		
		
		/**
		 * 
		 * Initializes power-ups
		 * 
		 * Adds objects to game-layer
		 * 
		 */
		private function initPowerUps():void{
			this.pu_superjump = new Superjump();			
			this.collidableObjects.push(this.pu_superjump);
			this.gameLayer.addChild(this.pu_superjump);
			
			this.pu_immortal = new Immortality();
			this.collidableObjects.push(this.pu_immortal);
			this.gameLayer.addChild(this.pu_immortal);
		}
		
		/**
		 * 
		 * Game update-loop
		 * 
		 * If player is alive - check position and match with collidable objects
		 * 
		 * Platformhandler checks intersection between all platforms and player
		 * 
		 * If player falls in water and Y-position is >= 600 - prepare for game over state
		 * 
		 */
		override public function update():void{
			
			if(this.playerVector[0].alive){
				m_updateCollission(this.playerVector[0]);
				this.platformhandler.update(this.playerVector[0]);
				if(this.playerVector[0].y >= 600) this.prepareGameOver(this.playerVector[0]);
			}
		}
		
		
		/**
		 * 
		 * Checks if Player's hitBox intersects with any of the collidabe objects's hitbox
		 * 
		 * @param Player
		 * 
		 */
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
		
		/**
		 * 
		 * Checks if player is not immortal and calls method in superclass 'Game'
		 * 
		 * @param Player
		 * @param Hazard
		 * 
		 */
		private function hazardCollission(player:Player, hazard:Hazard):void{
			if(player.immortal != true && hazard.lethal == true){
				super.prepareGameOver(player);
			}
		}
		
		/**
		 * 
		 * Calls method in soundHandler 
		 * Sets accurate points for @param Player
		 * Calls for reposition method for 'Gem' object
		 * 
		 */
		private function gemCollission(player:Player, gem:Gem):void{
			this.soundHandler.gemCollission();
			player.setBonusPoints(gem.value);
			this.m_gameBonusPoints.setVisibleBonusPoints(gem.value);
			gem.prepareReposition(this.positionGems);
		}
		
		/**
		 * 
		 * Calls method in soundHandler
		 * Sets powerup for @param Player
		 * Calls reposition method for 'PowerUp' object
		 * 
		 */
		private function powerCollission(player:Player, pw:PowerUp):void{
			this.soundHandler.powerUpCollission();
			player.setPowerUp(pw);
			pw.reposition();
		}
		
		/**
		 * 
		 * @return int
		 * 
		 */
		private function playerPush(player:Player):int{
			return 1;
		}
		
		override public function dispose():void{
			this.gem_ruby = null;
			this.gem_emerald = null;
			this.m_gameBonusPoints = null;
			this.pu_superjump = null;
			this.pu_immortal = null;
			this.hazardhandler.dispose();
			this.soundHandler.dispose();
		}
		
	}
}