package as3.game.gameHandler
{
	
	import as3.game.gameobject.hazards.Arrow;
	import as3.game.gameobject.hazards.Coconut;
	import as3.game.gameobject.hazards.Hazard;
	import as3.game.gameobject.hazards.Wave;
	import as3.game.gameobject.player.Player;
	
	import scene.Game;
	
	import se.lnu.stickossdk.system.Session;
	
	public class HazardHandler{
		
		private var game:Game;
		private var ocean:Wave;
		private var arr:Arrow;
		private var coco:Coconut;
		private var hazards:Vector.<Hazard>;
		
		/**
		 * 
		 * Constructor
		 * 
		 * @param Game
		 * 
		 */
		public function HazardHandler(game:Game){
			super();
			this.game = game;
			this.hazards = new Vector.<Hazard>();
			this.init();
		}
		
		private function init():void{
		
			// Inithazards
			this.initWave();
			Session.timer.create(3000, this.initCoconut);
			Session.timer.create(15000, this.initCoconut);
			Session.timer.create(6000, this.initArrow);
			Session.timer.create(15000, this.initArrow);
			Session.timer.create(20000, this.initArrow);
			
		}
		
		private function initWave():void{
			this.ocean = new Wave();
			this.ocean.x = 0;
			this.ocean.y = 600;
			this.game.gameLayer.addChild(this.ocean);
			this.game.hazardVector.push(this.ocean);
			this.game.collidableObjects.push(this.ocean);
			this.hazards.push(this.ocean);
		}
		
		private function initArrow():void{
			this.arr = new Arrow(this.getPlayerAsTarget());
			this.game.gameLayer.addChild(this.arr);
			this.game.hazardVector.push(this.arr);
			this.game.collidableObjects.push(this.arr);
			this.hazards.push(this.arr);
		}
		
		private function initCoconut():void{
			this.coco = new Coconut(getPlayerAsTarget());
			this.game.gameLayer.addChild(this.coco);
			this.game.hazardVector.push(this.coco);
			this.game.collidableObjects.push(this.coco);
			this.hazards.push(this.coco);
		}
		
		private function getPlayerAsTarget():Player{
			return this.game.playerVector[0];
			
		}
		
		public function dispose():void{
		
			this.game = null;
			this.ocean = null;
			this.arr = null;
			this.coco = null;
		
		}
	}
}