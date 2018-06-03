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
		
		//Hämtar och läser av highscore informationen från databasen
		//Skickar in denna data i createHighscoreArray när detta är klart
		public function GetHighscoreData():void
		{
			Session.highscore.receive(1, 10, function(data:XML):void{CreateHighscoreArray(data)});
			
		}
		
		//Skapar 3 arrays. 1 för antal positioner som är i highscorelistan
		//1 med alla namn från högsta till lägsta
		//1 med alla poäng från högsta till lägsta
		//Kallar på highscoreToString när detta är klart
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
		
		//Konverterar position, namn och poäng arrays till strängar för att senare kunna placera ut dem
		//I textfält när den återvänder till antingen gameover eller highscore skärmarna
		private function HighscoreToString():void
		{
			
			this.highscoreScores = new String;
			this.highscoreNames = new String;
			this.highscorePositions = new String;			
			
			//Lägger till så den bryter till en ny rad efter varje punkt i arrayen
			//Detta är för att highscore placeras ut i 3 separata vertikala textfält i gameover och highscore
			//En för position, en för namn, och en för poäng
			for (var i:int = 0; i < hl_position.length; i++) {
				highscorePositions += hl_position[i] + "." + "\n";
			}
			
			for (var e:int = 0; e < hl_names.length; e++) {
				highscoreNames += hl_names[e] + "\n";
			}
			
			for (var o:int = 0; o < hl_position.length; o++) {
				highscoreScores += hl_scores[o] + "\n";
			}
			
			//Gör en callback till den funktion som specificerades när denna klass kallades på från början,
			//i gameover är denna recieveHighscore och i Highscore är det recieveHighscoreInfo
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