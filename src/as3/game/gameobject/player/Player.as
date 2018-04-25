package  as3.game.gameobject.player{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.platforms.LeftBase;
	import as3.game.gameobject.platforms.RightBase;
	
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	
	
	public class Player extends GameObject {
		
		private var m_controls:EvertronControls;
		private var ctrl:int;
		private var speed:int = 6;
		public var velocity:Number;
		private const DEFAULT_VELOCITY:Number = 10;
		private const GRAVITY:Number = 0.9;
		private var onGround:Boolean = false;
		public var falling:Boolean = false;
		private var onPlat:Boolean = false;
		private var currentPlat:GameObject;
		public var bottomHitBox:Sprite;
		public var bonusPoints:int = 0;
		private var numJumps:int = 0;
		
		// För att jämföra currentplat.y - om den ändras i Y-led
		private var currentY:int;
		public var m_skin:MovieClip;
		
		//Power-ups
		public var immortal:Boolean;
		private const PWR_VELOCITY:Number = 22; // För power-ups

		
		public function Player(ctrl) {
			this.ctrl = ctrl;
			this.velocity = 0;
		}
		
		override public function init():void{
			this.m_controls = new EvertronControls(this.ctrl);
		}
			
		override public function update():void{
			if(this.onGround == false) jump();
			updateControllers();
			if(this.currentPlat) checkCurrentPlat();
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
				this.velocity = DEFAULT_VELOCITY;
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
			
			this.velocity < 0 ? this.falling = true : this.falling = false;
			this.currentPlat = null;
			this.y -= this.velocity;
			
			this.velocity -= this.GRAVITY;
			if(this.y + this.height >= 600){
				this.onGround = true;
				this.y = 600 - this.height;
				this.velocity = 0;
			}
			
		}
		
		public function setBonusPoints(point:int):void{
			this.bonusPoints+=point;
		}
		
		
		//Methods for power-ups
		public function setVelocity():void{
		
			
		
		}
		
		public function setImmortality():void{
		
			
		
		}
		
		override public function dispose():void{
			
			this.m_controls = null;
			this.currentPlat = null;
			this.bottomHitBox = null;
		
		}

	}
	
}
