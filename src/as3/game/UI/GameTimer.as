package as3.game.UI
{
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	public class GameTimer extends Hud{
		
		private var tick:int = 0;
		private var m_timer:Timer;
		private var m_timerText:TextField;
		
		public function GameTimer(){
			super();
			this.initText();
		}
		
		private function initText():void{
			this.m_timerText = new TextField();
			
			this.x = 380;
			this.y = 30;
			this.m_timerText.text = "0";
			//this.m_timerText.embedFonts = true;
			this.m_timerText.setTextFormat(m_textFormat);
			this.m_timerText.defaultTextFormat = m_textFormat;
			//this.m_timerText.autoSize = TextFieldAutoSize.LEFT;
			addChild(this.m_timerText);
			this.initTimer();
		}
		
		private function initTimer():void{
			this.m_timer = Session.timer.create(10, onTick, 0);
		}
		
		private function onTick():void{
			tick++;
			this.initTimer();
			this.m_timerText.text = tick.toString();
			this.m_timerText.setTextFormat(m_textFormat);
		}
		
	}
}