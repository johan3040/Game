package scene
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3.game.GetHighscore;
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
	import se.lnu.stickossdk.media.SoundObject;
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
		
		//---------------------------------------
		// Highscore elements
		//---------------------------------------
		private var go_HighscoreData:GetHighscore;
		private var go_highscoreNumbers:TextField;
		private var go_highscoreNames:TextField;
		private var go_highscoreScores:TextField;
		private var go_highscoreListFormat:TextFormat;
		private var go_highscoreNumbersFormat:TextFormat;
		private var go_highscoreTitle:TextField;
		private var go_highscoreTitleFormat:TextFormat;
		
		//---------------------------------------
		// Font
		//---------------------------------------
		[Embed(source="../../assets/font/PaintyPaint.TTF",
					fontName = "FontyFont",
					mimeType = "application/x-font",
					advancedAntiAliasing="true",
					embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		
		//---------------------------------------
		// Musik
		//---------------------------------------
		[Embed(source = "../../assets/audio/gameoverMusicAU.mp3")] 	// <-- this data..
		private const GO_MAIN_AUDIO:Class;					// ..gets saved in this const
		private var goAudio:SoundObject;
		
		public function GameOver(player, mode){
			super();
			this.player = player;
			this.mode = mode;
			this.go_controls = new EvertronControls(0);
		}
		
		//Initierar grafik och musiken. Kollar sedan om spelläget som den kommer ifrån är Sp eller Mp.
		//Beroende på vilket läge det är så aktiverar den olika funktioner
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initMusic();
			this.mode == 1 ? this.go_Sp() : this.go_Mp();
		}
		
		override public function update():void{
			if (submitted) this.go_updatecontrols();
			if (this.mode != 1) this.go_updatecontrols();
		}
		
		//Funktion för att läsa av vad som ska göras beroende på hur spelar interagerar med menyn
		//Om de flyttar upp och ner eller klickar
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
		
		//Skapar den färg som ligger i bakgrunden av både Mp och Sp gameover
		private function initBackground():void {
			this.go_background = new Sprite();
			
			this.go_background.graphics.beginFill(0x121944);
			this.go_background.graphics.drawRect(0, 0, 800, 600);
			this.go_background.graphics.endFill();
			
			this.go_menuLayer.addChild(this.go_background);
		}
		
		//Initierar musiken. Loopar musiken 9999 gånger för att den ska fortsätta loopa
		private function initMusic():void {
			Session.sound.soundChannel.sources.add("GO_MAIN", GO_MAIN_AUDIO);
			this.goAudio = Session.sound.soundChannel.get("GO_MAIN", true, true);
			
			this.goAudio.play(9999); //Loopar musiken 9999 gånger
			this.goAudio.volume = 1;
		}
		
		//Efter att game over initieras så skickas den hit om spelläget är Sp.
		//Ser till att score har samma värde som spelarens slutpoäng
		private function go_Sp():void{
			this.score = this.player.bonusPoints;
			//Kod för Gameover single player
			checkHighscore();
		}
		
		//Använder smartsend för att kolla om det är highscore, och skicka in poängen om detta är sant.
		//Går till onSubmitComplete när detta är klart
		private function checkHighscore():void{
			Session.highscore.smartSend(this.TABLE, this.score, this.RANGE, onSubmitComplete);
		}
		
		//Initierar grafiken i bakgrunden för Sp
		//Det är i denna funktion som XML datan från smartsend tas emot för att sedan kunna initiera highscore
		private function onSubmitComplete(data:XML):void {
			
			this.initBottom();
			this.initHighscoreDisplay();
			this.initTitle();
			this.initGameoverBtns();
			
			this.submitted = true;
			
			this.initHighscore();
			this.initHighscoreTitle();
		}
		
		//Startar klassen GetHighscore() där XML datan med alla highscore resultat läses av och hanteras
		//När GetHighscore klassen är klar så görs en callback till recieveHighscore vilket defineras här
		private function initHighscore():void{			
			this.go_HighscoreData = new GetHighscore(this.recieveHighScore);
		}
		
		//Denna funktion aktiveras när spelet skickas tillbaka hit efter att GetHighscore är klart
		private function recieveHighScore():void{
			this.placeHighscoreElements();
		}
		
		//Placerar ut den information som hanterades i GetHighscore()
		private function placeHighscoreElements():void{
			
			//Om spelare väljer att starta nytt spel innan highscore-data har hämtats lämnas metoden utan att spelet kraschar
			if(go_HighscoreData == null) return;
			
			//Skapar textfältet som har alla positioner i highscorelistan
			//Sätter innehållet i denna textfield från vad som genererats i GetHighscore()
			this.go_highscoreNumbers = new TextField();
			go_highscoreNumbers.text = go_HighscoreData.highscorePositions;
			
			//Skapar textfältet som har alla namn i highscorelistan
			//Sätter innehållet i denna textfield från vad som genererats i GetHighscore()
			this.go_highscoreNames = new TextField();
			go_highscoreNames.text = go_HighscoreData.highscoreNames;
			
			//Skapar textfältet som har alla poäng i highscorelistan
			//Sätter innehållet i denna textfield från vad som genererats i GetHighscore()
			this.go_highscoreScores = new TextField();
			go_highscoreScores.text = go_HighscoreData.highscoreScores;
			
			go_highscoreNumbers.x = 498;
			go_highscoreNumbers.y = 129;
			go_highscoreNumbers.height = 420;
			go_highscoreNumbers.width = 44;
			
			go_highscoreNames.x = 548;
			go_highscoreNames.y = 129;
			go_highscoreNames.height = 420;
			go_highscoreNames.width = 140;
			
			go_highscoreScores.x = 685;
			go_highscoreScores.y = 129;
			go_highscoreScores.height = 420;
			go_highscoreScores.width = 85;
			
			this.go_highscoreNumbersFormat = new TextFormat("FontyFont", 24, 0xFFFFFF);
			go_highscoreNumbersFormat.align = "right";
			go_highscoreNumbersFormat.leading = 10.5;
			go_highscoreNumbers.setTextFormat(go_highscoreNumbersFormat);
			this.go_highscoreNumbers.embedFonts = true;
			
			this.go_highscoreListFormat = new TextFormat("FontyFont", 24, 0xFFFFFF);
			go_highscoreListFormat.align = "left";
			go_highscoreListFormat.leading = 10.5;
			go_highscoreNames.setTextFormat(go_highscoreListFormat);
			go_highscoreScores.setTextFormat(go_highscoreListFormat);
			this.go_highscoreNames.embedFonts = true;
			this.go_highscoreScores.embedFonts = true;
			
			this.go_menuLayer.addChild(this.go_highscoreNumbers);
			this.go_menuLayer.addChild(this.go_highscoreNames);
			this.go_menuLayer.addChild(this.go_highscoreScores);
		}
		
		//Skapar den titel som visas över highscorelistan
		private function initHighscoreTitle():void{
			this.go_highscoreTitle = new TextField();
			this.go_highscoreTitleFormat = new TextFormat("FontyFont", 38, 0xFFFFFF);
			this.go_highscoreTitle.text = "Highscore";
			this.go_highscoreTitle.setTextFormat(this.go_highscoreTitleFormat);
			this.go_highscoreTitle.embedFonts = true;
			this.go_highscoreTitle.defaultTextFormat = this.go_highscoreTitleFormat;
			
			this.go_highscoreTitle.x = 575;
			this.go_highscoreTitle.y = 58;
			this.go_highscoreTitle.width = 220;
			this.go_highscoreTitle.rotation = -5;
			this.go_menuLayer.addChild(this.go_highscoreTitle);
		}
		
		//Efter att game over initieras så skickas den hit om spelläget är Mp
		//Knapparna initieras, och ser till att menyvalet högst upp är markerat från början,
		//vilket görs genom label "replay"
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
		
		// För MP
		//Initierar botten grafiken om P1 vinner
		private function initMpBottomP1():void{
			// Skapa & visa grafik när P1 är vinnare
			
			this.go_mpP1 = new gameoverBottomP1();
			
			go_mpP1.x = 0;
			go_mpP1.y = 382.45;
			
			this.go_menuLayer.addChild(this.go_mpP1);
			
		}

		// För MP
		//Initierar botten grafiken om P2 vinner		
		private function initMpBottomP2():void{
			// Skapa & visa grafik när P2 är vinnare
			
			this.go_mpP2 = new gameoverBottomP2();
			
			go_mpP2.x = 0;
			go_mpP2.y = 382.45;
			
			this.go_menuLayer.addChild(this.go_mpP2);
			
		}
		
		// För MP
		//Initierar titeln om P1 vinner
		private function initP1WinnerText():void{
			this.go_mpTitleP1 = new gameoverTitleP1();
			
			go_mpTitleP1.x = 48;
			go_mpTitleP1.y = 36.55;
			
			this.go_menuLayer.addChild(this.go_mpTitleP1);
		}
		
		// För MP
		//initierar titeln om P2 vinner
		private function initP2WinnerText():void{
			this.go_mpTitleP2 = new gameoverTitleP2();
			
			go_mpTitleP2.x = 48;
			go_mpTitleP2.y = 36.55;
			
			this.go_menuLayer.addChild(this.go_mpTitleP2);
		}
		
		// För MP
		private function initBottom():void {	
			this.go_bottom = new gameoverBottom();
			
			go_bottom.x = 0;
			go_bottom.y = 382.45;
			
			this.go_menuLayer.addChild(this.go_bottom);
		}
		
		// För SP
		//Knapparna initieras, och ser till att menyvalet högst upp är markerat från början,
		//vilket görs genom label "replay"
		private function initGameoverBtns():void {		
			this.go_btns = new gameoverBtns();
			
			go_btns.x = 119.45;
			go_btns.y = 189.3;
			
			this.go_btns.gotoAndStop("replay");
			
			this.go_menuLayer.addChild(this.go_btns);
		}
		
		// För SP titel
		private function initTitle():void {		
			this.go_title = new gameoverTitle();
			
			go_title.x = 48;
			go_title.y = 47.55;
			
			this.go_menuLayer.addChild(this.go_title);
		}
		
		// Initierar det grafiska som highscoren sedan placeras ut på
		private function initHighscoreDisplay():void {		
			this.go_highscoreDisplay = new gameoverHighscoreDisplay();
			
			go_highscoreDisplay.x = 503.75;
			go_highscoreDisplay.y = 35.7;
			
			this.go_menuLayer.addChild(this.go_highscoreDisplay);
		}
		
		//När spelaren flyttar upp med joysticken i menyn
		private function menuMoveUp():void {
			if (go_btns.currentLabel == "menu") {
				this.go_btns.gotoAndStop("replay");
			}
		}
		
		//När spelaren flyttar ner med joysticken i menyn
		private function menuMoveDown():void {
			if (go_btns.currentLabel == "replay") {
				this.go_btns.gotoAndStop("menu");
			}
		}
		
		//När spelaren trycker på knappen, så aktiveras läget beroende på vilket "mode" som är valt i menyn
		private function btnPress():void {
			if (go_btns.currentLabel == "replay") {
				if(mode == 1) Session.application.displayState = new SingleplayerGame(mode);
				if(mode == 2) Session.application.displayState = new MultiplayerGame(mode);
			}
			
			if (go_btns.currentLabel == "menu") {
				Session.application.displayState = new Menu();
			}
		}
		
		override public function dispose():void{
			this.go_HighscoreData = null;
			this.go_highscoreNumbers = null;
			this.go_highscoreNames = null;
			this.go_highscoreScores = null;
			this.go_highscoreListFormat = null;
			this.go_highscoreNumbersFormat = null;
			this.go_highscoreDisplay = null;
			this.player = null;
			this.go_bottom = null;
			this.go_mpP1 = null;
			this.go_mpP2 = null;
			this.go_title = null;
			this.go_mpTitleP1 = null;
			this.go_mpTitleP2 = null;
			this.go_background = null;
			this.go_controls = null;
			this.go_btns = null;
			this.go_highscoreTitle = null;
			this.go_highscoreTitleFormat = null;
		}
		
	}
}