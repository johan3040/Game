package  as3.game.gameobject.player{
	
	import assets.gameObjects.P2;
	
	
	public class Cannibal extends Player{
		
		
		public function Cannibal(push:Function) {
			super(1, push);
			initExplorer();
		}
		
		private function initExplorer():void{
			
			initSkin();
			setBodyBitbox();
			setFootHitbox();
			setObjectDim();
			addChildren();
			
		}
		
		private function initSkin():void{
			m_skin = new P2();
			m_skin.x -= (m_skin.width/2);
			m_skin.gotoAndStop(1);
		}
		
		private function setBodyBitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(-6, 0, 14, 33);
			//hitBox.graphics.endFill();
			//hitBox.alpha = 0.7;
		}
		
		private function setFootHitbox():void{
			//bottomHitBox.graphics.beginFill(0xFF0000);
			bottomHitBox.graphics.drawRect(-10, 30, 18, 12);
			//bottomHitBox.graphics.endFill();
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
		
		override public function dispose():void{
			this.m_skin = null;
			this.bottomHitBox = null;
			hitBox = null;
		}
		
	}
	
}

