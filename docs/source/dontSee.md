---
extends: _layouts.master
section: content
page: "/dontSee"
title: "dontSee"
---
        
<h1 class="title is-1">dontSee</h1>
<h2 class="subtitle is-4">
    Verifies that the given text does not exist in any element on the current page.
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
            <td class="title is-5">The text that should not appear.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>caseSensitive</strong></td>
            <td class="title is-5">boolean</td>
            <td class="title is-5">false</td>
            <td class="title is-5">true</td>
            <td class="title is-5">If true, will only fail if the text exists and matches case.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can see that text is not on a page", function() {
    this.visit( "/" )
        .dontSee( "Oops!  An error occurred." );
} );
```