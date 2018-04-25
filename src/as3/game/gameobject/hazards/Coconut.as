package as3.game.gameobject.hazards
{
	import as3.game.gameobject.GameObject;
	
	import assets.gameObjects.HazardCoconut;
	
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;

	public class Coconut extends Hazard{
		
		private var coconut:HazardCoconut;
		//private var callback:Function;
		private var target:GameObject;
		private var startSpeed:Number;
		private var dragForce:Number = 0.1;
		private var drop:Boolean;
		
		[Embed(source = "../../../../../assets/audio/CoconutDropAU.mp3")]
		private const COCO_AUDIO:Class;
		private var cocoAudioSound:SoundObject;
		
		public function Coconut(target){
			super();
			this.target = target;
			this.coconut = new HazardCoconut();
			this.initAudio();
			this.initCoconut();
		}
		
		private function initCoconut():void{
			this.coconut.gotoAndStop(2);
			this.coconut.scaleX = 0.8;
			this.coconut.scaleY = 0.8;
			this.startSpeed = 1;
			this.drop = true;
			this.setHitbox();
			this.setPosition();
			addChild(this.coconut);
			addChild(hitBox);
			//this.cocoAudioSound.play();
		}
		
		private function setHitbox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,0,28,25);
			//hitBox.graphics.endFill();
		}
		
		private function setPosition():void{
		
			var x_pos:int = Math.floor(Math.random()*99) + 1;
			x_pos *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
			this.x = this.target.x + x_pos;
			this.y = -20;
		
		}
		
		private function initAudio():void{
		
			Session.sound.soundChannel.sources.add("coconutFalling", COCO_AUDIO);
			this.cocoAudioSound = Session.sound.soundChannel.get("coconutFalling", true, true);
		
		}
		
		override public function update():void{
			if(this.drop) moveCoconut();
		}
		
		private function moveCoconut():void{
			this.y += this.startSpeed;
			this.startSpeed += this.dragForce;
			if(this.y > 600){
				//this.parent.removeChild(this);
				//this.coconut = null;
				//this.callback(this);
				this.drop = false;
				Session.timer.create(4000,initCoconut,0);
			}
		}
		
	}
}