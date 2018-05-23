package  as3.game.gameobject.player{
	
	import assets.gameObjects.P1;
	
	public class Explorer extends Player{
		
		public function Explorer(ctrl:int,push:Function) {
			super(ctrl, push);
			this.initExplorer();
		}
		
		private function initExplorer():void{
			
			this.initSkin();
			this.setBodyBitbox();
			this.setFootHitbox();
			this.setObjectDim();
			this.addChildren();
			this.startPosition();
			
			}
		
		private function initSkin():void{
			m_skin = new P1();
			m_skin.x -= (m_skin.width/2);
			m_skin.gotoAndStop(1);
		}
		
		private function setBodyBitbox():void{
			hitBox.graphics.drawRect(-7, 4, 14, 33);
		}
		
		private function setFootHitbox():void{
			bottomHitBox.graphics.drawRect(-10, 30, 18, 12);
		}
		
		private function setObjectDim():void{
			obj_height = this.m_skin.height;
			obj_width = this.m_skin.width;
		}
		
		private function addChildren():void{
			addChild(this.m_skin);
			addChild(hitBox);
			addChild(bottomHitBox);
		}
		
		public function startPosition():void{
			this.x = 160;
			this.y = 560 - this.obj_height;
			if(this.scaleX != 1) this.scaleX = 1;
		}
		
		override public function dispose():void{
			this.m_skin = null;
			this.bottomHitBox = null;
			hitBox = null;
		}

	}
	
}
