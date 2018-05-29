package scene
{
	import flash.display.Sprite;
	
	import assets.gameObjects.TutorialSpBook;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class TutorialSP extends DisplayState{
		
		private var hi_controls:EvertronControls;
		private var tsp_background:Sprite;
		private var tsp_Layer:DisplayStateLayer;
		private var tsp_book:TutorialSpBook;
		
		public function TutorialSP(){
			super();
			this.hi_controls = new EvertronControls(0);
		}
		
		override public function init():void{		
			this.initLayers();
			this.initBackground();
			this.initSpBook();
		}
		
		override public function update():void{
			this.hi_updatecontrols();
		}
		
		override public function dispose():void{
			
		}
		
		private function hi_updatecontrols():void{
			if (Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_1) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_2) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_3) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_4) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_5) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_6) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_7) || Input.keyboard.justPressed(this.hi_controls.PLAYER_BUTTON_8)){
				btnPress();
			}
		}
		
		private function initLayers():void {
			this.tsp_Layer = this.layers.add("Tutmp");
		}
		
		private function initSpBook():void
		{
			this.tsp_book = new TutorialSpBook;
			
			tsp_book.scaleX = 1.05;
			tsp_book.scaleY = 1.05;
			tsp_book.x = (Session.application.size.x - tsp_book.width) / 2;
			tsp_book.y = (Session.application.size.y - tsp_book.height) / 2;
			
			this.tsp_Layer.addChild(this.tsp_book);
		}
		
		private function initBackground():void {
			this.tsp_background = new Sprite();
			
			this.tsp_background.graphics.beginFill(0x121944);
			this.tsp_background.graphics.drawRect(0, 0, 800, 600);
			this.tsp_background.graphics.endFill();
			
			this.tsp_Layer.addChild(this.tsp_background);
		}
		
		private function btnPress():void {
			Session.application.displayState = new SingleplayerGame(1);
		}
		
	}
}