package as3.game.gameobject.hazards{
	
	import assets.gameObjects.ocean;
	
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Sine;
	
	public class Wave extends Hazard{
		
		private var hazard_ocean:ocean;
		private var tideWaveDelay:int = 8000;
		private var duration:int = 2000;
		private var transStartY:int = 610;
		private var transEndY:int = 600;
		// Audio
		[Embed(source = "../../../../../assets/audio/wave.mp3")] 	// <-- this data..
		private const WAVE_AUDIO:Class;						// ..gets saved in this const
		private var waveAudio:SoundObject;
		
		public function Wave(){
			
			super();
			this.y = 610;
			this.alpha = 0.7;
			this.initWave();
			this.initAudio();
			
		}
		
		private function initWave():void{
			
			this.hazard_ocean = new ocean();
			this.initHitBox();
			addChild(this.hazard_ocean);
			addChild(hitBox);
			goTween();
			this.setDelay(4000);
			
		}
		
		private function initAudio():void{
			Session.sound.soundChannel.sources.add("waveAudio", WAVE_AUDIO);
			this.waveAudio = Session.sound.soundChannel.get("waveAudio", true, true);
		}
		
		private function initHitBox():void{
			hitBox.graphics.drawRect(0, -15, 800, 100);
		}
		
		private function setDelay(delay:int):void{
			Session.timer.create(delay, startTideWave);
		}
		
		
		private function goTween():void{
			
			var targetY:int = 0;
			
			if(this.y != this.transStartY) targetY = this.transStartY;
			else{ targetY = this.transEndY};
			
			Session.tweener.add(this, {
				y: targetY,
				duration: this.duration,
				transition: Sine.easeInOut,
				onComplete: goTween
			});
		
		}
		
		private function startTideWave():void{
			
			this.transStartY = 620;
			this.transEndY = 610;
			Session.timer.create(3000, goTideWave);
		}
		
		private function goTideWave():void{
			this.waveAudio.play();
			this.waveAudio.volume = 0.8;
			this.transStartY = 560;
			this.transEndY = 550;
			Session.timer.create(4000, waveDrawback);
			
		}
		
		private function waveDrawback():void{
			this.transStartY = 610;
			this.transEndY = 600;
			this.setDelay(10000);
		}
		
		override public function dispose():void{
		
			this.hazard_ocean = null;
			hitBox = null;
		
		}
		
	}
}