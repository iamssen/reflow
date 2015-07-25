package ssen.reflow {

/**
 * [구현 불필요] <code>Context.backgroundProcessMap</code>의 <code>Interface</code>.
 *
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface IBackgroundServiceMap {
	function map(Type:Class, UseType:Class=null):void;
}
}
