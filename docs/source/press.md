---
extends: _layouts.master
section: content
page: "/press"
title: "press"
---
        
<h1 class="title is-1">press</h1>
<h2 class="subtitle is-4">
    Press a submit button.
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
            <td class="title is-5"><strong>selectorOrName</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The selector or name of the button to press.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>overrideEvent</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">The event to run instead of the form's default.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can press the submit button of a form", function() {
    this.visit( "/login" )
        .type( "scotty@uss.enterprise", "email" )
        .type( "miracle_worker", "password" )
        .press( "Log In" );
} );
```