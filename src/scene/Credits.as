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
		private var cr_soundCreditsText:TextField;
		
		private var cr_creditsTitleFormat:TextFormat = new TextFormat;
		private var cr_mainCreditsFormat:TextFormat = new TextFormat;
		private var cr_soundCreditsFormat:TextFormat = new TextFormat;
		
		public function Credits(){
			super();
			this.cr_controls = new EvertronControls(0);
		}
		
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initBackBook();
			
			this.initCreditsBtns();
			this.initTitle();
		}
		
		override public function update():void{
			this.cr_updatecontrols();
		}
		
		override public function dispose():void{
			
		}
		
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
		
		private function initBackground():void {
			this.cr_background = new Sprite();
			
			this.cr_background.graphics.beginFill(0x121944);
			this.cr_background.graphics.drawRect(0, 0, 800, 600);
			this.cr_background.graphics.endFill();
			
			this.cr_menuLayer.addChild(this.cr_background);
		}
		
		private function initBackBook():void {
			this.cr_book = new HighscoreBook();
			
			cr_book.scaleX = 1.05;
			cr_book.scaleY = 1.05;
			cr_book.x = (Session.application.size.x - cr_book.width) / 2;
			cr_book.y = (Session.application.size.y - cr_book.height) / 2;
			
			this.cr_menuLayer.addChild(this.cr_book);
		}
		
		private function initCreditsBtns():void {		
			this.cr_btns = new creditsBtns();
			
			cr_btns.x = 127.6;
			cr_btns.y = 310;
			
			this.cr_btns.gotoAndStop("menu");
			
			this.cr_menuLayer.addChild(this.cr_btns);
		}
		
		private function initTitle():void {
			this.cr_creditsTitle = new TextField;
			
			cr_creditsTitleFormat.font = "Segoe Script";
			cr_creditsTitleFormat.color = 0x990000;
			cr_creditsTitleFormat.size = 50;
			
			cr_creditsTitle.text = "Credits";
			cr_creditsTitle.width = 265;
			cr_creditsTitle.height = 75;
			cr_creditsTitle.x = 130;
			cr_creditsTitle.y = 145;
			
			cr_creditsTitle.setTextFormat(cr_creditsTitleFormat);
			
			this.cr_menuLayer.addChild(this.cr_creditsTitle);
		}
		
		private function initMainCredits():void {
			this.cr_soundCreditsTitle = new TextField;			
			
			cr_soundCreditsTitle.text = "Sound";			
		}
		
		private function initSoundCredits():void {
			
		}
		
		private function menuMoveUp():void {
			if (cr_btns.currentLabel == "highscore") {
				this.cr_btns.gotoAndStop("menu");
			}
		}
		
		private function menuMoveDown():void {
			if (cr_btns.currentLabel == "menu") {
				this.cr_btns.gotoAndStop("highscore");
			}
		}
		
		private function btnPress():void {
			if (cr_btns.currentLabel == "menu") {
				Session.application.displayState = new Menu;
			}
			
			if (cr_btns.currentLabel == "highscore") {
				Session.application.displayState = new Highscore;
			}
		}
		
	}
}