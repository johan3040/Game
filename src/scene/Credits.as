package scene
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import assets.gameObjects.HighscoreBook;
	import assets.gameObjects.creditsBtns;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class Credits extends DisplayState{
		
		private var cr_menuLayer:DisplayStateLayer;
		private var cr_controls:EvertronControls;
		
		private var cr_btns:creditsBtns;
		private var cr_background:Sprite;
		private var cr_book:HighscoreBook;
		
		private var cr_creditsTitle:TextField;
		private var cr_mainCreditsTitle:TextField;
		private var cr_mainCreditsText:TextField;
		private var cr_soundCreditsTitle:TextField;
		private var cr_soundCredits:TextField;
		private var cr_mainCreditsDeveloperTitle:TextField;
		private var cr_mainCreditsDeveloper:TextField;
		private var cr_mainCreditsDesignerTitle:TextField;
		private var cr_mainCreditsDesigner:TextField;
		
		private var cr_creditsTitleFormat:TextFormat = new TextFormat;
		private var cr_mainCreditsFormat:TextFormat = new TextFormat;
		private var cr_soundCreditsFormat:TextFormat = new TextFormat;
		private var cr_mainCreditsTitleFormat:TextFormat;
		private var cr_soundCreditsTitleFormat:TextFormat;
		private var cr_fontCreditsTitle:TextField;
		private var cr_fontCredits:TextField;
		private var cr_fontCreditsTitleFormat:TextFormat;
		private var cr_fontCreditsFormat:TextFormat;
		
		public function Credits(){
			super();
			this.cr_controls = new EvertronControls(0);
		}

		//Initierar grafik, knappar och text
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initBackBook();
			
			this.initCreditsBtns();
			this.initTitle();
			
			this.initMainCredits();
			this.initSoundCredits();
			this.initFontCredits();
		}
		
		override public function update():void{
			this.cr_updatecontrols();
		}

		//Funktion för att läsa av vad som ska göras beroende på hur spelar interagerar med menyn
		//Om de flyttar upp och ner eller klickar
		private function cr_updatecontrols():void{
			if (Input.keyboard.justPressed(this.cr_controls.PLAYER_BUTTON_1)){
				btnPress();
			}
			
			if (Input.keyboard.justPressed(this.cr_controls.PLAYER_UP)){
				menuMoveUp();
			}
			
			if (Input.keyboard.justPressed(this.cr_controls.PLAYER_DOWN)){
				menuMoveDown();
			}
		}
		
		private function initLayers():void {
			this.cr_menuLayer = this.layers.add("menu");
		}
		
		//Ritar upp bakgrunden
		private function initBackground():void {
			this.cr_background = new Sprite();
			
			this.cr_background.graphics.beginFill(0x121944);
			this.cr_background.graphics.drawRect(0, 0, 800, 600);
			this.cr_background.graphics.endFill();
			
			this.cr_menuLayer.addChild(this.cr_background);
		}
		
		//Initierar bok-grafiken
		private function initBackBook():void {
			this.cr_book = new HighscoreBook();
			
			cr_book.scaleX = 1.05;
			cr_book.scaleY = 1.05;
			cr_book.x = (Session.application.size.x - cr_book.width) / 2;
			cr_book.y = (Session.application.size.y - cr_book.height) / 2;
			
			this.cr_menuLayer.addChild(this.cr_book);
		}
		
		//Knapparna initieras, och ser till att menyvalet högst upp är markerat från början,
		//vilket görs genom label "menu"		
		private function initCreditsBtns():void {		
			this.cr_btns = new creditsBtns();
			
			cr_btns.x = 127.6;
			cr_btns.y = 310;
			
			this.cr_btns.gotoAndStop("menu");
			
			this.cr_menuLayer.addChild(this.cr_btns);
		}
		
		//Initierar, skriver och placerar ut titel för skärmen
		private function initTitle():void {
			this.cr_creditsTitle = new TextField;
			
			cr_creditsTitleFormat.font = "Segoe Script";
			cr_creditsTitleFormat.color = 0x000066;
			cr_creditsTitleFormat.size = 50;
			
			cr_creditsTitle.text = "Credits";
			cr_creditsTitle.width = 265;
			cr_creditsTitle.height = 75;
			cr_creditsTitle.x = 130;
			cr_creditsTitle.y = 145;
			
			cr_creditsTitle.setTextFormat(cr_creditsTitleFormat);
			
			this.cr_menuLayer.addChild(this.cr_creditsTitle);
		}
		
		//Initierar, skriver och placerar ut alla credits för utvecklare och designer
		private function initMainCredits():void {
			//Credits för programmering
			this.cr_mainCreditsDeveloperTitle = new TextField;
			this.cr_mainCreditsDeveloper = new TextField;
			//Credits för design
			this.cr_mainCreditsDesignerTitle = new TextField;
			this.cr_mainCreditsDesigner = new TextField;
			
			cr_mainCreditsDeveloperTitle.text = "Johan Lundqvist";
			cr_mainCreditsDeveloper.text = "Developer";
			cr_mainCreditsDesignerTitle.text = "Samantha Persson";
			cr_mainCreditsDesigner.text = "Design, Music & Sound";
			
			this.cr_mainCreditsTitleFormat = new TextFormat("Segoe Script", 25, 0x000066);
			cr_mainCreditsTitleFormat.align = "center";
			cr_mainCreditsTitleFormat.leading = 0;
			cr_mainCreditsDeveloperTitle.setTextFormat(cr_mainCreditsTitleFormat);
			cr_mainCreditsDesignerTitle.setTextFormat(cr_mainCreditsTitleFormat);
			
			this.cr_mainCreditsFormat = new TextFormat("Segoe Script", 18, 0x000066);
			cr_mainCreditsFormat.align = "center";
			cr_mainCreditsFormat.leading = 0;
			cr_mainCreditsDeveloper.setTextFormat(cr_mainCreditsFormat);
			cr_mainCreditsDesigner.setTextFormat(cr_mainCreditsFormat);
			
			cr_mainCreditsDeveloperTitle.x = 440;
			cr_mainCreditsDeveloperTitle.y = 45;
			cr_mainCreditsDeveloperTitle.width = 250;
			
			cr_mainCreditsDeveloper.x = 440;
			cr_mainCreditsDeveloper.y = 80;
			cr_mainCreditsDeveloper.width = 250;
			
			cr_mainCreditsDesignerTitle.x = 440;
			cr_mainCreditsDesignerTitle.y = 120;
			cr_mainCreditsDesignerTitle.width = 250;
			
			cr_mainCreditsDesigner.x = 440;
			cr_mainCreditsDesigner.y = 155;
			cr_mainCreditsDesigner.width = 250;
			
			this.cr_menuLayer.addChild(this.cr_mainCreditsDeveloperTitle);
			this.cr_menuLayer.addChild(this.cr_mainCreditsDeveloper);
			this.cr_menuLayer.addChild(this.cr_mainCreditsDesignerTitle);
			this.cr_menuLayer.addChild(this.cr_mainCreditsDesigner);
		}
		
		//Credits för fonten
		private function initFontCredits():void {
			this.cr_fontCreditsTitle = new TextField;		
			this.cr_fontCredits = new TextField;
			
			cr_fontCreditsTitle.text = "Font";	
			cr_fontCredits.text = "Painty Paint - Vin Rowe(dafont)";
	
			this.cr_fontCreditsTitleFormat = new TextFormat("Segoe Script", 19, 0x000066);
			cr_fontCreditsTitleFormat.align = "center";
			cr_fontCreditsTitleFormat.leading = 0;
			cr_fontCreditsTitle.setTextFormat(cr_fontCreditsTitleFormat);
			
			this.cr_fontCreditsFormat = new TextFormat("Segoe Script", 12, 0x000066);
			cr_fontCreditsFormat.align = "center";
			cr_fontCreditsFormat.leading = 0;
			cr_fontCredits.setTextFormat(cr_fontCreditsFormat);
			
			cr_fontCreditsTitle.x = 440;
			cr_fontCreditsTitle.y = 350;
			cr_fontCreditsTitle.width = 250;
			
			cr_fontCredits.x = 425;
			cr_fontCredits.y = 375;
			cr_fontCredits.width = 280;
			
			this.cr_menuLayer.addChild(this.cr_fontCreditsTitle);
			this.cr_menuLayer.addChild(this.cr_fontCredits);
		}
		
		//Credits för de ljudeffekter som används
		private function initSoundCredits():void {
			this.cr_soundCreditsTitle = new TextField;		
			this.cr_soundCredits = new TextField;
			
			cr_soundCreditsTitle.text = "Sound";	
			cr_soundCredits.text = "Wave3 - Kayyy (freesound)\nCrate Break 1 - kevinkace(freesound)\nShaker Riff - cloudyeyetavern(freesound)";
			
			this.cr_soundCreditsTitleFormat = new TextFormat("Segoe Script", 19, 0x000066);
			cr_soundCreditsTitleFormat.align = "center";
			cr_soundCreditsTitleFormat.leading = 0;
			cr_soundCreditsTitle.setTextFormat(cr_soundCreditsTitleFormat);
			
			this.cr_soundCreditsFormat = new TextFormat("Segoe Script", 12, 0x000066);
			cr_soundCreditsFormat.align = "center";
			cr_soundCreditsFormat.leading = 4;
			cr_soundCredits.setTextFormat(cr_soundCreditsFormat);
			
			cr_soundCreditsTitle.x = 440;
			cr_soundCreditsTitle.y = 210;
			cr_soundCreditsTitle.width = 250;
			
			cr_soundCredits.x = 425;
			cr_soundCredits.y = 240;
			cr_soundCredits.width = 280;
			
			this.cr_menuLayer.addChild(this.cr_soundCreditsTitle);
			this.cr_menuLayer.addChild(this.cr_soundCredits);
		}
		
		//När spelaren flyttar upp med joysticken i menyn
		private function menuMoveUp():void {
			if (cr_btns.currentLabel == "highscore") {
				this.cr_btns.gotoAndStop("menu");
			}
		}
		
		//När spelaren flyttar upp ner joysticken i menyn
		private function menuMoveDown():void {
			if (cr_btns.currentLabel == "menu") {
				this.cr_btns.gotoAndStop("highscore");
			}
		}
		
		//När spelaren trycker på knappen, så aktiveras läget beroende på vilket "mode" som är valt i menyn
		private function btnPress():void {
			if (cr_btns.currentLabel == "menu") {
				Session.application.displayState = new Menu;
			}
			
			if (cr_btns.currentLabel == "highscore") {
				Session.application.displayState = new Highscore;
			}
		}
		
		
		override public function dispose():void{
			
			this.cr_background = null;
			this.cr_book = null;
			this.cr_btns = null;
			this.cr_controls = null;
			this.cr_creditsTitle = null;
			this.cr_creditsTitleFormat = null;
			this.cr_fontCredits = null;
			this.cr_fontCreditsFormat = null;
			this.cr_fontCreditsTitle = null;
			this.cr_fontCreditsTitleFormat = null;
			this.cr_mainCreditsDesigner = null;
			this.cr_mainCreditsDesignerTitle = null;
			this.cr_mainCreditsDeveloper = null;
			this.cr_mainCreditsDeveloperTitle = null;
			this.cr_mainCreditsFormat = null;
			this.cr_mainCreditsText = null;
			this.cr_mainCreditsTitle = null;
			this.cr_mainCreditsTitleFormat = null;
			this.cr_soundCredits = null;
			this.cr_soundCreditsFormat = null;
			this.cr_soundCreditsTitle = null;
			this.cr_soundCreditsTitleFormat = null;
			
		}
		
	}
}