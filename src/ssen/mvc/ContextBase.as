package ssen.mvc {

/** @see ssen.mvc.ondisplay.Context */
public class ContextBase implements IContext {
	private var _contextView:IContextView;
	private var _parentContext:IContext;
	private var _eventBus:IEventBus;
	private var _injector:IInjector;
	private var _contextViewInjector:ImplContextViewInjector;
	private var _commandMap:ImplCommandMap;

	public function ContextBase(contextView:IContextView, parentContext:IContext=null) {
		_parentContext=parentContext;
		_contextView=contextView;

		initialize();
	}

	/** @private */
	protected function initialize():void {
		injector.mapValue(IInjector, injector);
		injector.mapValue(IEvtDispatcher, eventBus.evtDispatcher);
		injector.mapValue(IEventBus, eventBus);
		injector.mapValue(IContextView, contextView);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IViewInjector, viewInjector);
		injector.mapValue(ICallLater, callLater);

		mapDependency();

		viewCatcher.start(contextView);
	}

	protected function mapDependency():void {
	}

	protected function startup():void {
	}

	protected function shutdown():void {
	}

	protected function dispose():void {
		viewCatcher.stop();

		callLater.dispose();
		eventBus.dispose();
		injector.dispose();
		viewCatcher.dispose();
		viewInjector.dispose();
		contextViewInjector.dispose();
		commandMap.dispose();

		_contextView=null;
		_parentContext=null;
		_eventBus=null;
		_injector=null;
		_contextViewInjector=null;
		_commandMap=null;
	}

	//==========================================================================================
	// 
	//==========================================================================================
	/** @see ssen.mvc.core.IContextView */
	final protected function get contextView():IContextView {
		return _contextView;
	}

	/** @private */
	final protected function get parentContext():IContext {
		return _parentContext;
	}

	protected function get stage():Object {
		throw new Error("not implemented");
	}

	/** @see ssen.mvc.core.IEventBus */
	final public function get eventBus():IEventBus {
		if (_eventBus) {
			return _eventBus;
		}

		_eventBus=parentContext === null ? new EventBus : new EventBus(parentContext.eventBus);

		return _eventBus;
	}

	/** @see ssen.mvc.core.IInjector */
	final public function get injector():IInjector {
		if (_injector) {
			return _injector;
		}

		_injector=parentContext === null ? new Injector : parentContext.injector.createChild();

		return _injector;
	}

	protected function get callLater():ICallLater {
		throw new Error("not implemented");
	}

	protected function get viewCatcher():IViewCatcher {
		throw new Error("not implemented");
	}

	protected function get viewInjector():IViewInjector {
		throw new Error("not implemented");
	}

	final protected function get contextViewInjector():IContextViewInjector {
		return _contextViewInjector||=new ImplContextViewInjector(this);
	}

	/** @see ssen.mvc.core.ICommandMap */
	public function get commandMap():ICommandMap {
		return _commandMap||=new ImplCommandMap(eventBus.evtDispatcher, injector);
	}
}
}
import flash.utils.Dictionary;

import ssen.datakit.ds.MultipleKeyDataCollection;
import ssen.mvc.DispatchTo;
import ssen.mvc.Evt;
import ssen.mvc.helpers.EvtGatherer;
import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;
import ssen.mvc.ICommandMap;
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;
import ssen.mvc.IEventBus;
import ssen.mvc.IEvtDispatcher;
import ssen.mvc.IEvtUnit;
import ssen.mvc.IInjector;
import ssen.mvc.mvc_internal;

use namespace mvc_internal;

class ImplCommandMap implements ICommandMap {
	private var dic:Dictionary;
	private var injector:IInjector;
	private var dispatcher:IEvtDispatcher;
	private var evtUnits:EvtGatherer;

	public function ImplCommandMap(dispatcher:IEvtDispatcher, injector:IInjector) {
		this.dispatcher=dispatcher;
		this.injector=injector;
		dic=new Dictionary;
		evtUnits=new EvtGatherer;
	}

	public function mapCommand(eventType:String, commandClasses:Vector.<Class>):void {
		if (dic[eventType] !== undefined) {
			throw new Error("mapped this event type");
		}

		dic[eventType]=commandClasses;
		evtUnits.add(dispatcher.addEvtListener(eventType, eventCatched));
	}

	private function eventCatched(event:Evt):void {
		var chain:ICommandChain=new ImplEventChain(event, create(event.type));
		chain.next();
	}

	public function unmapCommand(eventType:String):void {
		if (dic[eventType] === undefined) {
			throw new Error("undefined this command type");
		}

		evtUnits.remove(eventType);
		delete dic[eventType];
	}

