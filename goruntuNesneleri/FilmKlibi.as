package vMotor.goruntuNesneleri
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import vMotor.animasyon.Zamansal;
	import vMotor.olaylar.Olay;
	
	/**
	 * ...
	 * @author anıl
	 */
	public class FilmKlibi extends Sprite implements Zamansal
	{
		private var btmDatalari:Vector.<BitmapData>;
		private var sesler:Vector.<Sound>;
		private var kareSuresi:Vector.<Number>;
		private var basSureleri:Vector.<Number>;
		
		private var varsayilanKareSuresi:Number;
		private var simdikiZaman:Number;
		private var simdikiKarem:int;
		private var dongum:Boolean;
		private var oynuyor:Boolean;
		private var sessizm:Boolean;
		private var sesAyarim:SoundTransform = null;
		private var klip:Bitmap;
		
		public function FilmKlibi(bitmapData:Vector.<BitmapData>, fps:Number = 12)
		{
			if (bitmapData.length > 0)
			{
				btmDatalari = bitmapData;
				baslat(bitmapData, fps);
			}
			else
			{
				throw new ArgumentError("Boş BitmapData dizisi");
			}
		}
		
		private function baslat(bitmapData:Vector.<BitmapData>, fps:Number):void
		{
			if (fps < 0)
				throw new ArgumentError("fps 0 dan küçük olamaz");
			
			klip = new Bitmap();
			klip.bitmapData = btmDatalari[0];
			klip.x = -klip.width * 0.5;
			klip.y = -klip.height * 0.5;
			addChild(klip);
			
			var kareSayim:int = btmDatalari.length;
			
			varsayilanKareSuresi = 1.0 / fps;
			dongum = false;
			oynuyor = false;
			simdikiZaman = 0.0;
			simdikiKarem = 0;
			btmDatalari = btmDatalari.concat();			//Yeni bir dizi döndürür.
			sesler = new Vector.<Sound>(kareSayim);
			kareSuresi = new Vector.<Number>(kareSayim);
			basSureleri = new Vector.<Number>(kareSayim);
			
			for (var i:int = 0; i < kareSayim; ++i)
			{
				kareSuresi[i] = varsayilanKareSuresi;
				basSureleri[i] = i * varsayilanKareSuresi;
			}
		}
		
		public function gosteriZamani(zaman:Number):void
		{
			if (!oynuyor)
				return;
			
			var sonKare:int;
			var oncekiKare:int = simdikiKarem;
			var araZaman:Number = 0.0;
			var dongudenCik:Boolean = false;
			var bittiOlayi:Boolean = false;
			var toplamZaman:Number = this.toplamZaman;
			
			/*if (dongum && simdikiZaman >= toplamZaman)
			{
				simdikiZaman = 0.0;
				simdikiKarem = 0;
			}*/
			
			if (simdikiZaman < toplamZaman)
			{
				simdikiZaman += zaman;
				sonKare = btmDatalari.length - 1;
				
				while (simdikiZaman > basSureleri[simdikiKarem] + kareSuresi[simdikiKarem])
				{
					
					if (simdikiKarem == sonKare)
					{
						if (dongum)
						{
							simdikiZaman -=toplamZaman;
							simdikiKarem = 0;
						}
						else
						{
							dongudenCik = true;
							//araZaman = simdikiZaman - toplamZaman;
							bittiOlayi = true;
							simdikiKarem = sonKare;
							simdikiZaman = toplamZaman;
						}
					}
					else
					{
						simdikiKarem++;
					}
	
					if (dongudenCik)
						break;
					
					var ses:Sound = sesler[simdikiKarem];
					if (ses && !sessizm)
						ses.play(0, 0, sesAyarim);
					
				}
				
				if (simdikiKarem != oncekiKare)
					klip.bitmapData = btmDatalari[simdikiKarem];
				
				if (bittiOlayi)
				{
					oynuyor = false;
					klip.bitmapData = btmDatalari[0];
					simdikiKarem = 0;
					simdikiZaman = 0;
					dispatchEvent(new Olay(Olay.TAMAMLANDI));
				}
				
			}
		}
		
		public function oynat():void
		{
			if (simdikiKarem == 0 && !oynuyor)
			{
				oynuyor = true;
				simdikiZaman = 0.0;
			}
			else
			{
				oynuyor = true;
			}
		}
		
		public function durdur():void
		{
			oynuyor = false;
		}
		
		public function bitir():void
		{
			oynuyor = false;
			simdikiKarem = 0;
		}
		
		
		
		public function get kareSayisi():int { return btmDatalari.length; } 
		
		public function get dongu():Boolean { return dongum; }
		public function set dongu(deger:Boolean):void { dongum = deger; }
		
		public function get sessiz():Boolean { return sessizm; }
        public function set sessiz(deger:Boolean):void { sessizm = deger; }
		
		public function get sesAyari():SoundTransform { return sesAyarim; }
        public function set sesAyari(deger:SoundTransform):void { sesAyarim = deger; }
		
		public function get simdikiKare():int  { return simdikiKarem + 1; }
		public function set simdikiKare(kare:int):void
		{
			if (kare<=0 || kare>kareSayisi)
			{
				throw new ArgumentError("Geçersiz kare numarası");
				return;
			}
			
			kare-= 1;
			simdikiKarem = kare;
			simdikiZaman = 0.0;
			
			for (var i:int = 0; i < kare; i++ )
				simdikiZaman += kareSuresiAl(i);
			
			klip.bitmapData = btmDatalari[simdikiKarem];
			
			if (!sessizm && sesler[simdikiKarem])
				sesler[simdikiKarem].play(0, 0, sesAyarim);
				
		}
		
		public function get FPS():Number { return 1 / varsayilanKareSuresi; }
		public function set FPS(deger:Number):void 
		{ 
			var yeniKaresSuresi:Number = 1.0 / deger;
			var ivme:Number = yeniKaresSuresi / varsayilanKareSuresi;
			simdikiZaman *= ivme;
			varsayilanKareSuresi = yeniKaresSuresi;
			
			for (var i:int = 0; i < kareSayisi; i++ )
				kareSuresi[i] *= ivme;
			
			basSureleriniAyarla();
		}
		
		public function get oynuyorMu():Boolean { return oynuyor; }
		
		
		public function get toplamZaman():Number
		{
			var kareSayim:int = btmDatalari.length;
			return basSureleri[int(kareSayim - 1)] + kareSuresi[int(kareSayim - 1)];
		}
		
		private function basSureleriniAyarla():void 
		{
			var kareSayim:int = this.kareSayisi;
			basSureleri.length = 0;
			basSureleri[0] = 0;
			
			for (var i:int = 1; i < kareSayim;i++ )
				basSureleri[i] = basSureleri[int(i - 1)] + kareSuresi[int(i - 1)]; //Her kare süresi eşit olmazsa diye!
		}
		
		public function kareSuresiAl(kare:int):Number
        {
            if (kare < 0 || kare >= kareSayisi) throw new ArgumentError("Böyle bir kare numarası yok");
            return kareSuresi[kare];
        }
		
		
		public function sesEkle(kare:int, ses:Sound):void 
		{
			if (kare<=0 || kare>kareSayisi)
			{
				throw new ArgumentError("Geçersiz kare numarası");
				return;
			}
			sesler[kare-1] = ses;
		}
		
		public function sil():void
		{
			dispatchEvent(new Olay(Olay.HOKKABAZDAN_SILINDI));
			parent.removeChild(this);
			btmDatalari.length = 0;
			sesler.length = 0;
		}
	
	}

}