package ssen.reflow {

/**
 * [DO NOT IMPLEMENT] Interface of <code>Context.backgroundProcessMap</code>.
 *
 * @see ssen.reflow.context.Context#mapDependency()
 * @see ssen.reflow.context.Context#backgroundServiceMap
 */
public interface IBackgroundServiceMap {
	function map(RequestType:Class, ResponseType:Class = null):void;
}
}
