﻿package  as3.game.gameobject.player{
	
	import assets.gameObjects.P1;
	
	public class Explorer extends Player{
		
		public function Explorer(push:Function) {
			super(0, push);
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
			m_skin = new P1();
			m_skin.x -= (m_skin.width/2);
			m_skin.gotoAndStop(1);
		}
		
		private function setBodyBitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(-7, 4, 14, 33);
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
			//this.scaleX = 0.8;
			//this.scaleY = 0.8;
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
