package
{	
	import org.flixel.*;
	
	
	public class MilkState extends GameState
	{
		
		// STATE
		private const NONE:uint = 0;
		private const MOVING:uint = 1;
		private const POURED:uint = 2;
		
		private var _milkState:uint = NONE;
		
		private var _milkSuccess:Boolean = false;

		
		// GRAPHICS
		
		// CUP AND SUGAR
		private var _cup:FlxSprite;
		private var _jug:FlxSprite;
		
		// SUGAR UI
		private var _milkMeter:AccuracyMeter;
		
		private const JUG_SPEED:Number = 500;
		private var _location:Number = 0;
		
		private const JUG_FAR_LEFT:uint = 10*6;
		private const LEFT_SUCCESS:uint = 20*6;
		private const RIGHT_SUCCESS:uint = 30*6;
		private const JUG_FAR_RIGHT:uint = 50*6;
		
		private const TRACK_LENGTH:Number = JUG_FAR_RIGHT - JUG_FAR_LEFT;
		
		private const THRUST_TIME:Number = 1;
		private const RETRACT_TIME:Number = 1;
		
		private const THRUSTING:uint = 0;
		private const RETRACTING:uint = 1;
		
		private var _thrustState:uint = THRUSTING;
		private var _thrustTime:Number = 0.0;
		
		
		public function MilkState()
		{
		}
		
		
		public override function create():void
		{						
			_cup = new FlxSprite(30*6,35*6);
			_cup.loadGraphic(Assets.CUP_PNG);
			
			_jug = new FlxSprite(0,0);
			_jug.loadGraphic(Assets.MILK_JUG_PNG,true,false,80*6,80*6);
			_jug.addAnimation("NORMAL",Assets.MILK_JUG_NORMAL_FRAMES,Assets.ANIMATION_FRAMERATE,false);
			_jug.addAnimation("SUCCESS",Assets.MILK_JUG_POUR_SUCCESS_FRAMES,Assets.ANIMATION_FRAMERATE,false);
			_jug.addAnimation("SHORT",Assets.MILK_JUG_SHORT_FRAMES,Assets.ANIMATION_FRAMERATE,false);
			_jug.addAnimation("LONG",Assets.MILK_JUG_LONG_FRAMES,Assets.ANIMATION_FRAMERATE,false);
			_jug.play("NORMAL");
			
			_jug.width = 22*6;
			_jug.height = 25*6;
			_jug.offset.x = 29*6;
			_jug.offset.y = 20*6;
			
			_jug.x = JUG_FAR_LEFT;
			_jug.y = 24*6;
			
			_jug.visible = false;
			
			_milkMeter = new AccuracyMeter(10*6, "MILK ACCURACY",Assets.MILK_METER_PNG);
			
			_milkMeter.setVisible(false);
			
			add(_cup);
			add(_jug);
			add(_milkMeter);
			
			super.create();
			
			FlxG.bgColor = 0xFF000000;
			
			_cup.visible = false;
			
			_conversationNPC.setText(Assets.MILK_NPC);	
			_conversationPlayer.setText(Assets.MILK_PLAYER);			
			_instructions.setText(Assets.MILK_INSTRUCTIONS);	
			
			for (var i:int = 0; i < Assets.MILK_INTERJECTIONS.length; i++)
			{
				_interjections.push(Assets.MILK_INTERJECTIONS[i]);
			}
		}
		
		
		protected override function startPlay(t:FlxTimer):void
		{
			super.startPlay(t);
			
			_milkState = NONE;
			
			_milkMeter.setVisible(true);
		}
		
		
		public override function update():void
		{
			super.update();	
			
			
			if (_state == COMPLETE && !_result.isVisible())
			{				
				_state = RESULT;
				_messageTimer.start(0.5,1,showResult);
			}
			
			if (_state == PLAYING)
			{		
				handleMilkInput();
				
				setMeter();
				
				if (_interjection.isVisible())
				{
					_milkMeter.setVisible(false);
				}
				else
				{
					_milkMeter.setVisible(true);
				}
				if (_milkState == MOVING)
				{
					handleMoving();
				}
				else if ( _milkState == POURED && _jug.finished )
				{
					_state = COMPLETE;
					stageOver();
				}								
			}
		}
		
		
		protected override function gotoNextState():void
		{
			FlxG.switchState(new EvaluationState);
		}
		
		
		protected override function gotoRetryState():void
		{
			FlxG.switchState(new MilkState);
		}
		
		
		protected override function gotoInstructions(t:FlxTimer):void
		{
			FlxG.bgColor = 0xFF776688;
			
			_conversationPlayer.makeInvisible();
			
			_milkMeter.setVisible(true);
			
			_cup.visible = true;
			_jug.visible = true;
			
			super.gotoInstructions(t);
		}
		
		
		protected override function showInstructions(t:FlxTimer):void
		{
			_milkMeter.setVisible(false);
			
			super.showInstructions(t);
		}
		
		
		protected override function showResult(t:FlxTimer):void
		{					
			_milkMeter.setVisible(false);
			
			super.showResult(t);
		}
		
		
		protected override function stageOver():void
		{
			super.stageOver();
		}
		
		
		private function handleMoving():void
		{
			if (_milkState != MOVING)
				return;
			
			
			if (_thrustState == THRUSTING)
			{
				_thrustTime += FlxG.elapsed;
				
				var change:Number = 0;
				//var t:Number = _thrustTime /= THRUST_TIME/2;
				
				change = JUG_SPEED/FlxG.framerate * Math.pow(2, 2 * (_thrustTime/THRUST_TIME - 1));
				
//				c * Math.pow( 2, 10 * (t/d - 1) ) + b;
//				
//				if (t < 1)
//				{
//					change = JUG_SPEED/FlxG.framerate/2 * Math.pow(2, 1 * (t - 1) ) + JUG_FAR_LEFT;
//				}
//				else
//				{
//					t--;
//					change = JUG_SPEED/FlxG.framerate/2 * (-Math.pow(2, -1 * t) + 2) + JUG_FAR_LEFT;
//				}
				
				_jug.x += change;
			}
			else if (_thrustState == RETRACTING)
			{
				_jug.x -= 10;
			}
			
			if (_jug.x < JUG_FAR_LEFT)
			{
				_jug.x = JUG_FAR_LEFT;
				_thrustState = THRUSTING;	
			}
			else if (_jug.x > JUG_FAR_RIGHT)
			{
				_jug.x = JUG_FAR_RIGHT;
				_thrustState = RETRACTING;	
				_thrustTime = 0;
			}
			
		}
		
		
		
		private function handleMilkInput():void
		{
			if (FlxG.keys.SPACE && _milkState != MOVING)
			{
				_milkState = MOVING;
			}
			else if (!FlxG.keys.SPACE && _milkState == MOVING)
			{
				_milkState = POURED;
				
				if (_jug.x < LEFT_SUCCESS)
				{
					if (_jug.x > LEFT_SUCCESS - 6)
						_jug.x = LEFT_SUCCESS - 6;
					_jug.play("SHORT");
					Globals.CREAMINESS = 0.0;
				}
				else if (_jug.x > RIGHT_SUCCESS)
				{
					if (_jug.x < RIGHT_SUCCESS + 6)
						_jug.x = RIGHT_SUCCESS + 6;
					_jug.play("LONG");
					Globals.CREAMINESS = 0.0;
				}
				else
				{
					_milkSuccess = true;
					_jug.play("SUCCESS");
					Globals.CREAMINESS = 1.0;
				}
			}
		}
		
		
		private function setMeter():void
		{
			_milkMeter.setIndicator((_jug.x - JUG_FAR_LEFT) / TRACK_LENGTH);
		}
		
		
		public override function destroy():void
		{
			super.destroy();
						
			trace(Globals.HEAT);
			trace(Globals.CONSISTENCY);
			trace(Globals.FINENESS);
			trace(Globals.STRENGTH);
			trace(Globals.SWEETNESS);
			trace(Globals.CREAMINESS);
			
			_cup.destroy();
			_jug.destroy();
			
			_milkMeter.destroy();
		}
	}
}