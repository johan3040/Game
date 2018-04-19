package as3.game.gameobject.hazards{
	
	import assets.gameObjects.ocean;
	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Sine;
	
	public class Wave extends Hazard{
		
		private var hazard_ocean:ocean;
		
		public function Wave(){
			super();
			this.y = 600;
			this.alpha = 0.7;
			this.initWave();
			
		}
		
		private function initWave():void{
			
			
			
			this.hazard_ocean = new ocean();
			this.initHitBox();
			addChild(this.hazard_ocean);
			addChild(hitBox);
			goTween();
		}
		
		private function initHitBox():void{
		
			//hitBox.graphics.beginFill(0xFF0000);
			hitBox.graphics.drawRect(0, -20, 800, 100);
			//hitBox.graphics.endFill();
			
		}
		
		
		private function goTween():void{
			
			var targetY:int = 0;
			
			if(this.y != 590) targetY = 590;
			else{ targetY = 600};
			
			Session.tweener.add(this, {
				y: targetY,
				duration: 1000,
				transition: Sine.easeInOut,
				onComplete: goTween
			});
		
		}
		
	}
}