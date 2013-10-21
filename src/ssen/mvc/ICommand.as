package ssen.mvc {
import ssen.common.IDisposable;

public interface ICommand extends IDisposable {
	function execute(chain:ICommandChain=null):void;
}
}
