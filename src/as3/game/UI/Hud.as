package as3.game.UI
{
	
	import flash.text.TextFormat;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class Hud extends DisplayStateLayerSprite{
		
		protected var m_textFormat:TextFormat = new TextFormat();
		
		public function Hud(){
			super();
		}
		
		override public function init():void{
			initTextFormat();
		}
		
		protected function initTextFormat():void{
			this.m_textFormat.font = "Helvetica";
			this.m_textFormat.size = 22;
		}
		
		
	}
}