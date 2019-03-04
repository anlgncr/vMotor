package vMotor.goruntuNesneleri
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author anıl
	 */
	public class Kitap extends Sprite
	{
		private var sayfa:Bitmap;
		private var btmDatalar:Vector.<BitmapData>;
		private var simdikiSayfa:int;
		private var sayfaSayisi:int;
		
		public function Kitap(sayfalar:Vector.<BitmapData>) 
		{
			
			btmDatalar = sayfalar.concat();
			sayfa = new Bitmap(btmDatalar[0]);
			simdikiSayfa = 1;
			sayfaOrtala();
			
			addChild(sayfa);
			sayfaSayisi = btmDatalar.length;
			
		}
		
		public function git(sayfaNo:int):void 
		{
			if (sayfaNo < 1) simdikiSayfa = 1;
			
			else if (sayfaNo > sayfaSayisi) simdikiSayfa = sayfaSayisi;
			
			else	simdikiSayfa = sayfaNo;
			
			sayfa.bitmapData = btmDatalar[simdikiSayfa-1];
		}
		
		public function sonrakiSayfa():void 
		{
			var sayfaNo:int;
			
			if (simdikiSayfa >= sayfaSayisi) 
			{
				sayfaNo = 1;
			}
			else 
			{
				sayfaNo = simdikiSayfa + 1;
			}
			
			git(sayfaNo);
		
		}
		
		public function oncekiSayfa():void 
		{
			var sayfaNo:int;
			
			if (simdikiSayfa <= 1) sayfaNo = sayfaSayisi;
			
			else sayfaNo = simdikiSayfa - 1;
			
			git(sayfaNo);
		}
		
		private function sayfaOrtala():void 
		{
			sayfa.x = -sayfa.width * 0.5;
			sayfa.y = -sayfa.height * 0.5;
		}
		
		public function sil():void 
		{
			btmDatalar.length = 0;
			parent.removeChild(this);
		}
		
	}

}