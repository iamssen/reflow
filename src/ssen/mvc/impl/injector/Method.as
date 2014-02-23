package ssen.mvc.impl.injector {

internal class Method implements InjectionTarget {
	public var methodName:String;
	public var argumentsTypes:Vector.<String>=new Vector.<String>;

	public function mapping(instance:Object, factoryMap:InstanceFactoryMap):void {
		var method:Function=instance[methodName];
		var args:Array=[];

		var f:int=-1;
		var fmax:int=argumentsTypes.length;

		while (++f < fmax) {
			args.push(factoryMap.get(argumentsTypes[f]).getInstance());
		}

		method.apply(null, args);
	}
}
}
