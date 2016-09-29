---
extends: _layouts.master
section: content
page: "/seeInElement"
title: "seeInElement"
---
        
<h1 class="title is-1">seeInElement</h1>
<h2 class="subtitle is-4">
    Verifies that the given element contains the given text on the current page.
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
            <td class="title is-5">The expected text.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>selectorOrName</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The provided selector or name to check for the text in.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can verify text is found in an element", function() {
    this.visit( "/" )
        .seeInElement( "Please Log In.", ".error" );
} );
```