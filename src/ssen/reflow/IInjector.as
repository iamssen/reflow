package ssen.reflow {

/**
 * [DO NOT IMPLEMENT]
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface IInjector {
	//----------------------------------------------------------------
	// tree
	//----------------------------------------------------------------
	function createChildInjector():IInjector;

	//----------------------------------------------------------------
	// get
	//----------------------------------------------------------------
	function getInstance(Type:Class):Object;

	function hasMapping(Type:Class):Boolean;

	function injectInto(obj:Object):void;

	//----------------------------------------------------------------
	// map
	//----------------------------------------------------------------
	function mapClass(Type:Class, Implementation:Class = null):void;

	function mapSingleton(Type:Class, Implementation:Class = null):void;

	function mapValue(Type:Class, usingValue:Object):void;

	function mapFactory(Type:Class, FactoryType:Class):void;

	//----------------------------------------------------------------
	// unmap
	//----------------------------------------------------------------
	function unmap(Type:Class):void;
}
}
