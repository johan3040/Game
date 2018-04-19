package scene
{	
	
	import flash.geom.Rectangle;
	
	import as3.game.GameBoard;
	import as3.game.UI.GameBonusPoints;
	import as3.game.UI.GameTimer;
	import as3.game.UI.Hud;
	import as3.game.UI.Sidebar;
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.gems.Emerald;
	import as3.game.gameobject.gems.Gem;
	import as3.game.gameobject.gems.Ruby;
	import as3.game.gameobject.hazards.Arrow;
	import as3.game.gameobject.hazards.Coconut;
	import as3.game.gameobject.hazards.Hazard;
	import as3.game.gameobject.hazards.Wave;
	import as3.game.gameobject.platforms.Bungalow;
	import as3.game.gameobject.platforms.LeftBase;
	import as3.game.gameobject.platforms.OriginalPlatform;
	import as3.game.gameobject.platforms.RightBase;
	import as3.game.gameobject.platforms.WeakPlatform;
	import as3.game.gameobject.player.Cannibal;
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.system.Session;
	
	public class Game extends DisplayState{
		
		private var m_gameLayer:DisplayStateLayer;
		private var m_gameHudLayer:DisplayStateLayer;
		private var m_hud:Hud;
		private var m_gameTimer:GameTimer;
		private var m_gameBonusPoints:GameBonusPoints;
		private var gb:GameBoard;
		private var player1:Player;
		private var player2:Player;
		
		private var lb:LeftBase;
		private var rb:RightBase;
		private var ocean:Wave;
		private var lb_bungalow:Bungalow;
		
		private var plat:OriginalPlatform;
		private var weakPlat:WeakPlatform;
		private var playerVector:Vector.<GameObject>;
		private var arr:Arrow;
		private var coco:Coconut;
		private var gameObjectVec:Vector.<GameObject>;
		private var hazardVector:Vector.<GameObject>;
		private var collidableObjects:Vector.<GameObject>;
		private var platformVector:Vector.<GameObject>;
		private var tempPlatRect:Rectangle;
		private var tempHazardRect:Rectangle;
		
		private var gem_ruby:Ruby;
		private var gem_emerald:Emerald;
		
		public function Game(){
			super();
			this.gameObjectVec = new Vector.<GameObject>;
			this.playerVector = new Vector.<GameObject>;
			this.hazardVector = new Vector.<GameObject>;
			this.platformVector = new Vector.<GameObject>;
			this.collidableObjects = new Vector.<GameObject>;
			
		}
		
		override public function init():void{
			this.m_initLayer();
			this.initBackground();
			this.initIslands();
			this.initBungalows();
			this.initPlayer();
			//this.initPlayer2();
			this.initWaves();
			this.initPlatforms();
			this.initWeakplatforms();
			this.initArrow();
			this.initCoconut();
			Session.timer.create(1000, this.initArrow);
			this.initGems();
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
			this.player1 = new Explorer();
			this.player1.x = 160;
			this.player1.y = 520 - this.player1.height;
			this.m_gameLayer.addChild(this.player1);
			this.playerVector.push(this.player1);
		}
		
		private function initPlayer2():void{
			this.player2 = new Cannibal();
			this.player2.x = 100;
			this.player2.y = 600 - this.player2.height;
			this.m_gameLayer.addChild(this.player2);
			this.playerVector.push(this.player2);
		}
		
		private function initIslands():void{
		
			this.lb = new LeftBase();
			this.m_gameLayer.addChild(this.lb);
			this.lb.x = this.lb.getX();
			this.lb.y = this.lb.getY();
			this.rb = new RightBase();
			this.m_gameLayer.addChild(this.rb);
			this.rb.x = this.rb.getX();
			this.rb.y = this.rb.getY();
			this.platformVector.push(this.lb);
			this.platformVector.push(this.rb);
		}
		
		private function initBungalows():void{
		
			this.lb_bungalow = new Bungalow();
			this.lb_bungalow.x = 240;
			this.lb_bungalow.y = 530;
			this.platformVector.push(this.lb_bungalow);
			this.m_gameLayer.addChild(this.lb_bungalow);
		
		}
		
		private function initWaves():void{
		
			this.ocean = new Wave();
			this.ocean.x = 0;
			this.ocean.y = 600;
			this.m_gameLayer.addChild(this.ocean);
			this.hazardVector.push(this.ocean);
			this.collidableObjects.push(this.ocean);
		}
		
		private function initPlatforms():void{
			for(var i: int = 0; i<10; i++){
				this.plat = new OriginalPlatform(this.positionPlatform);
				this.m_gameLayer.addChildAt(this.plat,1);
				this.positionPlatform(this.plat);
				this.gameObjectVec.push(this.plat);
				this.platformVector.push(this.plat);
				
			}
		}
		
		private function initWeakplatforms():void{
			this.weakPlat = new WeakPlatform(this.positionWeakPlatform);
			this.m_gameLayer.addChild(this.weakPlat);
			this.platformVector.push(this.weakPlat);
			
		}
		
		private function initArrow():void{
			var target:GameObject = getPlayerAsTarget();
			this.arr = new Arrow(this.removeFromVector, target);
			this.m_gameLayer.addChild(this.arr);
			this.gameObjectVec.push(this.arr);
			this.hazardVector.push(this.arr);
			this.collidableObjects.push(this.arr);
			
		}
		
		private function initCoconut():void{
			var target:GameObject = getPlayerAsTarget();
			this.coco = new Coconut(this.removeFromVector, target);
			this.m_gameLayer.addChild(this.coco);
			this.gameObjectVec.push(this.coco);
			this.hazardVector.push(this.coco);
			this.collidableObjects.push(this.coco);
		}
		
		private function initGems():void{
			this.initRuby();
			this.initSapphire();
		
		}
		
		private function initRuby():void{
		
			this.gem_ruby = new Ruby();
			this.gem_ruby.x = this.gem_ruby.getX();
			this.gem_ruby.y = this.gem_ruby.getY();
			this.m_gameLayer.addChild(this.gem_ruby);
			this.hazardVector.push(this.gem_ruby);
			this.collidableObjects.push(this.gem_ruby);
		}
		
		private function initSapphire():void{
		
			this.gem_emerald = new Emerald();
			this.gem_emerald.x = this.gem_emerald.getX();
			this.gem_emerald.y = this.gem_emerald.getY();
			this.m_gameLayer.addChild(this.gem_emerald);
			this.hazardVector.push(this.gem_emerald);
			this.collidableObjects.push(this.gem_emerald);
		}
		
		private function initHud():void{
			
			this.initSidebars();
			this.initGameTimer();
			this.initGameBonusPoints();
		}
		
		private function initSidebars():void{
		
			var leftSidebar:Sidebar = new Sidebar();
			var rightSidebar:Sidebar = new Sidebar();
			rightSidebar.scaleX = -1;
			rightSidebar.x = 800 - rightSidebar.width;
			this.m_gameHudLayer.addChild(leftSidebar);
			this.m_gameHudLayer.addChild(rightSidebar);
		
		}
		
		private function initGameTimer():void{
		
			this.m_gameTimer = new GameTimer();
			this.m_gameHudLayer.addChild(this.m_gameTimer);
		
		}
		
		private function initGameBonusPoints():void{
		
			this.m_gameBonusPoints = new GameBonusPoints(this.player1);
			this.m_gameHudLayer.addChild(this.m_gameBonusPoints);
			
		}
		
		private function positionPlatform(obj:OriginalPlatform):void{
			obj.x = obj.getX();
			obj.y = obj.getY();
			var a:Rectangle = obj.getRect(Session.application.stage);
			for(var i:int = 0; i<this.platformVector.length; i++){
				if(this.platformVector.indexOf(obj) === i) continue;
				var b:Rectangle = this.platformVector[i].getRect(Session.application.stage);
				if(a.intersects(b)) {
					obj.immidiateReposition();
					break;
				}
			}
		}
		
		private function positionWeakPlatform(obj:WeakPlatform):void{
			obj.x = obj.getX();
			obj.y = obj.getY();
			var a:Rectangle = obj.getRect(Session.application.stage);
			for(var i:int = 0; i<this.platformVector.length; i++){
				if(this.platformVector.indexOf(obj) === i) continue;
				var b:Rectangle = this.platformVector[i].getRect(Session.application.stage);
				if(a.intersects(b)) {
					obj.immidiateReposition();
					break;
				}
			}
		}
		
		private function getPlayerAsTarget():GameObject{
			return this.playerVector[0];
		}
		
		override public function update():void{
			m_updateCollission();
			m_updatePlatformCollission();
		}
		
		private function m_updateCollission():void{
			
			for(var j:int = 0; j<this.playerVector.length; j++){
				var a:Rectangle = this.playerVector[j].hitBox.getRect(this.m_gameLayer);
				
				for(var i:int = 0; i<this.collidableObjects.length; i++){
					
					this.tempHazardRect = collidableObjects[i].hitBox.getRect(this.m_gameLayer);
					
					if(a.intersects(this.tempHazardRect)){
						if(this.collidableObjects[i] is Hazard){
							this.hazardCollission(this.playerVector[j], this.collidableObjects[i]);
							break;
						}
						if(this.collidableObjects[i] is Gem){
							this.gemCollission(this.playerVector[j], this.collidableObjects[i]);
							break;
						}
						
					}//End if intersect
				}//End hazardloop
			}//End playerloop
		}//End function
		
		private function hazardCollission(player, hazard):void{
		
			//
		
		}
		
		private function gemCollission(player, gem):void{
		
			player.setBonusPoints(gem.value);
			this.m_gameBonusPoints.setVisibleBonusPoints(gem.value);
			gem.remove();
			this.collidableObjects.splice(this.collidableObjects.indexOf(gem),1);
		
		}
		
		private function m_updatePlatformCollission():void{
			
			var a:Rectangle;
			
			for(var j:int = 0; j<this.playerVector.length; j++){
				
				// If velocity is < 0, check against body hitbox (larger), else if going up in a jump(velocity > 0), check against foot hitbox
				this.playerVector[j].velocity < 0 ? a = this.playerVector[j].hitBox.getRect(this.m_gameLayer) : a = this.playerVector[j].bottomHitBox.getRect(this.m_gameLayer);
				
				for(var i:int = 0; i<this.platformVector.length; i++){
					this.tempPlatRect = platformVector[i].hitBox.getRect(this.m_gameLayer);
					if(a.intersects(this.tempPlatRect)){
						this.platformCollission(this.platformVector[i], this.playerVector[j]);
						break;
					}//End if intersect
				}//End platformloop
			}//End playerloop
		}//End function

		
		private function platformCollission(plat, player):void{
			if(player.falling && plat.exists){
				//
				if(plat is WeakPlatform){
					player.setCurrentPlat(plat);
					plat.removePlat(this.removeFromVector);
				}else{
					player.setCurrentPlat(plat);
				}
			}
			
		}
		
		private function removeFromVector(obj:GameObject):void{
			//var index:int = platformVector.indexOf(obj);
			//this.platformVector.splice(index, 1);
		}
		
		
	}
}