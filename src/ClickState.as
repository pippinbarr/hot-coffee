/**
 * Atari 2600 Breakout
 * In Flixel 2.5
 * By Richard Davey, Photon Storm
 * In 20mins :)
 * 
 * Modified by Pippin Barr
 * In way longer :(
 */
package  
{
	import flash.events.MouseEvent;
	
	import org.flixel.*;
	
	public class ClickState extends FlxState
	{	
		private var _instructionsText:FlxText;
		
		
		public function ClickState() 
		{
		}
		
		override public function create():void
		{	
			_instructionsText = new FlxText(0,200,FlxG.width,"[ CLICK ]",true);
			_instructionsText.setFormat(null,64,0xFFFFFFFF,"center");
			
			add(_instructionsText);
			
			FlxG.stage.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		
		override public function update():void
		{
			super.update();
		}
		
		
		
		
		
		private function onMouseUp(e:MouseEvent):void
		{
			FlxG.stage.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			FlxG.switchState(new TitleState);
		}
		
		
		public override function destroy():void
		{
			_instructionsText.destroy();
		}
		
		
	}
	
}