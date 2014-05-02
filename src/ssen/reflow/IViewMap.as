package ssen.reflow {

/**
 * [구현 불필요] <code>Context.viewMap</code>의 <code>Interface</code>.
 *
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface IViewMap {
	/**
	 * @param ViewType 등록할 View Class
	 * @param MediatorType View에 사용할 Mediator Class
	 * @param global View가 Popup과 같이 Global 한 위치(를 포함해서 <code>Context</code> 하위에 있지 않은 모든 위치)에서 뜨는지 여부
	 */
	function map(ViewType:Class, MediatorType:Class=null, global:Boolean=false):void;

	/**
	 * @param ViewType View class
	 */
	function unmap(ViewType:Class):void;

	/**
	 * @param view View class or instance
	 */
	function has(view:*):Boolean;
}
}
