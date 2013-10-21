package ssen.mvc {
import ssen.common.IDisposable;

public interface IContextViewInjector extends IDisposable {
	function injectInto(contextView:IContextView):void;
}
}
