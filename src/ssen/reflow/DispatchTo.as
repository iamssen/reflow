package ssen.reflow {

/**
 * [ENUM] Enums of <code>EventBus.dispatchEvent()</code> second parameter <code>dispatchTo</code>.
 * <p>This options choice dispatch <code>Event</code> to where.</p>
 *
 * @see IEventBus#dispatchEvent()
 * @see https://quip.com/TLsvANgJWgGM About the Context to Context event dispatching
 */
final public class DispatchTo {
	//	public static const CURRENT:String = "current";
	// TODO 기존 DispatchTo의 처리를 IEventDistributor로 이전
	public static const PARENT:String = "parent";
	public static const CHILDREN:String = "children";
	public static const GLOBAL:String = "global";
}
}
