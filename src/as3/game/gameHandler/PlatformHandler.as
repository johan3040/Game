package as3.game.gameHandler
{	
	import flash.geom.Rectangle;
	
	import as3.game.gameobject.platforms.LeftBase;
	import as3.game.gameobject.platforms.MpGround;
	import as3.game.gameobject.platforms.MpPlatform;
	import as3.game.gameobject.platforms.OriginalPlatform;
	import as3.game.gameobject.platforms.Platform;
	import as3.game.gameobject.platforms.RightBase;
	import as3.game.gameobject.platforms.SpPlatform;
	import as3.game.gameobject.platforms.WeakPlatform;
	import as3.game.gameobject.player.Player;
	
	import scene.Game;
	

	public class PlatformHandler{
		
		public var platformVector:Vector.<Platform>;
		public var playerVector:Vector.<Player>;
		private var plat:OriginalPlatform;
		private var weakPlat:WeakPlatform;
		private var game:Game;
		private var rb:RightBase;
		private var lb:LeftBase;
		private var ground:MpGround;
		private var nrOfWeakPlatforms:int = 3;
		private var nrOfOriginalPlatforms:int = 8;
		private var nrOfMpPlatforms:int = 11;
		private var tempPlatRect:Rectangle;
		private var benefitPosition:Boolean = false;
		
		private var platformPositions:Array = 	[[130,60],[130,160],[130,260],[130,360],[130,460],[130,560],[130,660],
												[250,60],[250,160],[250,260],[250,360],[250,460],[250,560],[250,660],
												[370,60],[370,160],[370,260],[370,360],[370,460],[370,560],[370,660],
												[490,60],[490,160],[490,260],[490,360],[490,460],[490,560],[490,660]];
		
		private var mpPlatformPositions:Array = [[130,260],[130,360],[130,660],
												[250,60],[250,460],[250,660],
												[370,60],[370,360],[370,660],
												[490,60],[490,660]];
		
		private var mpPlatformPositions2:Array = 	[[130,60],[130,360],[130,660],
													[250,60],[250,460],[250,660],
													[370,60],[370,260],[370,660],
													[490,160],[490,560]];
		
		private var mpPlatformPositions3:Array = 	[[130,60],[130,260],[130,560],
													[250,160],[250,460],[250,660],
													[370,60],[370,160],[370,560],
													[490,60],[490,560]];
		
		public function PlatformHandler(game, players){
			this.game = game;
			this.playerVector = players;
			this.platformVector = new Vector.<Platform>;
			this.playerVector.length == 1 ? this.initSpPlatforms() : this.initMpPlatforms();
			
		}
		
		private function initSpPlatforms():void{
			this.createSpPlatforms();
			this.createSpWeakplatforms();
			this.initIslands();
		}
		
		private function initMpPlatforms():void{
			this.createMpPlatforms();
			this.initGround();
			//this.initIslands();
		}
		
		private function createSpPlatforms():void{
			for(var i: int = 0; i < this.nrOfOriginalPlatforms; i++){
				this.plat = new SpPlatform(this.platformPosition, this.returnPlatformPosition);
				this.addToLayerAndVector(this.plat);
			}
		}
		
		private function createSpWeakplatforms():void{
			for(var i:int = 0; i < this.nrOfWeakPlatforms; i++){
				this.weakPlat = new WeakPlatform(this.platformPosition, this.returnPlatformPosition);
				this.addToLayerAndVector(this.weakPlat);
			}
		}
		
		private function createMpPlatforms():void{
			for(var i: int = 0; i < this.nrOfMpPlatforms; i++){
				this.plat = new MpPlatform(this.getMpPlatformPosition(i));
				this.addToLayerAndVector(this.plat);
			}
		}
		
		private function addToLayerAndVector(plat:Platform):void{
			this.game.gameLayer.addChild(plat);
			this.positionPlatform(plat);
			this.platformVector.push(plat);
		}
		
		private function initGround():void{
			var pos:Array = [562, 0];
			this.ground = new MpGround(pos);
			this.game.gameLayer.addChild(this.ground);
			this.ground.x = this.ground.xPos;
			this.ground.y = this.ground.yPos;
			this.platformVector.push(this.ground);
			
		}
		
		private function positionPlatform(obj:Platform):void{
			obj.x = obj.xPos;
			obj.y = obj.yPos;
		}
		
		private function get platformPosition():Array{
			return this.benefitPosition ? kindPosition() : meanPosition();
		}
		
		private function getMpPlatformPosition(index:int):Array{
			return this.mpPlatformPositions[index];
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
			plat.setNewData(this.platformPosition);
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
			this.lb.x = this.lb.xPos;
			this.lb.y = this.lb.yPos;
			this.platformVector.push(this.lb);
		}
		
		private function initRightIsland():void{
		
			var rbPos:Array = [550, 450];
			this.rb = new RightBase(rbPos);
			this.game.gameLayer.addChild(this.rb);
			this.rb.x = this.rb.xPos;
			this.rb.y = this.rb.yPos;
			this.platformVector.push(this.rb);
		}
		
		public function update(player:Player):void{
			if(player.currentPlat == null) this.m_updatePlatformCollission(player);
		}
		
		private function m_updatePlatformCollission(player:Player):void{
			
			var a:Rectangle;				
				// If velocity is < 0, check against body hitbox (larger), else if going up in a jump(velocity > 0), check against foot hitbox
			player.velocity < 0 ? a = player.hitBox.getRect(this.game.gameLayer) : a = player.bottomHitBox.getRect(this.game.gameLayer);
			
			for(var i:int = 0; i<this.platformVector.length; i++){
				this.tempPlatRect = this.platformVector[i].hitBox.getRect(this.game.gameLayer);
				if(a.intersects(this.tempPlatRect)){
					this.platformCollission(this.platformVector[i], player);
					break;
				}//End if intersect
			}//End platformloop
		}//End function
		
		
		private function platformCollission(plat:Platform, player:Player):void{
			if(player.falling){
				if(this.playerVector.length == 1){
					this.spPlatCollission(plat, player);
				} else{
					player.setCurrentPlat(plat);
					if(plat is MpPlatform) this.mpPlatCollission(plat as MpPlatform,player);
				}
			}
		}
		
		private function spPlatCollission(plat:Platform,player:Player):void{
			if(plat.exists){
				if(plat is WeakPlatform){
					this.setWeakPlatform(plat as WeakPlatform, player)
				}else{
					player.setCurrentPlat(plat);
				}
			}	
		}
		
		private function setWeakPlatform(plat:WeakPlatform, player:Player):void{
			player.setCurrentPlat(plat);
			plat.removePlat();
		}
		
		private function mpPlatCollission(plat:MpPlatform,player:Player):void{
			plat.playerOnPlat(player);
		}
		
		public function repositionAndNeutralizeMpPlatforms(round:int):void{
			var arr:Array;
			round == 2 ? arr = this.mpPlatformPositions2 : arr = this.mpPlatformPositions3;
			for(var i:int = 0; i < this.platformVector.length; i++){
				if(this.platformVector[i] is MpPlatform){
					var plat:MpPlatform = this.platformVector[i] as MpPlatform;
					this.mpRepos(plat, arr[i]);
					this.mpNeutralize(plat);
				}
			}
		}
		
		private function mpRepos(plat:MpPlatform, pos:Array):void{
			plat.setData(pos);
			this.positionPlatform(plat);
		}
		
		private function mpNeutralize(plat:MpPlatform):void{
			plat.resetFlag();
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