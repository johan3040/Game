package scene
{
	import flash.display.Sprite;
	
	import assets.gameObjects.gameoverBottom;
	import assets.gameObjects.gameoverBtns;
	import assets.gameObjects.gameoverHighscoreDisplay;
	import assets.gameObjects.gameoverTitle;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class GameOver extends DisplayState
	{
		
		private var go_menuLayer:DisplayStateLayer;
		private var go_background:Sprite;
		private var go_controls:EvertronControls;
		
		private var go_btns:gameoverBtns;
		
		private var go_title:gameoverTitle;
		private var go_highscoreDisplay:gameoverHighscoreDisplay;
		private var go_bottom:gameoverBottom;
		
		public function GameOver()
		{
			super();
			this.go_controls = new EvertronControls(1);
		}
		
	override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initGameoverBtns();
			this.initBottom();
			this.initHighscoreDisplay();
			this.initTitle();
	}
	
	override public function update():void{
		this.go_updatecontrols();
	}
	
	private function go_updatecontrols():void{
		if (Input.keyboard.justPressed(this.go_controls.PLAYER_BUTTON_1)){
			btnPress();
		}
		
		if (Input.keyboard.justPressed(this.go_controls.PLAYER_UP)){
			menuMoveUp();
		}
		
		if (Input.keyboard.justPressed(this.go_controls.PLAYER_DOWN)){
			menuMoveDown();
		}
	}	
	
	private function initLayers():void {
		this.go_menuLayer = this.layers.add("gameover");
	}
	
	private function initBackground():void {
		this.go_background = new Sprite();
		
		this.go_background.graphics.beginFill(0x121944);
		this.go_background.graphics.drawRect(0, 0, 800, 600);
		this.go_background.graphics.endFill();
		
		this.go_menuLayer.addChild(this.go_background);
	}	
	
	private function initBottom():void {		
		this.go_bottom = new gameoverBottom();
		
		go_bottom.x = 0;
		go_bottom.y = 382.45;
		
		this.go_menuLayer.addChild(this.go_bottom);
	}
		
	
	private function initGameoverBtns():void {		
		this.go_btns = new gameoverBtns();
		
		go_btns.x = 119.45;
		go_btns.y = 189.3;
		
		this.go_btns.gotoAndStop("replay");
		
		this.go_menuLayer.addChild(this.go_btns);
	}
	
	private function initTitle():void {		
		this.go_title = new gameoverTitle();
		
		go_title.x = 48;
		go_title.y = 47.55;
		
		this.go_menuLayer.addChild(this.go_title);
	}
	
	private function initHighscoreDisplay():void {		
		this.go_highscoreDisplay = new gameoverHighscoreDisplay();
		
		go_highscoreDisplay.x = 503.75;
		go_highscoreDisplay.y = 35.7;
		
		this.go_menuLayer.addChild(this.go_highscoreDisplay);
	}
	
	private function menuMoveUp():void {
		if (go_btns.currentLabel == "menu") {
			this.go_btns.gotoAndStop("replay");
		}
	}
	
	private function menuMoveDown():void {
		if (go_btns.currentLabel == "replay") {
			this.go_btns.gotoAndStop("menu");
		}
	}
	
	private function btnPress():void {
		if (go_btns.currentLabel == "replay") {
			Session.application.displayState = new Game();
		}
		
		if (go_btns.currentLabel == "menu") {
			Session.application.displayState = new Menu();
		}
	}
	
	}
}