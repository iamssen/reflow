package ssen.reflow.context {
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.reflow.IBackgroundService;
import ssen.reflow.IBackgroundServiceMap;
import ssen.reflow.di.Injector;
import ssen.reflow.reflow_internal;

use namespace reflow_internal;

/** @private implements class */
internal class BackgroundServiceMap implements IBackgroundServiceMap {
	private var hostContext:Context;

	private var backgroundServiceInfos:Dictionary; // [backgroundServiceClass:Class]=BackgroundServiceInfo
	private var started:Boolean;

	//==========================================================================================
	// func
	//==========================================================================================
	//----------------------------------------------------------------
	// context life cycle
	//----------------------------------------------------------------
	public function setContext(context:Context):void {
		hostContext = context;
		backgroundServiceInfos = new Dictionary;
	}

	public function dispose():void {
		if (started) stop();
		hostContext = null;
		backgroundServiceInfos = null;
	}

	public function start():void {
		var Type:Class;
		var UseType:Class;
		var instance:IBackgroundService;
		var injector:Injector = hostContext._injector;

		for each (var info:BackgroundServiceInfo in backgroundServiceInfos) {
			Type = info.Type;
			UseType = info.Type;

			instance = new UseType();
			
			injector.injectInto(instance);
			injector.mapValue(Type, instance);

			info.instance = instance;
			info.instance.start();
		}

		started = true;
	}

	public function stop():void {
		var injector:Injector = hostContext._injector;
		
		for each (var info:BackgroundServiceInfo in backgroundServiceInfos) {
			if (info.instance) {
				injector.unmap(info.Type);
				
				info.instance.stop();
				info.instance = null;
			}
		}

		started = false;
	}


	//----------------------------------------------------------------
	// implements IBackgroundProcessMap
	//----------------------------------------------------------------
	public function map(Type:Class, UseType:Class = null):void {
		if (started) {
			throw new Error(getQualifiedClassName(IBackgroundServiceMap) + ".map() can't call after Context started");
		}

		if (backgroundServiceInfos[Type] !== undefined) {
			throw new Error(getQualifiedClassName(Type) + " exists on " + getQualifiedClassName(IBackgroundServiceMap));
		}

		var info:BackgroundServiceInfo = new BackgroundServiceInfo;
		info.Type = Type;
		info.UseType = (UseType) ? UseType : Type;

		backgroundServiceInfos[Type] = info;
	}
}
}

import ssen.reflow.IBackgroundService;

class BackgroundServiceInfo {
	public var Type:Class;
	public var UseType:Class;
	public var instance:IBackgroundService;
}
