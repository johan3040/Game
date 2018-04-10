package as3.game.UI
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Hud extends DisplayStateLayerSprite{
		
		private var clock:Sprite;
		private var m_timer:Timer;
		private var m_timerText:TextField;
		private var m_textFormat:TextFormat = new TextFormat();
		
		public function Hud(){
			super();
		}
		
		override public function init():void{
			initSprite();
			initTextFormat();
			initText();
			initTimer();
		}
		
		private function initSprite():void{
			this.clock = new Sprite();
			this.clock.graphics.beginFill(0x0000FF);
			this.clock.graphics.drawRect(350, 15, 100, 30);
			this.clock.graphics.endFill();
			addChild(this.clock);
		}
		
		private function initTextFormat():void{
			this.m_textFormat.font = "Helvetica";
			this.m_textFormat.size = 22;
		}
		
		private function initText():void{
			this.m_timerText = new TextField();
			//this.m_textFormat = new TextFormat();
			this.m_timerText.width = 60;
			this.m_timerText.height = 50;
			this.m_timerText.text = "00:00";
			this.m_timerText.x = 380;
			this.m_timerText.y = 15;
			this.m_timerText.setTextFormat(this.m_textFormat);
			addChild(this.m_timerText);
		}
		
		private function initTimer():void{
			this.m_timer = new Timer(1000);
			this.m_timer.addEventListener(TimerEvent.TIMER, onTick);
			this.m_timer.start();
		}
		
		private function onTick(e:TimerEvent):void{
			
			this.m_timerText.text = returnTime(e.currentTarget.currentCount);
			this.m_timerText.setTextFormat(this.m_textFormat);
		}
		
		private function returnTime(num:Number):String{
			return num.toString();
			/*var val:String;
			if(num < 10){
				val = "00:0" + num % 60;
			}else if(num >= 10 && num < 60){
				val = "00:" + num % 60;
			}else{
				val = num / 60 + ":" + num%60;
			}
			return val;*/
		}
	}
}