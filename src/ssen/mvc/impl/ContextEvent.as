package ssen.mvc.impl {
import ssen.mvc.Evt;

internal class ContextEvent extends Evt {
	public static const FROM_PARENT_CONTEXT:String="fromParentContext";
	public static const FROM_GLOBAL_CONTEXT:String="fromGlobalContext";
	public static const FROM_CHILD_CONTEXT:String="fromChildContext";

	public var evt:Evt;
	public var penetrate:Boolean;

	public function ContextEvent(type:String, evt:Evt, penetrate:Boolean) {
		super(type);
		this.evt=evt;
		this.penetrate=penetrate;
	}
}
}
