package ssen.mvc {
import ssen.common.IDisposable;

public interface ICommandMap extends IDisposable {
	function mapCommand(eventType:String, commandClasses:Vector.<Class>):void;

	function unmapCommand(eventType:String):void;

	function hasMapping(eventType:String):Boolean;
}
}
