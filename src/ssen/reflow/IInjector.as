package ssen.reflow {

/**
 * [구현 불필요] <code>Context.injector</code>의 <code>Interface</code>.
 *
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface IInjector {
	//----------------------------------------------------------------
	// tree
	//----------------------------------------------------------------
	/** @private */
	function createChildInjector():IInjector;

	//----------------------------------------------------------------
	// get
	//----------------------------------------------------------------
	/**
	 * <code>mapClass(), mapSingleton(), mapValue()...</code> 등으로 등록한 의존성 객체를 가져온다
	 *
	 * @param Type 등록한 Class Type
	 */
	function getInstance(Type:Class):Object;

	/**
	 * <code>mapClass(), mapSingleton(), mapValue()...</code> 등으로 등록한 의존성이 있는지 확인한다
	 *
	 * @param Type 등록한 Class Type
	 */
	function hasMapping(Type:Class):Boolean;

	/**
	 * 대상 객체에 의존성을 주입해준다
	 *
	 * @param obj 의존성을 필요로 하는 객체
	 */
	function injectInto(obj:Object):void;

	//----------------------------------------------------------------
	// map
	//----------------------------------------------------------------
	/**
	 * 의존성을 등록 : 매 번, 요청 할 때마다 새로 생성함
	 *
	 * @param Type 등록할 Class Type
	 * @param Implementation 등록할 Class Type을 상속(extends) 또는 구현(implments)하는 항목. null일 경우 등록할 Class Type을 사용한다
	 */
	function mapClass(Type:Class, Implementation:Class=null):void;

	/**
	 * 의존성을 등록 : <code>Context</code> 내에서 <code>Singleton</code>으로 작동
	 *
	 * @param Type 등록할 Class Type
	 * @param Implementation 등록할 Class Type을 상속(<code>extends</code>) 또는 구현(<code>implments</code>)하는 항목. null일 경우 등록할 Class Type을 사용한다
	 */
	function mapSingleton(Type:Class, Implementation:Class=null):void;

	/**
	 * 의존성을 등록 : <code>Context</code> 내에서 <code>Singleton</code>으로 작동시키고, <code>instance</code>를 직접 등록
	 *
	 * @param Type 등록할 Class Type
	 * @param usingValue 등록할 Class Type을 상속(<code>extends</code>) 또는 구현(<code>implments</code>)하는 항목
	 */
	function mapValue(Type:Class, usingValue:Object):void;

	/**
	 * 의존성을 등록 : 매 번, 요청 할 때마다 <code>Factory</code>에 의해 새로 생성함
	 *
	 * @param Type 등록할 Class Type
	 * @param FactoryType 등록할 Class Type을 상속(<code>extends</code>) 또는 구현(<code>implments</code>)하는 항목을 생성하는 <code>mx.core.IFactory</code>를 구현하는 <code>Factory</code>
	 */
	function mapFactory(Type:Class, FactoryType:Class):void;

	//----------------------------------------------------------------
	// unmap
	//----------------------------------------------------------------
	/**
	 * 의존성을 해제
	 *
	 * @param Type 등록한 Class Type
	 */
	function unmap(Type:Class):void;
}
}
