package ssen.mvc {
import flash.events.Event;

import ssen.common.IDisposable;

public interface IEventEmitter extends IDisposable {
	function addEventListener(type:String, listener:Function):IEventUnit;
	function on(type:String, listener:Function):IEventUnit;
	function emitEvent(event:Event):void;
}
}
