package ssen.mvc.impl {
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;
import ssen.mvc.IDependent;
import ssen.mvc.IInjector;
import ssen.mvc.mvc_internal;

use namespace mvc_internal;

public class Injector implements IInjector {
	mvc_internal static var dependents:Object={};

	private var factories:Object;
	private var parent:Injector;
	private var factoriesset:Array;

	public function Injector(parent:Injector=null) {
		this.parent=parent;
		this.factories={};
		this.factoriesset=[this.factories];

		if (parent) {
			var current:Injector=parent;
			while (current) {
				factoriesset.push(current.factories);
				current=current.parent;
			}
		}
	}

	//==========================================================================================
	// children
	//==========================================================================================
	public function createChild():IInjector {
		return new Injector(this);
	}

	//==========================================================================================
	// factories logic
	//==========================================================================================
	public function getInstance(asktype:Class, named:String=""):* {
		var factory:InstanceFactory=getValueFactory(asktype, named);
		return factory ? factory.getInstance() : undefined;
	}

	public function hasMapping(asktype:Class, named:String=""):Boolean {
		var factory:InstanceFactory=getValueFactory(asktype, named);
		return factory !== null;
	}

	public function injectInto(obj:Object):Object {
		// 아이디 생성
		var id:String=getQualifiedClassName(obj);

		// 의존성 맵에 있는지 확인하고, 없다면 생성해준다
		
		if (!dependents[id]) {
			registerDependent(obj);
		}

		var d:Object;
		var list:Array=dependents[id];
		var facs:Array;
		var fac:InstanceFactory;
		var args:Array;
		var method:Function;

		var f:int=-1;
		var fmax:int=list.length;
		var s:int;
		var smax:int;

		while (++f < fmax) {
			d=list[f];

			if (d.type === "property") {
				//	 fac=factories[d.factory];
				fac=getValueFactoryByName(d.factory);
				obj[d.name]=fac.getInstance();
			} else if (d.type === "method") {
				method=obj[d.name];

				// TODO 에러 가능성 있음
				facs=d.factories;
				args=[];

				s=-1;
				smax=facs.length;
				while (++s < smax) {
					fac=facs[s];
					args.push(fac.getInstance());
				}

				method.apply(null, args);
			} else {
				throw new Error("type is property or method");
			}
		}

		if (obj is IDependent) {
			IDependent(obj).onDependent();
		}

		return obj;
	}

	//==========================================================================================
	// map, unmap
	//==========================================================================================
	public function mapClass(asktype:Class, usetype:Class=null, named:String=""):void {
		if (!usetype) {
			usetype=asktype;
		}
		factories[getNameByClass(asktype, named)]=new InstantiateFactory(this, usetype);
		registerDependent(usetype);
	}

	public function mapSingleton(asktype:Class, usetype:Class=null, named:String=""):void {
		if (!usetype) {
			usetype=asktype;
		}
		factories[getNameByClass(asktype, named)]=new SingletonFactory(this, usetype);
		registerDependent(usetype);
	}

	public function mapValue(asktype:Class, usevalue:*, named:String=""):void {
		factories[getNameByClass(asktype, named)]=new ValueFactory(this, usevalue);
		registerDependent(usevalue);
	}

	public function unmap(asktype:Class, named:String=""):void {
		var factory:InstanceFactory=factories[getNameByClass(asktype, named)];

		if (factory) {
			factory.dispose();
			delete factories[getNameByClass(asktype, named)];
		}
	}

	//==========================================================================================
	// dispose
	//==========================================================================================
	public function dispose():void {
		for each (var factory:InstanceFactory in factories) {
			if (factory) {
				factory.dispose();
			}
		}

		factories=null;
		parent=null;
		factoriesset=null;
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	public function registerDependent(target:*):XML {
		var id:String=getQualifiedClassName(target);
		if (dependents[id]) {
			return null;
		}

		var spec:XML=describeType(target);

		var injectList:XMLList=spec..metadata.(@name == "Inject");

		var member:XML;
		var inject:XML;
		var keys:XMLList;
		var params:XMLList;
		var param:XML;

		var list:Array=[];
		var factories:Array;

		var f:int=-1;
		var fmax:int=injectList.length();
		var s:int;
		var smax:int;

		while (++f < fmax) {
			inject=injectList[f];
			member=inject.parent();
			keys=inject.arg.(@key == "name");

			if ((member.name() == "variable") || (member.name() == "accessor" && member.@access != "readonly")) {
				list.push({name: member.@name.toString(), type: "property", factory: getName(member.@type.toString(), (keys.length() > 0) ? keys[0].@value.toString() : "")});
			} else if (member.name() == "method") {
				params=member.parameter;
				s=-1;
				smax=params.length();

				if (params.length() === 0) {
					continue;
				}

				factories=[];

				while (++s < smax) {
					factories.push(getName(params[s].@type.toString(), (keys.length() > s) ? keys[s].@value.toString() : ""));
				}
				list.push({name: member.@name.toString(), type: "method", factories: factories});
			}
		}

		dependents[id]=list;

		return spec;
	}

	private function getValueFactory(type:Class, named:String):InstanceFactory {
		var id:String=getNameByClass(type, named);

		var factories:Object;
		var factory:InstanceFactory;

		var f:int=-1;
		var fmax:int=factoriesset.length;

		while (++f < fmax) {
			factories=factoriesset[f];
			if (factories[id]) {
				return factories[id];
			}
		}

		return undefined;
	}

	private function getValueFactoryByName(id:String):InstanceFactory {
		var factories:Object;
		var factory:InstanceFactory;

		var f:int=-1;
		var fmax:int=factoriesset.length;

		while (++f < fmax) {
			factories=factoriesset[f];
			if (factories[id]) {
				return factories[id];
			}
		}

		return undefined;
	}

	private function getNameByClass(type:Object, named:String):String {
		return getQualifiedClassName(type) + "#" + named;
	}

	private function getName(type:String, named:String):String {
		return type + "#" + named;
	}
}
}
import mx.core.IFactory;

import ssen.common.IDisposable;
import ssen.mvc.impl.Injector;

class InstanceFactory implements IDisposable {
	private var injector:Injector;

	public function InstanceFactory(injector:Injector) {
		this.injector=injector;
	}

	public function getInstance():* {
		throw new Error("not implemented");
	}

	protected function instanceInitialize(instance:Object):Object {
		return injector.injectInto(instance);
	}

	public function dispose():void {
		injector=null;
	}
}

class InstantiateFactory extends InstanceFactory {
	private var type:Class;

	public function InstantiateFactory(injector:Injector, type:Class) {
		super(injector);
		this.type=type;
	}

	override public function getInstance():* {
		return instanceInitialize(new type);
	}

	override public function dispose():void {
		super.dispose();
		type=null;
	}
}

class SingletonFactory extends InstanceFactory {
	private var type:Class;
	private var instance:Object;

	public function SingletonFactory(injector:Injector, type:Class) {
		super(injector);
		this.type=type;
	}

	override public function getInstance():* {
		if (!instance) {
			instance=instanceInitialize(new type);
		}

		return instance;
	}

	override public function dispose():void {
		super.dispose();

		if (instance is IDisposable) {
			IDisposable(instance).dispose();
		}

		type=null;
		instance=null;
	}
}

class ValueFactory extends InstanceFactory {
	private var value:*;
	private var initialized:Boolean;

	public function ValueFactory(injector:Injector, value:*) {
		super(injector);
		this.value=value;
	}

	override public function getInstance():* {
		if (!initialized) {
			instanceInitialize(value);
		}

		return value;
	}

	override public function dispose():void {
		super.dispose();

		if (value is IDisposable) {
			IDisposable(value).dispose();
		}

		value=null;
	}
}

class FactorialFactory extends InstanceFactory {
	private var type:Class;
	private var factoryClass:Class;

	public function FactorialFactory(injector:Injector, type:Class, factoryClass:Class) {
		super(injector);
		this.type=type;
		this.factoryClass=factoryClass;
	}

	override public function getInstance():* {
		var factory:IFactory=new factoryClass();
		instanceInitialize(factory);
		return instanceInitialize(factory.newInstance());
	}

	override public function dispose():void {
		super.dispose();
		type=null;
		factoryClass=null;
	}
}
