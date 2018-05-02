package as3.game.gameHandler
{	
	import flash.geom.Rectangle;
	
	import as3.game.gameobject.GameObject;
	import as3.game.gameobject.platforms.LeftBase;
	import as3.game.gameobject.platforms.OriginalPlatform;
	import as3.game.gameobject.platforms.Platform;
	import as3.game.gameobject.platforms.RightBase;
	import as3.game.gameobject.platforms.WeakPlatform;
	
	import scene.Game;
	

	public class PlatformHandler{
		
		public var platformVector:Vector.<GameObject>;
		public var playerVector:Vector.<GameObject>;
		private var plat:OriginalPlatform;
		private var weakPlat:WeakPlatform;
		private var game:Game;
		private var rb:RightBase;
		private var lb:LeftBase;
		private var nrOfWeakPlatforms:int = 3;
		private var nrOfOriginalPlatforms:int = 8;
		private var tempPlatRect:Rectangle;
		private var benefitPosition:Boolean = false;
		
		private var platformPositions:Array = 	[[130,60],[130,160],[130,260],[130,360],[130,460],[130,560],[130,660],
												[250,60],[250,160],[250,260],[250,360],[250,460],[250,560],[250,660],
												[370,60],[370,160],[370,260],[370,360],[370,460],[370,560],[370,660],
												[490,60],[490,160],[490,260],[490,360],[490,460],[490,560],[490,660]];
		
		public function PlatformHandler(game, players){
			this.game = game;
			this.playerVector = players;
			this.platformVector = new Vector.<GameObject>;
			this.initPlatforms();
			this.initWeakplatforms();
			this.initIslands();
		}
		
		private function initPlatforms():void{
			for(var i: int = 0; i < this.nrOfOriginalPlatforms; i++){
				this.plat = new OriginalPlatform(this.getPlatformPosition(), this.returnPlatformPosition);
				this.game.gameLayer.addChild(this.plat);
				this.platformVector.push(this.plat);
				this.positionPlatform(this.plat);
			}
		}
		
		private function initWeakplatforms():void{
			for(var i:int = 0; i < this.nrOfWeakPlatforms; i++){
				this.weakPlat = new WeakPlatform(this.getPlatformPosition(), this.returnPlatformPosition);
				this.game.gameLayer.addChild(this.weakPlat);
				this.positionPlatform(this.weakPlat);
				this.platformVector.push(this.weakPlat);
			}
		}
		
		private function positionPlatform(obj:Platform):void{
			obj.x = obj.getX();
			obj.y = obj.getY();
		}
		
		private function getPlatformPosition():Array{
			
			return this.benefitPosition ? kindPosition() : meanPosition();
			
		}
		
		private function kindPosition():Array{
			this.benefitPosition = false;
			var pos:Array;
			for(var i:int = 0; i<this.platformPositions.length; i++){
				if(this.platformPositions[i][1] >= this.playerVector[0].x - 125 && 
					this.platformPositions[i][1] <= this.playerVector[0].x + 125 &&
					this.platformPositions[i][0] >= this.playerVector[0].y - 125 && 
					this.platformPositions[i][0] <= this.playerVector[0].y + 125){
					pos = this.platformPositions[i];
					this.platformPositions.splice(i,1);
					break;
				}
			}
			return pos == null ? meanPosition() : pos;
		}
		
		private function meanPosition():Array{
			this.benefitPosition = true;
			var pos:Array;
			
			for(var i:int = 0; i<this.platformPositions.length; i++){
				if(this.platformPositions[i][1] <= this.playerVector[0].x - 125 || 
					this.platformPositions[i][1] >= this.playerVector[0].x + 125 &&
					this.platformPositions[i][0] <= this.playerVector[0].y - 125 || 
					this.platformPositions[i][0] >= this.playerVector[0].y + 125){
					pos = this.platformPositions[i];
					this.platformPositions.splice(i,1);
					break;
				}
			}
			return pos;
		}
		
		private function returnPlatformPosition(plat:Platform):void{
			this.platformPositions.push(plat.pos);
			plat.setNewData(this.getPlatformPosition());
			this.positionPlatform(plat);
		}
		
		private function initIslands():void{
			this.initLeftIsland();
			this.initRightIsland();
		}
		
		private function initLeftIsland():void{
		
			var lbPos:Array = [550, 140];
			this.lb = new LeftBase(lbPos);
			this.game.gameLayer.addChild(this.lb);
			this.lb.x = this.lb.getX();
			this.lb.y = this.lb.getY();
			this.platformVector.push(this.lb);
		}
		
		private function initRightIsland():void{
		
			var rbPos:Array = [550, 450];
			this.rb = new RightBase(rbPos);
			this.game.gameLayer.addChild(this.rb);
			this.rb.x = this.rb.getX();
			this.rb.y = this.rb.getY();
			this.platformVector.push(this.rb);
		}
		
		public function update(player):void{
		
			this.m_updatePlatformCollission(player);
		
		}
		
		private function m_updatePlatformCollission(player):void{
			
			var a:Rectangle;
			//for(var j:int = 0; j<this.playerVector.length; j++){
				
				// If velocity is < 0, check against body hitbox (larger), else if going up in a jump(velocity > 0), check against foot hitbox
				player.velocity < 0 ? a = player.hitBox.getRect(this.game.gameLayer) : a = player.bottomHitBox.getRect(this.game.gameLayer);
				
				for(var i:int = 0; i<this.platformVector.length; i++){
					this.tempPlatRect = this.platformVector[i].hitBox.getRect(this.game.gameLayer);
					if(a.intersects(this.tempPlatRect)){
						this.platformCollission(this.platformVector[i], player);
						break;
					}//End if intersect
				}//End platformloop
			//}//End playerloop
		}//End function
		
		
		private function platformCollission(plat, player):void{
			if(player.falling && plat.exists){
				//
				if(plat is WeakPlatform){
					player.setCurrentPlat(plat);
					plat.removePlat();
				}else{
					player.setCurrentPlat(plat);
				}
			}
			
		}
		
		public function dispose():void{
		
			this.platformVector = null;
			this.playerVector = null;
			this.plat = null;
			this.weakPlat = null;
			this.game = null;
			this.rb = null;
			this.lb = null;
			this.tempPlatRect = null;
		
		}
		
	}
}