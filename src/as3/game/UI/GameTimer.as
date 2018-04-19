package as3.game.UI
{
	
	import flash.text.TextField;
	
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
			this.m_timerText.width = 100;
			this.m_timerText.height = 30;
			this.m_timerText.text = "0";
			this.x = 380;
			this.y = 30;
			this.m_timerText.setTextFormat(this.m_textFormat);
			addChild(this.m_timerText);
			this.initTimer();
		}
		
		private function initTimer():void{
			this.m_timer = Session.timer.create(1000, onTick, 0);
		}
		
		private function onTick():void{
			tick++;
			this.initTimer();
			this.m_timerText.text = tick.toString();
			this.m_timerText.setTextFormat(this.m_textFormat);
		}
		
	}
}