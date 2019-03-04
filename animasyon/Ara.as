package vMotor.animasyon
{
	import flash.events.EventDispatcher;
	import vMotor.olaylar.Olay;
	
	/**
	 * ...
	 * @author Anıl
	 */
	public class Ara extends EventDispatcher implements Zamansal
	{
		
		private var hedefim:Object;
		private var gecisFonkm:Function;
		private var gecisAdim:String;
		
		private var ozelliklerim:Vector.<String>;
		private var basDegerlerim:Vector.<Number>;
		private var bitisDegerlerim:Vector.<Number>;
		
		private var basFonkm:Function;
		private var yenileFonkm:Function;
		private var tekrarFonkm:Function;
		private var bitisFonkm:Function;
		
		private var basParamm:Array;
		private var yenileParamm:Array;
		private var tekrarParamm:Array;
		private var bitisParamm:Array;
		
		private var toplamZamanim:Number;
		private var simdikiZamanim:Number;
		private var ilerlemem:Number;
		private var gecikmem:Number;
		
		private var sonrakiAram:Ara;
		private var tekrarSayim:int;
		private var tekrarGecikmem:Number;
		private var geriye:Boolean;
		private var simdikiDongum:int;
		private var geriyeSar:Boolean;
		
		public function Ara(hedef:Object, sure:Number, gecis:String="dogrusal"):void
		{
			sifirla(hedef, sure, gecis);
		}
		
		public function sifirla(hedef:Object, sure:Number, gecis:String="dogrusal"):Ara
		{
			hedefim = hedef;
			gecikmem = tekrarGecikmem = ilerlemem = simdikiZamanim = 0.0;
			toplamZamanim = Math.max(0.0001, sure);
			basFonkm = yenileFonkm = tekrarFonkm = bitisFonkm = null;
			basParamm = yenileParamm = tekrarParamm = bitisParamm = null;
			tekrarSayim = 1;
			simdikiDongum = -1;
			geriyeSar = false;
			
			if (gecis is String)
				this.gecis = String(gecis); 
            else if (gecis is Function)
                this.gecisFonk = Function(gecis);
            else 
                throw new ArgumentError("Geçiş, fonksiyon veya string olmalıdır");
			
			
			if (ozelliklerim) ozelliklerim.length = 0;
			else ozelliklerim = new Vector.<String>();
			
			if (basDegerlerim) basDegerlerim.length = 0;
			else basDegerlerim = new Vector.<Number>();
			
			if (bitisDegerlerim) bitisDegerlerim.length = 0;
			else bitisDegerlerim = new Vector.<Number>();
			
			return this;
		}
		
		public function animeEt(ozellik:String, bitisDegeri:Number):void
		{
			if (hedefim == null)
				return;
			
			ozelliklerim.push(ozellik);
			basDegerlerim.push(Number.NaN);
			bitisDegerlerim.push(bitisDegeri);
		}
		
		
		public function sil():void 
		{
			dispatchEvent(new Olay(Olay.HOKKABAZDAN_SILINDI));
		}
		
		public function gosteriZamani(zaman:Number):void
		{
			var oncekiZamanim:Number = simdikiZamanim;
			simdikiZamanim += zaman;
			
			if (simdikiZamanim <= 0)
				return;
			else if (simdikiZamanim > toplamZamanim)
				simdikiZamanim = toplamZamanim;
			
			if (simdikiDongum < 0 && oncekiZamanim <= 0 && simdikiZamanim > 0) // BASLA!!!
			{
				simdikiDongum++;
				
				if (basFonkm != null)
					basFonkm.apply(this, basParamm);
			}
			
			var oran:Number = simdikiZamanim / toplamZamanim;
			var ozellikSayisi:int = basDegerlerim.length;
			ilerlemem = gecisFonkm(oran);
			
			for (var i:int = 0; i < ozellikSayisi; i++)
			{
				if (basDegerlerim[i] != basDegerlerim[i]) //NaN?
					basDegerlerim[i] = hedefim[ozelliklerim[i]] as Number;
				
				var basDegeri:Number = basDegerlerim[i];
				var bitisDegeri:Number = bitisDegerlerim[i];
				var fark:Number = bitisDegeri - basDegeri;
				var simdikiDeger:Number = basDegeri + fark * ilerlemem;
				
				hedefim[ozelliklerim[i]] = simdikiDeger;
				
			}
			
			if (yenileFonkm != null)
				yenileFonkm.apply(this, yenileParamm);
			
			if (oncekiZamanim < toplamZamanim && simdikiZamanim >= toplamZamanim) //BİTTİ!!!
			{
				if (!geriyeSar && (tekrarSayim == 0 || tekrarSayim > 1)) //birden büyük veya sonsuzsa
				{
					simdikiZamanim = -tekrarGecikmem;
					simdikiDongum++;
					
					if (tekrarSayim > 1)
						tekrarSayim--;
					
					if (tekrarFonkm != null)
						tekrarFonkm.apply(this, tekrarParamm);
				}
				else
				{
					
					if (geriyeSar && (tekrarSayim>=0))
					{
						
						simdikiZamanim = -tekrarGecikmem;
						simdikiDongum++;
						
						if (tekrarSayim > 1)
							tekrarSayim--;	
						
						if (tekrarSayim == 1)
							geriyeSar = false;
					
						if (tekrarFonkm != null)
							tekrarFonkm.apply(this, tekrarParamm);
							
						for (i = 0; i < ozellikSayisi; i++)
						{
							var tersBitis:Number = basDegerlerim[i];
							var tersBas:Number = bitisDegerlerim[i];
							
							basDegerlerim[i] = tersBas;
							bitisDegerlerim[i] = tersBitis;
							
						}
						
					}
					else
					{
						var bitisFonk:Function = bitisFonkm;
						var bitisParam:Array = bitisParamm;
						
						dispatchEvent(new Olay(Olay.HOKKABAZDAN_SILINDI));
						
						if (bitisFonk != null)
							bitisFonk.apply(this, bitisParam);
					}
				}
			}
		
		}
		
		//--------------------------------------------> ÖZELLİKLER <--------------------------------------------//
		
		public function get gecikme():Number  { return gecikmem }
		public function set gecikme(deger:Number):void
		{
			simdikiZamanim = simdikiZamanim + gecikmem - deger;
			gecikmem = deger;
		}
		
		public function set geriSar(deger:Boolean):void { geriyeSar = deger }
		
		public function set basFonk(deger:Function):void { basFonkm = deger }
		public function set basParam(deger:Array):void { basParamm = deger }
		
		public function set bitisFonk(deger:Function):void { bitisFonkm = deger }
		public function set bitisParam(deger:Array):void { bitisParamm = deger }
		
		public function set yenileFonk(deger:Function):void { yenileFonkm = deger }
		public function set yenileParam(deger:Array):void { yenileParamm = deger }
		
		public function set tekrarFonk(deger:Function):void { tekrarFonkm = deger }
		public function set tekrarParam(deger:Array):void { tekrarParamm = deger }
		
		public function set tekrarSayisi(deger:int):void { tekrarSayim = deger }
		public function get tekrarSayisi():int { return tekrarSayim }
		
		public function set tekrarGecikmesi(deger:Number):void { tekrarGecikmem = deger }
		public function get tekrarGecikmesi():Number { return tekrarGecikmem }
		
		public function get hedef():Object { return hedefim	};
		
		public function set gecis(deger:String):void 
        { 
            gecisAdim = deger;
			gecisFonkm = Gecisler.gecisAl(deger);
        }
		
		public function get bittiMi():Boolean { return simdikiZamanim >= toplamZamanim && tekrarSayim==1 }
		
		public function get gecisFonk():Function { return gecisFonkm }
		public function set gecisFonk(deger:Function):void
        {
            gecisAdim = "özel";
            gecisFonkm = deger;
        }
		
		//--------------------------------------------> HAVUZ <--------------------------------------------//
		
		private static var araHavuzu:Vector.<Ara> = new Vector.<Ara>();
		
		public static function havuzaAt(ara:Ara):void
		{
			ara.basFonkm = ara.tekrarFonkm = ara.yenileFonkm = ara.bitisFonkm = null;
			ara.basParamm = ara.tekrarParamm = ara.yenileParamm = ara.bitisParamm = null;
			ara.hedefim = null;
			ara.gecisFonkm = null;
			araHavuzu.push(ara);
		}
		
		public static function havuzdanAl(hedef:Object, sure:Number):Ara
		{
			if (araHavuzu.length)
			{
				return araHavuzu.pop().sifirla(hedef, sure);
			}
			else
			{
				return new Ara(hedef, sure);
			}
		}
	
	}
}