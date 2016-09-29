---
extends: _layouts.master
section: content
page: "/seeControllerIs"
title: "seeControllerIs"
---
        
<h1 class="title is-1">seeControllerIs</h1>
<h2 class="subtitle is-4">
    Verifies the framework controller of the current page.
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
            <td class="title is-5"><strong>controller</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The expected controller</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can verify a framework controller", function() {
    this.visit( "/" )
        .seeControllerIs( "Main" );
} );
```