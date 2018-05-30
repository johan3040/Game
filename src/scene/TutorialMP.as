package scene
{
	import flash.display.Sprite;
	
	import assets.gameObjects.TutorialMpBook;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class TutorialMP extends DisplayState{
		
		private var hi_controls:EvertronControls;
		private var tmp_background:Sprite;
		private var tmp_Layer:DisplayStateLayer;
		private var tmp_book:TutorialMpBook;
		
		public function TutorialMP(){
			super();
			this.hi_controls = new EvertronControls(0);
		}
		
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initMpBook();
		}
		
		override public function update():void{
			this.hi_updatecontrols();
		}
		
		private function hi_updatecontrols():void{
			if (Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_1) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_2) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_3) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_4) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_5) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_6) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_7) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_8)){
				btnPress();
			}
		}
		
		private function initLayers():void {
			this.tmp_Layer = this.layers.add("Tutmp");
		}
		
		private function initMpBook():void
		{
			this.tmp_book = new TutorialMpBook();
			
			tmp_book.scaleX = 1.05;
			tmp_book.scaleY = 1.05;
			tmp_book.x = (Session.application.size.x - tmp_book.width) / 2;
			tmp_book.y = (Session.application.size.y - tmp_book.height) / 2;
			
			this.tmp_Layer.addChild(this.tmp_book);
		}
		
		private function initBackground():void {
			this.tmp_background = new Sprite();
			
			this.tmp_background.graphics.beginFill(0x121944);
			this.tmp_background.graphics.drawRect(0, 0, 800, 600);
			this.tmp_background.graphics.endFill();
			
			this.tmp_Layer.addChild(this.tmp_background);
		}
		
		private function btnPress():void {
			Session.application.displayState = new MultiplayerGame(2);
		}
		
		override public function dispose():void{
			this.tmp_book = null;
			this.tmp_background = null;
			this.hi_controls = null;
		}
		
	}
}