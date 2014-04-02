package ssen.mvc {

public interface ICommandMap {
	function mapCommand(eventType:String, commandClasses:Vector.<Class>):void;
	function unmapCommand(eventType:String):void;
	function hasCommand(eventType:String):Boolean;
}
}
