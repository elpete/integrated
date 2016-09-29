---
extends: _layouts.master
section: content
page: "/debugPrivateCollection"
title: "debugPrivateCollection"
---
        
<h1 class="title is-1">debugPrivateCollection</h1>
<h2 class="subtitle is-4">
    Pipes the current private collection in to the TestBox debug panel.
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
            <td colspan="5" class="title is-5 has-text-centered">No Arguments</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can see the current private collection in the debug panel", function() {
    this.visit( "/login" )
        .debugPrivateCollection();
} );
```