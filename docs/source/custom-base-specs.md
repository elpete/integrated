---
extends: _layouts.master
section: content
page: "/custom-base-specs"
title: "Custom Base Specs"
---
        
<h1 class="title is-1">Custom Base Specs</h1>


To create your own framework specific BaseSpec, first extend the `Integrated.BaseSpecs.AbstractBaseSpec` component.

```js
component extends="Integrated.BaseSpecs.AbstractBaseSpec" {
    function beforeAll() {
    // IMPORTANT!  Don't forget to call `beforeAll()` and `afterAll()`!
        super.beforeAll(
            // your setup here
        );
    }

    function afterAll() {
        super.afterAll();
    }
}
```

The `beforeAll` method takes four separate engines that drive Integrated:

```js
/**
* Sets up the needed dependancies for Integrated.
*
* @requestEngine Integrated.Engines.Request.Contracts.RequestEngine
* @frameworkEngine Integrated.Engines.Assertion.Contracts.FrameworkAssertionEngine
* @domEngine Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
* @interactionEngine Integrated.Engines.Interaction.Contracts.InteractionEngine
*
* @return Integrated.BaseSpecs.AbstractBaseSpec
*/
public AbstractBaseSpec function beforeAll(
    required RequestEngine requestEngine,
    required FrameworkAssertionEngine frameworkEngine,
    required DOMAssertionEngine domEngine,
    required InteractionEngine interactionEngine
);
```

In your base spec, you can return any combination of these four engines to power Integrated.  For instance, you may wish to specify a different `RequestEngine` and `FrameworkAssertionEngine` for your new base spec but  use JSoup for the `DOMAssertionEngine` and the `InteractionEngine`.  Or, you could use Selenium based engines for every one of the required engines.  It's up to you.

You can look at [`Integrated.BaseSpecs.ColdBoxBaseSpec`](https://github.com/elpete/integrated/blob/master/BaseSpecs/ColdBoxBaseSpec.cfc) for how this is done for ColdBox.

Each engine has an Interface that new engines must conform to as well as an abstract spec they should pass.

```js
// Integrated.Engines.Request.MyAwesomeRequestEngine
component implements="Integrated.Engines.Request.Contracts.RequestEngine" {
    // your implementation here
}
```

```js
component extends="tests.specs.unit.Engines.Request.Contracts.RequestEngineTest" {

    function getCUT() {
        return new Integrated.Engines.Request.MyAwesomeRequestEngine();
    }

}
```

**Note:** each engine's abstract spec may be slightly different in how they are set up.  Take a [look][DOMAssertionEngineTest] [at][FrameworkAssertionEngineTest] [the][InteractionEngineTest] [specs][RequestEngineTest] to see the details.


[DOMAssertionEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Assertion/Contracts/DOMAssertionEngineTest.cfc
[FrameworkAssertionEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Assertion/Contracts/FrameworkAssertionEngineTest.cfc
[InteractionEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Interaction/Contracts/InteractionEngineTest.cfc
[RequestEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Request/Contracts/RequestEngineTest.cfc