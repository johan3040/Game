package as3.game
{	
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.util.URLUtils;

	public class GetHighscore extends DisplayState
	{
		
		private var hl_names:Array;
		private var hl_scores:Array;
		private var hl_position:Array;
		public var highscoreScores:String;
		public var highscoreNames:String;
		public var highscorePositions:String;
		private var HighscoreData:XML;
		private var callback:Function;
		
		
		public function GetHighscore(callback:Function){
			super();
			this.callback = callback;
			this.GetHighscoreData();
		}
		
		public function GetHighscoreData():void
		{
			Session.highscore.receive(1, 10, function(data:XML):void{CreateHighscoreArray(data)});
			
		}
		
		private function CreateHighscoreArray(data:XML):void
		{
			HighscoreData = data;
			
			this.hl_names = new Array;
			this.hl_scores = new Array;
			this.hl_position = new Array;
			
			for (var i:int = 0; i < data.items.item.length(); i++) {
				hl_position[i] = i + 1;
			}
			
			for (var e:int = 0; e < data.items.item.length(); e++) {
				hl_names[e] = URLUtils.decode(data.items.item[e].name);
			}
			
			for (var o:int = 0; o < data.items.item.length(); o++) {
				hl_scores[o] = data.items.item[o].score;
			}
			
			HighscoreToString();
			
		}
		
		private function HighscoreToString():void
		{
			
			this.highscoreScores = new String;
			this.highscoreNames = new String;
			this.highscorePositions = new String;			
			
			for (var i:int = 0; i < hl_position.length; i++) {
				highscorePositions += hl_position[i] + "." + "\n";
			}
			
			for (var e:int = 0; e < hl_names.length; e++) {
				highscoreNames += hl_names[e] + "\n";
			}
			
			for (var o:int = 0; o < hl_position.length; o++) {
				highscoreScores += hl_scores[o] + "\n";
			}
			
			this.callback();
		}
		
		override public function dispose():void{
			this.hl_names = null;
			this.hl_scores = null;
			this.hl_position = null;
			this.highscoreScores = null;
			this.highscoreNames = null;
			this.highscorePositions = null;
			this.HighscoreData = null;
			this.callback = null;
		}
	}
}