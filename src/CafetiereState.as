package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class CafetiereState extends GameState
	{
		private const STRENGTH_INCREMENT:Number = 0.0005;
		private const MAX_KEY_DELAY:Number = 0.12;
		private const PLUNGE_INPUT_NUM:uint = 4;
		
		// STATE
		private const NONE:uint = 0;
		private const WAITING:uint = 1;
		private const PLUNGING:uint = 2;
		private const PLUNGED:uint = 3;
		
		private var _cafetiereState:uint = NONE;
		
		private var _strength:Number = 0.0;
		private var _lastPressTime:Number = 0.0;
		private var _timeElapsed:Number = 0.0;
		private var _lastPlungeFrame:uint = 0;
		private var _currentLowerColour:uint = 0xFF894d2c;
		private var _currentUpperColour:uint = 0xFFa8462f;
		
		private var _pressCount:uint = 0;
		
		
		// GRAPHICS
		
		// CAFETIERE
		private var _cafetiere:FlxSprite;
		
		// CAFETIERE UI
		private var _strengthMeter:AccuracyMeter;

		private var _nextColourIncrement:Number = 0.1;
		
		
		
		
		
		public function CafetiereState()
		{
		}
		
		
		public override function create():void
		{						
			_cafetiere = new FlxSprite(15*6,22*6);
			_cafetiere.loadGraphic(Assets.CATETIERE_PNG,true,false,50*6,50*6);
			_cafetiere.addAnimation("NORMAL",Assets.CAFETIERE_NORMAL_FRAMES,Assets.ANIMATION_FRAMERATE,true);
			_cafetiere.addAnimation("PLUNGING",Assets.CAFETIERE_PLUNGE_FRAMES,Assets.ANIMATION_FRAMERATE,false);
			_cafetiere.replaceColor(0xFF00C73E, _currentLowerColour);
			_cafetiere.replaceColor(0xFFef1b26,_currentUpperColour);
			_cafetiere.visible = false;

			_strengthMeter = new AccuracyMeter(10*6, "COFFEE STRENGTH",Assets.ACCURACY_METER_PNG);
			
			_strengthMeter.setVisible(false);
			
			add(_cafetiere);
			add(_strengthMeter);
			
			super.create();
			
			FlxG.bgColor = 0xFF000000;
			
			_conversationNPC.setText(Assets.CAFETIERE_NPC);	
			_conversationPlayer.setText(Assets.CAFETIERE_PLAYER);			
			_instructions.setText(Assets.CAFETIERE_INSTRUCTIONS);	
			
			for (var i:int = 0; i < Assets.CAFETIERE_INTERJECTIONS.length; i++)
			{
				_interjections.push(Assets.CAFETIERE_INTERJECTIONS[i]);
			}
		}
		
		
		protected override function startPlay(t:FlxTimer):void
		{
			super.startPlay(t);
			
			_cafetiereState = NONE;
			
			_strengthMeter.setVisible(true);
		}
		
		
		public override function update():void
		{
			super.update();	
			
			
			if (_state == COMPLETE && !_result.isVisible())
			{			
				_state = NONE;
				_messageTimer.start(0.5,1,showResult);
			}
			
			if (_state == PLAYING)
			{
				
				if (_interjection.isVisible())
				{
					_strengthMeter.setVisible(false);
				}
				else
				{
					_strengthMeter.setVisible(true);
				}
				
				_timeElapsed += FlxG.elapsed;
				if (_timeElapsed - _lastPressTime > MAX_KEY_DELAY)
				{
					_cafetiere.active = false;
				}
				
				_strength += STRENGTH_INCREMENT;
				if (_strength > 1.0) _strength = 1.0;

				setMeters();
				
				if (_strength > _nextColourIncrement)
				{
					setCoffeeColour();
					_nextColourIncrement += 0.1;
				}
				
				if ( _cafetiereState == PLUNGING && _cafetiere.finished )
				{
					_cafetiereState = PLUNGED;
				}
				
				if ( _cafetiereState == PLUNGED )
				{
					_state = COMPLETE;
					stageOver();
				}	
				
				handleInput();
				handlePlungeState();
			}

		}
		
		
		protected override function gotoNextState():void
		{
			FlxG.switchState(new SugarState);
		}
		
		
		protected override function gotoRetryState():void
		{
			FlxG.switchState(new CafetiereState);
		}
		
		
		protected override function gotoInstructions(t:FlxTimer):void
		{
			FlxG.bgColor = 0xFF886677;
			
			_conversationPlayer.makeInvisible();
			
			_strengthMeter.setVisible(true);
			
			_cafetiere.visible = true;
			
			super.gotoInstructions(t);
		}
		
		
		protected override function showInstructions(t:FlxTimer):void
		{
			_strengthMeter.setVisible(false);
			
			super.showInstructions(t);
		}
		
		
		protected override function showResult(t:FlxTimer):void
		{					
			_strengthMeter.setVisible(false);
			
			super.showResult(t);
		}
		
		
		protected override function stageOver():void
		{
			
		}
		
		
		private function handleCafetiereInput():void
		{
			
		}
		
		
		
		private function handleInput():void
		{
			if (_state == PLAYING && FlxG.keys.justPressed("DOWN"))
			{
				_pressCount++;
			}
		}
		
		
		private function handlePlungeState():void
		{
			if (_pressCount >= PLUNGE_INPUT_NUM)
			{
				_pressCount = 0;
				_cafetiere.frame = _cafetiere.frame + 1;
				if (_cafetiere.frame == 15)
				{
					_state = PLUNGED;
				}
			}
		}
		
	
		
		
		private function setMeters():void
		{
			_strengthMeter.setIndicator(_strength);
		}
		
		
		private function setCoffeeColour():void
		{	
			var currentRed:uint = (_currentLowerColour >> 16) & 0xFF;
			var currentGreen:uint = (_currentLowerColour >> 8) & 0xFF;
			var currentBlue:uint = _currentLowerColour & 0x000000FF;
			
			currentRed -= 8;
			currentGreen -= 4;
			currentBlue -= 4;
			
			var newLowerColour:uint = 0xFF000000 | (currentRed << 16) | (currentGreen << 8) | (currentBlue);
			
			_cafetiere.replaceColor(_currentLowerColour,newLowerColour);
			
			_currentLowerColour = newLowerColour;
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			Globals.STRENGTH = _strengthMeter.getIndicator();

			
			_cafetiere.destroy();
			
			_strengthMeter.destroy();
		}
	}
}