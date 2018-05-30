package as3.game.UI{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.scoreboardBlue;
	import assets.gameObjects.scoreboardChain;
	import assets.gameObjects.scoreboardRed;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Back;
	import se.lnu.stickossdk.tween.easing.Quad;
	
	public class MultiplayerHud extends DisplayStateLayerSprite{
		
		private var board:MovieClip;
		private var boardContainer:Sprite;
		private var leftChain:scoreboardChain;
		private var rightChain:scoreboardChain;
		private var m_text:TextField;
		private var m_textFormat:TextFormat;
		private var owner:Player;
		
		[Embed(source="../../../../assets/font/PaintyPaint.TTF",
					fontName = "FontyFont",
					mimeType = "application/x-font",
					advancedAntiAliasing="true",
					embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		public function MultiplayerHud(player:Player){
			super();
			this.owner = player;
			this.boardContainer = new Sprite();
			this.owner is Explorer ? this.initBlue() : this.initRed();
			this.effect();
		}
		
		private function initBlue():void{
			this.x = 90;
			this.board = new scoreboardBlue();
			this.board.x -= 30;
			this.initLeftChain(-20);
			this.initRightChain(25);
			this.initText();
		}
		
		private function initRed():void{
			this.x = 680;
			this.board = new scoreboardRed();
			this.board.x -= 30;
			this.initLeftChain(-20);
			this.initRightChain(25);
			this.initText();
		}
		
		private function initText():void{
			this.m_text = new TextField();
			this.m_textFormat = new TextFormat("FontyFont", 30, 0xFFFFFF);
			this.m_text.width = 100;
			this.m_text.height = 30;
			this.m_text.embedFonts = true;
			this.m_text.defaultTextFormat = this.m_textFormat;
			this.m_text.x = -5;
			this.m_text.y = 0;
			this.y = 20;
			
			this.board.scaleX = 0.5;
			this.board.scaleY = 0.5;
			this.boardContainer.addChild(this.board);
			this.boardContainer.addChild(this.m_text);
			addChild(this.boardContainer);
		}
		
		private function initLeftChain(xVal:int):void{
			this.leftChain = new scoreboardChain();
			this.leftChain.x = xVal;
			this.leftChain.y = -30;
			addChild(this.leftChain);
		}
		
		private function initRightChain(xVal:int):void{
			this.rightChain = new scoreboardChain();
			this.rightChain.x = xVal;
			this.rightChain.y = -30;
			addChild(this.rightChain);
		}
		
		override public function update():void{
			if(this.m_text.text != this.owner.numFlags.toString()){
				this.m_text.text = this.owner.numFlags.toString();
				this.scaleUp();
			}
		}
		
		private function scaleUp():void{
			Session.tweener.add(this.m_text,{
				transition: Back.easeOut,
				scaleX: 2,
				scaleY: 2,
				duration: 500,
				onComplete: this.scaleDown
			});
		}
		
		private function scaleDown():void{
			Session.tweener.add(this.m_text,{
				transition: Back.easeOut,
				scaleX: 1,
				scaleY: 1,
				duration: 500
			});
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
			return Math.floor(Math.random() * (1700 - 700 + 1) + 700)
		}
		
		override public function dispose():void{
			this.board = null;
			this.m_text = null;
			this.m_textFormat = null;
			this.owner = null;
			this.leftChain = null;
			this.rightChain = null;
			this.boardContainer = null;
		}
		
	}
}