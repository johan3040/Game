package  as3.game.gameobject.platforms{
	
	
	import assets.gameObjects.WeakPlatGFX;
	
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	
	public class WeakPlatform extends Platform{
		
		private var platform:WeakPlatGFX;
		private var callback:Function; // Callback method to reposition method in Main
		private var removeCallback:Function;
		
		[Embed(source = "../../../../../assets/audio/PlatBreakAU.mp3")]
		private const BREAK_AUDIO:Class;
		private var breakAudioSound:SoundObject;
		
		public function WeakPlatform(pos:Array, callback:Function) {
			super(pos);
			this.callback = callback;
			this.pos = pos;
			this.initWeakPlat();
			this.initAudio();
			
		}
		
		private function initWeakPlat():void{
			this.platform = new WeakPlatGFX();
			this.platform.gotoAndStop(1);
			this.setHitbox();
			
			obj_width = this.platform.width;
			obj_height = this.platform.height;
			
			addChild(this.platform);
			addChild(hitBox);
			this.callback(this);
			}
		
		private function setHitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0, 1, 70, 6);
			//hitBox.graphics.endFill();
		}
		
		private function initAudio():void{
		
			Session.sound.soundChannel.sources.add("platformBreak", BREAK_AUDIO);
			this.breakAudioSound = Session.sound.soundChannel.get("platformBreak", true, true);
			
		}
			
		public function removePlat():void{
			this.breakAudioSound.play();
			//removeCallback(this);
			this.exists = false;
			this.platform.gotoAndPlay(2);
			}
		
		override public function update():void{
		
			if(this.platform.currentFrame == this.platform.totalFrames){
				this.platform.visible = false;
				reSpawn();
			} 
		}
		
		private function reSpawn():void{
			this.platform.gotoAndStop(1);
			this.callback(this);
			this.exists = true;
			this.platform.visible = true;
		
		}
		
		override public function dispose():void{
		
			this.platform = null;
			this.callback = null;
			this.removeCallback = null;
			this.breakAudioSound = null;
		
		}

	}
	
}
