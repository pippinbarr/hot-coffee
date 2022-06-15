package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	
	public class SugarState extends GameState
	{
		private const MAX_KEY_DELAY:Number = 0.12;
		
		// STATE
		private const NONE:uint = 0;
		private const POURING:uint = 1;
		private const POURED:uint = 2;
		private const STOPPED_POURING:uint = 3;
		
		private var _sugarState:uint = NONE;
		
		private const SUGAR_CRYSTAL_SWEETNESS:Number = 0.01;
		private var _sweetness:Number = 0.0;
		
		
		
		// GRAPHICS
		
		// CUP AND SUGAR
		private var _cup:FlxSprite;
		private var _sugars:FlxGroup;
		
		// SUGAR UI
		private var _sweetnessMeter:AccuracyMeter;
		
		private var _timeElapsed:Number = 0.0;
		private var _lastSugarTime:Number = 0.0;
		
		private const MIN_SUGAR_DELAY:Number = 0.01;
		private const MAX_SUGAR_DELAY:Number = 0.1;
		private var _sugarDelay:Number = 0.0;
		
		private const SUGAR_SPEED:Number = 200;

		private const SUGAR_INSET_X:uint = 37*6;
		private const SUGAR_INSET_Y:uint = 20*6;
		private const SUGAR_END_Y:uint = 41*6;
		private const SUGAR_X_RANGE:uint = 4*6;
		
		
		public function SugarState()
		{
		}
		
		
		public override function create():void
		{						
			_cup = new FlxSprite(15*6,22*6);
			_cup.loadGraphic(Assets.CUP_PNG);
			
			_sugars = new FlxGroup();
			
			_sweetnessMeter = new AccuracyMeter(10*6, "COFFEE SWEETNESS", Assets.ACCURACY_METER_PNG);
			
			_sweetnessMeter.setVisible(false);
			
			add(_cup);
			add(_sugars);
			add(_sweetnessMeter);
			
			super.create();
			
			FlxG.bgColor = 0xFF000000;
			
			_cup.visible = false;
			
			_conversationNPC.setText(Assets.SUGAR_NPC);	
			_conversationPlayer.setText(Assets.SUGAR_PLAYER);			
			_instructions.setText(Assets.SUGAR_INSTRUCTIONS);	
			
			for (var i:int = 0; i < Assets.SUGAR_INTERJECTIONS.length; i++)
			{
				_interjections.push(Assets.SUGAR_INTERJECTIONS[i]);
			}		
		}
		
		
		protected override function startPlay(t:FlxTimer):void
		{
			super.startPlay(t);
			
			_sugarState = NONE;
			
			_sweetnessMeter.setVisible(true);
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
				_timeElapsed += FlxG.elapsed;
				
				handleSugarInput();
				
				setMeter();
					
				
				if (_interjection.isVisible())
				{
					_sweetnessMeter.setVisible(false);
				}
				else
				{
					_sweetnessMeter.setVisible(true);
				}
				
				if (_sugarState == POURING)
				{
					handlePouring();
				}
				else if ( _sugarState == POURED )
				{
					_state = COMPLETE;
					stageOver();
				}
				
				handlePouredSugars();
				
				if (_sugarState == STOPPED_POURING && _sugars.getFirstAlive() == null)
				{
					_sugarState = POURED;
				}
			}
			
			
		}
		
		
		protected override function gotoNextState():void
		{
			FlxG.switchState(new MilkState);
		}
		
		
		protected override function gotoRetryState():void
		{
			FlxG.switchState(new SugarState);
		}

		
		protected override function gotoInstructions(t:FlxTimer):void
		{
			FlxG.bgColor = 0xFF668877;
			
			_conversationPlayer.makeInvisible();
			
			_sweetnessMeter.setVisible(true);
			
			_cup.visible = true;
			
			super.gotoInstructions(t);
		}
		
		
		protected override function showInstructions(t:FlxTimer):void
		{
			_sweetnessMeter.setVisible(false);
			
			super.showInstructions(t);
		}
		
		
		protected override function showResult(t:FlxTimer):void
		{					
			_sweetnessMeter.setVisible(false);
			
			super.showResult(t);
		}
		
		
		protected override function stageOver():void
		{
			
		}
		
		
		private function handlePouring():void
		{
			if (_timeElapsed - _lastSugarTime >= _sugarDelay)
			{
				// We should add a sugar crystal
				var sugar:FlxSprite = _sugars.recycle(FlxSprite) as FlxSprite;
				sugar.revive();
				
				sugar.makeGraphic(1*6,1*6,0xFFFFFFFF);
				sugar.y = SUGAR_INSET_Y;
				sugar.x = Math.floor(SUGAR_INSET_X + Math.random() * SUGAR_X_RANGE);
				
				sugar.velocity.y = SUGAR_SPEED;
				
				trace("Added a sugar at " + sugar.x + "," + sugar.y);
				
				_sugars.add(sugar);
				
				_lastSugarTime = _timeElapsed;
				_sugarDelay = (Math.random() * (MAX_SUGAR_DELAY - MIN_SUGAR_DELAY)) + MIN_SUGAR_DELAY;
			}
		}
		
		
		private function handlePouredSugars():void
		{
			for (var i:int = 0; i < _sugars.length; i++)
			{
				if (_sugars.members[i].active && _sugars.members[i].alive)
				{
					if (_sugars.members[i].y > SUGAR_END_Y)
					{
						_sugars.members[i].kill();
						
						_sweetness += SUGAR_CRYSTAL_SWEETNESS;
						if (_sweetness > 1.0)
						{
							_sweetness = 1.0;
						}
					}
				}
			}
		}
		
		
		private function handleSugarInput():void
		{
			if (FlxG.keys.SPACE && _sugarState != POURING)
			{
				_sugarState = POURING;
			}
			else if (!FlxG.keys.SPACE && _sugarState == POURING)
			{
				_sugarState = STOPPED_POURING;
			}
		}
				
		
		private function setMeter():void
		{
			_sweetnessMeter.setIndicator(_sweetness);
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			Globals.SWEETNESS = _sweetnessMeter.getIndicator();

			
			_cup.destroy();
			
			_sweetnessMeter.destroy();
		}
	}
}