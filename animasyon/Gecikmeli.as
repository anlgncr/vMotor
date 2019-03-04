package vMotor.animasyon
{
	import flash.events.EventDispatcher;
	import vMotor.olaylar.Olay;
	/**
	 * ...
	 * @author anıl
	 */
	public class Gecikmeli extends EventDispatcher implements Zamansal
	{
		
		public var simdikiZaman:Number;
		public var gecikmeSuresi:Number;
		public var yontemim:Function;
		public var parametrelerim:Array;
		private var tekrarSayisi:int;
		public var nesnem:Object;
		
		public function Gecikmeli(yontem:Function, gecikme:Number, parametreler:Array = null)
		{
			sifirla(yontem, gecikme, parametreler);
		}
		
		public function sifirla(yontem:Function, gecikme:Number, parametreler:Array = null):Gecikmeli
		{
			simdikiZaman = 0;
			gecikmeSuresi = Math.max(0.0001, gecikme);
			parametrelerim = parametreler;
			yontemim = yontem;
			tekrarSayisi = 1;
			
			return this; //Havuz için
		}
		
		public function gosteriZamani(zaman:Number):void
		{
			var oncekiZaman:Number = simdikiZaman;
			simdikiZaman = Math.min(gecikmeSuresi, simdikiZaman + zaman);
			
			if (oncekiZaman< gecikmeSuresi && simdikiZaman>=gecikmeSuresi)
			{
				if (tekrarSayisi == 0 || tekrarSayisi > 1)
				{
					yontemim.apply(null, parametrelerim);
					
					if (tekrarSayisi > 0) 
						tekrarSayisi -= 1;
						
					simdikiZaman = 0;
					gosteriZamani((oncekiZaman + zaman) - gecikmeSuresi); //artan zaman
				}
				else //yontem sadece 1 kere çağrilacaksa
				{
					yontemim.apply(null, parametrelerim);
					dispatchEvent(new Olay(Olay.HOKKABAZDAN_SILINDI));
				}
			}
		}
		
		
		//--------------------------------------------> ÖZELLİKLER <--------------------------------------------//

		public function get TekrarSayisi():int { return tekrarSayisi; }
		public function set TekrarSayisi(deger:int):void { tekrarSayisi = deger; }
		
		
		//--------------------------------------------> HAVUZ <--------------------------------------------//
		
		public static var hNesneler:Vector.<Gecikmeli> = new <Gecikmeli>[];
		
		public static function havuzaAt(gecikmeli:Gecikmeli):void 
		{
			gecikmeli.yontemim = null;
			gecikmeli.parametrelerim = null;
			hNesneler.push(gecikmeli);
		}
		
		public static function havuzdanAl(yontem:Function, gecikme:Number, parametreler:Array = null):Gecikmeli
		{
			if (hNesneler.length > 0)
			{
				return hNesneler.pop().sifirla(yontem, gecikme, parametreler);
			}
			else
			{
				return new Gecikmeli(yontem, gecikme, parametreler);
			}			
		}
		
	}

}