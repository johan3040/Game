package as3.game.gameobject.hazards
{
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.FallingLeaf;
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
		private var warningLeaf:FallingLeaf;
		
		[Embed(source = "../../../../../assets/audio/CoconutDropAU.mp3")]
		private const COCO_AUDIO:Class;
		private var cocoAudio:SoundObject;
		
		public function Coconut(target:Player){
			super();
			this.target = target;
			//this.setPosition();
			this.initCoconut();
			this.initHitBox();
			this.initWarning();
			this.initAudio();
			
			this.goWarning();
			//this.setMeta();
		}
		
		private function initCoconut():void{
			this.coconut = new HazardCoconut();
			this.coconut.gotoAndStop(2);
			this.coconut.scaleX = 0.8;
			this.coconut.scaleY = 0.8;
			addChild(this.coconut);
			//this.setPosition();			
			//this.cocoAudioSound.play();
		}
		
		private function initHitBox():void{
			//hitBox.graphics.beginFill(0x00FF00);
			hitBox.graphics.drawRect(0,0,28,25);
			//hitBox.graphics.endFill();
			addChild(hitBox);
		}
		
		private function initWarning():void{
			this.warningLeaf = new FallingLeaf();
			addChild(this.warningLeaf);
		}
		
		private function setPosition():void{
		
			var x_pos:int = Math.floor(Math.random()*99) + 1;
			x_pos *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
			this.x = this.target.x + x_pos;
			this.y = 0;
		
		}
		
		private function setMeta():void{			
			this.startSpeed = 1;
			this.drop = true;
		}
		
		private function initAudio():void{
		
			Session.sound.soundChannel.sources.add("coconutFalling", COCO_AUDIO);
			this.cocoAudio = Session.sound.soundChannel.get("coconutFalling", true, true);
		
		}
		
		override public function update():void{
			if(this.warningLeaf.currentFrame == this.warningLeaf.totalFrames) this.prepareFallingCoco();
			if(this.drop) moveCoconut();
		}
		
		private function goWarning():void{
			this.setPosition();
			this.lethal = false;
			this.warningLeaf.visible = true;
			this.coconut.visible = false;
			this.warningLeaf.play();
			
		}
		
		private function prepareFallingCoco():void{
			this.warningLeaf.gotoAndStop(1);
			this.lethal = true;
			this.warningLeaf.visible = false;
			this.coconut.visible = true;
			this.startSpeed = 1;
			this.drop = true;
		}
		
		private function moveCoconut():void{
			this.y += this.startSpeed;
			this.startSpeed += this.dragForce;
			if(this.y > 600){
				this.drop = false;
				Session.timer.create(1000,goWarning,0);
			}
		}
		
		override public function dispose():void{
			this.coconut = null;
			this.target = null;
			this.cocoAudio = null;
			this.warningLeaf = null;
		}
		
	}
}