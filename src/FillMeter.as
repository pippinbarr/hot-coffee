package
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import org.flixel.*;

	
	public class FillMeter extends FlxGroup
	{
		private const METER_LENGTH:Number = 50*6;
		
		private var _meterBG:FlxSprite;
		private var _meterFill:FlxSprite;
		private var _meterText:TextField;
		private var _meterTextFormat:TextFormat = new TextFormat("Commodore",18,0xFFFFFF,null,null,null,null,null,"center");

		private var _fillAmount:Number = 0.0;
		
		
		public function FillMeter(Y:Number, title:String)
		{
			super();
			
			_meterBG = new FlxSprite();
			_meterBG.loadGraphic(Assets.FILL_METER_PNG);
			_meterBG.x = FlxG.width/2 - _meterBG.width/2;
			_meterBG.y = Y;
			
			_meterFill = new FlxSprite();
			_meterFill.makeGraphic(1,2*6,0xFFFF0000);
			_meterFill.x = FlxG.width/2 - _meterBG.width/2 + 1*6;
			_meterFill.y = _meterBG.y + 1*6;
			_meterFill.origin.x = 0;
			_meterFill.scale.x = 0;
			
			_meterText = new TextField();
			_meterText.defaultTextFormat = _meterTextFormat;
			_meterText.text = title;
			_meterText.x = 0; 
			_meterText.y = _meterBG.y * Globals.ZOOM - 25;
			_meterText.width = FlxG.width*Globals.ZOOM;
			_meterText.wordWrap = true;
			_meterText.embedFonts = true;
			_meterText.selectable = false;
			
			add(_meterBG);
			add(_meterFill);
			FlxG.stage.addChild(_meterText);
		}
		
		
		public function setFill(amount:Number):void
		{
			trace("Set fillAmount to " + amount);
			_fillAmount = amount;
			_meterFill.scale.x = Math.ceil(_fillAmount * METER_LENGTH);
			trace("Math.ceil(_fillAmount * METER_LENGTH) == " + _meterFill.scale.x);
		}
		
		
		public function getFill():Number
		{
			return _fillAmount;
		}
		
		
		public function setVisible(visibility:Boolean):void
		{
			_meterBG.visible = visibility;
			_meterFill.visible = visibility;
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
			_meterFill.destroy();
			if (FlxG.stage.contains(_meterText)) FlxG.stage.removeChild(_meterText);
		}
		
		

	}
}