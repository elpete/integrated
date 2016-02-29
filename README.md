# Integrated

## A TestBox package for even better Integration tests in ColdBox!

[![Master Branch Build Status](https://img.shields.io/travis/elpete/integrated/master.svg?style=flat-square&label=master)](https://travis-ci.org/elpete/integrated)
[![Development Branch Build Status](https://img.shields.io/travis/elpete/integrated/development.svg?style=flat-square&label=development)](https://travis-ci.org/elpete/integrated)

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
        // Make sure to call the parent class's beforeAll() method.
        super.beforeAll();
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

### Creating Framework-specific BaseSpecs

To create your own framework specific BaseSpec, first extend the `Integrated.BaseSpecs.AbstractBaseSpec` component.

```cfc
component extends="Integrated.BaseSpecs.AbstractBaseSpec" {
    function beforeAll() {
        super.beforeAll(); // IMPORTANT!  Don't forget to call `beforeAll()`!

        // Your specific setup here.
    }
}
```

There are three abstract methods that you need to implement:

1. `makeFrameworkRequest` — makes a request specifically for your framework.  Return whatever event object your framework uses.  That object will be passed to the `getHTML` method you implement.
2. `getHTML` — returns the html string from your framework's event object.  This html string is then parsed and available for your tests.
3. `parseActionFromForm` — returns just the route portion of a full uri.  For example, `http://localhost:8500/index.cfm/login` should return just `/login` in ColdBox.

You can look at [`Integrated.BaseSpecs.ColdBoxBaseSpec`](https://github.com/elpete/integrated/blob/master/BaseSpecs/ColdBoxBaseSpec.cfc) for how this is done for ColdBox.

### Credits

This package is **heavily** inspired by [Jeffrey Way's Integrated package for Laravel](https://github.com/laracasts/Integrated).
I learned about it at [Laracasts](https://laracasts.com/), which I consider my best programming resource *regardless* of the fact that I have never deployed a line of PHP code.
