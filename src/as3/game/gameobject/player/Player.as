package  as3.game.gameobject.player{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.platforms.LeftBase;
	import as3.game.gameobject.platforms.RightBase;
	import as3.game.gameobject.powerups.Immortality;
	import as3.game.gameobject.powerups.PowerUp;
	import as3.game.gameobject.powerups.Superjump;
	
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	
	public class Player extends GameObject {
		
		private var m_controls:EvertronControls;
		public var m_skin:MovieClip;
		private var ctrl:int;
		private var speed:int = 6;
		private var current_velocity:Number;
		private var onGround:Boolean = false;
		private var onPlat:Boolean = false;
		private var currentPlat:GameObject;
		private var numJumps:int = 0;
		private var gravity:Number;
		private var currentY:int; // För att jämföra currentplat.y - om den ändras i Y-led
		
		private const DEFAULT_VELOCITY:Number = 10;
		private const PWR_VELOCITY:Number = 14; // För power-ups
		private const DEFAULT_GRAVITY:Number = 0.9;
		private const PWR_GRAVITY:Number = 0.6;
		
		public var falling:Boolean = false;
		public var velocity:Number;
		public var alive:Boolean = true;
		public var bottomHitBox:Sprite;
		public var bonusPoints:int = 0;
		public var immortal:Boolean = false;

		
		public function Player(ctrl) {
			this.ctrl = ctrl;
			this.velocity = 0;
			this.gravity = this.DEFAULT_GRAVITY;
			this.current_velocity = this.DEFAULT_VELOCITY;
		}
		
		override public function init():void{
			this.m_controls = new EvertronControls(this.ctrl);
		}
			
		override public function update():void{
			if(this.alive){
				if(this.onGround == false) jump();
				updateControllers();
				if(this.currentPlat) checkCurrentPlat();
			}
		}
			
		private function updateControllers():void{
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_RIGHT)) 	this.m_goRight();
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_LEFT)) 	this.m_goLeft();
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_DOWN)) 	this.m_goDown();
			
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)) this.m_jump();
			
			if(Input.keyboard.justReleased(this.m_controls.PLAYER_RIGHT)) this.m_skin.gotoAndStop("idle");
			
			if(Input.keyboard.justReleased(this.m_controls.PLAYER_LEFT)) this.m_skin.gotoAndStop("idle");
			
		}
			
		private function m_goRight():void{
			this.scaleX = 1;
			if(this.x <= 760) {
				this.x += this.speed;
				if(this.onGround == true){
					if(this.m_skin.currentFrame != 2) this.m_skin.gotoAndStop("walk");
				}
				
			}
		}
		
		private function m_goLeft():void{
			this.scaleX = -1;
			if(this.x>=40){ 
				this.x -= this.speed;
				if(this.onGround == true){
					if(this.m_skin.currentFrame != 2) this.m_skin.gotoAndStop("walk");
				}
			}
		}
		
		private function m_goDown():void{
			
			if(this.currentPlat){
				// Go down trough plat
			}
		
		}
		
		private function m_jump():void{
			if(this.onGround || this.numJumps<2){
				this.m_skin.gotoAndStop("jump");
				this.velocity = current_velocity;
				this.onGround = false;
				jump();
				this.numJumps++;
			}
		}

		public function setCurrentPlat(plat:GameObject):void{
			this.numJumps = 0;
			this.onGround = true;
			this.currentPlat = plat;
			this.currentY = this.currentPlat.y;
			if(plat is LeftBase || plat is RightBase){
				this.y = this.currentPlat.y - this.height + 10;
			}else{
				this.y = this.currentPlat.y - this.height;
			}
				
			this.velocity = 0;
			this.m_skin.gotoAndStop("idle");

		}
		
		private function checkCurrentPlat():void{
			
			if((this.x + this.width/2) < this.currentPlat.x ||
				this.x-this.width/2  > (this.currentPlat.x + this.currentPlat.obj_width) 	||
				this.currentPlat.exists == false			||
				this.currentPlat.y != this.currentY){				
				this.velocity = 0;
				this.onGround = false;
				this.currentPlat = null;
			}
			
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
				Session.timer.create(4000, this.setVelocity);
			}else{
				this.current_velocity = this.DEFAULT_VELOCITY;
				this.gravity = this.DEFAULT_GRAVITY;
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
		
		override public function dispose():void{
			
			this.m_controls = null;
			this.currentPlat = null;
			this.bottomHitBox = null;
		
		}

	}
	
}
