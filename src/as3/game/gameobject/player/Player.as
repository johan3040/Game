package  as3.game.gameobject.player{
	
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.platforms.Platform;
	import as3.game.gameobject.platforms.WeakPlatform;
	
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	
	
	public class Player extends GameObject {
		
		private var m_controls:EvertronControls;
		private var ctrl:int;
		private var onGround:Boolean = true;
		private var speed:int = 12;
		
		private var velocity:Number;
		private const DEFAULT_VELOCITY:Number = 20;
		private const PWR_VELOCITY:Number = 22; // För power-ups
		
		private var falling:Boolean = false;
		private var onPlat:Boolean = false;
		private var currentPlat:GameObject;
		private var pv:Vector.<Platform>;
		
		private var timeoutWP:uint;
		private var isOnWeak:Boolean = false;
		
		/*Om man ska tweaka fysiken för "jump", kika på att använda nedanstående variabler
		/var acceleration:int = 2;
		/var dt:Number = 0.16;
		/var gravity:int = 10;
		*/
		public function Player(vector, ctrl) {
			this.pv = new Vector.<Platform>();
			this.pv = vector;
			this.ctrl = ctrl;
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
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_RIGHT)){
				if(this.x <= 800) this.x += this.speed;
			}
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_LEFT)){
				if(this.x>=0) this.x -= this.speed;
			}
			
			if(Input.keyboard.pressed(this.m_controls.PLAYER_UP)){
				if(this.onGround){
					this.velocity = DEFAULT_VELOCITY;
					this.onGround = false;
					jump();
				}
			}
			}
			
		private function checkCurrentPlat():void{
			
			if((this.x + this.obj_width) < this.currentPlat.x || this.x > (this.currentPlat.x + this.currentPlat.obj_width)){
				this.velocity = 0;
				this.onGround = false;
			}
			
			
			//Ful lösning, men funkar atm
			if(this.currentPlat.y != (this.y + this.obj_height + 0.45)){
				this.velocity = 0;
				this.onGround = false;
			}
			
			/*
			for(var i:int = 0; i<this.pv.length; i++){
				
				if(this.falling == true && (this.hitTestObject(this.pv[i]) && this.y <= this.pv[i].y)){
					this.onGround = true;
					this.y = this.pv[i].y - this.height;
					this.currentPlat = this.pv[i];
					//trace(this.currentPlat);
					if(this.currentPlat is WeakPlatform){
						
						this.isOnWeak = true;
						//this.currentPlat.removeWeakPlat();
						this.currentPlat = null;
						//this.onGround = false;
						
						}
					
				}
			
				if(this.currentPlat){
					if(this.x + this.width < this.currentPlat.x || this.x > this.currentPlat.x + this.currentPlat.width){
						this.velocity = 0;
						this.onGround = false;
					}
				}
			}*/
			
		}
		
		
		public function setCurrentPlat(plat:GameObject):void{
			if(this.falling){
				this.onGround = true;
				this.y = plat.y - this.height;
				this.currentPlat = plat;
			}
			
		}
		
		private function jump():void{
			this.velocity < 0 ? this.falling = true : this.falling = false;
			this.currentPlat = null;
			this.y -= this.velocity;
			this.velocity -= 1.8;
			if(this.y + this.height >= 600){
				this.onGround = true;
				this.y = 600 - this.height;
				}
			
			}

	}
	
}
