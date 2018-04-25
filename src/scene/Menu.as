package scene
{
	import flash.display.Sprite;
	
	import assets.gameObjects.menuPalm;
	import assets.gameObjects.menuBtns;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class Menu extends DisplayState{
		
		private var m_menuLayer:DisplayStateLayer;
		private var m_background:Sprite;
		private var m_controls:EvertronControls;
		
		private var m_btns:menuBtns;
		
		private var m_palmLeft:menuPalm;
		private var m_palmRight:menuPalm;
		
		public function Menu(){
			super();
			this.m_controls = new EvertronControls(1);
		}
		
	override public function init():void{		
		this.initLayers();
		this.initBackground();
		this.initMenuBtns();
		
		this.initPalmLeft();
		this.initPalmRight();
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
		this.m_background = new Sprite();
		
		this.m_background.graphics.beginFill(0x7DC8DB);
		this.m_background.graphics.drawRect(0, 0, 800, 600);
		this.m_background.graphics.endFill();
		
		this.m_menuLayer.addChild(this.m_background);
	}
	
	private function initMenuBtns():void {		
		this.m_btns = new menuBtns();
		
		m_btns.x = ((Session.application.width) / 2) - (m_btns.width / 2);
		m_btns.y = 190.9;
		
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
			
			multiGraphics();
		}
	}
	
	private function btnPress():void {
		if (m_btns.currentLabel == "single") {
			Session.application.displayState = new Game();
		}
		
		if (m_btns.currentLabel == "multi") {

		}
	}
	
	private function singleGraphics():void {
		
	}
	
	private function multiGraphics():void {
		
	}
	
	private function highscoreGraphics():void {
		
	}
	
	}
}