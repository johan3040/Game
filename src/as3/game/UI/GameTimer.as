package as3.game.UI
{
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import assets.gameObjects.hudLeafMiddle;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	public class GameTimer extends DisplayStateLayerSprite{
		
		private var tick:int = 0;
		private var m_timer:Timer;
		private var m_timerText:TextField;
		private var m_textFormat:TextFormat;
		private var m_leaf:hudLeafMiddle;
		
		public function GameTimer(){
			super();
		
		}
		
		override public function init():void{
			this.initLeaf();
			this.initText();
			
			
			this.x = Session.application.size.x/2;
			this.y = 30;
			//this.m_timerText.embedFonts = true;
			
			//this.m_timerText.autoSize = TextFieldAutoSize.LEFT;
			addChild(this.m_leaf);
			addChild(this.m_timerText);
			this.initTimer();
		}
		
		private function initLeaf():void{
			this.m_leaf = new hudLeafMiddle();
			this.m_leaf.scaleX = 0.7;
			this.m_leaf.scaleY = 0.7;
			this.m_leaf.x -= this.m_leaf.width/2;
		}
		
		private function initText():void{
			this.m_timerText = new TextField();
			this.m_textFormat = new TextFormat();
			this.m_textFormat.font = "Helvetica";
			this.m_textFormat.size = "16";
			this.m_timerText.defaultTextFormat = m_textFormat;
			this.m_timerText.autoSize = TextFieldAutoSize.LEFT;
			this.m_timerText.text = "0";
			this.m_timerText.y = 5;
		}
		
		private function initTimer():void{
			this.m_timer = Session.timer.create(10, onTick, 0);
		}
		
		private function onTick():void{
			tick++;
			this.initTimer();
			this.m_timerText.text = tick.toString();
			this.m_timerText.x = this.m_timerText.width/1.5 * -1;
		}
		
		override public function dispose():void{
			this.m_leaf = null;
		}
		
	}
}