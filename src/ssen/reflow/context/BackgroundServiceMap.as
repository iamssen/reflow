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
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// dependent
	//----------------------------------------------------------------
	private var context:Context;

	//----------------------------------------------------------------
	// variables
	//----------------------------------------------------------------
	// dic[backgroundServiceClass:Class]=BackgroundServiceInfo
	private var backgroundServiceInfos:Dictionary;
	private var started:Boolean;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function BackgroundServiceMap() {
		backgroundServiceInfos = new Dictionary;
	}

	//==========================================================================================
	// life cycle on context
	//==========================================================================================
	public function setContext(hostContext:Context):void {
		context = hostContext;
	}

	public function start():void {
		var type:Class;
		var useType:Class;
		var instance:IBackgroundService;
		var injector:Injector = context._injector;

		for each (var info:BackgroundServiceInfo in backgroundServiceInfos) {
			type = info.type;
			useType = info.type;

			instance = new useType();
			
			injector.injectInto(instance);
			injector.mapValue(type, instance);

			info.instance = instance;
			info.instance.start();
		}

		started = true;
	}

	public function stop():void {
		var injector:Injector = context._injector;
		
		for each (var info:BackgroundServiceInfo in backgroundServiceInfos) {
			if (info.instance) {
				injector.unmap(info.type);
				
				info.instance.stop();
				info.instance = null;
			}
		}

		started = false;
	}

	public function dispose():void {
		if (started) stop();
		context = null;
		backgroundServiceInfos = null;
	}

	//==========================================================================================
	// implements IBackgroundProcessMap
	//==========================================================================================
	public function map(Type:Class, UseType:Class = null):void {
		if (started) {
			throw new Error("background service mapping can't after context started.")
		}

		if (backgroundServiceInfos[Type] !== undefined) {
			throw new Error(getQualifiedClassName(Type) + " is exists on background service map.");
		}

		var info:BackgroundServiceInfo = new BackgroundServiceInfo;
		info.type = Type;
		info.useType = (UseType) ? UseType : Type;

		backgroundServiceInfos[Type] = info;
	}
}
}

import ssen.reflow.IBackgroundService;

class BackgroundServiceInfo {
	public var type:Class;
	public var useType:Class;
	public var instance:IBackgroundService;
}
