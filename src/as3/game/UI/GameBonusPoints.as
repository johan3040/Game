package as3.game.UI{
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.hudLeafMiddle;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	
	
	public class GameBonusPoints extends DisplayStateLayerSprite{
		
		private var player:Player;
		private var m_bonusText:TextField;
		private var m_textFormat:TextFormat;
		private var m_bonusPoints:int = 0;
		private var m_visibleBonusPoints:int = 0;
		private var inComingPoints:int;
		private var m_leaf:hudLeafMiddle;
		
		[Embed(source="../../../../assets/font/PaintyPaint.TTF",
					fontName = "FontyFont",
					mimeType = "application/x-font",
					advancedAntiAliasing="true",
					embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		public function GameBonusPoints(player:Player){
			super();
			this.player = player;
			
		}
		
		override public function init():void{
			
			this.m_leaf = new hudLeafMiddle();
			this.m_leaf.scaleX = 0.7;
			this.m_leaf.scaleY = 0.7;
			this.m_leaf.x = -10;
			
			this.m_bonusText = new TextField();
			this.m_textFormat = new TextFormat("FontyFont", 22, 0xFFFFFF);
			this.m_bonusText.width = 100;
			this.m_bonusText.height = 30;
			this.m_bonusText.x = 20;
			this.m_bonusText.y = 5;
			this.m_bonusText.embedFonts = true;
			this.m_bonusText.defaultTextFormat = this.m_textFormat;
			this.m_bonusText.text = m_visibleBonusPoints.toString();
			this.x = 350;
			this.y = 40;
			addChild(this.m_leaf);
			addChild(this.m_bonusText);
		
		}
		
		public function setVisibleBonusPoints(points:int):void{
			
			this.m_bonusPoints += points;
			
		}
		
		override public function update():void{
			if(this.m_visibleBonusPoints < this.m_bonusPoints){
				this.m_visibleBonusPoints+=10;
				Session.timer.create(5, addPoints);
			}
		}
		
		private function addPoints():void{
			
			this.m_bonusText.text = m_visibleBonusPoints.toString();
			
		}
		
		override public function dispose():void{
			this.player = null;
		}
		
		
	}
}