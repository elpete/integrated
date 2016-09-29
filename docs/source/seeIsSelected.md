---
extends: _layouts.master
section: content
page: "/seeIsSelected"
title: "seeIsSelected"
---
        
<h1 class="title is-1">seeIsSelected</h1>
<h2 class="subtitle is-4">
    Verifies that a given select field has a given option selected.
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
            <td class="title is-5"><strong>value</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The value or text of the option that should exist.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>selectorOrName</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The selector or name of the select field to check for the value in.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can verify an option is selected", function() {
    this.visit( "/contact-us" )
        .select( "I'm having a problem", "contact_reason" )
        .seeIsSelected( "I'm having a problem", "contact_reason" );
} );
```