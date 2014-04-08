package ssen.mvc.di {
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

/** @private implements class */
internal class TypeMap {
	// [name.space::Class] = Vector.<InjectionTarget>
	private var types:Object={};

	// [name.space::Class] = "methodName" 
	private var havePostConstructor:Object={};

	public function has(source:*):Boolean {
		var typeName:String=(source is String) ? source : getQualifiedClassName(source);
		return types[typeName] is InjectionTarget;
	}

	public function map(target:*):void {
		var typeName:String=getQualifiedClassName(target);

		if (types[typeName]) {
			return;
		}

		//----------------------------------------------------------------
		// xml types
		//----------------------------------------------------------------
		//	<[variable | accessor] name="" type="">
		//		<metadata name="Inject" />
		//	</[variable | accessor]>
		//
		//	<method name="">
		//		<parameter index="1" type="String"/>
		//		<parameter index="2" type="String"/>
		//		<parameter index="3" type="String"/>
		//		<metadata name="Inject" />
		//	</method>
		var spec:XML=describeType(target);

		//	<[variable | accessor | method]>
		//		<metadata name="Inject"/>		
		//	</[variable | accessor | method]>
		var injectList:XMLList=spec..metadata.(@name == "Inject");
		var inject:XML;

		//	<[variable | accessor | method] />
		var member:XML;

		//	<method>
		//		<parameter index="1" type="String"/>
		//		<parameter index="2" type="String"/>
		//	</method>
		var params:XMLList;
		var param:XML;


		//----------------------------------------------------------------
		// loop
		//----------------------------------------------------------------
		var f:int=-1;
		var fmax:int=injectList.length();
		var s:int;
		var smax:int;

		//----------------------------------------------------------------
		// types
		//----------------------------------------------------------------
		var argumentsTypes:Vector.<String>;
		var injectionTargets:Vector.<InjectionTarget>=new Vector.<InjectionTarget>(fmax, true);
		var propertyInjectionTarget:Property;
		var methodInjectionTarget:Method;

		while (++f < fmax) {
			inject=injectList[f];
			member=inject.parent();

			if ((member.name() == "variable") || (member.name() == "accessor" && member.@access != "readonly")) {
				propertyInjectionTarget=new Property;
				propertyInjectionTarget.propertyName=member.@name.toString();
				propertyInjectionTarget.valueType=member.@type.toString();

				injectionTargets[f]=propertyInjectionTarget;

			} else if (member.name() == "method") {
				params=member.parameter;

				s=-1;
				smax=params.length();

				if (params.length() === 0) {
					continue;
				}

				argumentsTypes=new Vector.<String>(smax, true);

				while (++s < smax) {
					argumentsTypes[s]=params[s].@type.toString();
				}

				methodInjectionTarget=new Method;
				methodInjectionTarget.methodName=member.@name.toString();
				methodInjectionTarget.argumentsTypes=argumentsTypes;

				injectionTargets[f]=methodInjectionTarget;
			}
		}

		types[typeName]=injectionTargets;


		//----------------------------------------------------------------
		// check post constructor
		//----------------------------------------------------------------
		var postConstructList:XMLList=spec..metadata.(@name == "PostConstruct");

		if (postConstructList.length() > 0) {
			member=postConstructList[0].parent();

			if (member.name() == "method") {
				havePostConstructor[typeName]=member.@name.toString();
			}
		}
	}

	public function getInjectionTargets(instance:Object):Vector.<InjectionTarget> {
		return types[getQualifiedClassName(instance)];
	}

	public function getPostConstructor(instance:Object):String {
		return havePostConstructor[getQualifiedClassName(instance)];
	}

	//	public function injectInto(instance:Object, factoryMap:InstanceFactoryMap):void {
	//		var typeName:String=getQualifiedClassName(instance);
	//		var injectionTargets:Vector.<InjectionTarget>=types[typeName];
	//
	//		if (!injectionTargets) {
	//			throw new Error("No have injection targets map of " + typeName);
	//		}
	//
	//		var injectionTarget:InjectionTarget;
	//
	//		var f:int=-1;
	//		var fmax:int=injectionTargets.length;
	//
	//		while (++f < fmax) {
	//			injectionTargets[f].mapping(instance, factoryMap);
	//		}
	//	}
}
}
