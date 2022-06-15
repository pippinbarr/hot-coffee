package
{
	import org.flixel.*;
	
	
	public class EvaluationState extends FlxState
	{
		private const HEAT:uint = 0;
		private const FINENESS:uint = 1;
		private const CONSISTENCY:uint = 2;
		private const STRENGTH:uint = 3;
		private const SWEETNESS:uint = 4;
		private const CREAMINESS:uint = 5;
		
		private var _poors:Array = new Array();
		private var _okays:Array = new Array();
		private var _goods:Array = new Array();
		private var _overs:Array = new Array();
		
		
		private var _cups:FlxSprite;
		
		private const NONE:uint = 0;
		private const NPC_SPEAKS_1:uint = 1;
		private const PLAYER_SPEAKS_1:uint = 2;
		private const NPC_SPEAKS_2:uint = 3;
		private const PLAYER_SPEAKS_2:uint = 4;
		
		private var _state:uint = NONE;
		
		private var _npc:Message;
		private var _player:Message;
		
		private var _conversationTimer:FlxTimer;
		
		
		public function EvaluationState()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFFaabbcc;
			
			_cups = new FlxSprite(0,0,Assets.CUPS_PNG);
			
			_npc = new Message(64,Globals.NPC_BG);
			_player = new Message(64,Globals.PLAYER_BG);
			
			_conversationTimer = new FlxTimer();
						
			add(_cups);
			add(_npc);
			add(_player);
			
			_npc.makeInvisible();
			_player.makeInvisible();
			
			_conversationTimer.start(1,1,npcSpeaksOne);
		}
		
		
		private function npcSpeaksOne(t:FlxTimer):void
		{
			_npc.setText(buildEvaluationString());
			_npc.makeVisible();
			_state = NPC_SPEAKS_1;
		}
		
		private function npcSpeaksTwo(t:FlxTimer):void
		{
			_npc.setText("ME TOO. IT WAS A LOVELY EVENING. GOOD NIGHT!");
			_npc.makeVisible();
			_state = NPC_SPEAKS_2;
		}
		
		private function playerSpeaksOne(t:FlxTimer):void
		{
			_player.setText("WELL, IT'S LATE, I SHOULD PROBABLY GO. I HAD A GREAT TIME.");
			_player.makeVisible();
			_state = PLAYER_SPEAKS_1;
		}
		
		private function playerSpeaksTwo(t:FlxTimer):void
		{
			_player.setText("GOOD NIGHT.");
			_player.makeVisible();
			_state = PLAYER_SPEAKS_2;
		}
		
		public override function update():void
		{
			super.update();
			
			if (_state == NPC_SPEAKS_1 && FlxG.keys.justPressed("ENTER"))
			{
				_state = NONE;
				_npc.makeInvisible();
				_conversationTimer.start(1,1,playerSpeaksOne);
			}
			else if (_state == PLAYER_SPEAKS_1 && FlxG.keys.justPressed("ENTER"))
			{
				_state = NONE;
				_player.makeInvisible();
				_conversationTimer.start(1,1,npcSpeaksTwo);
			}
			else if (_state == NPC_SPEAKS_2 && FlxG.keys.justPressed("ENTER"))
			{
				_state = NONE;
				_npc.makeInvisible();
				_conversationTimer.start(1,1,playerSpeaksTwo);
			}
			else if (_state == PLAYER_SPEAKS_2 && FlxG.keys.justPressed("ENTER"))
			{
				_state = NONE;
				_player.makeInvisible();
				_conversationTimer.start(1,1,fadeOut);
			}
		}
		
		
		private function fadeOut(t:FlxTimer):void
		{
			FlxG.fade(0xFF000000,1,endStage);
		}
		
		
		private function endStage():void
		{
			FlxG.pauseSounds();
			FlxG.switchState(new EndState);
		}
		
		
		private function buildEvaluationString():String
		{
			
			var returnString:String = "";
			
			if (Globals.HEAT < 0.5)
			{
				_poors.push(HEAT);
			}
			else if (Globals.HEAT < 1.0)
			{
				_okays.push(HEAT);
			}
			else
			{
				_goods.push(HEAT);
			}
			
			checkAccuracy(Globals.FINENESS,FINENESS);
			checkAccuracy(Globals.CONSISTENCY,CONSISTENCY);
			checkAccuracy(Globals.STRENGTH,STRENGTH);
			checkAccuracy(Globals.SWEETNESS,SWEETNESS);
			
			if (Globals.CREAMINESS == 1.0)
			{
				_goods.push(CREAMINESS);
			}
			else
			{
				_poors.push(CREAMINESS);
			}
			
			
			
			// CREATE RESPONSE
			
			if (_goods.length == 6)
			{
				// BEST CASE
				returnString = "" +
					"WOW! THAT WAS A REALLY AMAZING CUP OF COFFEE! " +
					"HOT, SWEET, AND STRONG, JUST THE WAY I LIKE IT! " +
					"I THINK I NEED A CIGARETTE NOW!";
			}
			else if (_poors.length + _overs.length == 6)
			{
				// WORST CASE
				returnString = "" +
					"WELL LOOK, LET'S JUST BE HONEST WITH EACH OTHER, " +
					"THAT WAS AN AWFUL CUP OF COFFEE. BUT THAT'S OKAY, " +
					"THE FIRST COFFEE'S NOT ALWAYS AMAZING.";
			}
			else if (_okays.length == 6)
			{
				// SUPER MEDIOCRE CASE
				returnString = "" +
					"THAT WAS A GOOD, SOLID CUP OF COFFEE. " +
					"THANKS A LOT FOR MAKING IT!";
			}
			else if ((_poors.length + _overs.length) > _okays.length &&
				(_poors.length + _overs.length) > _goods.length)
			{
				// SHITTY CASE (MORE POORS THAN ANYTHING ELSE)
				returnString = "" +
					"OKAY, WELL, THAT WASN'T REALLY THE BEST " +
					"CUP OF COFFEE I'VE EVER HAD, BUT THAT'S ALRIGHT... " +
					"NEXT TIME IT WILL BE BETTER.";
			}
			else if (_goods.length > (_poors.length + _overs.length) &&
				_goods.length > _okays.length)
			{
				// GOOD CASE (MORE GOODS THAN ANYTHING ELSE)
				returnString = "" +
					"THAT WAS A PRETTY GREAT COFFEE WE JUST HAD, " +
					"I REALLY LOVE A GOOD CUP LIKE THAT TO FINISH OFF AN EVENING.";
			}
			else
			{
				// BALANCED == MEDIOCRE AGAIN...
				if (_goods.length > (_poors.length + _overs.length))
				{
					// MEDIOCRE WITH MORE GOODS
					returnString = "" +
						"THANKS FOR THE COFFEE, IT WAS REALLY PRETTY GOOD, TOO. " +
						"I'D LIKE TO TRY YOUR COFFEE AGAIN SOME TIME...";
				}
				else if (_goods.length < (_poors.length + _overs.length))
				{
					// MEDIOCRE WITH MORE BADS
					returnString = "" +
						"THAT WASN'T REALLY A GREAT CUP OF COFFEE, " +
						"BUT I'D STILL LIKE TO HAVE COFFEE WITH YOU AGAIN SOME TIME...";
				}
				else
				{
					// MEDIOCRE WITH EQUAL GOODS AND BADS
					// e.g. 4-1-1 or 2-2-2
					returnString = "" +
						"THAT WAS A SOLIDLY AVERAGE COFFEE WE JUST HAD. BUT YOU KNOW WHAT? " +
						"I THINK YOU'LL MAKE IT MUCH BETTER NEXT TIME...";
				}
				
			}
			
			
			return returnString;
		}
		
		
		private function checkAccuracy(value:Number, type:uint):void
		{
			if (value < 0.5)
			{
				_poors.push(type);
			}
			else if (value < 0.88)
			{
				_okays.push(type);
			}
			else if (value < 0.94)
			{
				_goods.push(type);
			}
			else
			{
				_overs.push(type);
			}	
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			_npc.destroy();
			_player.destroy();
			_cups.destroy();
			_conversationTimer.destroy();
		}
	}
}