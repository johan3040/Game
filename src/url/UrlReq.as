package url{
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import se.lnu.stickossdk.system.Session;
	
	public class UrlReq{
		
		private var urlString:String;
		private var request:URLRequest;
		private var loader:URLLoader;
		
		private const TABLE:int = 1;
		private const RANGE:int = 10;
		
		private var score:int;
		
		public function UrlReq(score:int){
			this.score = score;
			this.checkIfHighscore();
		}
		
		private function checkIfHighscore():void{
			
			Session.highscore.smartSend(this.TABLE, this.score, this.RANGE, this.onComplete);
			
			/*this.urlString = "http://localhost/stickos/?method_id=1&game_id=42&limit=10";
			this.request = new URLRequest(this.urlString);
			this.loader = new URLLoader();
			this.loader.load(this.request);
			this.loader.addEventListener(Event.COMPLETE, this.handleData);*/
		}
		
		private function onComplete():void{
			
		}
		
		private function handleData(e:Event):void{
			//var data:Object = JSON.parse(this.loader.data);
			//trace(data);
		}
		
	}
}