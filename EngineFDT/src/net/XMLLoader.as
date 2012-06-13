package net
{
	import log4a.Logger;

	import utils.GStringUtil;

	import flash.events.Event;



	public class XMLLoader extends RESLoader {

		private var _xml : XML;

		override protected function onComplete() : void {
			try {
				var s : String = _byteArray.readUTFBytes(_byteArray.length);
				_xml = new XML(s);
				_isLoadding = false;
				_isLoaded = true;
				Logger.info(this, GStringUtil.format("load {0} complete", _libData.url));
				dispatchEvent(new Event(Event.COMPLETE));
			}catch(e : TypeError) {
				onError(e.message);
			}
		}

		public function XMLLoader(data : LibData) {
			super(data);
		}

		public function getXML() : XML {
			return _xml;
		}
	}
}