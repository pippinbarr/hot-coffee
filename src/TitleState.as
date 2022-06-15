package
{
	import org.flixel.*;
	
	
	public class TitleState extends FlxState
	{
		private const NONE:uint = 3;
		private const NPC_SPEAKING:uint = 0;
		private const PLAYER_SPEAKING:uint = 1;
		private const TITLE:uint = 2;
		
		private var _state:uint = NONE;
		
		private var _splash:FlxSprite;
		private var _hot:FlxText;
		private var _coffee:FlxText;
		private var _pressSpace:FlxText;
		
		private var _conversationNPC:Message;
		private var _conversationPlayer:Message;
		
		private var _conversationTimer:FlxTimer;
		
		public function TitleState()
		{
			super();
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFF000000;
			
			_splash = new FlxSprite(0,0,Assets.SPLASH_PNG);
			
			_hot = new FlxText(5,85,FlxG.width,"HOT",true);
			_hot.setFormat(null,64,0xFFFFFF,"center");
			_coffee = new FlxText(0,320,FlxG.width,"COFFEE",true);
			_coffee.setFormat(null,64,0xFFFFFF,"center");
	
			_pressSpace = new FlxText(0,420,FlxG.width,"PRESS [ENTER] TO PLAY",true);
			_pressSpace.setFormat(null,18,0xFFFFFF,"center");
			
			add(_splash);
			
			_conversationNPC = new Message(64,Globals.NPC_BG);	
			_conversationPlayer = new Message(64,Globals.PLAYER_BG);		

			_conversationNPC.setText("WANNA HAVE SOME COFFEE?");
			_conversationPlayer.setText("ALRIGHT. LET'S HAVE US SOME...");
			
			add(_conversationNPC);
			add(_conversationPlayer);

			_conversationNPC.makeInvisible();
			_conversationPlayer.makeInvisible();

			_conversationTimer = new FlxTimer();
			_conversationTimer.start(2,1,npcSpeaks);
		}
		
		
		private function npcSpeaks(t:FlxTimer):void
		{
			_state = NPC_SPEAKING;
			_conversationNPC.makeVisible();
		}
		
		
		private function playerSpeaks(t:FlxTimer = null):void
		{
			_state = PLAYER_SPEAKING;
			_conversationPlayer.makeVisible();
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (_state == NPC_SPEAKING && FlxG.keys.justPressed("ENTER"))
			{
				_conversationNPC.makeInvisible();
				_conversationTimer.start(1,1,playerSpeaks);
			}
			else if (_state == PLAYER_SPEAKING && FlxG.keys.justPressed("ENTER"))
			{
				_conversationPlayer.makeInvisible();
				_conversationTimer.start(1,1,showTitleOne);
			}
			else if (_state == TITLE && FlxG.keys.justPressed("ENTER"))
			{
				FlxG.fade(0xFF000000,1,gotoKettleState);
			}
		}
		
		private function gotoKettleState():void
		{
			FlxG.switchState(new KettleState);
		}
		
		
		private function showTitleOne(t:FlxTimer):void
		{
			add(_hot);
			_conversationTimer.start(0.5,1,showTitleTwo);
		}
		
		private function showTitleTwo(t:FlxTimer):void
		{
			add(_coffee);
			_conversationTimer.start(1,1,showPressSpace);
		}
		
		
		private function showPressSpace(t:FlxTimer):void
		{
			_state = TITLE;
			add(_pressSpace);
			FlxG.playMusic(Assets.SOUNDTRACK_MP3,1);
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			_hot.destroy();
			_coffee.destroy();
			_pressSpace.destroy();
			
			_conversationNPC.destroy();
			_conversationPlayer.destroy();
			
			_conversationTimer.destroy();
		}
	}
}