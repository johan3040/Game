package as3.game.gameobject.platforms{
	
	import se.lnu.stickossdk.system.Session;

	public class SpPlatform extends OriginalPlatform{
		
		private var delay:int;
		private var callback:Function;
		
		public function SpPlatform(pos:Array, callback:Function){
			super(pos);
			this.callback = callback;
			this.setLifespan();
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