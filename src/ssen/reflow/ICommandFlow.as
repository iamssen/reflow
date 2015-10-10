package ssen.reflow {
public interface ICommandFlow {
	function hasNext():Boolean;

	function next():Class;
}
}
