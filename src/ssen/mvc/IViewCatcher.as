package ssen.mvc {
import ssen.common.IDisposable;

public interface IViewCatcher extends IDisposable {
	function start(view:IContextView):void;

	function stop():void;

	function isRun():Boolean;
}
}
