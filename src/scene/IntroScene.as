package scene
{
	import assets.gameObjects.introAnimation;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class IntroScene extends DisplayState{
		
		private var m_controls:EvertronControls;
		private var introLayer:DisplayStateLayer;
		private var intro:introAnimation;
		
		[Embed(source = "../../assets/audio/introAU.mp3")] 	// <-- this data..
		private const INTRO_AUDIO:Class;						// ..gets saved in this const
		private var introAudio:SoundObject;
		
		public function IntroScene(){
			super();
			this.m_controls = new EvertronControls(0);
		}
		
		override public function init():void{
			this.initLayer();
			this.initAnimation();
			this.initAudio();
		}
		
		private function initLayer():void{
			this.introLayer = this.layers.add("introLayer");
		}
		
		private function initAnimation():void{
			this.intro = new introAnimation();
			this.intro.gotoAndPlay(1);
			this.introLayer.addChild(this.intro);
		}
		
		private function initAudio():void{
			Session.sound.soundChannel.sources.add("introMusic", INTRO_AUDIO);
			this.introAudio = Session.sound.soundChannel.get("introMusic", true, true);
			this.introAudio.play();
		}
		
		override public function update():void{
			if(this.intro.currentFrame == this.intro.totalFrames ||
				Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)){
				Session.application.displayState = new Menu();
			}
		}
		
		
		override public function dispose():void{
			this.intro = null;
			this.m_controls = null;
			this.introAudio = null;
		}
	}
}