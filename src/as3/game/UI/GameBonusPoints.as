package as3.game.UI{
	
	import flash.text.TextField;
	
	import as3.game.gameobject.player.Player;
	
	import se.lnu.stickossdk.system.Session;
	
	
	public class GameBonusPoints extends Hud{
		
		private var player:Player;
		private var m_bonusText:TextField;
		private var m_bonusPoints:int = 0;
		private var inComingPoints:int;
		
		public function GameBonusPoints(player:Player){
			super();
			this.player = player;
		}
		
		override public function init():void{
		
			this.m_bonusText = new TextField();
			this.m_bonusText.width = 100;
			this.m_bonusText.height = 30;
			this.m_bonusText.text = m_bonusPoints.toString();
			this.x = 100;
			this.y = 30;
			this.m_bonusText.setTextFormat(this.m_textFormat);
			addChild(this.m_bonusText);
		
		}
		
		//
		// Om det kommer in nya poäng innan räknaren är klar så fuckas allt upp
		//
		
		public function setVisibleBonusPoints(points:int):void{
			
			this.inComingPoints = points;
			if(this.m_bonusPoints != this.m_bonusPoints + this.inComingPoints){
				Session.timer.create(5, addPoints);
			}
			this.m_bonusText.text = m_bonusPoints.toString();
			this.m_bonusText.setTextFormat(this.m_textFormat);
		}
		
		private function addPoints():void{
		
			this.m_bonusPoints+=10;
			this.inComingPoints-=10;
			this.setVisibleBonusPoints(this.inComingPoints);
			
		}
		
		
	}
}