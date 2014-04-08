package ssen.mvc {

/**
 * Contants of "self, parent, children, global".
 *
 * @see IEventBus#dispatchEvent()
 */
public class DispatchTo {
	/** Dispatch to current Context */
	public static const CURRENT:String="current";

	/** Dispatch to parent Context */
	public static const PARENT:String="parent";

	/** Dispatch to children Contexts */
	public static const CHILDREN:String="children";

	/** Dispatch to all Contexts */
	public static const GLOBAL:String="global";
}
}
