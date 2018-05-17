package scene
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3.game.GetHighscore;
	
	import assets.gameObjects.HighscoreBook;
	import assets.gameObjects.highscoreBtns;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class Highscore extends DisplayState{
		
		private var hi_menuLayer:DisplayStateLayer;
		private var hi_controls:EvertronControls;
		
		private var hi_btns:highscoreBtns;
		private var hi_background:Sprite;
		private var hi_book:HighscoreBook;
		private var hi_highscoreTitle:TextField;
		
		private var hi_highscoreTitleFormat:TextFormat = new TextFormat;
		private var hi_highscoreListFormat:TextFormat;
		
		private var hi_highscoreNumbers:TextField;
		private var hi_highscoreNames:TextField;
		private var hi_highscoreScores:TextField;
		
		private var hi_HighscoreData:GetHighscore;
		private var hi_highscoreNumbersFormat:TextFormat;
		
		public function Highscore(){
			super();
			this.hi_controls = new EvertronControls(0);
		}
		
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initBackBook();
			
			this.initHighscoreBtns();
			this.initTitle();
			
			this.initHighscore();
		}
		
		private function initHighscore():void
		{			
			this.hi_HighscoreData = new GetHighscore(this.recieveHighscoreInfo);
			
			//hi_HighscoreData.GetHighscoreData();
			
		}
		
		private function recieveHighscoreInfo():void {
			placeHighscoreElements();
		}
		
		private function placeHighscoreElements():void
		{
			
			this.hi_highscoreNumbers = new TextField;
			hi_highscoreNumbers.text += hi_HighscoreData.highscorePositions;
			
			this.hi_highscoreNames = new TextField;
			hi_highscoreNames.text += hi_HighscoreData.highscoreNames;
			
			this.hi_highscoreScores = new TextField;
			hi_highscoreScores.text += hi_HighscoreData.highscoreScores;
			
			hi_highscoreNumbers.x = 410;
			hi_highscoreNumbers.y = 80;
			hi_highscoreNumbers.height = 420;
			hi_highscoreNumbers.width = 44;
			
			hi_highscoreNames.x = 460;
			hi_highscoreNames.y = 80;
			hi_highscoreNames.height = 420;
			hi_highscoreNames.width = 180;
			
			hi_highscoreScores.x = 640;
			hi_highscoreScores.y = 80;
			hi_highscoreScores.height = 420;
			hi_highscoreScores.width = 100;
			
			this.hi_highscoreNumbersFormat = new TextFormat("Segoe Script", 20, 0x000066);
			hi_highscoreNumbersFormat.align = "right";
			hi_highscoreNumbersFormat.leading = 8;
			hi_highscoreNumbers.setTextFormat(hi_highscoreNumbersFormat);
			
			this.hi_highscoreListFormat = new TextFormat("Segoe Script", 20, 0x000066);
			hi_highscoreListFormat.align = "left";
			hi_highscoreListFormat.leading = 8;
			hi_highscoreNames.setTextFormat(hi_highscoreListFormat);
			hi_highscoreScores.setTextFormat(hi_highscoreListFormat);
			
			this.hi_menuLayer.addChild(this.hi_highscoreNumbers);
			this.hi_menuLayer.addChild(this.hi_highscoreNames);
			this.hi_menuLayer.addChild(this.hi_highscoreScores);
		}
		
		override public function update():void{
			this.hi_updatecontrols();
		}
		
		override public function dispose():void{
			
		}
		
		private function hi_updatecontrols():void{
			if (Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_1)){
				btnPress();
			}
			
			if (Input.keyboard.justPressed(this.hi_controls.PLAYER_UP)){
				menuMoveUp();
			}
			
			if (Input.keyboard.justPressed(this.hi_controls.PLAYER_DOWN)){
				menuMoveDown();
			}
		}
		
		private function initLayers():void {
			this.hi_menuLayer = this.layers.add("menu");
		}
		
		private function initBackground():void {
			this.hi_background = new Sprite();
			
			this.hi_background.graphics.beginFill(0x121944);
			this.hi_background.graphics.drawRect(0, 0, 800, 600);
			this.hi_background.graphics.endFill();
			
			this.hi_menuLayer.addChild(this.hi_background);
		}
		
		private function initBackBook():void {
			this.hi_book = new HighscoreBook();
			
			hi_book.scaleX = 1.05;
			hi_book.scaleY = 1.05;
			hi_book.x = (Session.application.size.x - hi_book.width) / 2;
			hi_book.y = (Session.application.size.y - hi_book.height) / 2;
			
			this.hi_menuLayer.addChild(this.hi_book);
		}
		
		private function initHighscoreBtns():void {		
			this.hi_btns = new highscoreBtns();
			
			hi_btns.x = 127.6;
			hi_btns.y = 310;
			
			this.hi_btns.gotoAndStop("menu");
			
			this.hi_menuLayer.addChild(this.hi_btns);
		}
		
		private function initTitle():void {
			this.hi_highscoreTitle = new TextField;
			
			hi_highscoreTitleFormat.font = "Segoe Script";
			hi_highscoreTitleFormat.color = 0x000066;
			hi_highscoreTitleFormat.size = 50;
			
			hi_highscoreTitle.text = "Highscore";
			hi_highscoreTitle.width = 265;
			hi_highscoreTitle.height = 75;
			hi_highscoreTitle.x = 100;
			hi_highscoreTitle.y = 145;
			
			hi_highscoreTitle.setTextFormat(hi_highscoreTitleFormat);
			
			this.hi_menuLayer.addChild(this.hi_highscoreTitle);
		}
		
		private function menuMoveUp():void {
			if (hi_btns.currentLabel == "credits") {
				this.hi_btns.gotoAndStop("menu");
			}
		}
		
		private function menuMoveDown():void {
			if (hi_btns.currentLabel == "menu") {
				this.hi_btns.gotoAndStop("credits");
			}
		}
		
		private function btnPress():void {
			if (hi_btns.currentLabel == "menu") {
				Session.application.displayState = new Menu;
			}
			
			if (hi_btns.currentLabel == "credits") {
				Session.application.displayState = new Credits;
			}
		}
		
	}
}