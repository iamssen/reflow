package ssen.mvc {
import ssen.common.IDisposable;

public interface IInjector extends IDisposable {
	function createChild():IInjector;
	function getInstance(asktype:Class, named:String=""):*;
	function hasMapping(asktype:Class, named:String=""):Boolean;
	function injectInto(obj:Object):Object;
	function mapClass(asktype:Class, usetype:Class=null, named:String=""):void;
	function mapSingleton(asktype:Class, usetype:Class=null, named:String=""):void;
	function mapValue(asktype:Class, usevalue:*, named:String=""):void;
	function unmap(asktype:Class, named:String=""):void;
	function registerDependent(target:*):XML;
}
}
