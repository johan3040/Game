package  as3.game.gameobject.platforms{
	
	
	import assets.gameObjects.OrgPlatGFX;
	import se.lnu.stickossdk.system.Session;
	
	public class OriginalPlatform extends Platform{
		
		private var platform:OrgPlatGFX;
		private var delay:int;
		private var callback:Function;
		private var vec:Vector.<Array>;
		
		public function OriginalPlatform(callback) {
			super();
			this.callback = callback;
			initOriginalPlat();
		}
		
		private function initOriginalPlat():void{
			this.platform = new OrgPlatGFX();
			this.platform.gotoAndStop(1);
			setHitbox();
			obj_width = 70;
			obj_height = this.platform.height;
			
			addChild(this.platform);
			addChild(hitBox);
			setLifespan();
		}
		
		private function setHitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,1, 70, 6);
			//hitBox.graphics.endFill();
		}

			
		private function setLifespan():void{
			this.delay = Math.floor(Math.random() * (10000 - 4000) + 4000);
			Session.timer.create((this.delay - 2000), warning);
			Session.timer.create(this.delay, rePosition);
			}
			
		private function rePosition():void{
			this.platform.gotoAndStop(1);
			super.setData();
			this.callback(this);
			setLifespan();
			}
			
		private function warning():void{
			this.platform.gotoAndStop(2);
			}
		
		public function immidiateReposition():void{
			super.setData();
			this.callback(this);
		}

	}
	
}
