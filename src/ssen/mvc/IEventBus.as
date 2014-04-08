package ssen.mvc {
import flash.events.Event;

/**
 * EventBus.
 *
 * @see ssen.mvc.context.Context#mapDependency()
 *
 * @includeExample eventBusSample.txt
 */
public interface IEventBus {
	//==========================================================================================
	// listener
	//==========================================================================================
	/**
	 * @param type Event type
	 * @param listener Listener handler
	 */
	function addEventListener(type:String, listener:Function):IEventListener;

	/**
	 * @param type Event type
	 * @param listener Listener handler
	 */
	function on(type:String, listener:Function):IEventListener;

	//==========================================================================================
	// dispatcher
	//==========================================================================================
	/**
	 * @param event Event
	 * @param to Where dispatch to context direction (current, parent, children, global)
	 * @param penetrate
	 *
	 * @see DispatchTo
	 */
	function dispatchEvent(event:Event, to:String="current", penetrate:Boolean=false):void;

	//==========================================================================================
	// tree
	//==========================================================================================
	function get parentEventBus():IEventBus;
	function createChildEventBus():IEventBus;
}
}
