package ssen.mvc {
import ssen.common.IDisposable;

public interface IEvtDispatcher extends IDisposable {
	function addEvtListener(type:String, listener:Function):IEventUnit;
	function dispatchEvt(evt:Evt):void;
}
}
