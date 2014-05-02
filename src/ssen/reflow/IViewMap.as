package ssen.reflow {

/**
 * [구현 불필요] <code>Context.viewMap</code>의 <code>Interface</code>.
 *
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface IViewMap {
	/**
	 * @param viewClass 등록할 View Class
	 * @param mediatorClass View에 사용할 Mediator Class
	 * @param global View가 Popup과 같이 Global 한 위치(를 포함해서 <code>Context</code> 하위에 있지 않은 모든 위치)에서 뜨는지 여부
	 */
	function map(viewClass:Class, mediatorClass:Class=null, global:Boolean=false):void;

	/**
	 * @param viewClass View class
	 */
	function unmap(viewClass:Class):void;

	/**
	 * @param view View class or instance
	 */
	function has(view:*):Boolean;
}
}
