package as3.game.gameobject.hazards
{
	import flash.display.Sprite;
	
	import as3.game.gameobject.GameObject;
	
	import assets.gameObjects.Hazard_Arrow;

	public class Coconut extends Hazard{
		
		private var coconut:Hazard_Arrow;
		private var callback:Function;
		private var target:GameObject;
		private var startSpeed:Number;
		private var dragForce:Number = 0.3;
		
		public function Coconut(callback, target){
			super();
			this.callback = callback;
			this.target = target;
			initCoconut();
		}
		
		private function initCoconut():void{
		
			this.coconut = new Hazard_Arrow();
			this.coconut.rotation = 270;
			this.x = this.target.x + (this.target.obj_width/2);
			this.y = -20;
			this.startSpeed = 1;
			this.hitBox = new Sprite();
			hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,0,10,10);
			hitBox.graphics.endFill();
			
			addChild(this.coconut);
			addChild(this.hitBox);
		
		}
		
		override public function update():void{
			moveCoconut();
		}
		
		private function moveCoconut():void{
			this.y += this.startSpeed;
			this.startSpeed += this.dragForce;
			if(this.y > 600){
				this.parent.removeChild(this);
				this.coconut = null;
				this.callback(this);
			}
		}
		
	}
}