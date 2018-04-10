package  as3.game.gameobject.hazards{
	

	import flash.display.Sprite;
	
	import assets.gameObjects.Hazard_Arrow;
	
	public class Arrow extends Hazard{
		
		private var arrow:Hazard_Arrow;
		
		public function Arrow() {
			super();
			lethal = true;
			initArrow();
		}
		
		private function initArrow():void{
			this.arrow = new Hazard_Arrow();
			this.x = 800;
			this.y = 570;
			
			this.hitBox = new Sprite();
			hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,0,10,10);
			hitBox.graphics.endFill();
			
			trace(hitBox.width);
			
			addChild(this.arrow);
			addChild(this.hitBox);
			}
		
		override public function update():void{
			moveArrow();
		}
			
		private function moveArrow():void{
			this.x-=5;
			if(this.x < 0){
				this.parent.removeChild(this);
				this.arrow = null;
				}
			}
			
		

	}
	
}
