package scene
{
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	public class Menu extends DisplayState{
		
		private var m_controls:EvertronControls;
		
		public function Menu(){
			super();
			this.m_controls = new EvertronControls(1);
			trace("Menu");
		}
		
	override public function init():void{
		
	}
	
	override public function update():void{
		this.m_updatecontrols();
	}
	
	override public function dispose():void{
		
	}
	
	private function m_updatecontrols():void{
		if (Input.keyboard.pressed(this.m_controls.PLAYER_BUTTON_1)){
			Session.application.displayState = new Game();
		}
	}
	
	}
}