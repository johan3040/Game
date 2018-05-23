package scene{
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	
	import as3.game.UI.Hud;
	import as3.game.UI.MultiplayerHud;
	import as3.game.gameHandler.PlatformHandler;
	import as3.game.gameHandler.SoundHandler;
	import as3.game.gameobject.player.Cannibal;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	import as3.game.gameobject.powerups.IceBlock;
	import as3.game.gameobject.powerups.PowerUp;
	import as3.game.gameobject.powerups.Snail;
	
	import assets.gameObjects.RoundFinal;
	import assets.gameObjects.RoundOne;
	import assets.gameObjects.RoundTwo;
	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timers;
	import se.lnu.stickossdk.tween.easing.Back;
	
	public class MultiplayerGame extends Game{
		
		private var p1_leaf:MultiplayerHud;
		private var p2_leaf:MultiplayerHud;
		private var pu_iceblock:IceBlock;
		private var pu_snail:Snail;
		private var mp_roundsGFX:Vector.<MovieClip>;
		private var showRound:Boolean = false;
		private var updateMP:Boolean = true;
		private var mp_rounds:int = 0;
		private var winnerCurrentRound:Player;
		
		private var flagTimers:Timers;
		
		/**
		 * 
		 * Class's constructor method
		 * 
		 * @param int == 2
		 * 
		 */
		public function MultiplayerGame(mode:int){
			super(mode);
		}
		
		/**
		 * 
		 * Initializes class methods
		 * 
		 */
		override public function init():void{
			this.initPlayer();
			this.initPlayer2();
			this.platformhandler = new PlatformHandler(this, this.playerVector);
			this.soundHandler = new SoundHandler(2);
			this.initPowerUps();
			this.initHud();
			this.initMpUI();
			this.initRoundGFX();
			this.initAudio();
			this.initTimers();
		}
		
		/**
		 * 
		 * Adds player1 to dedicated player-layer
		 * Pushes object into playerVector
		 * 
		 */
		private function initPlayer():void{
			this.player1 = new Explorer(0, this.playerPush, this.m_powerupMeterLayer);
			this.m_playerLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		/**
		 * 
		 * Adds player2 to dedicated player-layer
		 * Pushes object into plyerVector
		 * 
		 */
		private function initPlayer2():void{
			this.player2 = new Cannibal(1, this.playerPush, this.m_powerupMeterLayer);
			this.m_playerLayer.addChild(this.player2);
			this.playerVector.push(this.player2);
		}
		
		/**
		 * 
		 * Initializes multiplayer Hud
		 * 
		 */
		private function initHud():void{
			this.m_hud = new Hud(this.playerVector);
			this.m_gameHudLayer.addChild(this.m_hud);
		}
		
		/**
		 * 
		 * Initializes multiplayer UI (for game points)
		 * 
		 */
		private function initMpUI():void{
			this.p1_leaf = new MultiplayerHud(this.player1);
			this.p2_leaf = new MultiplayerHud(this.player2);
			this.m_gameHudLayer.addChild(this.p1_leaf);
			this.m_gameHudLayer.addChild(this.p2_leaf);
		}
		
		/**
		 * 
		 * Initializes multiplayer power-ups
		 * 
		 */
		private function initPowerUps():void{
			this.pu_iceblock = new IceBlock();
			this.collidableObjects.push(this.pu_iceblock);
			this.gameLayer.addChild(this.pu_iceblock);
			this.pu_snail = new Snail();
			this.collidableObjects.push(this.pu_snail);
			this.gameLayer.addChild(this.pu_snail);
		}
		
		
		/**
		 * 
		 * Initializes graphics for round-information
		 * Pushes graphics into vector
		 * 
		 */
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
		
		/**
		 * 
		 * Plays main game audio
		 * 
		 */
		private function initAudio():void{
			this.soundHandler.playMainAudio();
		}
		
		private function initTimers():void{
			this.flagTimers = new Timers();
		}
		
		/**
		 * 
		 * Checks if @param Player has opponent nearby. If so, call method 'gotPushed' in class 'Player'
		 * 
		 * @return int == 2
		 * 
		 */
		protected function playerPush(player:Player):int{
			var opponent:Player;
			player is Explorer ? opponent = this.player2 : opponent = this.player1;
			if(	player.x > opponent.x - 25 &&
				player.x < opponent.x + 25 &&
				player.y > opponent.y - 25 &&
				player.y < opponent.y + 25){
				opponent.gotPushed(player.faceRight);
			}
			return 2;
		}
		
		/**
		 * 
		 * Shows round info in beginning of every multiplayer round
		 * 
		 */
		private function showMpRound():void{			
			this.gameLayer.addChild(this.mp_roundsGFX[this.mp_rounds]);
			this.mp_roundsGFX[this.mp_rounds].x = 180;
			this.mp_roundsGFX[this.mp_rounds].y = 200;
			this.mp_roundsGFX[this.mp_rounds].gotoAndPlay(1);
			this.showRound = true;
			this.setUpdateOff();
		}
		
		/**
		 * 
		 * Initializes new multiplayer round
		 * 
		 */
		private function initNewMpRound():void{
			this.showMpRound();
			this.newMpRound();
		}
		
		private function newMpRound():void{			
			this.player1.numFlags = 0;
			this.player2.numFlags = 0;
			this.player1.onGround = false;
			this.player2.onGround = false;
			this.player1.currentPlat = null;
			this.player2.currentPlat = null;
			this.winnerCurrentRound = null;
			this.resetMpRound();
			this.checkIfActivePowerups();
			this.positionPlayers();
			this.positionPowerUps();
		}
		
		/**
		 * 
		 * Calls method in 'platformhandler'
		 * 
		 */
		private function resetMpRound():void{
			this.platformhandler.repositionAndNeutralizeMpPlatforms(this.mp_rounds);
		}
		
		/**
		 * 
		 * Checks if players has active powerups in beginning of round
		 * 
		 */
		private function checkIfActivePowerups():void{
			for(var i:int = 0; i < this.playerVector.length; i++){
				if(this.playerVector[i].slowedDown || this.playerVector[i].frozen) this.playerVector[i].clearActivePowerups();
				if(this.playerVector[i].frozen) this.playerVector[i].resetFrozen();
				if(this.playerVector[i].slowedDown) this.playerVector[i].resetSpeed();
			}
		}
		
		/**
		 * 
		 * Sets start positions for both players
		 * 
		 */
		private function positionPlayers():void{
			var p1:Explorer = this.player1 as Explorer;
			p1.startPosition();
			var p2:Cannibal = this.player2 as Cannibal;
			p2.startPosition();
		}
		
		/**
		 * 
		 * Sets start positions for power-ups
		 * 
		 */
		private function positionPowerUps():void{
			this.pu_iceblock.reposition();
			this.pu_snail.reposition();
		}
		
		
		
		/**
		 * 
		 * Game update-loop
		 * 
		 * Calls methods for collission check of power-ups and platforms
		 * 
		 */
		override public function update():void{
			for(var i:int = 0; i<this.playerVector.length; i++){
				m_updateCollission(this.playerVector[i]);
				this.platformhandler.update(this.playerVector[i]);
				if(this.updateMP) this.updatePoints(this.playerVector[i]);
			}
			if(this.showRound) this.checkRoundGFX();
		}
		
		/**
		 * 
		 * Collission detection for power ups and players
		 * 
		 * @param Player
		 * 
		 */
		private function m_updateCollission(player:Player):void{
		
			var a:Rectangle = player.hitBox.getRect(this.gameLayer);
			for(var i:int = 0; i<this.collidableObjects.length; i++){
				this.tempHazardRect = collidableObjects[i].hitBox.getRect(this.gameLayer);
				if( a.intersects(this.tempHazardRect) ) this.collission(player, this.collidableObjects[i] as PowerUp);				
			}//End loop
		}//End function
		
		/**
		 * 
		 * Sets actions depending on what @param pw @param player colided with
		 * 
		 */
		private function collission(player:Player, pw:PowerUp):void{
			this.soundHandler.powerUpCollission();
			pw.reposition();
			var receiver:Player = this.playerVector.indexOf(player) == 0 ? receiver = this.playerVector[1] : receiver = this.playerVector[0];
			if(pw is IceBlock) receiver.setFrozen(pw as IceBlock);				
			if(pw is Snail) receiver.setSpeed(pw as Snail);
		}
		
		/**
		 * 
		 * Checks if @param Player has 6 registered flags
		 * If condition is met - call methods and prepare for new round
		 * 
		 */
		private function updatePoints(player:Player):void{
			if(player.numFlags == 6){
				player.roundsWon++;
				this.updateMP = false;
				this.setUpdateOff();
				this.gotoIdleSkin();
				this.clearTimers();
				this.winnerCurrentRound = player;
				this.roundWinnerFxOne();
				this.mp_rounds++;
				this.checkIfGameOver();
				Session.timer.create(2000, this.initNewMpRound,0,true);
			}
		}
		
		/**
		 * 
		 * Clears all registered timer-objects
		 * 
		 */
		private function clearTimers():void{
			Session.timer.dispose();
		}
		
		/**
		 * 
		 * Effect on round winner
		 * Scales up to 2x size
		 * 
		 */
		private function roundWinnerFxOne():void{
			var sX:int = this.winnerCurrentRound.faceRight == true ? 2 : -2;
			Session.tweener.add(this.winnerCurrentRound,{
				transition: Back.easeOut,
				scaleX: sX,
				scaleY: 2,
				duration: 500,
				onComplete: this.roundWinnerFxTwo
			});
		}
		
		/**
		 * 
		 * Effect on round winner, scales down to original size
		 * 
		 */
		private function roundWinnerFxTwo():void{
			var sX:int = this.winnerCurrentRound.faceRight == true ? 1 : -1;
			Session.tweener.add(this.winnerCurrentRound,{
				transition: Back.easeOut,
				scaleX: sX,
				scaleY: 1,
				duration: 500
			});
		}
		
		/**
		 * 
		 * Shows graphics of round-information (eg "Round 1", "Final Round") for 120 frames (2 sec)
		 * Removes graphics after 120 frames
		 * 
		 */
		private function checkRoundGFX():void{
			if(this.mp_roundsGFX[this.mp_rounds].currentFrame == 120){
				this.gameLayer.removeChild(this.mp_roundsGFX[this.mp_rounds]);
				this.showRound = false;
				this.setAutoUpdate();
				this.updateMP = true;
			}
		}
		
		/**
		 * 
		 * Resets all objects's autoUpdate property to true
		 * 
		 */
		private function setAutoUpdate():void{
			this.player1.autoUpdate = true;
			this.player2.autoUpdate = true;
			this.pu_iceblock.autoUpdate = true;
			this.pu_snail.autoUpdate = true;
		}
		
		/**
		 * 
		 * Sets all objects's autoUpdate property to false
		 * 
		 * Used when a round has winner until next round is active
		 * 
		 */
		private function setUpdateOff():void{
			this.player1.autoUpdate = false;
			this.player2.autoUpdate = false;
			this.pu_iceblock.autoUpdate = false;
			this.pu_snail.autoUpdate = false;
		}
		
		private function gotoIdleSkin():void{
			if(this.player1.m_skin.currentFrameLabel != "idle") this.player1.m_skin.gotoAndStop("idle");
			if(this.player2.m_skin.currentFrameLabel != "idle") this.player2.m_skin.gotoAndStop("idle");
		}
		
		/**
		 * 
		 * Checks if any of the players have won 2 rounds - if so, prepare for game over
		 * 
		 */
		private function checkIfGameOver():void{
			if(this.player1.roundsWon == 2 || this.player2.roundsWon == 2){
				this.roundWinnerFxOne();
				super.prepareGameOver(super.getMpWinner());
			}
		}
		
		override public function dispose():void{
			this.p1_leaf = null;
			this.p2_leaf = null;
			this.player2 = null;
			this.pu_iceblock = null;
			this.soundHandler.dispose();
		}
		
	}
}