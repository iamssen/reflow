package ssen.mvc.impl {
import flash.events.Event;

internal class ContextEvent extends Event {
	public static const FROM_PARENT_CONTEXT:String="fromParentContext";
	public static const FROM_GLOBAL_CONTEXT:String="fromGlobalContext";
	public static const FROM_CHILDREN_CONTEXT:String="fromChildContext";

	public var evt:Event;
	public var penetrate:Boolean;

	public function ContextEvent(type:String, evt:Event, penetrate:Boolean) {
		super(type);
		this.evt=evt;
		this.penetrate=penetrate;
	}
}
}
