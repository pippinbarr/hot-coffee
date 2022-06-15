package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class GrinderState extends GameState
	{
		private const GRINDER_Y:uint = 28*6;
		private const FINENESS_INCREMENT:Number = 0.001;
		private const CONSISTENCY_INCREMENT:Number = 0.0001;
		private const CONSISTENCY_JERK_INCREMENT:Number = 0.002;

		
		// STATE
		private const NONE:uint = 0;
		private const GRINDING:uint = 1;
		private const GROUND:uint = 2;
		
		private var _grindState:uint = NONE;
		
		private const UP:uint = 0;
		private const DOWN:uint = 1;
		private const MIDDLE:uint = 2;
		
		private var _lastPosition:uint = MIDDLE;
		
		private var _fineness:Number = 0.0;
		private var _consistency:Number = 0.0;
		

		
		// GRAPHICS
		
		// GRINDER
		private var _grinder:FlxSprite;
		
		// GRIND UI
		private var _finenessMeter:AccuracyMeter;
		private var _consistencyMeter:AccuracyMeter;
		
		
		
		
		
		public function GrinderState()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFF000000;
			
			_grinder = new FlxSprite(15*6,GRINDER_Y);
			_grinder.loadGraphic(Assets.GRINDER_PNG,true,false,50*6,50*6);
			_grinder.addAnimation("GRINDING",Assets.GRINDER_GRINDING_FRAMES,Assets.ANIMATION_FRAMERATE,true);
			_grinder.addAnimation("GROUND",Assets.GRINDER_GROUND_FRAMES,Assets.ANIMATION_FRAMERATE,false);
			
			_finenessMeter = new AccuracyMeter(10*6, "FINENESS OF GRIND", Assets.ACCURACY_METER_PNG);
			_consistencyMeter = new AccuracyMeter(20*6, "CONSISTENCY OF GRIND", Assets.ACCURACY_METER_PNG);
			
			_finenessMeter.setVisible(false);
			_consistencyMeter.setVisible(false);
			
			add(_grinder);
			add(_finenessMeter);
			add(_consistencyMeter);
			
			
			_grinder.visible = false;
			
			_conversationNPC.setText(Assets.GRINDER_NPC);	
			_conversationPlayer.setText(Assets.GRINDER_PLAYER);			
			_instructions.setText(Assets.GRINDER_INSTRUCTIONS);	
			
			for (var i:int = 0; i < Assets.GRINDER_INTERJECTIONS.length; i++)
			{
				_interjections.push(Assets.GRINDER_INTERJECTIONS[i]);
			}
		}
		
		
		protected override function startPlay(t:FlxTimer):void
		{
			super.startPlay(t);
			
			_grindState = NONE;
			
			_finenessMeter.setVisible(true);
			_consistencyMeter.setVisible(true);			
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
				if (_interjection.isVisible())
				{
					_consistencyMeter.setVisible(false);
					_finenessMeter.setVisible(false);
				}
				else
				{
					_consistencyMeter.setVisible(true);
					_finenessMeter.setVisible(true);
				}
				
				if (_grindState == GRINDING || _grindState == NONE)
				{
					handleGrindInput();
					setMeters();
				}
				
				if ( _grindState == GROUND )
				{
					_state = COMPLETE;
					stageOver();
				}				
			}

		}
		
		
		protected override function gotoNextState():void
		{
			FlxG.switchState(new CafetiereState);
		}
		
		
		protected override function gotoRetryState():void
		{
			FlxG.switchState(new GrinderState);
		}
		
		
		protected override function gotoInstructions(t:FlxTimer):void
		{
			FlxG.bgColor = 0xFF667788;
			
			_conversationPlayer.makeInvisible();
			
			_finenessMeter.setVisible(true);
			_consistencyMeter.setVisible(true);
			
			_grinder.visible = true;
			
			super.gotoInstructions(t);
		}
		
		
		protected override function showInstructions(t:FlxTimer):void
		{
			_finenessMeter.setVisible(false);
			_consistencyMeter.setVisible(false);
			
			super.showInstructions(t);
		}
		
		
		protected override function showResult(t:FlxTimer):void
		{					
			_finenessMeter.setVisible(false);
			_consistencyMeter.setVisible(false);
			
			super.showResult(t);
		}
		
		
		protected override function stageOver():void
		{
			
		}
		
		
		private function handleGrindInput():void
		{
			if (FlxG.keys.SPACE && _grindState == NONE)
			{
				_grindState = GRINDING;
			}
			else if (FlxG.keys.SPACE && _grindState == GRINDING)
			{
				_grinder.play("GRINDING");
				
				_fineness += FINENESS_INCREMENT;
				_consistency += CONSISTENCY_INCREMENT;
				
				if (FlxG.keys.UP)
				{
					_grinder.y = GRINDER_Y - 5*6;
					if (_lastPosition != UP)
					{
						_consistency += CONSISTENCY_JERK_INCREMENT;
					}
					_lastPosition = UP;
					
				}
				else if (FlxG.keys.DOWN)
				{
					_grinder.y = GRINDER_Y + 5*6;
					if (_lastPosition != DOWN)
					{
						_consistency += CONSISTENCY_JERK_INCREMENT;			
					}
					_lastPosition = DOWN;
				}
				else
				{
					_grinder.y = GRINDER_Y;
					if (_lastPosition != MIDDLE)
					{
						_consistency += CONSISTENCY_JERK_INCREMENT;
					}
					_lastPosition = MIDDLE;
				}
			}
			else if (!FlxG.keys.SPACE && _grindState == GRINDING)
			{
				_grinder.play("GROUND");
				_grinder.y = GRINDER_Y;
				
				_grindState = GROUND;
			}
			
			return;
		}
		
		
		private function setMeters():void
		{
			_finenessMeter.setIndicator(_fineness);
			_consistencyMeter.setIndicator(_consistency);
		}
		
		public override function destroy():void
		{
			super.destroy();
			
			Globals.FINENESS = _finenessMeter.getIndicator()
			Globals.CONSISTENCY = _consistencyMeter.getIndicator();

			_grinder.destroy();
			
			_finenessMeter.destroy();
			_consistencyMeter.destroy();
		}
	}
}