	public function hasMapping(eventType:String):Boolean {
		return dic[eventType] !== undefined;
	}

	private function create(eventType:String):Vector.<ICommand> {
		if (dic[eventType] === undefined) {
			throw new Error("undefined command");
		}

		var commandClasses:Vector.<Class>=dic[eventType];
		var commands:Vector.<ICommand>=new Vector.<ICommand>(commandClasses.length, true);
		var cls:Class;

		var f:int=commandClasses.length;
		while (--f >= 0) {
			cls=commandClasses[f];
			commands[f]=new cls();
			injector.injectInto(commands[f]);
		}

		return commands;
	}

	public function dispose():void {
		dic=null;
	}
}

//==========================================================================================
// event chain
//==========================================================================================
class ImplEventChain implements ICommandChain {

	private var _commands:Vector.<ICommand>;
	private var dic:Dictionary;
	private var c:int=-1;
	private var _trigger:Evt;

	public function ImplEventChain(trigger:Evt, commands:Vector.<ICommand>) {
		_trigger=trigger;
		_commands=commands;
	}

	public function get cache():Dictionary {
		if (dic === null) {
			dic=new Dictionary(true);
		}

		return dic;
	}

	public function get current():int {
		return c;
	}

	public function next():void {
		if (++c < _commands.length) {
			_commands[c].execute(this);
		} else {
			var f:int=_commands.length;
			while (--f >= 0) {
				_commands[f].dispose();
			}
			_commands=null;
			dic=null;
		}
	}

	public function get numCommands():int {
		return _commands.length;
	}

	public function get trigger():Evt {
		return _trigger;
	}
}

//==========================================================================================
// event bus
//==========================================================================================
class EventBus implements IEventBus {

	private static var _globalDispatcher:IEvtDispatcher;
	private var _parent:IEventBus;
	private var _evtDispatcher:IEvtDispatcher;
	private var _eventUnits:EvtGatherer;

	public function EventBus(parent:IEventBus=null) {
		if (_globalDispatcher === null) {
			_globalDispatcher=new EvtDispatcher;
		}

		_evtDispatcher=new EvtDispatcher;
		_parent=parent;
		_eventUnits=new EvtGatherer;

		if (_parent)
			_eventUnits.add(_parent.evtDispatcher.addEvtListener(ContextEvent.FROM_PARENT_CONTEXT, catchOutsideEvent));
		_eventUnits.add(_globalDispatcher.addEvtListener(ContextEvent.FROM_GLOBAL_CONTEXT, catchOutsideEvent));
		_eventUnits.add(_evtDispatcher.addEvtListener(ContextEvent.FROM_CHILD_CONTEXT, catchOutsideEvent));
	}

	//----------------------------------------------------------------
	// dispatcher method
	//----------------------------------------------------------------
	public function addEventListener(type:String, listener:Function):IEvtUnit {
		return _evtDispatcher.addEvtListener(type, listener);
	}

	private function catchOutsideEvent(event:ContextEvent):void {
		_evtDispatcher.dispatchEvt(event.evt);

		if (event.penetrate) {
			if (event.type === ContextEvent.FROM_CHILD_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.PARENT, true);
			} else if (event.type === ContextEvent.FROM_PARENT_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.CHILDREN, true);
			}
		}
	}

	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	public function get evtDispatcher():IEvtDispatcher {
		return _evtDispatcher;
	}

	public function get parentEventBus():IEventBus {
		return _parent;
	}

	public function createChildEventBus():IEventBus {
		return new EventBus(this);
	}

	public function dispatchEvent(evt:Evt, to:String="self", penetrate:Boolean=false):void {
		if (to == DispatchTo.CHILDREN) {
			_evtDispatcher.dispatchEvt(new ContextEvent(ContextEvent.FROM_PARENT_CONTEXT, evt, penetrate));
		} else if (to == DispatchTo.ALL) {
			_globalDispatcher.dispatchEvt(new ContextEvent(ContextEvent.FROM_GLOBAL_CONTEXT, evt, penetrate));
		} else if (to == DispatchTo.PARENT) {
			if (_parent) {
				_parent.evtDispatcher.dispatchEvt(new ContextEvent(ContextEvent.FROM_CHILD_CONTEXT, evt, penetrate));
			}
		} else if (to == DispatchTo.SELF) {
			_evtDispatcher.dispatchEvt(evt);
		} else {
			throw new Error("unknown dispatch target :: " + to);
		}
	}

	public function dispose():void {
		_eventUnits.dispose();
		_evtDispatcher.dispose();

		_eventUnits=null;
		_evtDispatcher=null;
		_parent=null;
	}
}

