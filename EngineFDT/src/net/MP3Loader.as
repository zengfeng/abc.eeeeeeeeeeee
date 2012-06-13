package net
{
	import log4a.Logger;

	import utils.GStringUtil;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;



	
	public class MP3Loader extends ALoader{
		
		private var _sound:Sound;
		
        private function addListeners() : void {
            _sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            _sound.addEventListener(Event.COMPLETE, completeHandler);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }
        
        private function removeListeners() : void {
            _sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
            _sound.removeEventListener(Event.COMPLETE, completeHandler);
            _sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }

        private function ioErrorHandler(event : IOErrorEvent) : void {
            removeListeners();
            _sound.close();
            _isLoadding = _isLoaded = false;
            Logger.error(GStringUtil.format("load {0} ioError!", _libData.url));
            dispatchEvent(event);
        }

        private function securityErrorHandler(event : SecurityErrorEvent) : void {
            removeListeners();
            _sound.close();
            _isLoadding = _isLoaded = false;
            Logger.error(GStringUtil.format("load {0} security error!", _libData.url));
            dispatchEvent(event);
        }

        private function progressHandler(event : ProgressEvent) : void {
            _loadData.calc(event.bytesLoaded,event.bytesTotal);
        }

        private function completeHandler(event : Event) : void {
            removeListeners();
            dispatchEvent(event);
        }
		
		public function MP3Loader(data : LibData) {
			super(data);
        }

        override public function load():void{
        	if(_isLoadding)return;
            if(_isLoaded)return;
            _isLoadding = true;
            _sound=new Sound();
            addListeners();
            _loadData.reset();
        	var request:URLRequest=new URLRequest(_libData.url);
            request.data = new URLVariables("version="+_libData.version);
            request.method = URLRequestMethod.GET;
            try{
        	   _sound.load(request);
            }catch(e:Error){
            	_sound.close();
            	Logger.error(e.message);
			}
        }
        
        public function getSound():Sound{
        	return _sound;
        }
	}
}
