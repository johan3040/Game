package scene
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import as3.game.UI.TopBar;
	import as3.game.gameobject.player.Player;
	
	import assets.gameObjects.EmeraldGFX;
	import assets.gameObjects.FlagFirework;
	import assets.gameObjects.GradientBack;
	import assets.gameObjects.RubyGFX;
	import assets.gameObjects.menuPalm;
	import assets.gameObjects.newHighscoreText;
	import assets.gameObjects.scoreSign;
	import assets.gameObjects.sideBarLeft;
	import assets.gameObjects.sideBarRight;
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	public class PointsCounter extends DisplayState{
		
		private var player:Player;
		private var m_controls:EvertronControls;
		private var pc_layer:DisplayStateLayer;
		private var pc_textLayer:DisplayStateLayer;
		private var bg:GradientBack;
		private var pc_sign:scoreSign;
		private var pointsText:TextField;
		private var pointsFormat:TextFormat;
		private var ruby:RubyGFX;
		private var emerald:EmeraldGFX;
		private var pointsCounter:int;
		private var sidebarLeft:menuPalm;
		private var sidebarRight:menuPalm;
		private var topbar:TopBar;
		private var ocean:Sprite;
		private var leftFirework:FlagFirework;
		private var rightFirework:FlagFirework;
		private var pc_newHighscore:newHighscoreText;
		
		private var continueText:TextField;
		private var continueTextFormat:TextFormat;
		
		private var reachedPoints:Boolean = false;
		
		
		[Embed(source="../../assets/font/PaintyPaint.TTF",
					fontName = "FontyFont",
					mimeType = "application/x-font",
					advancedAntiAliasing="true",
					embedAsCFF="false")]
		private var myEmbeddedFont:Class;
		
		[Embed(source = "../../assets/audio/pointCountAU.mp3")] 	// <-- this data..
		private const POINT_AUDIO:Class;						// ..gets saved in this const
		private var pointAudio:SoundObject;
		
		[Embed(source = "../../assets/audio/winner.mp3")] 	// <-- this data..
		private const FINAL_AUDIO:Class;						// ..gets saved in this const
		private var finalAudio:SoundObject;
		
		
		/**
		 * 
		 * Class constructor
		 * 
		 * @param Player
		 * 
		 */
		public function PointsCounter(player:Player){
			super();
			this.player = player;
			this.m_controls = new EvertronControls(0);
		}
		
		override public function init():void{
			this.initLayers();
			this.initBackground();
			this.initSign();
			this.initPointsText();
			this.initWater();
			this.initGraphics();
			this.initAudio();
			this.updatePoints();
			this.initContinueText();
		}
		
		private function initLayers():void{
			this.pc_layer = this.layers.add("pc_layer");
			this.pc_textLayer = this.layers.add("textLayer");
		}
		
		private function initBackground():void{
			this.bg = new GradientBack();
			this.pc_layer.addChild(this.bg);
		}
		
		private function initSign():void{
			this.pc_sign = new scoreSign();
			
			this.pc_sign.x = 170;
			this.pc_sign.y = 130;
			
			this.pc_layer.addChild(this.pc_sign);
		}

		private function initPointsText():void{
			this.pointsText = new TextField();
			this.pointsFormat = new TextFormat("fontyFont", 60, 0xFFFFFF);
			this.pointsText.text = "0";
			this.pointsText.setTextFormat(this.pointsFormat);
			this.pointsText.x = 350;
			this.pointsText.y = 230;
			this.pointsText.width = 200;
			this.pointsText.embedFonts = true;
			this.pointsText.defaultTextFormat = this.pointsFormat;
			this.pc_textLayer.addChild(this.pointsText);
			
			this.pointsCounter = 0;
		}

		private function initWater():void{
			this.ocean = new Sprite();
			
			this.ocean.graphics.beginFill(0x2B879E);
			this.ocean.graphics.drawRect(0, 540, 800, 60);
			this.ocean.graphics.endFill();
			
			this.pc_layer.addChild(this.ocean);
		}
		
		private function initGraphics():void{
			this.sidebarLeft = new menuPalm();
			this.sidebarRight = new menuPalm();
			this.topbar = new TopBar();
			
			this.sidebarRight.scaleX = -1;
			this.sidebarRight.x = 800;
			
			this.pc_layer.addChild(this.topbar);
			this.pc_layer.addChild(this.sidebarLeft);
			this.pc_layer.addChild(this.sidebarRight);
		}
		
		private function initAudio():void{
			Session.sound.soundChannel.sources.add("pointMusic", POINT_AUDIO);
			this.pointAudio = Session.sound.soundChannel.get("pointMusic", true, false);
			Session.sound.soundChannel.sources.add("final", FINAL_AUDIO);
			this.finalAudio = Session.sound.soundChannel.get("final", true, true);
		}
		
		private function updatePoints():void{
			if(this.player.bonusPoints != this.pointsCounter){
				this.player.bonusPoints < 100 ? this.pointsCounter+= 5 : this.pointsCounter += 10;
				this.pointsText.text = this.pointsCounter.toString();
				this.pointAudio.play();
			}else{
				this.finalAudio.play();
				this.reachedPoints = true;
				this.pointsFormat = new TextFormat("fontyFont", 60, 0xFFd700);
				this.pointsText.setTextFormat(this.pointsFormat);
				Session.highscore.checkScore(1, this.player.bonusPoints, this.newHighscore);
				
			}
		}
		
		private function initContinueText():void{
			this.continueText = new TextField();
			this.continueTextFormat = new TextFormat("Segoe Script", 30, 0xFFFFFF);
			this.continueText.text = 'Press "jump" to continue';
			this.continueText.width = 400;
			this.continueText.setTextFormat(this.continueTextFormat);
			this.continueText.defaultTextFormat = this.continueTextFormat;
			this.continueText.x = 400 - this.continueText.width/2;
			this.continueText.y = 540;
			
			this.pc_textLayer.addChild(this.continueText);
		}
		
		private function newHighscore(data:XML):void{
			
			if(data.child("header").child("success")){
				if(data.child("header").child("position") <= 10){
					this.goFireworks();
					this.goHighscore();
				}
				
			}
		}
		
		private function goFireworks():void{
			this.leftFirework = new FlagFirework();
			this.rightFirework = new FlagFirework();
			
			this.leftFirework.scaleX = -2;
			this.leftFirework.scaleY = 2;
			this.rightFirework.scaleX = 2;
			this.rightFirework.scaleY = 2;
			
			this.leftFirework.x = 100;
			this.leftFirework.y = 400;
			
			this.rightFirework.x = 700;
			this.rightFirework.y = 400;
			
			this.pc_layer.addChild(this.rightFirework);
			this.pc_layer.addChild(this.leftFirework);
			this.leftFirework.gotoAndPlay(1);
			this.rightFirework.gotoAndPlay(1);
		}
		
		private function goHighscore():void{
			this.pc_newHighscore = new newHighscoreText();
			
			this.pc_newHighscore.x = 400 - (this.pc_newHighscore.width/2);
			this.pc_newHighscore.y = 400;
			
			this.pc_textLayer.addChild(this.pc_newHighscore);
			this.pc_newHighscore.gotoAndPlay(1);
		}
		
		override public function update():void{
			if(reachedPoints != true) this.updatePoints();
			if(Input.keyboard.justPressed(this.m_controls.PLAYER_BUTTON_1)) Session.application.displayState = new GameOver(this.player, 1);
		}
		
		override public function dispose():void{
			this.pointsFormat = null;
			this.pointsText = null;
			this.ruby = null;
			this.emerald = null;
			this.m_controls = null;
			this.leftFirework = null;
			this.rightFirework = null;
			this.pc_sign = null;
			this.pc_newHighscore = null;
			this.pointAudio = null;
			this.finalAudio = null;
			this.ocean = null;
			this.continueText = null;
			this.continueTextFormat = null;
		}
		
	}
}