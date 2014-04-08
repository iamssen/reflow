package ssen.mvc {

/**
 * ViewMap
 *
 * @see ssen.mvc.context.Context#mapDependency()
 */
public interface IViewMap {
	/**
	 * @param viewClass View class
	 * @param mediatorClass Mediator class
	 * @param global If launch View not on Context (ex. popup)
	 */
	function mapView(viewClass:Class, mediatorClass:Class=null, global:Boolean=false):void;

	/**
	 * @param viewClass View class
	 */
	function unmapView(viewClass:Class):void;

	/**
	 * @param view View class or instance
	 */
	function hasView(view:*):Boolean;
}
}
