---
extends: _layouts.master
section: content
page: "/click"
title: "click"
---
        
<h1 class="title is-1">click</h1>
<h2 class="subtitle is-4">
    Clicks on a link in the current page.
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
            <td class="title is-5"><strong>link</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">A selector of a link or the text of the link to click.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can click on a link", function() {
    this.visit( "/" )
        .click( "/about" )
        .seePageIs( "/about" );
} );
```