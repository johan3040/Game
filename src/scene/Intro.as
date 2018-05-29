package scene
{
	import assets.gameObjects.introAnimation;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;

	public class Intro extends DisplayState
	{
		
		private var in_controls:EvertronControls;
		private var in_Layer:DisplayStateLayer;
		private var in_animation:introAnimation;
		
		private var introTimer:Timer;
		
		[Embed(source = "../../assets/audio/introAU.mp3")] 	// <-- this data..
		private const IN_MAIN_AUDIO:Class;					// ..gets saved in this const
		private var inAudio:SoundObject;
		
		public function Intro()
		{
			super();
			this.in_controls = new EvertronControls(0);
		}
		
		override public function init():void{
			this.initLayers();
			this.initAnimationAudio();
			this.initAnimation();
			
			this.introTimer = Session.timer.create(8000, initMenu);
		}
		
		private function initLayers():void
		{
			this.in_Layer = this.layers.add("Intro");
			
		}
		
		private function initAnimation():void
		{
			this.in_animation = new introAnimation;
			
			in_animation.x = 0;
			in_animation.y = 0;
			
			this.in_Layer.addChild(this.in_animation);
		}
		
		private function initAnimationAudio():void
		{
			Session.sound.soundChannel.sources.add("IN_MAIN", IN_MAIN_AUDIO);
			this.inAudio = Session.sound.soundChannel.get("IN_MAIN", true, true);
			
			this.inAudio.play(1);
			this.inAudio.volume = 0.6;
		}
		
		private function initMenu():void {
			Session.application.displayState = new Menu;
		}
	}
}