package 
{
	
	import com.bit101.components.ComboBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.Text;
	import com.bit101.components.TextArea;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.tuio.osc.OSCMessage;
	/**
	 * ...
	 * @author umhr
	 */
	public class Container extends Sprite 
	{
		
		private var _inAdress:Text;
		private var _outAdress:Text;
		private var _oscAddress:Text;
		private var _oscMessageList:Array/*Text*/ = [];
		private var _typeCBList:Array/*ComboBox*/ = [];
		private var _log:TextArea;
		public function Container() 
		{
			init();
		}
		private function init():void 
		{
			if (stage) onInit();
			else addEventListener(Event.ADDED_TO_STAGE, onInit);
		}

		private function onInit(event:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onInit);
			// entry point
			
			Style.setStyle(Style.DARK);
			new Label(this, 8, 8, "IN:");
			_inAdress = new Text(this, 38, 8, "127.0.0.1:6666");
			_inAdress.width = 220;
			_inAdress.height = 20;
			new Label(this, 8, 32, "OUT:");
			_outAdress = new Text(this, 38, 32, "127.0.0.1:6667");
			_outAdress.width = 220;
			_outAdress.height = 20;
			new PushButton(this, 266, 32, "Bind", onBind);
			trace(546);
		}
		
		private function onBind(e:Event):void 
		{
			var inIPAdress:String = _inAdress.text.split(":")[0];
			var inPort:int = int(_inAdress.text.split(":")[1]);
			var outIPAdress:String = _outAdress.text.split(":")[0];
			var outPort:int = int(_outAdress.text.split(":")[1]);
			
			OSCListenerManager.getInstance().bind(inIPAdress, inPort, outIPAdress, outPort);
			
			(e.target as PushButton).enabled = _inAdress.enabled = _outAdress.enabled = false;
			addMessageUI();
		}
		
		private function addMessageUI():void 
		{
			new Label(this, 8, 60, "OSCMessage Adress");
			_oscAddress = new Text(this, 8, 80, "d");
			_oscAddress.width = 250;
			_oscAddress.height = 20;
			
			new Label(this, 8, 80 + 24 * 1 + 4, "OSCMessage Arguments");
			
			for (var i:int = 0; i < 6; i++) 
			{
				var tx:int = 8;
				var ty:int = 80 + 24 * (2 + i);
				_oscMessageList[i] = new Text(this, tx, ty, "");
				_oscMessageList[i].width = 250;
				_oscMessageList[i].height = 20;
				var items:Array = ["String", "int", "float"];
				_typeCBList[i] = new ComboBox(this, tx + 258, ty, "String", items);
				_typeCBList[i].numVisibleItems = items.length;
			}
			
			_oscMessageList[0].text = "ABC";
			_oscMessageList[1].text = "qwerty";
			_oscMessageList[2].text = "XYZ";
			_oscMessageList[3].text = "123";
			
			new PushButton(this, 266, 80 + 24 * 8, "Send", onSend);
			_log = new TextArea(this, 8, 80 + 24 * 9);
			_log.width = 358;
			
			OSCListenerManager.getInstance().onAcceptOSCMessage = onAcceptOSCMessage;
		}
		
		private function onSend(e:Event):void 
		{
			var oscAddress:String = _oscAddress.text;
			
			var messageList:Array = [];
			var typeList:Array/*String*/ = [];
			var n:int = _oscMessageList.length;
			for (var i:int = 0; i < n; i++) 
			{
				if (_oscMessageList[i].text.length > 0) {
					var type:String;;
					if (_typeCBList[i].selectedIndex <= 0) {
						type = "s";
						messageList.push(_oscMessageList[i].text);
					}else if(_typeCBList[i].selectedIndex == 1){
						type = "i";
						messageList.push(int(_oscMessageList[i].text));
					}else if(_typeCBList[i].selectedIndex == 2){
						type = "f";
						messageList.push(Number(_oscMessageList[i].text));
					}
					typeList.push(type);
				}
				
			}
			
			trace(oscAddress, _oscMessageList.length);
			OSCListenerManager.getInstance().send(oscAddress, messageList, typeList);
		}
		
		private function onAcceptOSCMessage(oscmsg:OSCMessage):void 
		{
			var text:String = "";
			text += oscmsg.address + ", ";
			var n:int = oscmsg.arguments.length;
			for (var i:int = 0; i < n; i++) 
			{
				text += oscmsg.arguments[i] + ", ";
			}
			
			_log.text = text;
			
		}
		
	}
	
}