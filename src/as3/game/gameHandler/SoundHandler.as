package as3.game.gameHandler{
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class SoundHandler{
		
		//------------------------------------------
		// Audio
		//------------------------------------------
		[Embed(source = "../../../../assets/audio/PDeathAU.mp3")] 	// <-- this data..
		private const GAME_OVER_AUDIO:Class;					// ..gets saved in this const
		protected var gameOverAudio:SoundObject;
		
		[Embed(source = "../../../../assets/audio/PowerupAU.mp3")] 	// <-- this data..
		private const POWER_UP_AUDIO:Class;						// ..gets saved in this const
		protected var powerUpAudio:SoundObject;
		
		[Embed(source = "../../../../assets/audio/gameMusicAU.mp3")] 	// <-- this data..
		private const GAME_MAIN_AUDIO:Class;					// ..gets saved in this const
		protected var mainAudio:SoundObject;
		
		[Embed(source = "../../../../assets/audio/winner.mp3")] 	// <-- this data..
		private const WINNER_AUDIO:Class;					// ..gets saved in this const
		protected var winnerAudio:SoundObject;
		
		[Embed(source = "../../../../assets/audio/PointAU.mp3")] 	// <-- this data..
		private const POINT_AUDIO:Class;						// ..gets saved in this const
		private var pointAudio:SoundObject;
		
		//
		// @param 1 = singleplayer mode, 2 = multiplayer mode
		//
		public function SoundHandler(mode:int){
			this.init();
			mode == 1 ? this.initSpAudio() : this.initMpAudio();
		}
		
		private function init():void{
			Session.sound.soundChannel.sources.add("powerUp", POWER_UP_AUDIO);
			this.powerUpAudio = Session.sound.soundChannel.get("powerUp", true, true);
			Session.sound.soundChannel.sources.add("main", GAME_MAIN_AUDIO);
			this.mainAudio = Session.sound.soundChannel.get("main", true, true);
		}
		
		
		private function initSpAudio():void{
			Session.sound.soundChannel.sources.add("gameOver", GAME_OVER_AUDIO);
			this.gameOverAudio = Session.sound.soundChannel.get("gameOver", true, true);
			Session.sound.soundChannel.sources.add("point", POINT_AUDIO);
			this.pointAudio = Session.sound.soundChannel.get("point", true, true);
		}
		
		private function initMpAudio():void{
			Session.sound.soundChannel.sources.add("winner", WINNER_AUDIO);
			this.winnerAudio = Session.sound.soundChannel.get("winner", true, true);
		}
		
		public function playMainAudio():void{
			//this.mainAudio.play(999);
		}
		
		public function lowerVolume():void{
			this.mainAudio.fade(0.3, 200, this.resetVolume);
		}
		
		private function resetVolume():void{
			this.mainAudio.fade(0.6, 700);
		}
		
		public function gameOverSp():void{
			this.stopAllAudio();
			this.gameOverAudio.play();
		}
		
		public function gameOverMp():void{
			this.stopAllAudio();
			this.winnerAudio.play();
		}
		
		public function gemCollission():void{
			this.lowerVolume();
			this.pointAudio.play();
		}
		
		public function powerUpCollission():void{
			this.lowerVolume();
			this.powerUpAudio.play();
		}
		
		private function stopAllAudio():void{
			this.mainAudio.stop();
		}
		
		public function dispose():void{
			this.gameOverAudio = 	null;
			this.powerUpAudio = 	null;
			this.mainAudio = 		null;
			this.pointAudio = 		null;
		}
		
	}
}