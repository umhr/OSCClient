package 
{
	import org.tuio.connectors.UDPConnector;
	import org.tuio.osc.IOSCListener;
	import org.tuio.osc.OSCManager;
	import org.tuio.osc.OSCMessage;
	/**
	 * ...
	 * @author umhr
	 */
	public class OSCListenerManager implements IOSCListener
	{
		private static var _instance:OSCListenerManager;
		public function OSCListenerManager(block:Block){init();};
		public static function getInstance():OSCListenerManager{
			if ( _instance == null ) {_instance = new OSCListenerManager(new Block());};
			return _instance;
		}
		
		private var _oscManager:OSCManager;
		/**
		 * 受信時にこの関数にメッセージが渡されます。
		 */
		public var onAcceptOSCMessage:Function = function(oscmsg:OSCMessage):void { };
		private function init():void
		{
			
		}
		
		/**
		 * 送受信IPAdress、Portを指定します。
		 * @param	inHost	このアプリ自身が受信待ちするIPAdress
		 * @param	inPort	このアプリ自身が受信待ちするポート番号
		 * @param	outHost	送信先IPAdress
		 * @param	outPort	送信先ポート番号
		 */
		public function bind(inHost:String, inPort:int, outHost:String, outPort:int):void {
			var udpConnectorIn:UDPConnector = new UDPConnector(inHost, inPort);
			var udpConnectorOut:UDPConnector = new UDPConnector(outHost, outPort, false);
			var autoStart:Boolean = true;
			
			_oscManager = new OSCManager(udpConnectorIn, udpConnectorOut, autoStart);
			_oscManager.addMsgListener(this);
		}
		
		/**
		 * 送信します。
		 * @param	address	例:d
		 * @param	messageList	例:["hoge",123]
		 * @param	typeList	例:["s","i"]
		 */
		public function send(address:String, messageList:Array, typeList:Array/*String*/):void {
			if (_oscManager == null) { return };
			if(messageList.length != typeList.length || messageList.length == 0) { return };
			
			var m:OSCMessage = new OSCMessage();
			m.address = address;// "/d";
			var n:int = messageList.length;
			for (var i:int = 0; i < n; i++) 
			{
				m.addArgument(typeList[i], messageList[i]);
			}
			
			_oscManager.sendOSCPacket(m);
			
		}
		
		public function acceptOSCMessage(oscmsg:OSCMessage):void
		{
			onAcceptOSCMessage(oscmsg);
			//trace(oscmsg.address);
			//var n:int = oscmsg.arguments.length;
			//for (var i:int = 0; i < n; i++) 
			//{
				//trace(oscmsg.arguments[i]);
			//}
		}
		
		
	}
	
}
class Block { };