package as3.game.gameobject.platforms{
	
	import assets.gameObjects.ArenaBottom;
	
	public class MpGround extends Platform{
		
		private var plat:ArenaBottom;
		
		public function MpGround(pos:Array){
			super(pos);
			this.initGround();
			this.initHitBox();
		}
		
		private function initGround():void{
			this.plat = new ArenaBottom();
			obj_width = 800;
			obj_height = 40;
			addChild(this.plat);
		}
		
		private function initHitBox():void{
			//hitBox.graphics.beginFill(0x0000FF);
			hitBox.graphics.drawRect(0,0,800,40);
			//hitBox.graphics.endFill();
			addChild(hitBox);
		}
		
		override public function dispose():void{
			this.plat = null;
			hitBox = null;
		}
		
	}
}