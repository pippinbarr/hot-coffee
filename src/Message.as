package
{
	import flash.events.KeyboardEvent;
	import flash.text.*;
	import flash.ui.Keyboard;
	
	import org.flixel.*;
	
	public class Message extends FlxGroup
	{
		private const INTERJECTION_TIME:Number = 1;
		
		private var _y:Number;
		private var _bg:uint;
		private var _interjection:Boolean;
		private var _showEnter:Boolean;
		private var _interjectionTimer:FlxTimer;
		
		private const MESSAGE_TIME:uint = 10;
		
		private var _destroy:Boolean = false;
		
		private var _outerBox:FlxSprite;
		private var _innerBox:FlxSprite;
		
		private var _text:TextField;
		private var _textFormat:TextFormat = new TextFormat("Commodore",18,0xFFFFFF,null,null,null,null,null,"left",null,null,null,null);
		private var _enterTextFormat:TextFormat = new TextFormat("Commodore",18,0xFFFFFF,null,null,null,null,null,"center",null,null,null,null);

		private var _enterText:TextField;
		
		
		public function Message(Y:Number, BG:uint, Interjection:Boolean = false, ShowEnter:Boolean = true)
		{						
			super();
				
			_y = Y;
			_bg = BG;
			_interjection = Interjection;
			_showEnter = ShowEnter;
			
			_interjectionTimer = new FlxTimer();

			_text = new TextField();
			_outerBox = new FlxSprite();
			_innerBox = new FlxSprite();
			_enterText = new TextField();
		}
		
		
		public override function update():void 
		{
			super.update();
		}
			
		
		public function setText(text:String):void
		{
			_text.defaultTextFormat = _textFormat;
			_text.embedFonts = true;
			_text.wordWrap = true;
			_text.autoSize = "center";
			_text.selectable = false;
			
			_text.text = text;
			
			_text.width = 50*6 * Globals.ZOOM; 
			
			_text.x = (FlxG.width * Globals.ZOOM) / 2 - (_text.width / 2);
			//_text.y = (FlxG.height * Globals.ZOOM) / 2 - (_text.height / 2);
			_text.y = (_y + 3*6) * Globals.ZOOM;
			
			
			_outerBox.makeGraphic((_text.width / Globals.ZOOM) + 6*6,(_text.height / Globals.ZOOM) + 6*6,0xFFFFFFFF);
			_outerBox.x = (_text.x / Globals.ZOOM) - 3*6;
			_outerBox.y = (_text.y / Globals.ZOOM) - 3*6;
			
			this.add(_outerBox);
			
			_innerBox.makeGraphic((_text.width / Globals.ZOOM) + 4*6,(_text.height / Globals.ZOOM) + 4*6,_bg);
			_innerBox.x = _outerBox.x + 1*6;
			_innerBox.y = _outerBox.y + 1*6;
			
			this.add(_innerBox);
			
			_text.y -= 5;
			
			_enterText.defaultTextFormat = _enterTextFormat;
			_enterText.embedFonts = true;
			_enterText.wordWrap = true;
			_enterText.autoSize = "center";
			_enterText.selectable = false;
			
			if (!_interjection && _showEnter)
				_enterText.text = "( PRESS ENTER )";
			
			_enterText.width = 50*6 * Globals.ZOOM; 
			_enterText.x = (FlxG.width * Globals.ZOOM) / 2 - (_text.width / 2);
			_enterText.y = (_outerBox.y + _outerBox.height) * Globals.ZOOM + 10;
			
			FlxG.stage.addChild(_text);
			FlxG.stage.addChild(_enterText);
			
			
			_text.text = text;
			
			trace("x = " + _text.x);
			
			if (_interjection)
				this.makeInvisible(null);

		}
		
		
		public function showInterjection():void
		{
			this.makeVisible();
			
			_interjectionTimer.start(INTERJECTION_TIME,1,makeInvisible);
		}
		
		
		public function makeInvisible(t:FlxTimer = null):void 
		{
			_outerBox.visible = false;
			_innerBox.visible = false;
			_text.visible = false;
			_enterText.visible = false;
			FlxG.stage.focus = null;
		}
		
		
		public function makeVisible():void 
		{
			_outerBox.visible = true;
			_innerBox.visible = true;
			_text.visible = true;
			_enterText.visible = true;
			FlxG.stage.focus = null;
		}
		
		
		public function isVisible():Boolean
		{
			return _text.visible;
		}
		
		public override function destroy():void 
		{
			
			super.destroy();

			this._textFormat = null;
			
			_outerBox.destroy();
			_innerBox.destroy();
			
			if (FlxG.stage.contains(_text)) FlxG.stage.removeChild(_text);	
			if (FlxG.stage.contains(_enterText)) FlxG.stage.removeChild(_enterText);			
		}
	}
}