package ssen.reflow {

/**
 * [DO NOT IMPLEMENT]
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface ICommandMap {
	function map(eventType:String, commands:ICommandFlow, avoidRunSameCommand:Boolean = false):void;

	function unmap(eventType:String):void;

	function has(eventType:String):Boolean;

	function get progressingCommandChains():Vector.<ICommandChain>;
}
}
