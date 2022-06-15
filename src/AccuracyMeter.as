package
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.*;
	
	
	public class AccuracyMeter extends FlxGroup
	{
		private const METER_LENGTH:Number = 300;
		
		private var _meterBG:FlxSprite;
		private var _meterIndicator:FlxSprite;
		private var _meterText:TextField;
		private var _meterTextFormat:TextFormat = new TextFormat("Commodore",18,0xFFFFFF,null,null,null,null,null,"center");
		
		private var _indicatorAmount:Number = 0.0;
		
		
		public function AccuracyMeter(Y:Number, title:String, meterClass:Class)
		{
			super();
			
			_meterBG = new FlxSprite();
			
			_meterBG.loadGraphic(meterClass);
			_meterBG.x = FlxG.width/2 - _meterBG.width/2;
			_meterBG.y = Y;
			
			_meterIndicator = new FlxSprite();
			_meterIndicator.makeGraphic(6,12,0xFFFFFF00);
			_meterIndicator.x = _meterBG.x + 6; 
			_meterIndicator.y = _meterBG.y + 6;
			_meterIndicator.origin.x = 0;
			
			_meterText = new TextField();
			_meterText.defaultTextFormat = _meterTextFormat;
			_meterText.text = title;
			_meterText.x = 0; 
			_meterText.y = (_meterBG.y * Globals.ZOOM) - 25;
			_meterText.width = FlxG.width*Globals.ZOOM;
			_meterText.wordWrap = true;
			_meterText.embedFonts = true;
			_meterText.selectable = false;
			
			add(_meterBG);
			add(_meterIndicator);
			FlxG.stage.addChild(_meterText);
		}
		
		
		public function setIndicator(amount:Number):void
		{
			_indicatorAmount = amount;
			if (_indicatorAmount > 1) _indicatorAmount = 1;
			_meterIndicator.x = (_meterBG.x + 6) + Math.ceil(_indicatorAmount * METER_LENGTH - 6);
			
			if (_meterIndicator.x < _meterBG.x + 6) _meterIndicator.x = _meterBG.x + 6;
			if (_meterIndicator.x > _meterBG.x + 6 + METER_LENGTH - 6) _meterIndicator.x = _meterBG.x + 6 + METER_LENGTH - 6;
		}
		
		
		public function getIndicator():Number
		{
			return _indicatorAmount;
		}
		
		
		public function setVisible(visibility:Boolean):void
		{
			_meterBG.visible = visibility;
			_meterIndicator.visible = visibility;
			_meterText.visible = visibility;
		}
		
		
		public override function update():void
		{
			super.update();
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			_meterBG.destroy();
			_meterIndicator.destroy();
			if (FlxG.stage.contains(_meterText)) FlxG.stage.removeChild(_meterText);
		}
		
		
		
	}
}