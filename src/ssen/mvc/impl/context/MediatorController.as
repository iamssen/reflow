package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.events.Event;

import ssen.mvc.IMediator;

internal class MediatorController {
	private var context:Context;
	private var view:DisplayObject;
	private var mediator:IMediator;

	public function MediatorController(context:Context, view:DisplayObject, mediatorType:Class=null) {
		this.view=view;

		if (mediatorType) {
			mediator=context.injector.injectInto(new mediatorType) as IMediator;
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
