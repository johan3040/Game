package as3.game.gameobject.platforms{
	
	public class Bungalow extends Platform{
		
		public function Bungalow(pos){
			super(pos);
		}
		
		override public function init():void{
			
			obj_width = 25;
			obj_height = 25;
			hitBox.graphics.beginFill(0xDEB887);
			hitBox.graphics.drawRect(0,0,obj_width,obj_height);
			hitBox.graphics.endFill();
			
			
			
			addChild(hitBox);
		
		}
	}
}