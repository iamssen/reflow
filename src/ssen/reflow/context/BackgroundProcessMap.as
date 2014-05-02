package ssen.reflow.context {
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.reflow.IBackgroundProcess;
import ssen.reflow.IBackgroundProcessMap;
import ssen.reflow.reflow_internal;
import ssen.reflow.di.Injector;

use namespace reflow_internal;

/** @private implements class */
internal class BackgroundProcessMap implements IBackgroundProcessMap {
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
	// dic[backgroundProcessClass:Class]=BackgroundProcessInfo
	private var backgroundProcessInfos:Dictionary;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function BackgroundProcessMap() {
		backgroundProcessInfos=new Dictionary;
	}

	//==========================================================================================
	// life cycle on context
	//==========================================================================================
	public function setContext(hostContext:Context):void {
		context=hostContext;
	}

	public function start():void {
		var type:Class;
		var instance:IBackgroundProcess;
		var injector:Injector=context._injector;

		for each (var info:BackgroundProcessInfo in backgroundProcessInfos) {
			type=info.type;
			instance=new type();
			injector.injectInto(instance);

			info.instance=instance;
			info.instance.start();
		}
	}

	public function stop():void {
		for each (var info:BackgroundProcessInfo in backgroundProcessInfos) {
			if (info.instance) {
				info.instance.stop();
				info.instance=null;
			}
		}
	}

	public function dispose():void {
		context=null;
		backgroundProcessInfos=null;
	}

	//==========================================================================================
	// implements IBackgroundProcessMap
	//==========================================================================================
	public function map(Type:Class):void {
		if (backgroundProcessInfos[Type] !== undefined) {
			throw new Error(getQualifiedClassName(Type) + " is mapped!!!");
		}

		var info:BackgroundProcessInfo=new BackgroundProcessInfo;
		info.type=Type;

		backgroundProcessInfos[Type]=info;
	}
}
}
import ssen.reflow.IBackgroundProcess;

class BackgroundProcessInfo {
	public var type:Class;
	public var instance:IBackgroundProcess;
}
