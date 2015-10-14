package ssen.reflow {

/**
 * [DO NOT IMPLEMENT]
 * @see ssen.reflow.context.Context#mapDependency()
 * @see ssen.reflow.context.Context#backgroundServiceMap
 */
public interface IBackgroundServiceMap {
	function map(RequestType:Class, ResponseType:Class = null):void;
}
}
