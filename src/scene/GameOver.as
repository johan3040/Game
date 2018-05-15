package scene
{
	import flash.display.Sprite;
	
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.gameoverBottom;
	import assets.gameObjects.gameoverBottomP1;
	import assets.gameObjects.gameoverBottomP2;
	import assets.gameObjects.gameoverBtns;
	import assets.gameObjects.gameoverHighscoreDisplay;
	import assets.gameObjects.gameoverTitle;
	import assets.gameObjects.gameoverTitleP1;
	import assets.gameObjects.gameoverTitleP2;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class GameOver extends DisplayState{
		
		private var go_menuLayer:DisplayStateLayer;
		private var go_background:Sprite;
		private var go_controls:EvertronControls;
		private var go_btns:gameoverBtns;
		
		//---------------------------------------
		// Titles
		//---------------------------------------
		private var go_title:gameoverTitle;
		private var go_mpTitleP1:gameoverTitleP1;
		private var go_mpTitleP2:gameoverTitleP2;
		
		//---------------------------------------
		// Bottom GFX
		//---------------------------------------
		private var go_bottom:gameoverBottom;
		private var go_mpP1:gameoverBottomP1;
		private var go_mpP2:gameoverBottomP2;
		
		private var go_highscoreDisplay:gameoverHighscoreDisplay;
		private var player:Player;
		private var mode:int; // 1 = singelplayer 2 = multiplayer
		
		private const TABLE:int = 1;
		private const RANGE:int = 10;
		private var score:int = 0;
		private var submitted:Boolean = false;
		
		public function GameOver(player, mode){
			super();
			trace(mode);
			this.player = player;
			this.mode = mode;
			this.go_controls = new EvertronControls(0);
		}
		
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.mode == 1 ? this.go_Sp() : this.go_Mp();
		}
		
		override public function update():void{
			if (submitted) this.go_updatecontrols();
			if (this.mode != 1) this.go_updatecontrols();
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
		
		private function go_Sp():void{
			this.score = this.player.bonusPoints;
			//Kod för Gameover single player
			
			checkHighscore();
		}
		
		private function checkHighscore():void
		{
			Session.highscore.smartSend(this.TABLE, this.score, this.RANGE, onSubmitComplete);
			
		}
		
		private function onSubmitComplete(data:XML):void {
			
			this.initBottom();
			this.initHighscoreDisplay();
			this.initTitle();
			this.initGameoverBtns();
			
			this.submitted = true;
		}
		
		private function go_Mp():void{
			//Kod för Gameover multi player			
			this.initGameoverBtns();
			
			if(this.player is Explorer){
				this.initMpBottomP1();
				this.initP1WinnerText();
			}else{
				this.initMpBottomP2();
				this.initP2WinnerText();
			}
		}
		
		private function initMpBottomP1():void{
			// Skapa & visa grafik när P1 är vinnare
			
			this.go_mpP1 = new gameoverBottomP1();
			
			go_mpP1.x = 0;
			go_mpP1.y = 382.45;
			
			this.go_menuLayer.addChild(this.go_mpP1);
			
		}
		
		private function initMpBottomP2():void{
			// Skapa & visa grafik när P2 är vinnare
			
			this.go_mpP2 = new gameoverBottomP2();
			
			go_mpP2.x = 0;
			go_mpP2.y = 382.45;
			
			this.go_menuLayer.addChild(this.go_mpP2);
			
		}
		
		private function initP1WinnerText():void{
			this.go_mpTitleP1 = new gameoverTitleP1();
			
			go_mpTitleP1.x = 48;
			go_mpTitleP1.y = 36.55;
			
			this.go_menuLayer.addChild(this.go_mpTitleP1);
		}
		
		private function initP2WinnerText():void{
			this.go_mpTitleP2 = new gameoverTitleP2();
			
			go_mpTitleP2.x = 48;
			go_mpTitleP2.y = 36.55;
			
			this.go_menuLayer.addChild(this.go_mpTitleP2);
		}
		
		private function initBottom():void {	
			trace("123");
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
		
		// För SP
		private function initTitle():void {		
			this.go_title = new gameoverTitle();
			
			go_title.x = 48;
			go_title.y = 47.55;
			
			this.go_menuLayer.addChild(this.go_title);
		}
		
		// För SP
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
				Session.application.displayState = new Game(mode);
			}
			
			if (go_btns.currentLabel == "menu") {
				Session.application.displayState = new Menu();
			}
		}
		
		override public function dispose():void{
			//Alla instansierade objekt skall nullas: ex - this.go_highscroreDisplay = null;
		}
		
	}
}