---
extends: _layouts.master
section: content
page: "/seeInCollection"
title: "seeInCollection"
---
        
<h1 class="title is-1">seeInCollection</h1>
<h2 class="subtitle is-4">
    Verifies that the given key and optional value exists in the framework request collection.
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
            <td class="title is-5"><strong>key</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The key to find in the collection.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>value</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">The value to find in the collection with the given key. If omitted, only checks if the key exists.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>private</strong></td>
            <td class="title is-5">boolean</td>
            <td class="title is-5">false</td>
            <td class="title is-5">false</td>
            <td class="title is-5">If true, use the private collection instead of the default collection.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can verify that keys and values are in the framework collection", function() {
    this.visit( "/" )
        .seeInCollection( "error" )
        .seeInCollection( "email", "scotty@uss.enterprise" );
        .seeInCollection( key = "secret", private = true );
} );
```