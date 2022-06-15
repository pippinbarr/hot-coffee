package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class GameState extends FlxState
	{
		// STATE
		
		protected const CONVERSATION:uint = 0;
		protected const PLAYER_CONVERSATION:uint = 5;
		protected const INSTRUCTIONS:uint = 1;
		protected const PLAYING:uint = 2;
		protected const COMPLETE:uint = 3;
		protected const RESULT:uint = 4;
		protected const FADE:uint = 6;
		
		protected var _state:uint = CONVERSATION;
				
		protected var _conversationNPC:Message;
		protected var _conversationPlayer:Message;
		protected var _instructions:Message;
		protected var _result:Message;
		
		protected var _messageTimer:FlxTimer;
		
		protected var _interjection:Message;
		protected var _interjections:Array = new Array();
		protected var _interjectionTimer:FlxTimer = new FlxTimer();
		protected var MIN_INTERJECTION_DELAY:Number = 4.0;
		protected var MAX_INTERJECTION_DELAY:Number = 8.0;

		
		public function GameState()
		{
			super();
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFFF0000;

			_messageTimer = new FlxTimer();
			
			_conversationNPC = new Message(4*6,Globals.NPC_BG);	
			_conversationPlayer = new Message(4*6,Globals.PLAYER_BG);		
			
			_instructions = new Message(4*6,Globals.MESSAGE_BG);
			_result = new Message(2*6,Globals.MESSAGE_BG,false,false);
			
			_interjection = new Message(4*6,Globals.NPC_BG,true);
			_interjection.setText("FUCK YEAH.");
			
			add(_conversationNPC);
			add(_conversationPlayer);
			add(_instructions);
			add(_result);
			
			
			_conversationNPC.makeInvisible();
			_conversationPlayer.makeInvisible();
			_instructions.makeInvisible();
			_result.makeInvisible();
			
			_state = CONVERSATION;
			
			_messageTimer.start(1,1,showNPC);
		}
		
		private function showNPC(t:FlxTimer):void
		{
			_conversationNPC.makeVisible();
		}
		
		protected function startPlay(t:FlxTimer):void
		{
			_state = PLAYING;
			add(_interjection);
			_interjectionTimer.start(getInterjectionDelay(),1,interject);
		}
		
		
		public override function update():void
		{
			super.update();	
			
			if (_state == INSTRUCTIONS && FlxG.keys.justPressed("ENTER") && _instructions.isVisible())
			{
				_instructions.makeInvisible();
				startPlay(null);
			}
			else if (_state == CONVERSATION && _conversationNPC.isVisible() && FlxG.keys.justPressed("ENTER"))
			{
				_conversationNPC.makeInvisible();
				_messageTimer.start(0.5,1,showPlayerConversation);				
			}
			else if (_state == PLAYER_CONVERSATION && _conversationPlayer.isVisible() && FlxG.keys.justPressed("ENTER"))
			{
				_conversationPlayer.makeInvisible();
				_messageTimer.start(0.5,1,gotoInstructions);
			}
			else if (_state == RESULT && _result.isVisible() && FlxG.keys.justPressed("N"))
			{
				_state = FADE;
				_result.makeInvisible();
				_messageTimer.start(1,1,fadeToNext);
			}
			else if (_state == RESULT && _result.isVisible() && FlxG.keys.justPressed("R"))
			{
				_state = FADE;
				_result.makeInvisible();
				_messageTimer.start(1,1,fadeToRetry);
			}

		}
		
		
		private function fadeToNext(t:FlxTimer):void
		{
			FlxG.fade(0xFF000000,1,gotoNextState);
		}
		
		
		private function fadeToRetry(t:FlxTimer):void
		{
			FlxG.fade(0xFF000000,1,gotoRetryState);
		}

		protected function gotoNextState():void
		{
			
		}
		
		protected function gotoRetryState():void
		{
			
		}
		
		protected function showPlayerConversation(t:FlxTimer):void
		{			
			_conversationPlayer.makeVisible();
			
			_state = PLAYER_CONVERSATION;			
		}
		
		
		protected function gotoInstructions(t:FlxTimer):void
		{			
			_state = INSTRUCTIONS;
			
			_messageTimer.start(1,1,showInstructions);
		}
		
		protected function showInstructions(t:FlxTimer):void
		{
			_state = INSTRUCTIONS;
						
			_instructions.makeVisible();
		}
		
		
		protected function showResult(t:FlxTimer):void
		{
			_state = RESULT;
			
			_result.setText("STAGE COMPLETE!\n\n[N]EXT OR [R]ETRY.");
			_result.makeVisible();
		}
		
		
		
		protected function stageOver():void
		{
		}
		
		
		protected function interject(t:FlxTimer):void
		{
			if (_state == PLAYING)
			{
				_interjection.setText(_interjections[Math.floor(Math.random() * _interjections.length)]);
				_interjection.showInterjection();
			}
			_interjectionTimer.start(getInterjectionDelay(),1,interject);
		}
		
		
		protected function getInterjectionDelay():Number
		{
			return (Math.random() * (MAX_INTERJECTION_DELAY - MIN_INTERJECTION_DELAY) + MIN_INTERJECTION_DELAY);
		}
		
		
		
		public override function destroy():void
		{
			super.destroy();
					
			_conversationNPC.destroy();
			_conversationPlayer.destroy();
			_instructions.destroy();
			_result.destroy();
			_messageTimer.destroy();
			
			_interjection.destroy();
			_interjectionTimer.destroy();
		}
	}
}