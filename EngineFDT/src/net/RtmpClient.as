package net
{
	import log4a.LogError;
	import log4a.Logger;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.utils.Timer;


	public class RtmpClient extends EventDispatcher
	{
		public static const ADD_MY_USER:String="addMyUser";
		
		private static var _creating:Boolean=false;
		
		private static var _instance:RtmpClient;
		
		private var _maxAttempts : int = 3;

		private var _host : String;

		private var _appName : String;

		private var _protos : Array;

		private var _currentAttempt : int;

		private var _protosIndex : int;

		private var _temp_nc : NetConnection;

		private var _timer : Timer;

		private var _main_nc : NetConnection;

		private var _uid : int;

		private var _privateMsg : Object;

		private function init() : void {
			this._protos = new Array();
			this._protos.push({proto:"rtmp", port:1935});
			this._protos.push({proto:"rtmps", port:443});
			this._currentAttempt = 0;
			this._timer = new Timer(15000, 1);
			this._timer.addEventListener(TimerEvent.TIMER, this.timerHandler);
		}

		private function startProtosConnect() : void {
			this._currentAttempt++;
			if(this._currentAttempt > this._maxAttempts) {
				Logger.info(this, "startProtosConnect calling failed!");
				this.failed();
				return;
			}
			this._protosIndex = 0;
			this._temp_nc = this.setUpTempNC();
			var uri : String = this._protos[this._protosIndex]["proto"] + "://" + this._host + ":" + this._protos[this._protosIndex]["port"] + "/" + this._appName;
			this._temp_nc.connect(uri);
			Logger.info(this, "[" + this._currentAttempt + "/" + this._maxAttempts + "]" + (this._protosIndex + 1) + "/" + this._protos.length + ":" + this._temp_nc.uri);
			this._timer.reset();
			this._timer.start();
		}

		private function failed() : void {
			this._timer.stop();
			this.deleteTempNC();
			this.dispatchEvent(new Event("failed"));
		}

		private function setUpTempNC() : NetConnection {
			var nc : NetConnection = new NetConnection();
			nc.objectEncoding = ObjectEncoding.AMF3;
			nc.addEventListener(NetStatusEvent.NET_STATUS, this.tempNetStatusHandler);
			nc.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.tempSecurityErrorHandler);
			nc.proxyType = "best";
			return nc;
		}

		private function tempNetStatusHandler(event : NetStatusEvent) : void {
			this._timer.stop();
			var nc : NetConnection = event.currentTarget as NetConnection;
			var uri : String = nc.uri;
			switch(event.info["code"]) {
				case "NetConnection.Connect.Success":
					this.setUpMainNC(this._temp_nc);
					break;
				case "NetConnection.Connect.Failed":
					Logger.info(this, "connect " + uri + " failed!");
					this.nextConnect();
					break;
				case "NetConnection.Connect.Rejected":
					Logger.info(this, "connect " + uri + " rejected!");
					this.failed();
					break;
			}
		}

		private function tempSecurityErrorHandler(event : SecurityError) : void {
			this._timer.stop();
			this.failed();
			Logger.error(event);
		}

		private function nextConnect() : void {
			this._protosIndex++;
			if(this._protosIndex == this._protos.length) {
				this.startProtosConnect();
				return;
			}
			this.deleteTempNC();
			this._temp_nc = this.setUpTempNC();
			var uri : String = this._protos[this._protosIndex]["proto"] + "://" + this._host + ":" + this._protos[this._protosIndex]["port"] + "/" + this._appName;
			this._temp_nc.connect(uri);
			Logger.info(this, "[" + this._currentAttempt + "/" + this._maxAttempts + "]" + (this._protosIndex + 1) + "/" + this._protos.length + ":" + this._temp_nc.uri);
			this._timer.reset();
			this._timer.start();
		}

		private function timerHandler(event : TimerEvent) : void {
			Logger.info(this, "FMS3 connect time out!");
			if(this._protosIndex < this._protos.length)this.nextConnect();
			else this.startProtosConnect();
		}

		private function mainNetStatusHandler(event : NetStatusEvent) : void {
			Logger.info(this, "main net status:" + event.info["code"]);
			if(event.info["code"]== "NetConnection.Connect.Closed") {
				this.dispatchEvent(new Event("disconnect"));
			}
		}

		private function deleteTempNC() : void {
			if(this._temp_nc == null)return;
			this._temp_nc.removeEventListener(NetStatusEvent.NET_STATUS, this.tempNetStatusHandler);
			this._temp_nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.tempSecurityErrorHandler);
			this._temp_nc.close();
			this._temp_nc = null;
		}

		private function setUpMainNC(nc : NetConnection) : void {
			nc.removeEventListener(NetStatusEvent.NET_STATUS, this.tempNetStatusHandler);
			nc.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.tempSecurityErrorHandler);
			this._main_nc = nc;
			this._main_nc.addEventListener(NetStatusEvent.NET_STATUS, this.mainNetStatusHandler);
			this._main_nc.client = this;
			Logger.info("connect " + this._main_nc.uri.toLowerCase() + " success!");
			this.dispatchEvent(new Event(Event.COMPLETE));
		}

		public function RtmpClient(){
			if(!RtmpClient._creating){
                throw (new LogError("Class cannot be instantiated.Use getInstance() instead."));
            }
			this._host="localhost";
			this._appName="rpg";
			this.init();
		}
		
		public static function getInstance():RtmpClient{
			if(!RtmpClient._instance){
				RtmpClient._creating=true;
				RtmpClient._instance=new RtmpClient();
				RtmpClient._creating=false;
			}
			return RtmpClient._instance;
		}

		public function get nc() : NetConnection {
			return this._main_nc;
		}

		public function connect() : void {
			this.startProtosConnect();
		}

		public function disconnect() : void {
			this._timer.stop();
			if(this._main_nc == null)return;
			this._main_nc.removeEventListener(NetStatusEvent.NET_STATUS, this.mainNetStatusHandler);
			this._main_nc.close();
			this._main_nc = null;
			this.dispatchEvent(new Event("disconnect"));
		}

		public function areYouOk() : Boolean {
			return true;
		}

		public function privateMsg(s_uid : int,t_uid : int,msg : Object) : void {
			this._privateMsg = {s_uid:s_uid, t_uid:t_uid, msg:msg};
			this.dispatchEvent(new Event("privateMsg"));
		}

		public function getPrivateMsg() : Object {
			return this._privateMsg;
		}

		public function addMyUser(uid:int):void {
			this._uid = uid;
			this.dispatchEvent(new Event(RtmpClient.ADD_MY_USER));	
		}

		public function get uid() : int {
			return this._uid;
		}
	}
}