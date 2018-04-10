package  as3.game.gameobject.player{
	
	import flash.display.Sprite;
	
	import assets.gameObjects.P1;
	
	
	public class Explorer extends Player{
		
		public var player:P1;
		
		
		public function Explorer(v) {
			super(v, 0);
			initExplorer();
		}
		
		private function initExplorer():void{
			this.player = new P1();
			hitBox = new Sprite();
			hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(10, 10, 20, 20);
			
			hitBox.graphics.endFill();
			addChild(this.player);
			addChild(hitBox);
			}
		
		override public function dispose():void{
			this.player = null;
			this.hitBox = null;
		}

	}
	
}
