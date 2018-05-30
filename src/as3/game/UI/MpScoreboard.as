package as3.game.UI{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import mx.core.mx_internal;
	
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.scoreboard;
	import assets.gameObjects.scoreboardChain;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Quad;
	
	public class MpScoreboard extends DisplayStateLayerSprite{
		
		private var sb:scoreboard;
		private var leftChain:scoreboardChain;
		private var rightChain:scoreboardChain;
		private var boardContainer:Sprite;
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
			this.boardContainer = new Sprite();
			this.init();
			this.initTextLeft();
			this.initTextRight();
			this.initTextMiddle();
			this.initLeftChain();
			this.initRightChain();
			addChild(this.boardContainer);
			this.effect();
		}
		
		private function init():void{
			
			this.sb = new scoreboard();
			this.sb.scaleX = 0.5;
			this.sb.scaleY = 0.5;
			this.sb.x -= this.sb.width/2;
			this.x = 320 + this.sb.width/2;
			this.y = 20;
			this.m_textFormat = new TextFormat("FontyFont", 30, 0xFFFFFF);
			this.boardContainer.addChild(this.sb);
		}
		
		private function initTextLeft():void{
			
			this.m_textLeft = new TextField();
			this.m_textLeft.width = 40;
			this.m_textLeft.height = 40;
			this.m_textLeft.embedFonts = true;
			this.m_textLeft.text = "0";
			this.m_textLeft.x = -70;
			this.m_textLeft.y = 5;
			this.m_textLeft.autoSize = TextFieldAutoSize.CENTER;
			this.m_textLeft.defaultTextFormat = this.m_textFormat;
			this.m_textLeft.setTextFormat(this.m_textFormat);
			this.boardContainer.addChild(this.m_textLeft);
		}
		
		private function initTextRight():void{
			
			this.m_textRight = new TextField();
			this.m_textRight.embedFonts = true;
			this.m_textRight.text = "0";
			this.m_textRight.y = 5;
			this.m_textRight.x = 0;
			this.m_textRight.autoSize = TextFieldAutoSize.CENTER;
			this.m_textRight.defaultTextFormat = this.m_textFormat;
			this.m_textRight.setTextFormat(this.m_textFormat);
			this.boardContainer.addChild(this.m_textRight);
		}
		
		private function initTextMiddle():void{
			
			this.m_middleText = new TextField();
			this.m_middleText.embedFonts = true;
			this.m_middleText.text = "Rounds";
			this.m_middleText.x = -50;
			this.m_middleText.y = 5;
			this.m_middleText.autoSize = TextFieldAutoSize.CENTER;
			this.m_middleText.defaultTextFormat = this.m_textFormat;
			this.m_middleText.setTextFormat(this.m_textFormat);
			this.boardContainer.addChild(this.m_middleText);
		}
		
		private function initLeftChain():void{
			this.leftChain = new scoreboardChain();
			this.leftChain.x = -45;
			this.leftChain.y = -30;
			addChild(this.leftChain);
		}
		
		private function initRightChain():void{
			this.rightChain = new scoreboardChain();
			this.rightChain.x = 45;
			this.rightChain.y = -30;
			addChild(this.rightChain);
		}
		
		override public function update():void{
			if(this.m_textLeft.text != this.players[0].roundsWon.toString()) this.m_textLeft.text = this.players[0].roundsWon.toString();
			if(this.m_textRight.text != this.players[1].roundsWon.toString()) this.m_textRight.text = this.players[1].roundsWon.toString();
		}
		
		private function effect():void{
			Session.tweener.add(this.boardContainer,{
				transition: Quad.easeInOut,
				rotationX: Math.floor(Math.random() * (35 - 25 + 1) + 25),
				rotationY: Math.floor(Math.random() * (7 - 3 + 1) + 3),
				duration: this.getDuration(),
				onComplete: this.secondEffect
			});
		}
		
		private function secondEffect():void{
			Session.tweener.add(this.boardContainer,{
				transition: Quad.easeInOut,
				rotationX: this.getNegativeX(),
				rotationY: -2,
				alpha: 1,
				duration: this.getDuration(),
				onComplete: this.effect
			});
		}
		
		private function getNegativeX():int{
			return (Math.floor(Math.random() * (10 - 2 + 1) + 2)) * -1;
		}
		
		private function getDuration():int{
			return Math.floor(Math.random() * (1200 - 700 + 1) + 700)
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