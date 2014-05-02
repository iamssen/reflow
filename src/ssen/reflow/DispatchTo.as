package ssen.reflow {

/**
 * [상수] <code>EventBus.dispatchEvent()</code>에서 <code>Event</code>를 발생시킬 <code>Context</code>를 지정할 때 사용되는 문자열 상수의 모음.
 *
 * @see IEventBus#dispatchEvent()
 */
final public class DispatchTo {
	/** 현재 <code>Context</code> */
	public static const CURRENT:String="current";

	/** 상위 <code>Context</code> */
	public static const PARENT:String="parent";

	/** 하위의 <code>Context</code>들 */
	public static const CHILDREN:String="children";

	/** 위치와 상관없이 모든 <code>Context</code>들 */
	public static const GLOBAL:String="global";
}
}
