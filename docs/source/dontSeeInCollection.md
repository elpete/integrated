---
extends: _layouts.master
section: content
page: "/dontSeeInCollection"
title: "dontSeeInCollection"
---
        
<h1 class="title is-1">dontSeeInCollection</h1>
<h2 class="subtitle is-4">
    Verifies that the given key and optional value does not exist in the ColdBox request collection.
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
            <td class="title is-5">The key that should not be found in the collection.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>value</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">The value that should not be found in the collection with the given key. If omitted, only checks if the key exists.</td>
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
it( "can verify that keys and values are not in the framework collection", function() {
    this.visit( "/" )
        .dontSeeInCollection( "error" )
        .dontSeeInCollection( "email", "scotty@uss.enterprise" )
        .dontSeeInCollection( key = "secret", private = true );
} );
```