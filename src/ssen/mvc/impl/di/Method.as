package ssen.mvc.impl.di {
import ssen.mvc.mvc_internal;

use namespace mvc_internal;

internal class Method implements InjectionTarget {
	public var methodName:String;
	public var argumentsTypes:Vector.<String>=new Vector.<String>;

	public function mapping(instance:Object, injector:Injector):void {
		var method:Function=instance[methodName];
		var args:Array=[];

		var f:int=-1;
		var fmax:int=argumentsTypes.length;

		while (++f < fmax) {
			args.push(injector.getInstanceByName(argumentsTypes[f]));
		}

		method.apply(null, args);
	}
}
}
