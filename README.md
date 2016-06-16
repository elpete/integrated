# Integrated

## A TestBox package for even better Integration tests in ColdBox!

[![Master Branch Build Status](https://img.shields.io/travis/elpete/integrated/master.svg?style=flat-square&label=master)](https://travis-ci.org/elpete/integrated)
[![Development Branch Build Status](https://img.shields.io/travis/elpete/integrated/development.svg?style=flat-square&label=development)](https://travis-ci.org/elpete/integrated)

### Requirements

Requires ColdBox 4.2+ and TestBox 2.3+

### Installation
Install the package from ForgeBox:

```bash
box install integrated
```

**Important:**
Add the Integrated lib directory to `this.javaSettings` in your `*tests*` directory's `Application.cfc`.

```cfc
this.javaSettings = { loadPaths = [ "Integrated/lib" ], reloadOnChange = false };
```

### Usage

Change your Integration tests to extend from `Integration.BaseSpecs.ColdBoxBaseSpec`. (Make sure to call the parent class's `beforeAll` method.)

```cfc
component extends="Integrated.BaseSpecs.ColdBoxBaseSpec" {
    function beforeAll() {
        // Make sure to call the parent class's beforeAll() and afterAll() methods.
        super.beforeAll();
    }

    function afterAll() {
        super.afterAll();
    }
}
```

Start using an easy, fluent API for your integration tests!

```cfc
function run() {
    describe( "Registering", function() {
        it( "allows a new user to register for the site", function() {
            this.visitEvent('register.new')
                .type('Eric', 'name')
                .type('mYAw$someP2ssw0rd!', 'password')
                .press('Register')
                .seeTitleIs('Home')
                .seeOnPage('Welcome, Eric!');
        });
    });
}
```

You can see all the different methods you can call in the [API docs](http://elpete.github.io/integrated/).

You can add automatic database transactions by adding one line to the top of your spec:

```cfc
component extends="Integrated.BaseSpecs.ColdBoxBaseSpec" {

    this.useDatabaseTransactions = true;

    function run() {
        describe( "Registering", function() {
            it( "allows a new user to register for the site", function() {
                this.visitEvent('register.new')
                    .type('Eric', 'name')
                    .type('mYAw$someP2ssw0rd!', 'password')
                    .press('Register')
                    .seeTitleIs('Home')
                    .seeOnPage('Welcome, Eric!');
            });
        });
    }
}
```

Easily add database transactions around your tests by adding this one property to your test:

```cfc
this.useDatabaseTransactions = true;
```

By default, we clear out the session scope on each request.  If you want to persist the session scope across requests, simply add `this.persistSessionScope = true;` to the top of your spec.  **Note:** this will happen for all tests in the file.

### Creating Framework-specific BaseSpecs

To create your own framework specific BaseSpec, first extend the `Integrated.BaseSpecs.AbstractBaseSpec` component.

```cfc
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

```cfc
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

```cfc
// Integrated.Engines.Request.MyAwesomeRequestEngine
component implements="Integrated.Engines.Request.Contracts.RequestEngine" {
    // your implementation here
}
```

```cfc
component extends="tests.specs.unit.Engines.Request.Contracts.RequestEngineTest" {

    function getCUT() {
        return new Integrated.Engines.Request.MyAwesomeRequestEngine();
    }

}
```

**Note:** each engine's abstract spec may be slightly different in how they are set up.  Take a [look][DOMAssertionEngineTest] [at][FrameworkAssertionEngineTest] [the][InteractionEngineTest] [specs][RequestEngineTest] to see the details.

### Credits

This package is **heavily** inspired by [Jeffrey Way's Integrated package for Laravel](https://github.com/laracasts/Integrated).
I learned about it at [Laracasts](https://laracasts.com/), which I consider my best programming resource *regardless* of the fact that I have never deployed a line of PHP code.

[DOMAssertionEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Assertion/Contracts/DOMAssertionEngineTest.cfc
[FrameworkAssertionEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Assertion/Contracts/FrameworkAssertionEngineTest.cfc
[InteractionEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Interaction/Contracts/InteractionEngineTest.cfc
[RequestEngineTest]: https://github.com/elpete/integrated/blob/master/tests/specs/unit/Engines/Request/Contracts/RequestEngineTest.cfc