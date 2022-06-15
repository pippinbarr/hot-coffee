package
{
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class KettleState extends GameState
	{
		// CONSTANTS
		
		private const MIN_QTE_DELAY:Number = 0.5;
		private const MAX_QTE_DELAY:Number = 2.0;
		
		private const QTE_RESPONSE_TIME:Number = 2.0;
		private const BOIL_TIME:Number = 30.0;
		
		private const BOILING_TIME:Number = 2.0;
		
		
		
		// STATE
		
		private const NONE:uint = 0;
		private const HEATING:uint = 1;
		private const BOILING:uint = 2;
		private const BOILED:uint = 3;
		private const POSTBOIL:uint = 4;
		private const QTE:uint = 5;
		
		private var _kettleState:uint = NONE;
		
		
		// GRAPHICS
		
		// KETTLE
		private var _kettle:FlxSprite;
		private var _kettleBase:FlxSprite;
		
		// BOIL UI
		private var _boilMeter:FillMeter;
		
		
		// QUICK TIME EVENTS
		
		// QTE KEYS
		private var _qteKeyIndex:int = -1;
		
		private var _keys:Array = new Array(
			"A", "B", "C", "D", "E", "F",
			"G", "H", "I", "J", "K", "L",
			"M", "N", "O", "P", "Q", "R",
			"S", "T", "U", "V", "W", "X", 
			"Y", "Z");
		
		private var _letters:Array = new Array(
			"A", "B", "C", "D", "E", "F", "G", "H", "I",
			"J", "K", "L", "M", "N", "O", "P", "Q", "R",
			"S", "T", "U", "V", "W", "X", "Y", "Z");
		
		// QTE STATES
		private const NOT_TRIGGERED:uint = 0;
		private const TRIGGERED:uint = 1;
		private const SUCCESS:uint = 2;
		private const FAILURE:uint = 3;
		
		private var _qteState:uint = NOT_TRIGGERED;
		
		// QTE UI
		private var _qteText:TextField;
		private var _qteTextFormat:TextFormat = new TextFormat("Commodore",18,0xFFFFFF,null,null,null,null,null,"center");
		private var _qteTextBG:FlxSprite;
		
		private const QTE_MIN_Y:uint = 300;
		private const QTE_MAX_Y:uint = 400;
		
		// QTE TIMING
		private var _qteTimer:FlxTimer;
		
		
		// BOIL TIMING
		private var _boilTimer:FlxTimer;
		private var _boilAmount:Number = 0.0;
		
		private var _endTimer:FlxTimer;
		
		
		public function KettleState()
		{
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFF000000;
			
			_kettle = new FlxSprite(15*6,30*6);
			_kettle.loadGraphic(Assets.KETTLE_PNG,true,false,50*6,50*6);
			_kettle.addAnimation("BOILING",Assets.KETTLE_BOIL_FRAMES,Assets.ANIMATION_FRAMERATE,true);
			_kettle.addAnimation("POSTBOILED",Assets.KETTLE_POSTBOILED_FRAMES,Assets.ANIMATION_FRAMERATE,true);
			_kettle.addAnimation("SUBSIDING",Assets.KETTLE_SUBSIDE_FRAMES,Assets.ANIMATION_FRAMERATE,false);
			
			_kettleBase = new FlxSprite(15*6,30*6);
			_kettleBase.loadGraphic(Assets.KETTLE_BASE_PNG,false);
			
			_boilMeter = new FillMeter(10*6, "TIME TO BOIL");
			_boilMeter.setVisible(false);
			
			_qteText = new TextField();
			_qteText.width = 5*6*Globals.ZOOM;
			_qteText.defaultTextFormat = _qteTextFormat;
			_qteText.embedFonts = true;
			_qteText.selectable = false;
			
			_qteTextBG = new FlxSprite();
			_qteTextBG.makeGraphic(5*6,5*6,0xFF333333);
			
			add(_kettleBase);
			add(_kettle);
			add(_boilMeter);
			
			_kettleBase.visible = false;
			_kettle.visible = false;
			
			_qteTimer = new FlxTimer();
			_boilTimer = new FlxTimer();
			_endTimer = new FlxTimer();
			
			_conversationNPC.setText(Assets.KETTLE_NPC);	
			_conversationPlayer.setText(Assets.KETTLE_PLAYER);			
			_instructions.setText(Assets.KETTLE_INSTRUCTIONS);	
			
			for (var i:int = 0; i < Assets.KETTLE_INTERJECTIONS.length; i++)
			{
				_interjections.push(Assets.KETTLE_INTERJECTIONS[i]);
			}
		}
		
		
		protected override function startPlay(t:FlxTimer):void
		{
			super.startPlay(t);
			
			_kettleState = HEATING;
			
			_qteState = NOT_TRIGGERED;
			_qteTimer.start(2,1,triggerQTE);
			
			_boilMeter.setVisible(true);
			
			_boilTimer.start(BOIL_TIME,1);
		}
		
		
		public override function update():void
		{
			super.update();	
			
			
			if (_state == COMPLETE && _kettle.y + _kettle.height < 0 && !_result.isVisible() && _kettle.velocity.y != 0)
			{
				_kettle.velocity.y = 0;
				
				_messageTimer.start(1,1,showResult);
			}
			
			if (_state == PLAYING)
			{
				if (_kettleState == HEATING && !_boilTimer.finished)
				{
					_boilMeter.setFill(_boilTimer.progress);
				}
				
				if (_interjection.isVisible())
				{
					_boilMeter.setVisible(false);
				}
				else
				{
					_boilMeter.setVisible(true);
				}
				
				if (_kettleState == QTE)
				{
					handleQTEInput();
				}
				
				if (_kettleState == HEATING && _boilTimer.finished)
				{
					_boilMeter.setFill(1);
					_kettleState = BOILING;
					_kettle.play("BOILING");
					_endTimer.start(BOILING_TIME,1,finishBoiling);
				}
				

			}
		}
		
		
		protected override function gotoNextState():void
		{
			FlxG.switchState(new GrinderState);
		}

		
		protected override function gotoRetryState():void
		{
			FlxG.switchState(new KettleState);
		}
		
		
		private function finishBoiling(t:FlxTimer):void
		{
			_kettleState = POSTBOIL;
			_kettle.play("POSTBOILED");
			_endTimer.start(1.5,1,finishPostboil);
		}
		
		
		private function finishPostboil(t:FlxTimer):void
		{
			_kettleState = BOILED;
			_kettle.play("SUBSIDING");
			_endTimer.start(2,1,finishSubsiding);
		}
		
		
		private function finishSubsiding(t:FlxTimer):void
		{
			_state = COMPLETE;
			stageOver();
		}
				
		
		private function finishSubside(t:FlxTimer):void
		{
			_state = COMPLETE;
		}
		
		protected override function gotoInstructions(t:FlxTimer):void
		{
			FlxG.bgColor = 0xFF778866;
			
			_conversationPlayer.makeInvisible();
			
			_boilMeter.setVisible(false);

			_kettleBase.visible = true;
			_kettle.visible = true;
			
			super.gotoInstructions(t);
		}
		
		
		protected override function showInstructions(t:FlxTimer):void
		{
			_boilMeter.setVisible(false);

			super.showInstructions(t);
		}
		
		
		protected override function showResult(t:FlxTimer):void
		{					
			_boilMeter.setVisible(false);
			
			super.showResult(t);
		}
		
		
		private function triggerQTE(t:FlxTimer):void
		{
			if (_kettleState == BOILING || _kettleState == BOILED)
				return;
			
			_boilTimer.paused = true;
			
			_kettleState = QTE;
			_qteState = TRIGGERED;
			
			if (Math.random() > 0.5)
			{
				_qteText.x = FlxG.width * Globals.ZOOM * 1 / 4 - _qteTextBG.width/2;
				_qteTextBG.x = FlxG.width * Globals.ZOOM * 1 / 4  - _qteTextBG.width/2;
			}
			else
			{
				_qteText.x = FlxG.width * Globals.ZOOM * 3 / 4  - _qteTextBG.width/2;
				_qteTextBG.x = FlxG.width * Globals.ZOOM * 3 / 4  - _qteTextBG.width/2;
			}
			
			_qteTextBG.y = Math.random() * (QTE_MAX_Y - QTE_MIN_Y) + QTE_MIN_Y; 
			_qteText.y = _qteTextBG.y + 3;			
			
			
			_qteKeyIndex = Math.floor(Math.random() * _keys.length);
			_qteText.text = _letters[_qteKeyIndex];
			
			add(_qteTextBG);
			FlxG.stage.addChild(_qteText);
			
			_qteTimer.start(QTE_RESPONSE_TIME,1,qteFailed);
		}
		
		
		private function qteFailed(t:FlxTimer):void
		{
			_qteTimer.stop();
			
			remove(_qteTextBG);
			FlxG.stage.removeChild(_qteText);
			
			// HANDLE FUCKING UP
			_state = COMPLETE;
			_kettleState == NONE;
			_boilAmount = _boilTimer.progress;
			
			_boilTimer.stop();
			
			stageOver();
		}
		
		
		protected override function stageOver():void
		{
			_boilTimer.stop();
			_qteTimer.stop();
			
			_kettle.velocity.y = -50*6;
		}
		
		
		private function qteSucceeded():void
		{
			_qteTimer.stop();
			
			remove(_qteTextBG);
			FlxG.stage.removeChild(_qteText);
			
			_boilTimer.paused = false;
			_kettleState = HEATING;
			
			_qteTimer.start(0.5,1,resetTrigger);
		}
		
		
		private function resetTrigger(t:FlxTimer):void
		{
			_qteState = NOT_TRIGGERED;
			
			_qteTimer.start(Math.random() * MAX_QTE_DELAY + MIN_QTE_DELAY,1,triggerQTE);
		}
		
		
		private function handleQTEInput():void
		{
			
			if (FlxG.keys.justPressed(_keys[_qteKeyIndex]))
			{
				qteSucceeded();
			}
			else if (FlxG.keys.any())
			{
				qteFailed(null);
			}
			return;
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			Globals.HEAT = _boilMeter.getFill();
			
			_kettle.destroy();
			_kettleBase.destroy();
			
			_boilMeter.destroy();
			
			_qteTimer.destroy();
			_qteTextBG.destroy();
						
			if (FlxG.stage.contains(_qteText)) FlxG.stage.removeChild(_qteText);
		}
	}
}