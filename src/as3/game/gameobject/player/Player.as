package  as3.game.gameobject.player{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.platforms.LeftBase;
	import as3.game.gameobject.platforms.MpPlatform;
	import as3.game.gameobject.platforms.Platform;
	import as3.game.gameobject.platforms.RightBase;
	import as3.game.gameobject.powerups.Immortality;
	import as3.game.gameobject.powerups.PowerUp;
	import as3.game.gameobject.powerups.Superjump;
	
	import assets.gameObjects.IceBlock;
	
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	
	public class Player extends GameObject {
		
		private var m_controls:EvertronControls;
		public var m_skin:MovieClip;
		private var ctrl:int;
		private var speed:int = 5;
		private var current_velocity:Number;
		private var onGround:Boolean = false;
		private var onPlat:Boolean = false;
		public var currentPlat:Platform;
		private var numJumps:int = 0;
		private var gravity:Number;
		private var currentY:int; // För att jämföra currentplat.y - om den ändras i Y-led
		private var wings:Boolean = false;
		
		private const DEFAULT_VELOCITY:Number = 10;
		private const PWR_VELOCITY:Number = 14; // För power-ups
		private const DEFAULT_GRAVITY:Number = 0.8;
		private const PWR_GRAVITY:Number = 0.6;
		
		public var falling:Boolean = false;
		public var velocity:Number;
		public var alive:Boolean = true;
		public var bottomHitBox:Sprite = new Sprite();
		public var bonusPoints:int = 0;
		public var immortal:Boolean = false;
		
		//For MP
		public var numFlags:int = 0;
		public var roundsWon:int = 0;
		public var faceRight:Boolean = false;
		private var pushPower:Number;
		private var pushCallback:Function;
		public var frozen:Boolean = false;
		private var frozenGFX:IceBlock;
		private const FRICTION:Number = 0.6;
		private const DEFAULT_PUSH_POWER:int = 10;
		
		public function Player(ctrl:int, pushCallback:Function) {
			this.ctrl = ctrl;
			this.pushCallback = pushCallback;
			this.velocity = 0;
			this.gravity = this.DEFAULT_GRAVITY;
			this.current_velocity = this.DEFAULT_VELOCITY;
		}
		
		override public function init():void{
			this.m_controls = new EvertronControls(this.ctrl);
			this.initIceBlock();
		}
		
		private function initIceBlock():void{
			this.frozenGFX = new IceBlock();
			this.frozenGFX.x -= this.frozenGFX.width/2;
			addChild(this.frozenGFX);
			this.frozenGFX.visible = false;
		}
		
		override public function update():void{
			if(this.alive && this.frozen == false){
				if(this.onGround == false) jump();
				this.updateControllers();
				if(this.currentPlat) this.checkCurrentPlat();
			}
		}
			
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
		
		private function m_push():void{
			
			if(this.pushCallback(this) == 1){
				return;
			}else{
				//if(this.m_skin.currentFrameLabel != "push") this.m_skin.gotoAndStop("push");
			}
			
			
		}
		
		private function gotoIdle():void{
			if(this.m_skin.currentFrameLabel != "idle" && this.wings == false) this.m_skin.gotoAndStop("idle");
		}

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
		
		private function checkCurrentPlat():void{
			
			if((this.x + this.obj_width/2) < this.currentPlat.x ||
				this.x-this.obj_width/2  > (this.currentPlat.x + this.currentPlat.obj_width) 	||
				this.currentPlat.exists == false			||
				this.currentPlat.y != this.currentY){				
				this.velocity = 0;
				this.onGround = false;
				if(this.currentPlat is MpPlatform) this.steppedOfMpPlat(this.currentPlat as MpPlatform);
				this.currentPlat = null;
			}
			
		}
		
		private function steppedOfMpPlat(plat:MpPlatform):void{
			plat.visitorLeft(this);
		}
		
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
		
		
		//Methods for power-ups
		
		public function setPowerUp(pw:PowerUp):void{
			if(pw is Superjump) this.setVelocity();
			if(pw is Immortality) this.setImmortality();
		}
		
		private function setVelocity():void{
			
			if(this.current_velocity != this.PWR_VELOCITY){
				this.current_velocity = this.PWR_VELOCITY;
				this.gravity = this.PWR_GRAVITY;
				this.m_skin.gotoAndStop("wings");
				this.wings = true;
				Session.timer.create(4000, this.setVelocity);
			}else{
				this.current_velocity = this.DEFAULT_VELOCITY;
				this.gravity = this.DEFAULT_GRAVITY;
				this.wings = false;
				this.m_skin.gotoAndStop("idle");
			}
		}
		
		private function setImmortality():void{
		
			if(this.immortal){
				this.immortal = false;
			}else{
				this.immortal = true;
				Session.effects.add(new Flicker(this.m_skin, 4000, 30, true));
				Session.timer.create(4000, this.setImmortality);
			}
		
		}
		//End power ups
		
		//--------------------------------
		// MP methods
		//--------------------------------
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
		
		public function setFrozen():void{
			if(this.frozen){
				this.frozen = false;
				this.frozenGFX.visible = false;
			}else{
				this.frozen = true;
				this.frozenGFX.visible = true;
				Session.timer.create(5000, this.setFrozen);
			}
		}
		
		public function resetFrozen():void{
			Session.timer.dispose();
			this.setFrozen();
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
