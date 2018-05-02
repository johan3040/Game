package  as3.game.gameobject.platforms{
	
	
	import assets.gameObjects.OrgPlatGFX;
	import se.lnu.stickossdk.system.Session;
	
	public class OriginalPlatform extends Platform{
		
		private var platform:OrgPlatGFX;
		private var delay:int;
		private var callback:Function;
		
		public function OriginalPlatform(pos, callback) {
			super(pos);
			this.pos = pos;
			this.callback = callback;
			initOriginalPlat();
		}
		
		private function initOriginalPlat():void{
			this.platform = new OrgPlatGFX();
			this.platform.gotoAndStop(1);
			this.scaleX = 0.8;
			this.scaleY = 0.8;
			setHitbox();
			obj_width = 65;
			obj_height = this.platform.height;
			addChild(this.platform);
			addChild(hitBox);
			setLifespan();
		}
		
		private function setHitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(3,1, 65, 6);
			//hitBox.graphics.endFill();
		}

			
		private function setLifespan():void{
			this.delay = Math.floor(Math.random() * (10000 - 4000) + 4000);
			Session.timer.create((this.delay - 2000), warning);
			Session.timer.create(this.delay, rePosition);
		}
			
		private function rePosition():void{
			this.platform.gotoAndStop(1);
			this.callback(this);
			setLifespan();
		}
		
		private function warning():void{
			this.platform.gotoAndStop(2);
		}
		
		override public function dispose():void{
		
			this.platform = null;
			this.callback = null;
			
		}

	}
	
}
