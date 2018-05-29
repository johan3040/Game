package scene
{
	import flash.display.Sprite;
	
	import assets.gameObjects.GradientBack;
	import assets.gameObjects.Logo;
	import assets.gameObjects.menuBtns;
	import assets.gameObjects.menuPalm;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class Menu extends DisplayState{
		
		private var m_menuLayer:DisplayStateLayer;
		private var m_water:Sprite;
		private var m_controls:EvertronControls;
		
		private var m_btns:menuBtns;
		private var m_logo:Logo;
		private var m_background:GradientBack;
		
		private var m_palmLeft:menuPalm;
		private var m_palmRight:menuPalm;
		
		[Embed(source = "../../assets/audio/menuMusicAU.mp3")] 	// <-- this data..
		private const M_MAIN_AUDIO:Class;					// ..gets saved in this const
		private var mAudio:SoundObject;
		
		public function Menu(){
			super();
			this.m_controls = new EvertronControls(0);
		}
		
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initWater();
			this.initMenuBtns();
			
			this.initPalmLeft();
			this.initPalmRight();
			
			this.initLogo();
			
			this.initMenuMusic();
		}
		
		override public function update():void{
			this.m_updatecontrols();
		}
		
		override public function dispose():void{
			
		}
		
		private function m_updatecontrols():void{
			if (Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)){
				btnPress();
			}
			
			if (Input.keyboard.justPressed(this.m_controls.PLAYER_UP)){
				menuMoveUp();
			}
			
			if (Input.keyboard.justPressed(this.m_controls.PLAYER_DOWN)){
				menuMoveDown();
			}
		}
		
		private function initLayers():void {
			this.m_menuLayer = this.layers.add("menu");
		}
		
		private function initBackground():void {
			this.m_background = new GradientBack();
			
			m_background.x = 0;
			m_background.y = 0;
			
			this.m_menuLayer.addChild(this.m_background);
		}
		
		private function initWater():void {
			this.m_water = new Sprite();
			
			this.m_water.graphics.beginFill(0x2B879E);
			this.m_water.graphics.drawRect(0, 540, 800, 60);
			this.m_water.graphics.endFill();
			
			this.m_menuLayer.addChild(this.m_water);
		}
		
		private function initMenuBtns():void {		
			this.m_btns = new menuBtns();
			
			m_btns.x = 269.35;
			m_btns.y = 240.9;
			
			this.m_btns.gotoAndStop("single");
			
			this.m_menuLayer.addChild(this.m_btns);
		}
		
		private function initPalmLeft():void {		
			this.m_palmLeft = new menuPalm();
			
			m_palmLeft.x = 0;
			m_palmLeft.y = 0;
			
			this.m_menuLayer.addChild(this.m_palmLeft);
		}
		
		private function initPalmRight():void {		
			this.m_palmRight = new menuPalm();
			
			m_palmRight.scaleX = -1;
			m_palmRight.x = 800;
			m_palmRight.y = 0;
			
			this.m_menuLayer.addChild(this.m_palmRight);
		}
		
		private function initLogo():void {
			this.m_logo = new Logo();
			
			m_logo.scaleX = 2.25;
			m_logo.scaleY = 2.25;
			m_logo.x = 295;
			m_logo.y = 33.4;
			
			this.m_menuLayer.addChild(this.m_logo);
		}
		
		private function initMenuMusic():void {
			Session.sound.soundChannel.sources.add("M_MAIN", M_MAIN_AUDIO);
			this.mAudio = Session.sound.soundChannel.get("M_MAIN", true, true);
			
			this.mAudio.play(9999); //Loopar musiken 9999 gånger
			this.mAudio.volume = 0.6;
		}
		
		private function menuMoveUp():void {
			if (m_btns.currentLabel == "multi") {
				this.m_btns.gotoAndStop("single");
			}
			
			if (m_btns.currentLabel == "highscore") {
				this.m_btns.gotoAndStop("multi");
			}
		}
		
		private function menuMoveDown():void {
			if (m_btns.currentLabel == "multi") {
				this.m_btns.gotoAndStop("highscore");
			}
			
			if (m_btns.currentLabel == "single") {
				this.m_btns.gotoAndStop("multi");
			}
		}
		
		private function btnPress():void {
			if (m_btns.currentLabel == "single") {
				Session.application.displayState = new TutorialSP;
			}
			
			if (m_btns.currentLabel == "multi") {
				Session.application.displayState = new TutorialMP;
			}
			
			if (m_btns.currentLabel == "highscore") {
				Session.application.displayState = new Highscore;
			}
		}
		
	}
}