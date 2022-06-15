package
{
	import org.flixel.*;
	
	
	public class EndState extends FlxState
	{
		private const NONE:uint = 3;
		private const TITLE:uint = 2;
		private const FADE:uint = 4;
		
		private var _state:uint = FADE;
		
		private var _mask:FlxSprite;
		private var _splash:FlxSprite;
		private var _hot:FlxText;
		private var _coffee:FlxText;
		
		private var _conversationTimer:FlxTimer;
		
		public function EndState()
		{
			super();
		}
		
		
		public override function create():void
		{
			super.create();
			
			FlxG.bgColor = 0xFF000000;
			
			_mask = new FlxSprite(0,0);
			_mask.makeGraphic(FlxG.width,FlxG.height,0xFF000000);
			
			_splash = new FlxSprite(0,0,Assets.AFTER_SPLASH_PNG);
			
			_hot = new FlxText(-5,85,FlxG.width,"THE",true);
			_hot.setFormat(null,64,0xFFFFFF,"center");
			_coffee = new FlxText(5,320,FlxG.width,"END",true);
			_coffee.setFormat(null,64,0xFFFFFF,"center");
						
			add(_splash);
			add(_mask);
			
			_conversationTimer = new FlxTimer();
		}
		
		
		public override function update():void
		{
			super.update();
			
			if (_mask.alpha > 0 && _state == FADE)
			{
				_mask.alpha -= 0.01;
			}
			else if (_state == FADE)
			{
				_conversationTimer.start(2,1,showTitleOne);
				_state = TITLE;
			}
		}
		
		
		private function showTitleOne(t:FlxTimer):void
		{
			add(_hot);
			_conversationTimer.start(1,1,showTitleTwo);
		}
		
		private function showTitleTwo(t:FlxTimer):void
		{
			add(_coffee);
		}
		
		
		public override function destroy():void
		{
			super.destroy();
			
			_hot.destroy();
			_coffee.destroy();
			
			_conversationTimer.destroy();
		}
	}
}