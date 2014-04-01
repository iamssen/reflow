package ssen.mvc {

public interface IInjector {
	//==========================================================================================
	// tree
	//==========================================================================================
	function createChild():IInjector;

	//==========================================================================================
	// get
	//==========================================================================================
	function getInstance(asktype:Class):*;
	function hasMapping(asktype:Class):Boolean;
	function injectInto(obj:Object):Object;

	//==========================================================================================
	// map
	//==========================================================================================
	function mapClass(asktype:Class, usetype:Class=null):void;
	function mapSingleton(asktype:Class, usetype:Class=null):void;
	function mapValue(asktype:Class, usevalue:Object):void;
	function mapFactory(asktype:Class, usefactory:Class):void;
	function mapPath(askType:Class, host:Object, ... paths):void;

	//==========================================================================================
	// unmap
	//==========================================================================================
	function unmap(asktype:Class):void;
}
}
