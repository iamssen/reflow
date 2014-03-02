package ssen.mvc {

public interface ICommand {
	function execute(chain:ICommandChain=null):void;
}
}
