package ssen.reflow {

/**
 * [구현 불필요] <code>Context.commandMap</code>의 <code>Interface</code>.
 *
 * @see ssen.reflow.context.Context#mapDependency()
 *
 * @includeExample commandMapSample.txt
 */
public interface ICommandMap {

	/**
	 * @param eventType 이 <code>Event</code>가 <code>EventBus</code>에서 발생될 때
	 * @param commandClasses 이 <code>Command Class</code>들이 실행됨
	 */
	function map(eventType:String, commandClasses:Vector.<Class>, avoidRunSameCommand:Boolean = false):void;

	function unmap(eventType:String):void;

	function has(eventType:String):Boolean;

	function get activatedCommandChains():Vector.<ICommandChain>;
}
}
