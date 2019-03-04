package vMotor.goruntuNesneleri
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import vMotor.genel.DHizala;
	import vMotor.genel.YHizala;
	
	/**
	 * ...
	 * @author anil
	 */
	public class ResimAtlasi
	{
		private var xmlDosya:XML;
		private var atlas:BitmapData;
		private var kesilenResim:Bitmap;
		private var kesim:Rectangle;
		private var sifir:Point = new Point(0, 0);
		private var resimler:Vector.<BitmapData> = new Vector.<BitmapData>;
		private var xmlList:XMLList;
		private var btmpDatalar:Dictionary = new Dictionary();
		private var btmpDataAdlari:Vector.<String> = new Vector.<String>;
		
		public function ResimAtlasi(Atlas:Bitmap, xml:XML)
		{
			xmlDosya = xml;
			atlas = Atlas.bitmapData;
			
			kesilenResim = new Bitmap();
			kesim = new Rectangle();
			
			for each (var resim:XML in xml.resim)
			{
				var ad:String = resim.@ad;
				var boy:Number = resim.@boy;
				var en:Number = resim.@en;
				var x:Number = resim.@x;
				var y:Number = resim.@y;
				
				kesilenResim.bitmapData = new BitmapData(en, boy);
				
				kesim.setTo(x, y, en, boy);
				kesilenResim.bitmapData.copyPixels(atlas, kesim, sifir);
				btmpDatalar[ad] = kesilenResim.bitmapData.clone();
				btmpDataAdlari.push(ad);
			}
			
			btmpDataAdlari.sort(Array.CASEINSENSITIVE);
		}
		
		public function spriteAl(ad:String, yatay:int = YHizala.ORTA, dikey:int = DHizala.ORTA):Sprite
		{
			var sprite:Sprite = new Sprite();
			var bitmap:Bitmap = new Bitmap(btmpDatalar[ad]);
			
			switch (yatay)
			{
			case YHizala.SAG: 
				bitmap.x = -bitmap.width;
				break;
			case YHizala.SOL: 
				bitmap.x = 0;
				break;
			case YHizala.ORTA: 
				bitmap.x = -bitmap.width * 0.5;
				break;
			}
			
			switch (dikey)
			{
			case DHizala.UST: 
				bitmap.y = 0;
				break;
			case DHizala.ALT: 
				bitmap.y = -bitmap.height;
				break;
			case DHizala.ORTA: 
				bitmap.y = -bitmap.height * 0.5;
				break;
			}
			
			sprite.addChild(bitmap);
			
			return sprite;
		}
		
		public function resimAl(ad:String):BitmapData
		{
			return btmpDatalar[ad];
		}
		
		public function resimleriAl(onad:String = ""):Vector.<BitmapData>
		{
			var sonuc:Vector.<BitmapData> = new Vector.<BitmapData>();
			
			for each (var isim:String in isimleriAl(onad))
			{
				sonuc.push(resimAl(isim));
			}
			
			return sonuc;
		}
		
		private function isimleriAl(onad:String = ""):Vector.<String>
		{
			var sonuc:Vector.<String> = new Vector.<String>();
			
			for each (var isim:String in btmpDataAdlari)
			{
				if (isim.indexOf(onad) >= 0)
				{
					sonuc.push(isim);
				}
			}
			
			if (sonuc.length == 0)
				throw new ArgumentError("FilmKlib'i için istenen veriler boş! Örnek:isimleriAl('Önad_');");
			
			return sonuc;
		}
	
	}

}