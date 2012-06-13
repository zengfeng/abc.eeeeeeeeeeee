package net
{
	import log4a.LogError;
	import log4a.Logger;

	import flash.events.AsyncErrorEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;

	
	public class RemoteConnector extends EventDispatcher
	{
		private static var _creating:Boolean=false;
		
		private static var _instance:RemoteConnector;
		
		private var _gateway:String;
		
		private var _nc:NetConnection;

		private function ioErrorHandler(event:IOErrorEvent):void{
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void{
		}
					
		private function netStatusHandler(event:NetStatusEvent):void{
			Logger.info(this,event.info);
			switch(event.info["code"]) {
				case "NetConnection.Connect.Success":
					break;
				case "NetConnection.Call.Failed":
					break;
				case "NetConnection.Call.BadVersion":
					break;
				case "NetConnection.Connect.Rejected":
					break;
			}
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void{
			Logger.info(event.text);
		}
		
		public function RemoteConnector(){
			if(!RemoteConnector._creating){
				throw(new LogError("Class cannot be instantiated."));
			}
		}
		
		public static function getInstance():RemoteConnector{
			if(!RemoteConnector._creating){
				RemoteConnector._creating=true;
				RemoteConnector._instance=new RemoteConnector();
			}
			return RemoteConnector._instance;
		}
		
		public function setGateway(gateway:String):void{
			this._gateway=gateway;
		}
		
		public function connect():void {
			this._nc=new NetConnection();
			this._nc.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
			this._nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
			this._nc.addEventListener(NetStatusEvent.NET_STATUS,this.netStatusHandler);
			this._nc.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.asyncErrorHandler);
			this._nc.client=this._nc;
			this._nc.connect(this._gateway);
		}
		
		public function get nc():NetConnection{
			return this._nc;
		}
	}
}