package  as3.game.gameobject.platforms{
	
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import assets.gameObjects.OrgPlat;
	
	public class OriginalPlatform extends Platform{
		
		private var platform:OrgPlat;
		private var lifespan:uint;
		private var delay:int;
		private var setWarning:int;
		private var callback:Function;
		private var vec:Vector.<Array>;
		
		private var hitBox:Sprite;
		
		public function OriginalPlatform(callback) {
			super();
			this.callback = callback;
			//this.vec = filledSpaces;
			initOriginalPlat();
		}
		
		private function initOriginalPlat():void{
			this.platform = new OrgPlat();
			this.platform.gotoAndStop(1);
			
			this.hitBox = new Sprite();
			hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(2,3, 65, 3);
			hitBox.graphics.endFill();
			
			addChild(this.platform);
			addChild(hitBox);
			setLifespan();
			}

			
		private function setLifespan():void{
			this.delay = Math.floor(Math.random() * (10000 - 4000) + 4000);
			this.setWarning = setTimeout(warning, (this.delay - 2000));
			this.lifespan = setTimeout(rePosition, this.delay);
			}
			
		private function rePosition():void{
			this.platform.gotoAndStop(1);
			super.setData();
			this.callback(this);
			setLifespan();
			}
			
		private function warning():void{
			this.platform.gotoAndPlay(2);
			}

	}
	
}
