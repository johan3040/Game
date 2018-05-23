package as3.game.UI{
	
	import flash.display.Sprite;
	
	import as3.game.gameobject.player.Player;
	import as3.game.gameobject.powerups.PowerUp;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	public class PowerupMeter extends DisplayStateLayerSprite{
		
		private var meter:Sprite;
		private var timer:Timer;
		private var callback:Function;
		private var owner:Player;
		private var duration:Number;
		private var yPos:int;
		
		public function PowerupMeter(pw:PowerUp, callback:Function, player:Player){
			this.duration = pw.duration;
			this.callback = callback;
			this.owner = player;
			this.timer = Session.timer.create(pw.duration, this.removeGraphics, 0, true);
			this.x = -15;
			this.owner.powerupMeters.length < 1 ? this.y = -10 : this.y = -18;
			this.initMeter();
		}
		
		private function initMeter():void{
			this.meter = new Sprite();
			this.meter.graphics.beginFill(0xFFa500);
			this.meter.graphics.drawRect(0, 0, 30, 4);
			this.meter.graphics.lineStyle(2, 0x000000);
			this.meter.graphics.endFill();
			addChild(this.meter);
		}
		
		override public function update():void{
			var x:Number = 1 - (this.timer._activeTimeElapsed / this.duration);
			var y:Number = x*30;
			this.meter.graphics.beginFill(0xFFa500);
			this.meter.graphics.drawRect(0, 0, y, 4);
			this.meter.graphics.endFill();
		}
		
		public function setY():void{
			this.y = -10;
		}
		
		private function removeGraphics():void{
			this.callback(this);
		}
		
		override public function dispose():void{
			
		}
	}
}