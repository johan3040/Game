package
{
	
	import se.lnu.stickossdk.system.Engine;
	import scene.Intro;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	
	public class Main extends Engine{
		public function Main(){
			
		}
		
	override public function setup():void{
		this.initId = 42;
		this.initBackgroundColor = 0x000000;
		this.initDebugger = true;
		this.initDisplayState = Intro;
	}
	}
}