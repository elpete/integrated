---
extends: _layouts.master
section: content
page: "/visit"
title: "visit"
---
        
<h1 class="title is-1">visit</h1>
<h2 class="subtitle is-4">
    Makes a request to a route.
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
            <td class="title is-5">The route to visit, e.g. `/login` or `/posts/4`.<br />Integrated will build the full URL.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js

it( "can visit a route", function() {
    this.visit( "/" )
        .visit( "/about" );
} );
```