---
extends: _layouts.master
section: content
page: "/seeLink"
title: "seeLink"
---
        
<h1 class="title is-1">seeLink</h1>
<h2 class="subtitle is-4">
    Verifies that a link with the given text exists on the current page.<br />
    Can also take an optional url parameter.  If provided, it verifies the link found has the given url.
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
            <td class="title is-5"><strong>text</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The expected text of the link.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>url</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">The expected url of the link.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can verify a link exists", function() {
    this.visit( "/" )
        .seeLink( "Contact Us" );
} );
```

```js
it( "can verify a link with a specific url exists", function() {
    this.visit( "/" )
        .seeLink( "Contact Us", "/contact-us" );
} );
```