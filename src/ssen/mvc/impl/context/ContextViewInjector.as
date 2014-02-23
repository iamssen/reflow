package ssen.mvc.impl.context {
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;

internal class ContextViewInjector implements IContextViewInjector {
	private var context:IContext;

	public function ContextViewInjector(context:IContext=null) {
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
}
