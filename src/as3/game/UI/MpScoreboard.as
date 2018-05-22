package as3.game.UI{
	
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.scoreboard;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class MpScoreboard extends DisplayStateLayerSprite{
		
		private var sb:scoreboard;
		private var m_textLeft:TextField;
		private var m_textRight:TextField;
		private var m_middleText:TextField;
		private var m_textFormat:TextFormat;
		private var players:Vector.<Player>;
		
		[Embed(source="../../../../assets/font/PaintyPaint.TTF",
					fontName = "FontyFont",
					mimeType = "application/x-font",
					advancedAntiAliasing="true",
					embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		public function MpScoreboard(players:Vector.<Player>){
			super();
			this.players = players;
			this.init();
			this.initTextLeft();
			this.initTextRight();
			this.initTextMiddle();
		}
		
		private function init():void{
			
			this.sb = new scoreboard();
			this.sb.scaleX = 0.5;
			this.sb.scaleY = 0.5;
			this.x = 320;
			this.y = 20;
			this.m_textFormat = new TextFormat("FontyFont", 22, 0xFFFFFF);
			addChild(this.sb);
		}
		
		private function initTextLeft():void{
			
			this.m_textLeft = new TextField();
			this.m_textLeft.width = 40;
			this.m_textLeft.height = 40;
			this.m_textLeft.embedFonts = true;
			this.m_textLeft.text = "0";
			this.m_textLeft.x = 0;
			this.m_textLeft.y = 5;
			this.m_textLeft.autoSize = TextFieldAutoSize.CENTER;
			this.m_textLeft.defaultTextFormat = this.m_textFormat;
			this.m_textLeft.setTextFormat(this.m_textFormat);
			addChild(this.m_textLeft);
		}
		
		private function initTextRight():void{
			
			this.m_textRight = new TextField();
			this.m_textRight.embedFonts = true;
			this.m_textRight.text = "0";
			this.m_textRight.y = 5;
			this.m_textRight.x = 65;
			this.m_textRight.autoSize = TextFieldAutoSize.CENTER;
			this.m_textRight.defaultTextFormat = this.m_textFormat;
			this.m_textRight.setTextFormat(this.m_textFormat);
			addChild(this.m_textRight);
		}
		
		private function initTextMiddle():void{
			
			this.m_middleText = new TextField();
			this.m_middleText.embedFonts = true;
			this.m_middleText.text = "Rounds";
			this.m_middleText.x = 15;
			this.m_middleText.y = 5;
			this.m_middleText.autoSize = TextFieldAutoSize.CENTER;
			this.m_middleText.defaultTextFormat = this.m_textFormat;
			this.m_middleText.setTextFormat(this.m_textFormat);
			addChild(this.m_middleText);
		}
		
		override public function update():void{
			if(this.m_textLeft.text != this.players[0].roundsWon.toString()) this.m_textLeft.text = this.players[0].roundsWon.toString();
			if(this.m_textRight.text != this.players[1].roundsWon.toString()) this.m_textRight.text = this.players[1].roundsWon.toString();
		}
		
		override public function dispose():void{
			this.sb = null;
			this.m_middleText = null;
			this.m_textLeft = null;
			this.m_textRight = null;
			this.m_textFormat = null;
		}
		
	}
}