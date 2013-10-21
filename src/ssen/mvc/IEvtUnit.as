package ssen.mvc {
import ssen.common.IDisposable;

public interface IEvtUnit extends IDisposable {
	function get type():String;
	function get listener():Function;
}
}
