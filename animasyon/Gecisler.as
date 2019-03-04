package vMotor.animasyon
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Anıl
	 */
	public class Gecisler 
	{
	
		public static const DOGRUSAL:String = "dogrusal";
		
		public static const YUMUSAK_GIRIS:String = "yumusakGiris";
		public static const YUMUSAK_CIKIS:String = "yumusakCikis";
		
		public static const YUMUSAK_GIRIS_CIKIS:String = "yumusakGirisCikis";
        public static const YUMUSAK_CIKIS_GIRIS:String = "yumusakCikisGiris";  
		
		public static const YUMUSAK_GIRIS_SEKME:String = "yumusakGirisSekme";
		public static const YUMUSAK_CIKIS_SEKME:String = "yumusakCikisSekme";
		
		public static const EASE_IN_ELASTIC:String = "easeInElastic";
		public static const EASE_OUT_ELASTIC:String = "easeOutElastic";
		
		public static const EASE_IN_BACK:String = "easeInBack";
		public static const EASE_OUT_BACK:String = "easeOutBack";
		
		public static const EASE_IN_OUT_ELASTIC:String = "easeInOutElastic";
        public static const EASE_OUT_IN_ELASTIC:String = "easeOutInElastic";  
		
		
		private static var gecislerSozluk:Dictionary;
		
		public function Gecisler() { }
	
		public static function kaydet(ad:String, fonksiyon:Function):void 
		{
			if (gecislerSozluk == null)
				sozlugeEkle();
				
			gecislerSozluk[ad] = fonksiyon;
			
		}
		
		public static function sozlugeEkle():void
		{
			gecislerSozluk = new Dictionary();
			
			kaydet(DOGRUSAL, dogrusal);
			kaydet(YUMUSAK_GIRIS, yumusakGiris);
			kaydet(YUMUSAK_CIKIS, yumusakCikis);
			kaydet(YUMUSAK_GIRIS_CIKIS, yumusakGirisCikis);
			kaydet(YUMUSAK_CIKIS_GIRIS, yumusakCikisGiris);
			kaydet(YUMUSAK_GIRIS_SEKME, yumusakGirisSekme);
			kaydet(YUMUSAK_CIKIS_SEKME, yumusakCikisSekme);
			kaydet(EASE_IN_ELASTIC, easeInElastic);
			kaydet(EASE_OUT_ELASTIC, easeOutElastic);
			kaydet(EASE_IN_BACK, easeInBack);
			kaydet(EASE_OUT_BACK, easeOutBack);
			kaydet(EASE_IN_OUT_ELASTIC, easeInOutElastic);
			kaydet(EASE_OUT_IN_ELASTIC, easeOutInElastic);
		
		}
		
		public static function gecisAl(ad:String):Function 
		{
			if (gecislerSozluk == null)
				sozlugeEkle();
				
			return gecislerSozluk[ad];
		}
		
		protected static function dogrusal(oran:Number):Number
		{
			return oran;
		}
		
		protected static function yumusakGiris(oran:Number):Number
		{
			return oran * oran * oran;
		}
		
		protected static function yumusakCikis(oran:Number):Number
		{
			var tersOran:Number = oran - 1.0;
            return tersOran * tersOran * tersOran + 1;
		}
		
		protected static function yumusakGirisCikis(oran:Number):Number
        {
            return yumusakBirlesim(yumusakGiris, yumusakCikis, oran);
        } 
		
		protected static function yumusakCikisGiris(oran:Number):Number
        {
            return yumusakBirlesim(yumusakCikis, yumusakGiris, oran);
        } 
       
		protected static function yumusakGirisSekme(oran:Number):Number
        {
            return 1.0 - yumusakCikisSekme(1.0 - oran);
        }
		
		protected static function yumusakCikisSekme(oran:Number):Number
        {
            var s:Number = 7.5625;
            var p:Number = 2.75;
            var l:Number;
            if (oran < (1.0/p))
            {
                l = s * Math.pow(oran, 2);
            }
            else
            {
                if (oran < (2.0/p))
                {
                    oran -= 1.5/p;
                    l = s * Math.pow(oran, 2) + 0.75;
                }
                else
                {
                    if (oran < 2.5/p)
                    {
                        oran -= 2.25/p;
                        l = s * Math.pow(oran, 2) + 0.9375;
                    }
                    else
                    {
                        oran -= 2.625/p;
                        l =  s * Math.pow(oran, 2) + 0.984375;
                    }
                }
            }
            return l;
        }
		
		protected static function easeInBack(ratio:Number):Number
        {
            var s:Number = 1.70158;
            return Math.pow(ratio, 2) * ((s + 1.0)*ratio - s);
        }
		
		protected static function easeOutBack(ratio:Number):Number
        {
            var invRatio:Number = ratio - 1.0;            
            var s:Number = 1.70158;
            return Math.pow(invRatio, 2) * ((s + 1.0)*invRatio + s) + 1.0;
        }
        
        
		
		protected static function easeInElastic(ratio:Number):Number
        {
            if (ratio == 0 || ratio == 1) return ratio;
            else
            {
                var p:Number = 0.3;
                var s:Number = p/4.0;
                var invRatio:Number = ratio - 1;
                return -1.0 * Math.pow(2.0, 10.0*invRatio) * Math.sin((invRatio-s)*(2.0*Math.PI)/p);                
            }            
        }
		
		protected static function easeOutElastic(ratio:Number):Number
        {
            if (ratio == 0 || ratio == 1) return ratio;
            else
            {
                var p:Number = 0.3;
                var s:Number = p/4.0;                
                return Math.pow(2.0, -10.0*ratio) * Math.sin((ratio-s)*(2.0*Math.PI)/p) + 1;                
            }            
        }
		
		protected static function easeInOutElastic(ratio:Number):Number
        {
            return yumusakBirlesim(easeInElastic, easeOutElastic, ratio);
        }   
        
        protected static function easeOutInElastic(ratio:Number):Number
        {
            return yumusakBirlesim(easeOutElastic, easeInElastic, ratio);
        }
		
		
		protected static function yumusakBirlesim(baslangicFonk:Function, bitisFonk:Function, oran:Number):Number
        {
            if (oran < 0.5) {
				return 0.5 * baslangicFonk(oran * 2.0);
			}
            else {
				return 0.5 * bitisFonk((oran - 0.5) * 2.0) + 0.5;
			}
			
        }
		
	}

}