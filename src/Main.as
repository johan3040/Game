package
{
	
	import scene.IntroScene;
	
	import se.lnu.stickossdk.system.Engine;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#000000")]
	
	public class Main extends Engine{
		public function Main(){
			
		}
		
	override public function setup():void{
		this.initId = 42;
		this.initBackgroundColor = 0x000000;
		this.initDebugger = false;
		this.initDisplayState = IntroScene;
		//this.initExternalDatabaseLocation = "http://cactuar.lnu.se/lab/stickos";
	}
	}
}