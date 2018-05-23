package  as3.game.gameobject.player{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import as3.game.UI.PowerupMeter;
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.platforms.LeftBase;
	import as3.game.gameobject.platforms.MpPlatform;
	import as3.game.gameobject.platforms.Platform;
	import as3.game.gameobject.platforms.RightBase;
	import as3.game.gameobject.powerups.IceBlock;
	import as3.game.gameobject.powerups.Immortality;
	import as3.game.gameobject.powerups.PowerUp;
	import as3.game.gameobject.powerups.Snail;
	import as3.game.gameobject.powerups.Superjump;
	
	import assets.gameObjects.IceBlockGFX;
	
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	
	public class Player extends GameObject {
		
		/**
		 * 
		 * Private variables
		 * 
		 */
		private var m_controls:EvertronControls;
		private var ctrl:int;
		private var speed:int = 5;
		private var current_velocity:Number;
		private var onPlat:Boolean = false;
		private var numJumps:int = 0;
		private var gravity:Number;
		private var currentY:int; // För att jämföra currentplat.y - om den ändras i Y-led
		private var wings:Boolean = false;
		
		
		/**
		 * 
		 * Private constants for player's speed, gravity and velocity
		 * 
		 */
		private const DEFAULT_VELOCITY:Number = 10;
		private const PWR_VELOCITY:Number = 14; // För power-ups
		private const DEFAULT_GRAVITY:Number = 0.8;
		private const PWR_GRAVITY:Number = 0.6;
		private const DEFAULT_SPEED:int = 5;
		private const SLOW_SPEED:int = 2;
		
		/**
		 * 
		 * Public valiables
		 * 
		 */
		public var m_skin:MovieClip;
		public var currentPlat:Platform;
		public var onGround:Boolean = false;
		public var falling:Boolean = false;
		public var velocity:Number;
		public var alive:Boolean = true;
		public var bottomHitBox:Sprite = new Sprite();
		public var bonusPoints:int = 0;
		public var immortal:Boolean = false;
		public var powerupMeters:Vector.<PowerupMeter>;
		
		/**
		 * 
		 * Variables and constants specifically for multiplayer mode
		 * 
		 */
		public var numFlags:int = 0;
		public var roundsWon:int = 0;
		public var faceRight:Boolean = true;
		private var pushPower:Number;
		private var pushCallback:Function;
		public var frozen:Boolean = false;
		public var slowedDown:Boolean = false;
		private var frozenGFX:IceBlockGFX;
		private const FRICTION:Number = 0.6;
		private const DEFAULT_PUSH_POWER:int = 10;
		
		/**
		 * 
		 * 
		 * Class's constructor method
		 * 
		 * @param int
		 * @param function
		 * 
		 */
		public function Player(ctrl:int, pushCallback:Function) {
			this.ctrl = ctrl;
			if(pushCallback != null)this.pushCallback = pushCallback;
			this.powerupMeters = new Vector.<PowerupMeter>;
			this.velocity = 0;
			this.gravity = this.DEFAULT_GRAVITY;
			this.current_velocity = this.DEFAULT_VELOCITY;
		}
		
		/**
		 * 
		 * Sets controller according to player 1
		 * 
		 */
		override public function init():void{
			this.m_controls = new EvertronControls(this.ctrl);
			this.initIceBlock();
		}
		
		/**
		 * 
		 * Initializes graphics of IceBlock - only used in multi player mode
		 * 
		 */
		private function initIceBlock():void{
			this.frozenGFX = new IceBlockGFX();
			this.frozenGFX.scaleY = 1.2;
			this.frozenGFX.x -= this.frozenGFX.width/2;
			this.frozenGFX.y -= 8;
			addChild(this.frozenGFX);
			this.frozenGFX.visible = false;
		}
		
		/**
		 * 
		 * Player's update-loop
		 * 
		 * this.frozen is only used in multiplayer mode
		 * 
		 */
		override public function update():void{
			if(this.alive && this.frozen == false){
				if(this.onGround == false) jump();
				this.updateControllers();
				if(this.currentPlat) this.checkCurrentPlat();
			}
			if(this.powerupMeters.length > 0) this.updatePowerupMeters();
		}
		
		/**
		 * 
		 * Updates player's controllers
		 * 
		 */
		private function updateControllers():void{
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_RIGHT)) 	this.m_goRight();
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_LEFT)) 	this.m_goLeft();
			
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)) this.m_jump();
			
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_2)) this.m_push();
			
			if(Input.keyboard.justReleased(this.m_controls.PLAYER_RIGHT)) this.gotoIdle();
			
			if(Input.keyboard.justReleased(this.m_controls.PLAYER_LEFT)) this.gotoIdle();
			
		}
			
		private function m_goRight():void{
			this.scaleX = 1;
			if(this.x <= 760) {
				this.x += this.speed;
				this.faceRight = true;
				if(this.onGround == true && this.wings == false){
					if(this.m_skin.currentFrameLabel != "walk") this.m_skin.gotoAndStop("walk");
				}
				
			}
		}
		
		private function m_goLeft():void{
			this.scaleX = -1;
			if(this.x>=40){ 
				this.x -= this.speed;
				this.faceRight = false;
				if(this.onGround == true && this.wings == false){
					if(this.m_skin.currentFrameLabel != "walk") this.m_skin.gotoAndStop("walk");
				}
			}
		}
		
		private function m_jump():void{
			if(this.onGround || this.numJumps<2){
				if(this.currentPlat is MpPlatform) this.steppedOfMpPlat(this.currentPlat as MpPlatform);
				if(this.wings == false) this.m_skin.gotoAndStop("jump");
				this.velocity = current_velocity;
				this.onGround = false;
				jump();
				this.numJumps++;
			}
		}
		
		/**
		 * 
		 * Method for setting 'push'-animation
		 * Only used in multiplayer mode
		 * 
		 * this.pushCallback will return 1 if game is singleplayer mode
		 * 
		 */
		private function m_push():void{
			
			if(this.pushCallback(this) == 1){
				return;
			}else{
				if(this.m_skin.currentFrameLabel != "push") this.m_skin.gotoAndStop("push");
			}			
		}
		
		private function gotoIdle():void{
			if(this.m_skin.currentFrameLabel != "idle" && this.wings == false) this.m_skin.gotoAndStop("idle");
		}

		/**
		 * 
		 * Callback from platformhandler
		 * Will set player's current platform
		 * 
		 */
		public function setCurrentPlat(plat:Platform):void{
			this.numJumps = 0;
			this.onGround = true;
			this.currentPlat = plat;
			this.currentY = this.currentPlat.y;
			if(plat is LeftBase || plat is RightBase){
				this.y = this.currentPlat.y - this.obj_height + 10;
			}else{
				this.y = this.currentPlat.y - this.obj_height;
			}
				
			this.velocity = 0;
			if(this.wings == false) this.m_skin.gotoAndStop("idle");

		}
		
		/**
		 * 
		 * Checks if player is within the bounds of current platform
		 * 
		 */
		private function checkCurrentPlat():void{
			
			if((this.x + this.obj_width/2) < this.currentPlat.x ||
				this.x-this.obj_width/2  > (this.currentPlat.x + this.currentPlat.obj_width) 	||
				this.currentPlat.exists == false ||
				this.currentPlat.y != this.currentY){	
				this.velocity = 0;
				this.onGround = false;
				if(this.currentPlat is MpPlatform) this.steppedOfMpPlat(this.currentPlat as MpPlatform);
				this.currentPlat = null;
			}
			
		}
		
		private function updatePowerupMeters():void{
			for(var i:int = 0; i < this.powerupMeters.length; i++){
				this.powerupMeters[i].update();
			}
		}
		
		public function removePowerupMeter(timer:PowerupMeter):void{
			var i:int = this.powerupMeters.indexOf(timer);
			if(i != -1){
				removeChild(this.powerupMeters[i]);
				this.powerupMeters.splice(i,1);
				if(this.powerupMeters.length == 1) this.powerupMeters[0].setY();
			}
		}
		
		/**
		 * 
		 * Calls class MpPlatform's method if player leaves platform
		 * 
		 */
		private function steppedOfMpPlat(plat:MpPlatform):void{
			plat.visitorLeft(this);
		}
		
		/**
		 * 
		 * Physics for jumping
		 * 
		 */
		private function jump():void{
			
			if(this.y <= 5){
				this.y = 5;
				this.velocity -= 1.3;
			} 
			this.velocity < 0 ? this.falling = true : this.falling = false;
			this.currentPlat = null;
			this.y -= this.velocity;
			this.velocity -= this.gravity;
			
		}
		
		public function setBonusPoints(point:int):void{
			this.bonusPoints+=point;
		}
		
		/**
		 * 
		 * Callback method from class 'SingleplayerGame'
		 * 
		 * @param PowerUp
		 */
		public function setPowerUp(pw:PowerUp):void{
			this.setPowerMeter(pw as PowerUp);
			if(pw is Superjump) this.setVelocity(pw as Superjump);
			if(pw is Immortality) this.setImmortality(pw as Immortality);
		}
		
		/**
		 * 
		 * Sets player's velocity and game worlds gravity
		 * 
		 */
		private function setVelocity(pw:Superjump):void{
			this.current_velocity = this.PWR_VELOCITY;
			this.gravity = this.PWR_GRAVITY;
			this.m_skin.gotoAndStop("wings");
			this.wings = true;
			Session.timer.create(pw.duration, this.resetVelocity);
		}
		
		private function resetVelocity():void{
			this.current_velocity = this.DEFAULT_VELOCITY;
			this.gravity = this.DEFAULT_GRAVITY;
			this.wings = false;
			this.m_skin.gotoAndStop("idle");
		}
		
		/**
		 * 
		 * Sets player's immortality property
		 * 
		 */
		private function setImmortality(pw:Immortality):void{
		
			this.immortal = true;
			Session.effects.add(new Flicker(this.m_skin, pw.duration, 30, true));
			Session.timer.create(pw.duration, this.resetImmortality);
		}
		
		private function resetImmortality():void{
			this.immortal = false;
		}
		
		private function setPowerMeter(pw:PowerUp):void{
			var p:PowerupMeter = new PowerupMeter(pw, this.removePowerupMeter, this);
			addChild(p);
			this.powerupMeters.push(p);
		}
		
		/**
		 * 
		 * Callback from class 'MultiplayerGame'
		 * 
		 * Player gets pushed from opponent
		 * 
		 * Creates timer and alters player's x-position
		 * 
		 * @param Boolean
		 * 
		 */
		public function gotPushed(fromRight:Boolean):void{
			this.pushPower = this.DEFAULT_PUSH_POWER;
			fromRight ? Session.timer.create(10, this.movePushRight, 10) : Session.timer.create(10, this.movePushLeft, 10);
		}
		
		private function movePushRight():void{
			if(this.x < 760 && this.frozen == false){
				this.x += this.pushPower;
				this.pushPower -= this.FRICTION;
			}
		}
		
		private function movePushLeft():void{
			if(this.x > 40 && this.frozen == false){
				this.x -= this.pushPower;
				this.pushPower -= this.FRICTION;
			}
		}
		
		/**
		 * 
		 * Method used for Multiplayer mode.
		 * 
		 * If player is frozen he cannot move
		 * 
		 */
		public function setFrozen(pw:IceBlock):void{
			this.setPowerMeter(pw as PowerUp);
			this.frozen = true;
			this.frozenGFX.visible = true;
			Session.timer.create(pw.duration, this.resetFrozenState);
		}
		
		public function resetFrozenState():void{
			this.frozen = false;
			this.frozenGFX.visible = false;
		}
		
		/**
		 * 
		 * Callback from class 'MultiplayerGame'
		 * 
		 * Resets player frozen-state when a new MP-round is active
		 * 
		 */
		public function resetFrozen():void{
			Session.timer.dispose();
			this.resetFrozenState();
		}
		
		/**
		 * 
		 * Used for multiplayer mode to set new speed to player
		 * 
		 * @param Snail
		 */
		public function setSpeed(pw:Snail):void{
			this.setPowerMeter(pw as PowerUp);
			this.slowedDown = true;
			this.speed = this.SLOW_SPEED;
			Session.timer.create(pw.duration, this.resetToNormalSpeed);
		}
		
		private function resetToNormalSpeed():void{
			this.slowedDown = false;
			this.speed = this.DEFAULT_SPEED;
		}
		
		/**
		 * 
		 * Callback from class 'MultiplayerGame'
		 * 
		 * Resets player speed when a new MP-round is active
		 * 
		 */
		public function resetSpeed():void{
			Session.timer.dispose();
			this.resetToNormalSpeed();
		}
		//--------------------------------
		// End MP mehtods
		//--------------------------------
		
		override public function dispose():void{
			
			this.m_controls = null;
			this.currentPlat = null;
			this.bottomHitBox = null;
		
		}

	}
	
}
