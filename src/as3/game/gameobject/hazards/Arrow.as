package  as3.game.gameobject.hazards{
	

	import flash.display.Sprite;
	
	import as3.game.gameobject.GameObject;
	
	import assets.gameObjects.Hazard_Arrow;
	
	public class Arrow extends Hazard{
		
		private var arrow:Hazard_Arrow;
		private var callback:Function;
		private var target:GameObject;
		
		public function Arrow(callback, target) {
			super();
			this.callback = callback;
			this.target = target;
			initArrow();
		}
		
		private function initArrow():void{
			this.arrow = new Hazard_Arrow();
			this.x = 800;
			this.y = this.target.y + 10;
			
			this.hitBox = new Sprite();
			hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,0,10,10);
			hitBox.graphics.endFill();
			
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
				this.callback(this);
				}
			}
			
		

	}
	
}
