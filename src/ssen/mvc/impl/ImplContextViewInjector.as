package ssen.mvc.impl {
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;

internal class ImplContextViewInjector implements IContextViewInjector {
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
}
