package ssen.mvc {
import flash.utils.Dictionary;

public interface ICommandChain {
	function get trigger():Evt;
	
	function get current():int;
	function get numCommands():int;
	
	function get cache():Dictionary;
	
	function next():void;
}
}
