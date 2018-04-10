package  as3.game.gameobject.platforms{
	
	import assets.gameObjects.WeakPlatGFX;
	
	public class WeakPlatform extends Platform{
		
		private var platform:WeakPlatGFX;
		private var callback:Function; // Callback method to reposition method in Main
		//private var remove:Function; // Callback method to remove platform from vector in Main
		private var t:uint;
		
		public function WeakPlatform(callback) {
			super(); // Ej nödvändigt - endast för tydligehtens skull
			this.callback = callback;
			//this.remove = remove;
			initWeakPlat();
		}
		
		private function initWeakPlat():void{
			this.platform = new WeakPlatGFX();
			this.platform.gotoAndStop(1);
			addChild(this.platform);
			this.callback(this.platform);
			}
			
		public function removeWeakPlat():void{
			trace("remove");
			//trace("remove", this.stage);
			//this.remove(this);
			this.parent.removeChild(this);
			//trace(this.stage);
			}

	}
	
}
