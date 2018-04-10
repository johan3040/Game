package  as3.game.gameobject.player{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import assets.gameObjects.P1;
	
	public class Cannibal extends Player{
		
		private var cannibal:P1;
		private var v:Vector.<MovieClip>;
		
		public function Cannibal(v) {
			super(v, 1);
			initCannibal();
		}
		
		private function initCannibal():void{
			this.cannibal = new P1();
			hitBox = new Sprite();
			hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(10, 10, 20, 20);
			hitBox.graphics.endFill();
			addChild(this.cannibal);
			addChild(hitBox);
			}

	}
	
}
