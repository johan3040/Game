package as3.game.gameobject.hazards
{
	
	import as3.game.gameobject.GameObject;
	
	import assets.gameObjects.HazardCoconut;

	public class Coconut extends Hazard{
		
		private var coconut:HazardCoconut;
		private var callback:Function;
		private var target:GameObject;
		private var startSpeed:Number;
		private var dragForce:Number = 0.1;
		
		public function Coconut(callback, target){
			super();
			this.callback = callback;
			this.target = target;
			this.coconut = new HazardCoconut();
			initCoconut();
		}
		
		private function initCoconut():void{
			this.coconut.gotoAndStop(2);
			this.coconut.scaleX = 0.8;
			this.coconut.scaleY = 0.8;
			var x_pos:int = Math.floor(Math.random()*99) + 1;
			x_pos *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
			this.x = this.target.x + x_pos;
			this.y = -20;
			this.startSpeed = 1;
			setHitbox();
			addChild(this.coconut);
			addChild(hitBox);
		
		}
		
		private function setHitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,0,28,25);
			//hitBox.graphics.endFill();
		}
		
		override public function update():void{
			moveCoconut();
		}
		
		private function moveCoconut():void{
			this.y += this.startSpeed;
			this.startSpeed += this.dragForce;
			if(this.y > 600){
				//this.parent.removeChild(this);
				//this.coconut = null;
				//this.callback(this);
				initCoconut();
			}
		}
		
	}
}