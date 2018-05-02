package  as3.game.gameobject.hazards{
	
	import as3.game.gameobject.GameObject;
	
	import assets.gameObjects.CannibalGFX;
	import assets.gameObjects.HazardArrow;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Strong;
	
	public class Arrow extends Hazard{
		
		private var arrow:HazardArrow;
		private var warningCannibal:CannibalGFX;
		private var target:GameObject;
		private var delay:int = 1500;		
		private var shootArrow:Boolean = false;
		private var fromRight:int = 0;
		
		[Embed(source = "../../../../../assets/audio/PlatBreakAU.mp3")] 
		private const ARROW_AUDIO:Class;
		
		private var arrowAudioSound:SoundObject;
		
		public function Arrow(target) {
			super();
			this.target = target;
			
			this.initArrow();
			this.initHitBox();
			this.initPosition();
			this.initAudio();
			addChild(this.warningCannibal);
			addChild(this.arrow);
			addChild(this.hitBox);
		}
		
		private function initHitBox():void{
		
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,0,10,10);
			//hitBox.graphics.endFill();
		
		}
		
		private function initArrow():void{
			this.arrow = new HazardArrow();
			this.warningCannibal = new CannibalGFX();
			this.arrow.scaleX = 0.5;
			this.arrow.scaleY = 0.5;
			
		}
		
		private function initPosition():void{
			this.fromRight = Math.round(Math.random());
			this.y = this.target.y + 10;
			if(this.fromRight == 0){
				this.scaleX = 1;
				this.x = 800;
			}else{
				this.scaleX = -1;
				this.x = 0;
			}
			this.warningCannibal.visible = true;
			
			this.moveWarningIn();
		}
		
		private function initAudio():void{
		
			Session.sound.soundChannel.sources.add("platformBreak", ARROW_AUDIO);
			this.arrowAudioSound = Session.sound.soundChannel.get("platformBreak", true, true);
		
		}
		
		override public function update():void{
			
			if(this.shootArrow == true && this.fromRight == 0)this.moveArrowLeft();
			if(this.shootArrow == true && this.fromRight == 1)this.moveArrowRight();
			
		}
		
		private function moveWarningIn():void{
			
			Session.tweener.add(this.warningCannibal, {
				x: -65,
				duration: 600,
				transition: Strong.easeIn,
				onComplete: setWarningTimeout
			});
			
		}
		
		private function setWarningTimeout():void{
		
			Session.timer.create(500, moveWarningOut);
		
		}
		
		private function moveWarningOut():void{
			
			Session.tweener.add(this.warningCannibal, {
				x: 0,
				duration: 600,
				transition: Strong.easeIn,
				onComplete: setBoolean
			});
			
		}
		
		private function setBoolean():void{
			//this.arrowAudioSound.play();
			this.shootArrow = true;
			this.warningCannibal.visible = false;
			
		}
			
		private function moveArrowLeft():void{
			
			this.x-=5;
			if(this.x  <= -40){
				resetArrow();
				}
		}
		
		private function moveArrowRight():void{
		
			this.x+=5;
			if(this.x >= 840){
				resetArrow();
			}
		}
		
		private function resetArrow():void{
		
			this.shootArrow = false;
			Session.timer.create(this.delay, initPosition);
			this.delay <= 1500 ? this.delay = 1500 : this.delay -= 1000;
			
		}
		
		override public function dispose():void{
		
			this.arrow = null;
			this.warningCannibal = null;
			this.target = null;
		
		}

	}
	
}
