package as3.game.gameHandler
{
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.hazards.Arrow;
	import as3.game.gameobject.hazards.Coconut;
	import as3.game.gameobject.hazards.Wave;
	
	import scene.Game;
	import se.lnu.stickossdk.system.Session;
	
	public class HazardHandler{
		
		private var game:Game;
		private var ocean:Wave;
		private var arr:Arrow;
		private var coco:Coconut;
		
		public function HazardHandler(game){
			super();
			this.game = game;
			this.init();
		}
		
		private function init():void{
		
			// Inithazards
			this.initWave();
			this.initCoconut();
			//Session.timer.create(10000, this.initCoconut);
			this.initArrow();
			//Session.timer.create(5000, this.initArrow);
			//Session.timer.create(10000, this.initArrow);
			
		}
		
		private function initWave():void{
			this.ocean = new Wave();
			this.ocean.x = 0;
			this.ocean.y = 600;
			this.game.gameLayer.addChild(this.ocean);
			this.game.hazardVector.push(this.ocean);
			this.game.collidableObjects.push(this.ocean);
		}
		
		private function initArrow():void{
			this.arr = new Arrow(getPlayerAsTarget());
			this.game.gameLayer.addChild(this.arr);
			this.game.hazardVector.push(this.arr);
			this.game.collidableObjects.push(this.arr);
			
		}
		
		private function initCoconut():void{
			this.coco = new Coconut(getPlayerAsTarget());
			this.game.gameLayer.addChild(this.coco);
			this.game.hazardVector.push(this.coco);
			this.game.collidableObjects.push(this.coco);
		}
		
		private function getPlayerAsTarget():GameObject{
			return this.game.playerVector.length == 1 ? this.game.playerVector[0] : this.game.playerVector[Math.round(Math.random())];
			
		}
		
		public function dispose():void{
		
			this.game = null;
			this.ocean = null;
			this.arr = null;
			this.coco = null;
		
		}
	}
}