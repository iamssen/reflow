package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.events.Event;

import ssen.common.IDisposable;
import ssen.mvc.IInjector;
import ssen.mvc.IMediator;

internal class MediatorController implements IDisposable {
	private var view:DisplayObject;
	private var mediator:IMediator;

	public function MediatorController(injector:IInjector, view:DisplayObject, mediatorType:Class) {
		this.view=view;

		if (mediatorType) {
			mediator=injector.injectInto(new mediatorType) as IMediator;
			mediator.setView(view);

			if (view.stage) {
				mediator.onRegister();
				view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			} else {
				view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
	}

	private function addedToStage(event:Event):void {
		view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		mediator.onRegister();
		view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	private function removedFromStage(event:Event):void {
		dispose();
	}

	public function dispose():void {
		view.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		mediator.onRemove();
		mediator=null;
		view=null;
	}
}
}
