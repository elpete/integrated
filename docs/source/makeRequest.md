---
extends: _layouts.master
section: content
page: "/makeRequest"
title: "makeRequest"
---
        
<h1 class="title is-1">makeRequest</h1>
<h2 class="subtitle is-4">
    Makes a request internally through the framework request engine.<br />
    (Either a route or an event must be passed in.)<br />
    <br />
    This method is usually only called internally by <code>visit</code>, <code>visitEvent</code>, <code>link</code>, and <code>press</code>.
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
            <td class="title is-5"><strong>method</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The HTTP method to use for the request.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>route</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">The framework route to execute.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>event</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">The framework event to execute.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>parameters</strong></td>
            <td class="title is-5">struct</td>
            <td class="title is-5">false</td>
            <td class="title is-5"><code>{}</code></td>
            <td class="title is-5">A struct of parameters to attach to the request.  The parameters are attached to framework's collection.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can make an request through the framework", function() {
    this.visit( "/login" )
        .makeRequest(
            method = "POST",
            route = "/sessions",
            parameters = {
                userId = 1
            }
        );
} );
```