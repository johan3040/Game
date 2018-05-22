package as3.game.gameobject.powerups
{
	import flash.display.MovieClip;
	
	import as3.game.gameobject.GameObject;
	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Sine;
	
	public class PowerUp extends GameObject{
		
		protected var m_skin:MovieClip;
		protected var drop:Boolean = false;
		
		/**
		 * 
		 * Class's contructor method
		 * 
		 */
		public function PowerUp(){
			super();
			this.y = 0;
		}
		
		protected function setHitBox():void{
			//hitBox.graphics.beginFill(0xFF0000);
			hitBox.graphics.drawRect(-15,52,35,35);
			//hitBox.graphics.endFill();
			addChild(hitBox);
		}
		
		/**
		 * 
		 * Update-loop
		 * 
		 */
		override public function update():void{
			if(this.drop) this.dropPackage();
		}
		
		/**
		 * 
		 * Adds exactly 1 to objects Y-value
		 * 
		 * If objects y-value is >= 600 it is off-screen. Call for reposition method
		 * 
		 */
		private function dropPackage():void{
			this.y++;
			if(this.y >=600){
				this.drop = false;
				this.y = -100;
				var delay:int = Math.floor(Math.random()*13000) + 9000;
				Session.timer.create(delay, this.setPosition);
			}
		}
		
		/**
		 * 
		 * First tween for 'swinging' effect on object
		 * 
		 */
		protected function startTween():void{
			Session.tweener.add(this.m_skin, {
				rotation: -10,
				duration: 1000,
				transition: Sine.easeInOut,
				onComplete: endTween
			});
		}
		
		/**
		 * 
		 * Second tween for 'swining' effect on object
		 * 
		 */
		private function endTween():void{
			Session.tweener.add(this.m_skin, {
				rotation: 10,
				duration: 1000,
				transition: Sine.easeInOut,
				onComplete: startTween
			});
		}
		
		/**
		 * 
		 * Sets objects position off-screen until setPosition is called
		 * 
		 */
		public function reposition():void{
			this.x = -100;
			this.y = -100;
			this.drop = false;
			var delay:int = Math.floor(Math.random()*13000) + 9000;
			Session.timer.create(delay, this.setPosition);
		}
		
		protected function setPosition():void{
			this.x = Math.floor(Math.random()*600) + 75;
			this.y = -50;
			this.drop = true;
		}
		
	}
}