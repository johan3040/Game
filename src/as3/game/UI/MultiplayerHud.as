package as3.game.UI{
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3.game.gameobject.player.Explorer;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.hudLeafMiddle;
	
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	
	public class MultiplayerHud extends DisplayStateLayerSprite{
		
		private var leaf:hudLeafMiddle;
		private var m_text:TextField;
		private var m_textFormat:TextFormat;
		private var owner:Player;
		
		public function MultiplayerHud(player:Player){
			super();
			this.owner = player;
			this.initLeaf();
		}
		
		private function initLeaf():void{
			this.leaf = new hudLeafMiddle();
			this.leaf.scaleX = 0.5;
			this.leaf.scaleY = 0.5;
			
			this.m_text = new TextField();
			this.m_textFormat = new TextFormat();
			this.m_textFormat.font = "Helvetica";
			this.m_textFormat.size = "22";
			this.m_text.width = 100;
			this.m_text.height = 30;
			this.m_text.defaultTextFormat = this.m_textFormat;
			this.m_text.text = this.owner.numFlags.toString();
			this.m_text.x = 30;
			
			this.owner is Explorer ? this.x = 60 : this.x = 650;
			this.y = 40;
			
			addChild(this.leaf);
			addChild(this.m_text);
		}
		
		override public function update():void{
			if(this.m_text.text != this.owner.numFlags.toString()) this.m_text.text = this.owner.numFlags.toString();
		}
		
		override public function dispose():void{
			this.leaf = null;
			this.m_text = null;
			this.m_textFormat = null;
			this.owner = null;
		}
		
	}
}