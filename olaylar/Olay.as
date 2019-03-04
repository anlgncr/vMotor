package vMotor.olaylar
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author anıl
	 */
	public class Olay extends Event 
	{
		public static var HOKKABAZDAN_SILINDI:String = "HokkabazdanSilindi";
		public static var TAMAMLANDI:String = "Tamamlandi";
		
		
		public function Olay(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new Olay(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("Olaylar", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}