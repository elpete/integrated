---
extends: _layouts.master
section: content
page: "/seePageIs"
title: "seePageIs"
---
        
<h1 class="title is-1">seePageIs</h1>
<h2 class="subtitle is-4">
    Verifies the route of the current page.<br />
    (This method cannot be used after visiting a page using an event.)
</h2>

<h3 class="subtitle is-5">Arguments</h3>
<table class="table">
    <thead>
        <tr>
            <th>Name</th>
            <th>Type</th>
            <th>Required</th>
            <th>Default</th>
            <th>Description</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="title is-5"><strong>route</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The expected route.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can verify the current route", function() {
    this.visit( "/login" )
        .type( "scotty@uss.enterprise", "email" )
        .type( "miracle_worker", "password" )
        .press( "Log In" )
        .seePageIs( "/" );
} );
```