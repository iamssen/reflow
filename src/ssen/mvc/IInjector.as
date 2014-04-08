package ssen.mvc {

/**
 * Dependency Injector.
 *
 * @see ssen.mvc.context.Context#mapDependency()
 */
public interface IInjector {
	//==========================================================================================
	// tree
	//==========================================================================================
	function createChildInjector():IInjector;

	//==========================================================================================
	// get
	//==========================================================================================
	/**
	 * Get dependent instance
	 *
	 * @param Type Register type
	 */
	function getInstance(Type:Class):Object;

	/**
	 * Has registered dependent type
	 *
	 * @param Type Register type
	 */
	function hasMapping(Type:Class):Boolean;

	/**
	 * Dependency injection
	 *
	 * @param obj Any object or class
	 */
	function injectInto(obj:Object):void;

	//==========================================================================================
	// map
	//==========================================================================================
	/**
	 * Map dependent as everytime make new instance
	 *
	 * @param Type Register type
	 * @param Implementation Implementation type. Require extends or implementation registered type
	 */
	function mapClass(Type:Class, Implementation:Class=null):void;

	/**
	 * Map dependent as singleton instance in Context
	 *
	 * @param Type Register type
	 * @param Implementation Implementation type. Require extends or implementation registered type
	 */
	function mapSingleton(Type:Class, Implementation:Class=null):void;

	/**
	 * Map dependent as singleton instance in Context
	 *
	 * @param Type Register type
	 * @param usingValue Using value. Require extends or implementation registered type
	 */
	function mapValue(Type:Class, usingValue:Object):void;

	/**
	 * Map dependent as everytime make new instance using Factory
	 *
	 * @param Type Register type
	 * @param FactoryType Factory require implementation mx.core.IFactory and making instance need require extends or implementation registered type
	 */
	function mapFactory(Type:Class, FactoryType:Class):void;

	//==========================================================================================
	// unmap
	//==========================================================================================
	/**
	 * Unmap dependent
	 *
	 * @param Type Register type
	 */
	function unmap(Type:Class):void;
}
}
