---
extends: _layouts.master
section: content
page: "/select"
title: "select"
---
        
<h1 class="title is-1">select</h1>
<h2 class="subtitle is-4">
    Selects a given option in a given select field.
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
            <td class="title is-5"><strong>option</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The value or text to select.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>selectorOrName</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The selector or name to choose the option in.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can select an option in a select field", function() {
    this.visit( "/contact-us" )
        .select( "I'm having a problem", "contact_reason" );
} );
```