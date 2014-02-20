package ssen.mvc {
import ssen.common.IDisposable;

public interface IViewCatcher extends IDisposable {
	// TODO 중간에 start, stop 과 isRun을 필요로 하는가? 이게 외부로 공개되는게 맞는가?
	function start(view:IContextView):void;
	function stop():void;
	function isRun():Boolean;
}
}
