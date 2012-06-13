package net
{
	import log4a.Logger;

	import utils.GStringUtil;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;



	public class RSLLoader extends RESLoader{
		
		private var _loader: Loader;
		
		override protected function onComplete():void{
			_loader=new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeHandler);
			var context:LoaderContext=new LoaderContext(false,ApplicationDomain.currentDomain);
			_loader.loadBytes(_byteArray, context);
			Logger.info(this, GStringUtil.format("loadBytes {0}", _libData.url));
		}
		
		private function completeHandler(event:Event):void{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeHandler);
			_isLoadding=false;
			_isLoaded=true;
			Logger.info(this, GStringUtil.format("load {0} complete", _libData.url));
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function RSLLoader(data:LibData){
			super(data);
		}
		
		public function getContent():DisplayObject{
            return _loader.content;
        }
	}
}