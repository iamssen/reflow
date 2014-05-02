package ssen.reflow {
import flash.events.Event;

/**
 * [구현 불필요] <code>Context.eventBus</code>의 <code>Interface</code>.
 *
 * @see ssen.reflow.context.Context#mapDependency()
 *
 * @includeExample eventBusSample.txt
 */
public interface IEventBus {
	//----------------------------------------------------------------
	// event listener
	//----------------------------------------------------------------
	/**
	 * 기본 <code>IEventDispatcher.addEventListener()</code>와 유사하지만, 해제 방식이 다름
	 *
	 * @includeExample eventListenerSample.txt
	 *
	 * @see IEventListener
	 */
	function addEventListener(eventType:String, listener:Function):IEventListener;

	/** <code>addEventListener()</code>와 동일 */
	function on(type:String, listener:Function):IEventListener;

	//----------------------------------------------------------------
	// event dispatcher
	//----------------------------------------------------------------
	/**
	 * 기본 <code>IEventDispatcher.dispatchEvent()</code>와 유사하지만, <code>Context</code> 포함 관계를 지원하기 위한 옵션들이 추가되어 있음
	 *
	 * @param event Event
	 * @param to <code>Event</code>를 보낼 <code>Context</code>의 방향 [current | parent | children | global]
	 * @param penetrate <code>to</code>가 <code>parent</code>나 <code>children</code>일 경우, 전파를 지속시킬지 여부
	 *
	 * @see DispatchTo
	 */
	function dispatchEvent(event:Event, to:String="current", penetrate:Boolean=false):void;

	//----------------------------------------------------------------
	// tree
	//----------------------------------------------------------------
	/** @private */
	function get parentEventBus():IEventBus;
	
	/** @private */
	function createChildEventBus():IEventBus;
}
}
