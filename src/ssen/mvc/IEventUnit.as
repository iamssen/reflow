package ssen.mvc {
import ssen.common.IDisposable;

public interface IEventUnit extends IDisposable {
	function get type():String;
	function get listener():Function;
}
}
