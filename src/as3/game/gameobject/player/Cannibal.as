package  as3.game.gameobject.player{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	
	import assets.gameObjects.P1;
	
	public class Cannibal extends Player{
		
		private var cannibal:P1;
		private var v:Vector.<MovieClip>;
		
		public function Cannibal() {
			super(1);
			initCannibal();
		}
		
		private function initCannibal():void{
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
			hitBox = new Sprite();
			hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(-5, 4, 12, 34);
			hitBox.graphics.endFill();
		}
		
		private function setFootHitbox():void{
			bottomHitBox = new Sprite();
			bottomHitBox.graphics.beginFill(0xFF0000);
			bottomHitBox.graphics.drawRect(-10, 30, 18, 12);
			bottomHitBox.graphics.endFill();
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
			this.hitBox = null;
			this.bottomHitBox = null;
		}

	}
	
}
