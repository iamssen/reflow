package ssen.mvc {
import flash.events.Event;

import ssen.common.IDisposable;

public interface IEvtDispatcher extends IDisposable {
	function addEvtListener(type:String, listener:Function):IEventUnit;
	function dispatchEvt(evt:Event):void;
}
}
