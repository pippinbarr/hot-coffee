package
{
	
	import org.flixel.*;
	
	[SWF(width = "480", height = "480", backgroundColor = "#FFFFFF")]
	[Frame(factoryClass="HotCoffeePreloader")]

	public class HotCoffee extends FlxGame
	{
		public function HotCoffee()
		{
			super(480,480,TitleState,Globals.ZOOM,30,30);
			
			//this.useSoundHotKeys = false;
			this.forceDebugger = true;
			FlxG.volume = 1.0;
		}
	}
}