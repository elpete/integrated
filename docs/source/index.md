---
extends: _layouts.master
section: content
page: "/"
---

<h1 class="title is-1">Integrated</h1>
<h2 class="subtitle is-3">A TestBox package for even better Integration tests in ColdBox!</h2>
<br />

<h3 class="title is-3">Requirements</h3>
<p class="content">Requires ColdBox 4.2+ and TestBox 2.3+</p>

<h3 class="title is-3">Installation</h3>

Install the package from ForgeBox:

```bash
box install integrated
```

**Important:**
Add the Integrated lib directory to `this.javaSettings` in your `*tests*` directory's `Application.cfc`.

```js
this.javaSettings = { loadPaths = [ "Integrated/lib" ], reloadOnChange = false };
```

### Usage

Change your Integration tests to extend from `Integration.BaseSpecs.ColdBoxBaseSpec`. (Make sure to call the parent class's `beforeAll` method.)

```js
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

```js
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

You can see all the different methods you can call in the menu.

You can add automatic database transactions by adding one line to the top of your spec:

```js
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

```js
this.useDatabaseTransactions = true;
```

By default, we clear out the session scope on each request.  If you want to persist the session scope across requests, simply add `this.persistSessionScope = true;` to the top of your spec.  **Note:** this will happen for all tests in the file.

<h3 class="title is-3">Credits</h3>

This package is **heavily** inspired by [Jeffrey Way's Integrated package for Laravel](https://github.com/laracasts/Integrated).
I learned about it at [Laracasts](https://laracasts.com/), which I consider my best programming resource *regardless* of the fact that I have never deployed a line of PHP code.