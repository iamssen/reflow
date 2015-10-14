package ssen.reflow {

/**
 * [DO NOT IMPLEMENT]
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface IViewMap {
	function map(ViewType:Class, MediatorType:Class = null, global:Boolean = false):void;

	function unmap(ViewType:Class):void;

	function has(view:*):Boolean;
}
}
