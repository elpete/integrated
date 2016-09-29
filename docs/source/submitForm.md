---
extends: _layouts.master
section: content
page: "/submitForm"
title: "submitForm"
---
        
<h1 class="title is-1">submitForm</h1>
<h2 class="subtitle is-4">
    Submits a form.
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
            <td class="title is-5"><strong>inputs</strong></td>
            <td class="title is-5">struct</td>
            <td class="title is-5">false</td>
            <td class="title is-5"><code>{}</code></td>
            <td class="title is-5">The form values to submit.<br />If not provided, uses the values stored in Integrated combined with any values on the current page.</td>
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
it( "can submit a form", function() {
    this.visit( "/login" )
        .submitForm(
            selectorOrName = "Log In",
            inputs = {
                "email" = "scotty@uss.enterprise",
                "password" = "miracle_worker"
            }
        );
} );
```