class ContextEvent extends Evt {
	public static const FROM_PARENT_CONTEXT:String="fromParentContext";
	public static const FROM_GLOBAL_CONTEXT:String="fromGlobalContext";
	public static const FROM_CHILD_CONTEXT:String="fromChildContext";

	public var evt:Evt;
	public var penetrate:Boolean;

	public function ContextEvent(type:String, evt:Evt, penetrate:Boolean) {
		super(type);
		this.evt=evt;
		this.penetrate=penetrate;
	}
}

//==========================================================================================
// injector
//==========================================================================================
//class SwiftSuspendersInjector extends Injector implements IInjector {
//	public function createChild(applicationDomain:ApplicationDomain=null):IInjector {
//		var injector:SwiftSuspendersInjector=new SwiftSuspendersInjector();
//		injector.setApplicationDomain(applicationDomain);
//		injector.setParentInjector(this);
//		return injector;
//	}
//
//	public function get applicationDomain():ApplicationDomain {
//		return getApplicationDomain();
//	}
//
//	public function set applicationDomain(value:ApplicationDomain):void {
//		setApplicationDomain(value);
//	}
//
//	public function dispose():void {
//		// ???
//	}
//
//	override public function injectInto(target:Object):void {
//		super.injectInto(target);
//
//		if (target is IDependent) {
//			IDependent(target).onDependent();
//		}
//	}
//}

//class ContextInjector extends Injector implements IInjector {
//	public function ContextInjector(parent:ContextInjector=null) {
//		super(parent);
//	}
//
//	override public function createChild():IInjector {
//		return new ContextInjector(this);
//	}
//
//	/** @inheritDoc */
//	override public function registerDependent(target:*):XML {
//		var spec:XML=super.registerDependent(target);
//		return spec;
//	}
//
//
//}

//==========================================================================================
// context view injector
//==========================================================================================
class ImplContextViewInjector implements IContextViewInjector {
	private var context:IContext;

	public function ImplContextViewInjector(context:IContext=null) {
		this.context=context;
	}

	public function injectInto(contextView:IContextView):void {
		if (!contextView.contextInitialized) {
			contextView.initialContext(context);
		}
	}

	public function dispose():void {
		context=null;
	}
}


//==========================================================================================
// evt dispatcher
//==========================================================================================
class EvtDispatcher implements IEvtDispatcher {
	private var collection:Collection;

	public function EvtDispatcher() {
		collection=new Collection;
	}

	public function addEvtListener(type:String, listener:Function):IEvtUnit {
		return collection.add(type, listener);
	}

	public function dispatchEvt(evt:Evt):void {
		var units:Vector.<IEvtUnit>=collection.get(evt.type);
		var f:int=units.length;

		if (f === 0) {
			return;
		}

		while (--f >= 0) {
			units[f].listener(evt);
		}
	}

	public function dispose():void {
		collection.dispose();
		collection=null;
	}
}


class Collection extends MultipleKeyDataCollection {
	public function add(type:String, listener:Function):IEvtUnit {
		var indices:Vector.<int>=_find({type: type, listener: listener});

		if (indices.length > 0) {
			return _read(indices[0])["unit"];
		}

		var unit:EvtUnit=new EvtUnit;
		unit._collection=this;
		unit._listener=listener;
		unit._type=type;
		unit._index=_create({type: type, listener: listener, unit: unit});

		return unit;
	}

	public function remove(index:int):Object {
		return _delete(index);
	}

	public function get(type:String):Vector.<IEvtUnit> {
		var indices:Vector.<int>=_find({type: type});
		var units:Vector.<IEvtUnit>=new Vector.<IEvtUnit>(indices.length, true);

		var f:int=indices.length;
		while (--f >= 0) {
			units[f]=_read(indices[f])["unit"];
		}

		return units;
	}

	override public function dispose():void {
		var all:Array=_getSource();
		var obj:Object;
		var unit:EvtUnit;

		var f:int=all.length;
		while (--f >= 0) {
			obj=all[f];

			if (obj !== null) {
				unit=obj["unit"];
				unit.disposeResources();
			}
		}

		super.dispose();
	}


}

class EvtUnit implements IEvtUnit {
	internal var _collection:Collection;
	internal var _index:int;
	internal var _listener:Function;
	internal var _type:String;

	internal function disposeResources():void {
		_collection=null;
		_listener=null;
		_type=null;
	}

	public function dispose():void {
		if (_collection) {
			_collection.remove(_index);
			disposeResources();
		}
	}

	public function get listener():Function {
		return _listener;
	}

	public function get type():String {
		return _type;
	}
}
