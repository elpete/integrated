---
extends: _layouts.master
section: content
page: "/type"
title: "type"
---
        
<h1 class="title is-1">type</h1>
<h2 class="subtitle is-4">
    Types a value in to a form field.
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
            <td class="title is-5">The value to type in the form field.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>selectorOrName</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The element selector or name to type the value in to.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can visit type values in to form fields", function() {
    this.visit( "/contact-us" )
        .type( "James T. Kirk", "name" )
        .type( "james.t.kirk@uss.enterprise", "email" );
} );
```