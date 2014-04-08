package ssen.mvc {

/**
 * CommandMap.
 *
 * @see ssen.mvc.context.Context#mapDependency()
 *
 * @includeExample commandMapSample.txt
 */
public interface ICommandMap {

	/**
	 * @param eventType Trigger event type
	 * @param commandClasses Execute command classes
	 */
	function mapCommand(eventType:String, commandClasses:Vector.<Class>):void;

	/**
	 * @param eventType Trigger event type
	 */
	function unmapCommand(eventType:String):void;

	/**
	 * @param eventType Trigger event type
	 */
	function hasCommand(eventType:String):Boolean;
}
}
