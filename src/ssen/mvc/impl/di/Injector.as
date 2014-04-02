package ssen.mvc.impl.di {
import flash.utils.getQualifiedClassName;

import ssen.mvc.IInjector;
import ssen.mvc.mvc_internal;

use namespace mvc_internal;

/**
 * Dependency Injector
 */
public class Injector implements IInjector {
	//==========================================================================================
	// properties
	//==========================================================================================
	private static var typemap:TypeMap=new TypeMap;

	private var factoryMap:InstanceFactoryMap=new InstanceFactoryMap;
	private var parent:Injector;

	//==========================================================================================
	// tree api
	//==========================================================================================
	/** @inheritDoc */
	public function createChildInjector():IInjector {
		var child:Injector=new Injector;
		child.parent=this;
		return child;
	}

	/** @private */
	mvc_internal function setParent(parent:Injector):void {
		this.parent=parent;
	}

	//==========================================================================================
	// factories logic
	//==========================================================================================
	/** @inheritDoc */
	public function getInstance(asktype:Class):* {
		return getInstanceByName(getQualifiedClassName(asktype));
	}

	/** @private */
	mvc_internal function getInstanceByName(typeName:String):* {
		var injector:Injector=this;

		while (true) {
			if (injector.factoryMap.has(typeName)) {
				return injector.factoryMap.get(typeName).getInstance();
			} else if (injector.parent) {
				injector=injector.parent;
				continue;
			} else {
				return undefined;
			}
		}

		return undefined;
	}

	/** @inheritDoc */
	public function hasMapping(asktype:Class):Boolean {
		var injector:Injector=this;
		var typeName:String=getQualifiedClassName(asktype);

		while (true) {
			if (injector.factoryMap.has(typeName)) {
				return true;
			} else if (injector.parent) {
				injector=injector.parent;
				continue;
			} else {
				return false;
			}
		}

		return false;
	}

	/** @inheritDoc */
	public function injectInto(obj:Object):Object {
		var typeName:String=getQualifiedClassName(obj);

		if (!typemap.has(typeName)) {
			typemap.map(obj);
		}

		var injectionTargets:Vector.<InjectionTarget>=typemap.getInjectionTargets(obj);
		var injectionTarget:InjectionTarget;

		var f:int=-1;
		var fmax:int=injectionTargets.length;

		while (++f < fmax) {
			injectionTarget=injectionTargets[f];
			injectionTarget.mapping(obj, this);
		}

		return obj;
	}

	//==========================================================================================
	// map, unmap
	//==========================================================================================
	/** @inheritDoc */
	public function mapClass(asktype:Class, usetype:Class=null):void {
		if (!usetype) {
			usetype=asktype;
		}

		var instantiate:Instantiate=new Instantiate;
		instantiate.injector=this;
		instantiate.type=usetype;

		factoryMap.set(getQualifiedClassName(asktype), instantiate);
	}

	/** @inheritDoc */
	public function mapSingleton(asktype:Class, usetype:Class=null):void {
		if (!usetype) {
			usetype=asktype;
		}

		var singleton:Singleton=new Singleton;
		singleton.injector=this;
		singleton.type=usetype;

		factoryMap.set(getQualifiedClassName(asktype), singleton);
	}

	/** @inheritDoc */
	public function mapValue(asktype:Class, usevalue:Object):void {
		var value:Value=new Value;
		value.instance=usevalue;

		factoryMap.set(getQualifiedClassName(asktype), value);
	}

	/** @inheritDoc */
	public function mapFactory(askType:Class, factoryType:Class):void {
		var factory:Factory=new Factory;
		factory.injector=this;
		factory.factoryType=factoryType;

		factoryMap.set(getQualifiedClassName(askType), factory);
	}

	/** @inheritDoc */
	public function unmap(asktype:Class):void {
		factoryMap.unset(getQualifiedClassName(asktype));
	}

	//==========================================================================================
	// dispose
	//==========================================================================================
	/** @private */
	public function dispose():void {
		parent=null;
		factoryMap=null;
	}
}
}
