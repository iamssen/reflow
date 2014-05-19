---
title: "Injector Mapping Types"
layout: "contents"

---

<h1>
	<p align="center">
		<img src="../images/injector.mono.svg"/>
		<br/>
		Dependency Injection<br/>Mapping Types
	</p>
</h1>

[Reflow Framework]의 `Injector`는 총 4가지 종류의 Dependency(의존성) 형태를 지원합니다.

|Mapping Type		|`Context` 내에서 Singleton으로 작동|Instance 자동 생성됨|특이 사항|
|---				|---|---|---|
|`.mapClass()`		|N	|Y	| |
|`.mapSingleton()`	|Y	|Y	| |
|`.mapValue()`		|N	|N	|Instance를 수동으로 직접 생성해서 등록합니다. 자동생성으로 처리하기 어려운 상황에서 사용 가능합니다.|
|`.mapFactory()`	|N	|Y	|Factory Object를 통해서 Instance를 생성합니다. Instance 생성시에 여러 복잡한 요건들이 필요할 때 사용 가능합니다.|

`.mapValue()`와 `.mapFactory()` 같은 경우는 약간 특이한 경우고, 대체적인 경우 `.mapClass()`와 `.mapSingleton()`이 큰 분류가 됩니다.

## `IInjector.mapClass()`

<div class="center">
	<embed src="http://iamssen.github.io/reflow.sample.dependency-injection.mapping-types/bin-release/instantiate.swf" width="400" height="300"/>
	<div>
		<a href="http://github.com/iamssen/reflow.sample.dependency-inection.mapping-types" target="_blank"
		   class="btn btn-default btn-xs"><i class="fa fa-code"></i> view source</a>
		<a href="http://github.com/iamssen/reflow" target="_blank" class="btn btn-default btn-xs"><i
				class="fa fa-code-fork"></i> reflow framework</a>
	</div>
</div>

예제의 경우 + 와 - 를 누르면 개개별로 숫자가 증가/감소 하게 됩니다.

`reflow.sample.models.Model`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/models/Model.as"></script>

`Model`은 단순한 기능들만을 가지고 있습니다.

`reflow.sample.views.View`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/views/View.mxml"></script>

`View` 역시 단순합니다. `Model`을 주입받아서 바인딩 처리 하고 있습니다.

`reflow.sample.InstantiateAppContext`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/InstantiateAppContext.as"></script>

`reflow.sample.InstantiateApp`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/InstantiateApp.mxml"></script>

`Context` 입니다.

## `IInjector.mapSingleton()`

<div class="center">
	<embed src="http://iamssen.github.io/reflow.sample.dependency-injection.mapping-types/bin-release/singleton.swf" width="400" height="300"/>
	<div>
		<a href="http://github.com/iamssen/reflow.sample.dependency-inection.mapping-types" target="_blank"
		   class="btn btn-default btn-xs"><i class="fa fa-code"></i> view source</a>
		<a href="http://github.com/iamssen/reflow" target="_blank" class="btn btn-default btn-xs"><i
				class="fa fa-code-fork"></i> reflow framework</a>
	</div>
</div>

예제를 보면 `IInjector.mapClass()`에서 확인한 예제와는 다르게 모든 숫자들이 동시에 증가/감소 하는 것을 확인할 수 있습니다.

`reflow.sample.SingletonAppContext`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/SingletonAppContext.as"></script>

`reflow.sample.SingletonApp`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/SingletonApp.mxml"></script>

단순히 `injector.mapClass()` 부분을 `injector.mapSingleton()`으로 변경했음을 확인할 수 있습니다.

`Model`과 같이 `Context`내에서 Singleton 형태로 유일한 객체(Object)로 작동해야 하는 경우 사용 할 수 있습니다.

## `IInjector.mapValue()`

<div class="center">
	<embed src="http://iamssen.github.io/reflow.sample.dependency-injection.mapping-types/bin-release/value.swf" width="400" height="300"/>
	<div>
		<a href="http://github.com/iamssen/reflow.sample.dependency-inection.mapping-types" target="_blank"
		   class="btn btn-default btn-xs"><i class="fa fa-code"></i> view source</a>
		<a href="http://github.com/iamssen/reflow" target="_blank" class="btn btn-default btn-xs"><i
				class="fa fa-code-fork"></i> reflow framework</a>
	</div>
</div>

기본적인 동작은 `IInjector.mapSingleton()`과 차이가 없이 `Context` 내부에서 Singleton 으로 작동합니다.

`reflow.sample.ValueAppContext`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/ValueAppContext.as"></script>

`reflow.sample.ValueApp`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/ValueApp.mxml"></script>

`Context`에서 `Model`의 객체(`var model:Model`)을 직접 생성하는 것을 확인 할 수 있습니다.

외부에서 전달받은 객체를 등록한다거나 프로그램의 동작을 위해 수동으로 생성해야 하는 경우 사용할 수 있습니다.

## `IInjector.mapFactory()`

<div class="center">
	<embed src="http://iamssen.github.io/reflow.sample.dependency-injection.mapping-types/bin-release/factory.swf" width="400" height="300"/>
	<div>
		<a href="http://github.com/iamssen/reflow.sample.dependency-inection.mapping-types" target="_blank"
		   class="btn btn-default btn-xs"><i class="fa fa-code"></i> view source</a>
		<a href="http://github.com/iamssen/reflow" target="_blank" class="btn btn-default btn-xs"><i
				class="fa fa-code-fork"></i> reflow framework</a>
	</div>
</div>

기본적인 동작은 `IInjector.mapClass()`와 동일합니다.

`reflow.sample.models.ModelFactory`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/models/ModelFactory.as"></script>

`Model`을 생성하는 Factory Class 입니다.

Factory 에서 Instance를 생성하는 것을 확인 할 수 있습니다.

`reflow.sample.FactoryAppContext`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/FactoryAppContext.as"></script>

`reflow.sample.FactoryApp`

<script src="http://gist-it.appspot.com/github/iamssen/reflow.sample.dependency-injection.mapping-types/blob/gh-pages/src/reflow/sample/FactoryApp.mxml"></script>

Instance의 생성시에 여러가지 추가적인 작업들이 필요한 경우 사용할 수 있습니다.