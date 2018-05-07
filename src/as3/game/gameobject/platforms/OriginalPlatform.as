package  as3.game.gameobject.platforms{
	
	import assets.gameObjects.OrgPlatGFX;
	
	public class OriginalPlatform extends Platform{
		
		protected var platform:OrgPlatGFX;
		
		public function OriginalPlatform(pos:Array) {
			super(pos);
			this.pos = pos;
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
		}
		
		private function setHitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(3,1, 65, 6);
			//hitBox.graphics.endFill();
		}
		
		override public function dispose():void{
		
			this.platform = null;
			
		}

	}
	
}
