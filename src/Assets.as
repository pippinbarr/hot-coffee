package
{
	public class Assets
	{
		// TEXTS
		
		public static const KETTLE_NPC:String = "" +
			"\"WOULD YOU MAKE THE COFFEE FOR ME? PUT THE KETTLE ON, HONEY, AND BOIL US UP SOME " +
			"NICE, HOT WATER...\"";
		
		public static const KETTLE_PLAYER:String = "" +
			"\"OKAY...\"";

		public static const KETTLE_INSTRUCTIONS:String = "" +
			"PRESS THE INDICATED KEYS AS THEY APPEAR IN TIME TO HOLD YOURSELF BACK " +
			"FROM GETTING TOO EXCITED AND TAKING THE KETTLE BEFORE IT HAS " +
			"BOILED.";

		public static const KETTLE_INTERJECTIONS:Array = new Array(
				"GOT TO LET IT NICE AND HOT FIRST...",
				"WE WANT IT BOILING FOR A REALLY HOT COFFEE.",
				"I LOVE A NICE, HOT COFFEE, DON'T YOU?",
				"IT'S GETTING HOT IN THERE...",
				"HOLD BACK UNTIL THE LAST MINUTE...",
				"WARM COFFEE'S NO GOOD, IT HAS TO BE HOT.",
				"DON'T PULL THE KETTLE OFF TOO SOON!",
				"LET IT BOIL...",
				"THAT KETTLE'S GETTING SO HOT.",
				"HOTTER! HOTTER!");	
		
		
		public static const GRINDER_NPC:String = "" +
			"\"COULD YOU GRIND THE BEANS? THEY'RE SO FRESH! I BOUGHT THEM TODAY " +
			"JUST IN CASE WE HAD COFFEE TONIGHT...\"";
		
		public static const GRINDER_PLAYER:String = "" +
			"\"OKAY...\"";
		
		public static const GRINDER_INSTRUCTIONS:String = "" +
			"HOLD [SPACE] TO GRIND UNTIL THE INDICATORS ARE IN THE GREEN. " +
			"JERK THE GRINDER [UP] AND [DOWN] TO GET A BETTER CONSISTENCY.";
		
		public static const GRINDER_INTERJECTIONS:Array = new Array(
			"GRIND THOSE BEANS LIKE YOU MEAN IT!",
			"I'M LOVING WATCHING YOU GRIND...",
			"KEEP DOING WHAT YOU'RE DOING!",
			"SHAKE THAT THING! SHAKE IT!",
			"GRIND! GRIND! GRIND!",
			"KEEP ON GRINDING!",
			"GETTING TIRED?",
			"KEEP IT UP!",
			"A GOOD GRIND IS HARD TO FIND!",
			"YOU LOOK SO INTENSE!");	

		
		public static const CAFETIERE_NPC:String = "" +
			"\"NOW LET'S LET IT SIT FOR A MINUTE WHILE IT GETS NICE AND STRONG. " +
			"DON'T PLUNGE IT IN TOO SOON! YOU HAVE TO WAIT A WHILE...\"";
		
		public static const CAFETIERE_PLAYER:String = "" +
			"\"OKAY...\"";
		
		public static const CAFETIERE_INSTRUCTIONS:String = "" +
			"WAIT FOR THE INDICATOR TO REACH THE GREEN ZONE BEFORE " +
			"PLUNGING BY RAPIDLY PRESSING [DOWN] " +
			"TO ACHIEVE A PERFECT STRENGTH.";

		public static const CAFETIERE_INTERJECTIONS:Array = new Array(
				"DON'T PLUNGE IT IN TOO SOON...",
				"HOLDING BACK IS THE SECRET TO GREAT COFFEE...",
				"IT'S GETTING NICE AND STRONG...",
				"I LIKE IT STRONG.",
				"DON'T PLUNGE TOO HARD OR YOU MIGHT GET BURNED!",
				"YOU'RE DOING SUCH A GREAT JOB!",
				"THIS COFFEE'S GOING TO BE AMAZING!",
				"I CAN'T WAIT TO TRY YOUR COFFEE...",
				"THE SUSPENSE IS KILLING ME...",
				"IS IT READY FOR YOU TO PLUNGE IT IN YET?");
		
		
		public static const SUGAR_NPC:String = "" +
			"\"GIVE ME SOME SUGAR, WOULD YA? HA HA.\"";
		
		public static const SUGAR_PLAYER:String = "" +
			"\"OKAY...\"";
		
		public static const SUGAR_INSTRUCTIONS:String = "" +
			"HOLD [SPACE] TO POUR SUGAR INTO THE CUP " +
			"UNTIL THE INDICATOR IS IN THE GREEN.";

		public static const SUGAR_INTERJECTIONS:Array = new Array(
			"I LIKE IT SWEET.",
			"I HAVE A REAL SWEET TOOTH WHEN IT COMES TO COFFEE.",
			"POUR IT IN THERE!",
			"DON'T HOLD BACK!",
			"GIVE ME SOME SUGAR, SUGAR! HA HA.",
			"I TAKE IT HOT AND SWEET.",
			"SWEET, PLEASE.",
			"GIVE ME SOME SWEET, SWEETIE! HA HA..",
			"NOT TOO SWEET, I'M QUITE SWEET MYSELF!",
			"THERE IS SUCH A THING AS TOO SWEET!");	
			
		
		
		public static const MILK_NPC:String = "" +
			"\"I LIKE A SPLASH OF MILK IN MY COFFEE...\"";
		
		public static const MILK_PLAYER:String = "" +
			"\"OKAY...\"";
		
		public static const MILK_INSTRUCTIONS:String = "" +
			"HOLD [SPACE] TO BEGIN MOVING THE MILK JUG OVER THE CUP " +
			"AND RELEASE WHEN IT'S IN JUST THE RIGHT PLACE, " +
			"WITH THE INDICATOR IN THE GREEN.";

		
		public static const MILK_INTERJECTIONS:Array = new Array(
			"DON'T SPILL YOUR MILK ON THE BENCH...",
			"MAKE SURE YOU DON'T SPILL IT!",
			"GET THAT MILK IN MY CUP!",
			"I LIKE MY COFFEE CREAMY.",
			"MILK, PLEASE.",
			"GIVE ME SOME MILK.",
			"I LIKE A SPLASH OF MILK IN THERE.",
			"CAREFUL WITH THAT THING!",
			"WHY ARE YOU WAVING IT AROUND LIKE THAT?",
			"FOCUS! DON'T LET IT GO TOO EARLY...");	

		
		public static const ANIMATION_FRAMERATE:uint = 7;
		
		// UI ELEMENTS
		
		[Embed(source="assets/fonts/Commodore Pixelized v1.2.ttf", fontName="Commodore", fontWeight="Regular", embedAsCFF="false")]
		public static const COMMODORE_FONT:Class;
		
		[Embed(source="assets/sprites/accuracy_meter.png")]
		public static const ACCURACY_METER_PNG:Class;
		
		[Embed(source="assets/sprites/fill_meter.png")]
		public static const FILL_METER_PNG:Class;

		[Embed(source="assets/sprites/milk_meter.png")]
		public static const MILK_METER_PNG:Class;
		
		
		
		// INTRO/OUTTRO/EVAL
		
		[Embed(source="assets/sprites/splash.png")]
		public static const SPLASH_PNG:Class;

		[Embed(source="assets/sprites/after_splash.png")]
		public static const AFTER_SPLASH_PNG:Class;
		
		[Embed(source="assets/sprites/cups.png")]
		public static const CUPS_PNG:Class;
		
		
		// KETTLE STAGE
		
		[Embed(source="assets/sprites/kettle.png")]
		public static const KETTLE_PNG:Class;
		public static const KETTLE_NORMAL_FRAMES:Array = new Array(0,0);
		public static const KETTLE_BOIL_FRAMES:Array = new Array(1,3,2,3,1,2,1,3);
		public static const KETTLE_POSTBOILED_FRAMES:Array = new Array(4,6,5,6,4,5,4,6);
		public static const KETTLE_SUBSIDE_FRAMES:Array = new Array(4,5,6,7);
		
		[Embed(source="assets/sprites/kettle_base.png")]
		public static const KETTLE_BASE_PNG:Class;
		
		// GRINDER STAGE
		
		[Embed(source="assets/sprites/grinder.png")]
		public static const GRINDER_PNG:Class;
		public static const GRINDER_NORMAL_FRAMES:Array = new Array(0,0);
		public static const GRINDER_GRINDING_FRAMES:Array = new Array(1,2,3,4,5);
		public static const GRINDER_GROUND_FRAMES:Array = new Array(6,6);
		
		// CAFETIERE STAGE
		
		[Embed(source="assets/sprites/cafetiere.png")]
		public static const CATETIERE_PNG:Class;
		public static const CAFETIERE_NORMAL_FRAMES:Array = new Array(0,0);
		public static const CAFETIERE_PLUNGE_FRAMES:Array = new Array(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
		
		// SUGAR STAGE / CUP
		
		[Embed(source="assets/sprites/cup.png")]
		public static const CUP_PNG:Class;
		public static const CUP_NORMAL_FRAMES:Array = new Array(0,0);
		public static const CUP_MILKED_FRAMES:Array = new Array(1,1);

		// MILK STAGE
		
		[Embed(source="assets/sprites/milk_jug.png")]
		public static const MILK_JUG_PNG:Class;
		public static const MILK_JUG_NORMAL_FRAMES:Array = new Array(0,0);
		public static const MILK_JUG_POUR_SUCCESS_FRAMES:Array = new Array(1,2,3,4,5,6);
		public static const MILK_JUG_SHORT_FRAMES:Array = new Array(7,8,9,10,11,12,13,14);
		public static const MILK_JUG_LONG_FRAMES:Array = new Array(15,16,17,18,19,20,21,22,23);
		
		// SOUNDS
				
		[Embed(source="assets/sounds/soundtrack.mp3")]
		public static const SOUNDTRACK_MP3:Class;
		
		
		
		
		public function Assets()
		{
		}
	}
}