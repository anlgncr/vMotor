package vMotor.animasyon
{
	import flash.events.EventDispatcher;
	import vMotor.olaylar.Olay;
	/**
	 * ...
	 * @author anıl
	 */
	public class Hokkabaz implements Zamansal
	{
		private var nesnelerim:Vector.<Zamansal>;
		private var gecenZamanim:Number;
		private var silinecekNesneler:Vector.<Zamansal>;
		
		public function Hokkabaz() 
		{
			gecenZamanim = 0;
			nesnelerim = new Vector.<Zamansal>;
			silinecekNesneler = new Vector.<Zamansal>;
		}
		
		public function gosteriZamani(zaman:Number):void
		{
			gecenZamanim += zaman;

			var nesneSayisi:int = nesnelerim.length;
            var gercekIndex:int = 0;
            var i:int;
            
            if (nesneSayisi == 0) return;
            
            for (i=0; i<nesneSayisi; i++)
            {
                var nesne:Zamansal = nesnelerim[i];
                if (nesne)
                {
                    if (gercekIndex != i) //nesneleri sola kaydır
                    {
                        nesnelerim[gercekIndex] = nesne;
                        nesnelerim[i] = null;
                    }
                    
                    nesne.gosteriZamani(zaman);
                    gercekIndex++;//en son index null olduğunda burayı atladığı için gerçek index ile i farklı olur
                }
            }
		
         
            if (gercekIndex != i)//son indexlerde null kaldıysa gerçek indexle i farklı olur
            {
                nesneSayisi = nesnelerim.length; //uzunluk değişmiş olabilir (sahneye nesne eklenmiş olabilir)
                
                while (i < nesneSayisi)
                    nesnelerim[int(gercekIndex++)] = nesnelerim[int(i++)];//sahneye eklenen yeni nesneleri gerçek indexten itibaren diziye ekle
					
					nesnelerim.length = gercekIndex;//sondaki boş indexleri at (boş index kalmamış da olabilir yani eşit olabilir)
            }
				
		}
		
		public function ekle(nesne:Zamansal):void
		{
			if (nesnelerim.indexOf(nesne) < 0)
			{
				nesnelerim[nesnelerim.length] = nesne;
				
				var olayYarat:EventDispatcher = EventDispatcher(nesne);
				
				if (olayYarat) 
					olayYarat.addEventListener(Olay.HOKKABAZDAN_SILINDI, silindi);
			}
		}
		
		private function silindi(e:Olay):void 
		{
			sil(Zamansal(e.currentTarget));
		}
		
		public function sil(nesne:Zamansal):void 
		{
			if (nesne == null || nesnelerim.indexOf(nesne) < 0)
				return;
			
			EventDispatcher(nesne).removeEventListener(Olay.HOKKABAZDAN_SILINDI, silindi);
			nesnelerim[nesnelerim.indexOf(nesne)] = null;
		}
		
		
		//----------------------------------->GECİKMELİ ÇAĞIR<-----------------------------------//
		
		public function gecikmeliCagir(yontem:Function, gecikme:Number, parametreler:Array = null, tekrarSayisi:int = 1):Zamansal
		{
			if (yontem == null)
				return null;
			
			var gecikmeli:Gecikmeli = Gecikmeli.havuzdanAl(yontem, gecikme, parametreler);
			gecikmeli.TekrarSayisi = tekrarSayisi;
			gecikmeli.addEventListener(Olay.HOKKABAZDAN_SILINDI, havuzaYolla);
			
			ekle(gecikmeli);
			
			return gecikmeli;
		}
		
		private function havuzaYolla(e:Olay):void 
		{
			Gecikmeli(e.currentTarget).removeEventListener(Olay.HOKKABAZDAN_SILINDI, havuzaYolla);
			Gecikmeli.havuzaAt(Gecikmeli(e.currentTarget));
		}
		
		
		//----------------------------------->ARA OLUŞTUR<-----------------------------------//
		
		private var aralar:Vector.<Ara> = new Vector.<Ara>; 
		public function araOlustur(hedef:Object, sure:Number, ozellikler:Object):Zamansal
        {
			for each (var aram:Ara in aralar) 
			{
				if (aram.hedef == hedef) {
					aralar.splice(aralar.indexOf(aram), 1);
					aram.sil();
				}
			}
			
            var ara:Ara = Ara.havuzdanAl(hedef, sure);
			aralar.push(ara);
			
            for (var ozellik:String in ozellikler)
            {
				if (ara.hasOwnProperty(ozellik))
				{
					ara[ozellik] = Object(ozellikler[ozellik]);
				}
                else if (hedef.hasOwnProperty(ozellik))
				{
                    ara.animeEt(ozellik, ozellikler[ozellik] as Number);
				}
			}
            
			ara.addEventListener(Olay.HOKKABAZDAN_SILINDI, arayiHavuzaYolla)
			ekle(ara);
			
            return ara;
        }
		
		private function arayiHavuzaYolla(e:Olay):void 
		{
			Ara(e.currentTarget).removeEventListener(Olay.HOKKABAZDAN_SILINDI, arayiHavuzaYolla);
			Ara.havuzaAt(Ara(e.currentTarget));
		}
		
		
		//----------------------------------->FONKSİYONLAR<-----------------------------------//
		
		public function iceriyorMu(nesne:Zamansal):Boolean 
		{
			return nesnelerim.indexOf(nesne) > -1;
		}
		
		
		//----------------------------------->ÖZELLİKLER<-----------------------------------//
		
		public function get cocukSayisi():int { return nesnelerim.length; } 
		public function get gecenZaman():Number { return gecenZamanim; } 
	
	}

}