package ssen.mvc {
import flash.events.Event;
import flash.utils.Dictionary;

public interface ICommandChain {
	function get trigger():Event;

	function get current():int;
	function get numCommands():int;

	function get cache():Dictionary;

	function next():void;
}
}
