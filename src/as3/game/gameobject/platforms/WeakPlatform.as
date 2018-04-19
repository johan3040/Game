package  as3.game.gameobject.platforms{
	
	
	import assets.gameObjects.WeakPlatGFX;
	import se.lnu.stickossdk.system.Session;
	
	public class WeakPlatform extends Platform{
		
		private var platform:WeakPlatGFX;
		private var callback:Function; // Callback method to reposition method in Main
		private var removeCallback:Function;
		
		public function WeakPlatform(callback) {
			super();
			this.callback = callback;
			//this.remove = remove;
			initWeakPlat();
		}
		
		private function initWeakPlat():void{
			this.platform = new WeakPlatGFX();
			this.platform.gotoAndStop(1);
			this.setHitbox();
			
			obj_width = this.platform.width;
			obj_height = this.platform.height;
			
			addChild(this.platform);
			addChild(hitBox);
			this.callback(this);
			}
		
		private function setHitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0, 1, 70, 6);
			//hitBox.graphics.endFill();
		}
			
		public function removePlat(removeCallback):void{
			//this.removeCallback = removeCallback;
			removeCallback(this);
			this.exists = false;
			this.platform.gotoAndPlay(2);
			}
		
		override public function update():void{
		
			if(this.platform.currentFrame == this.platform.totalFrames){
				this.platform.visible = false;
				reSpawn();
			} 
		}
		
		public function immidiateReposition():void{
			super.setData();
			this.callback(this);
		}
		
		private function reSpawn():void{
			this.platform.gotoAndStop(1);
			this.exists = true;
			super.setData();
			this.platform.visible = true;
			this.callback(this);
		
		}

	}
	
}
