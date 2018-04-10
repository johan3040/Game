package scene
{	
	import flash.geom.Rectangle;
	import flash.utils.setInterval;
	
	import as3.game.GameBoard;
	import as3.game.UI.Hud;
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.hazards.Arrow;
	import as3.game.gameobject.hazards.Coconut;
	import as3.game.gameobject.platforms.OriginalPlatform;
	import as3.game.gameobject.platforms.Platform;
	import as3.game.gameobject.player.Cannibal;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.system.Session;

	//import se.lnu.stickossdk.display.DisplayStateLayers;
	
	public class Game extends DisplayState{
		
		private var m_gameLayer:DisplayStateLayer;
		private var m_gameHudLayer:DisplayStateLayer;
		private var gb:GameBoard;
		private var m_hud:Hud;
		private var gameHud:Hud;
		private var player1:Player;
		private var player2:Player;
		private var plat:OriginalPlatform;
		private var pv:Vector.<Platform>;
		private var playerVector:Vector.<GameObject>;
		private var arr:Arrow;
		private var coco:Coconut;
		
		private var gameObjectVec:Vector.<GameObject>;
		
		public function Game(){
			super();
			this.pv = new Vector.<Platform>();
			this.gameObjectVec = new Vector.<GameObject>;
			this.playerVector = new Vector.<GameObject>;
		}
		
		override public function init():void{
			this.m_initLayer();
			this.initBackground();
			this.initPlayer();
			//this.initPlayer2();
			this.initPlatforms();
			//var x:uint = setInterval(this.initArrow, 1000);
			this.initArrow();
			var x:uint = setInterval(this.initCoconut, 1000);
			this.initHud();
		}
		
		private function m_initLayer():void{
			this.m_gameLayer = this.layers.add("game");
			this.m_gameHudLayer = this.layers.add("HUD");
		}
		
		private function initBackground():void{
			this.gb = new GameBoard();
			//this.m_gameLayer = this.layers.add("gameBackground");
			this.m_gameLayer.addChild(this.gb);
		}
		
		private function initPlayer():void{
			this.player1 = new Explorer(this.pv);
			this.player1.x = 0;
			this.player1.y = 600 - this.player1.height;
			this.m_gameLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		private function initPlayer2():void{
			this.player2 = new Cannibal(this.pv);
			this.player2.x = 100;
			this.player2.y = 600 - this.player2.height;
			this.m_gameLayer.addChild(this.player2);
		}
		
		private function initPlatforms():void{
			for(var i: int = 0; i<8; i++){
				this.plat = new OriginalPlatform(this.positionPlatform);
				this.m_gameLayer.addChildAt(this.plat,1);
				this.positionPlatform(this.plat);
				this.pv.push(this.plat);
				this.gameObjectVec.push(this.plat);
			}
		}
		
		private function positionPlatform(obj:Platform):void{
			obj.x = obj.getX();
			obj.y = obj.getY();
		}
		
		
		private function initArrow():void{
			var target:GameObject = getPlayerAsTarget();
			this.arr = new Arrow(this.removeFromVector, target);
			this.m_gameLayer.addChild(this.arr);
			this.gameObjectVec.push(this.arr);
		}
		
		private function initCoconut():void{
			var target:GameObject = getPlayerAsTarget();
			this.coco = new Coconut(this.removeFromVector, target);
			this.m_gameLayer.addChild(this.coco);
			this.gameObjectVec.push(this.coco);
		}
		
		private function getPlayerAsTarget():GameObject{
			if(this.playerVector.length === 1) return this.playerVector[0];
			return this.playerVector(Math.floor(Math.random()*this.playerVector.length) +1);
		}
		
		
		private function initHud():void{
			this.m_hud = new Hud();
			this.m_gameHudLayer.addChild(this.m_hud);
		}
		
		override public function update():void{
			m_updateCollission();
		}
		
		private function m_updateCollission():void{
			
			var a:Rectangle = this.player1.hitBox.getRect(Session.application.stage);
			
			for(var i:int = 0; i<this.gameObjectVec.length; i++){
				
				var b:Rectangle = gameObjectVec[i].hitBox.getRect(Session.application.stage);
				
				if(a.intersects(b)){
					if(gameObjectVec[i] is Platform){
						gameObjectVec[i] is OriginalPlatform ? player1.setCurrentPlat(gameObjectVec[i]) : trace ("not OG");
					}
					if(gameObjectVec[i].lethal == true){
						trace("game over");
					}
				}
				
			}
		}
		
		private function removeFromVector(obj:GameObject):void{
			trace(gameObjectVec.indexOf(obj));
			var index:int = gameObjectVec.indexOf(obj);
			this.gameObjectVec.splice(index, 1);
		}
		
		
	}
}