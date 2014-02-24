package ssen.mvc {
import ssen.common.IDisposable;

public interface IInjector extends IDisposable {
	function createChild():IInjector;
	function getInstance(asktype:Class):*;
	function hasMapping(asktype:Class):Boolean;
	function injectInto(obj:Object):Object;
	function mapClass(asktype:Class, usetype:Class=null):void;
	function mapSingleton(asktype:Class, usetype:Class=null):void;
	function mapValue(asktype:Class, usevalue:Object):void;
	function mapFactory(asktype:Class, usefactory:Class):void;
	function unmap(asktype:Class):void;
}
}
