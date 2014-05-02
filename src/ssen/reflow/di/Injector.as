package ssen.reflow.di {
import flash.utils.getQualifiedClassName;

import ssen.reflow.IInjector;
import ssen.reflow.reflow_internal;

use namespace reflow_internal;

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
	reflow_internal function setParent(parent:Injector):void {
		this.parent=parent;
	}

	//==========================================================================================
	// factories logic
	//==========================================================================================
	/** @inheritDoc */
	public function getInstance(Type:Class):Object {
		return getInstanceByName(getQualifiedClassName(Type));
	}

	/** @private */
	reflow_internal function getInstanceByName(typeName:String):Object {
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
	public function hasMapping(Type:Class):Boolean {
		var injector:Injector=this;
		var typeName:String=getQualifiedClassName(Type);

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
	public function injectInto(obj:Object):void {
		var typeName:String=getQualifiedClassName(obj);

		if (!typemap.has(typeName)) {
			typemap.map(obj);
		}

		// inject dependent
		var injectionTargets:Vector.<InjectionTarget>=typemap.getInjectionTargets(obj);
		var injectionTarget:InjectionTarget;

		var f:int=-1;
		var fmax:int=injectionTargets.length;

		while (++f < fmax) {
			injectionTarget=injectionTargets[f];
			injectionTarget.mapping(obj, this);
		}

		// execute post constructor
		var postConstructor:String=typemap.getPostConstructor(obj);

		if (postConstructor) {
			obj[postConstructor]();
		}
	}

	//==========================================================================================
	// map, unmap
	//==========================================================================================
	/** @inheritDoc */
	public function mapClass(Type:Class, Implementation:Class=null):void {
		if (!Implementation) {
			Implementation=Type;
		}

		var instantiate:Instantiate=new Instantiate;
		instantiate.injector=this;
		instantiate.type=Implementation;

		factoryMap.set(getQualifiedClassName(Type), instantiate);
	}

	/** @inheritDoc */
	public function mapSingleton(Type:Class, Implementation:Class=null):void {
		if (!Implementation) {
			Implementation=Type;
		}

		var singleton:Singleton=new Singleton;
		singleton.injector=this;
		singleton.type=Implementation;

		factoryMap.set(getQualifiedClassName(Type), singleton);
	}

	/** @inheritDoc */
	public function mapValue(Type:Class, usingValue:Object):void {
		var value:Value=new Value;
		value.instance=usingValue;

		factoryMap.set(getQualifiedClassName(Type), value);
	}

	/** @inheritDoc */
	public function mapFactory(Type:Class, FactoryType:Class):void {
		var factory:Factory=new Factory;
		factory.injector=this;
		factory.factoryType=FactoryType;

		factoryMap.set(getQualifiedClassName(Type), factory);
	}

	/** @inheritDoc */
	public function unmap(Type:Class):void {
		factoryMap.unset(getQualifiedClassName(Type));
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
