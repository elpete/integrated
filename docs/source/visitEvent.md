---
extends: _layouts.master
section: content
page: "/visitEvent"
title: "visitEvent"
---
        
<h1 class="title is-1">visitEvent</h1>
<h2 class="subtitle is-4">
    Makes a request to a framework event.<br />
    <span class="subtitle is-5">Used in situations where framework engines don't support routes.</span>
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
            <td class="title is-5"><strong>event</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The name of the event to execute.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js

it( "can visit a framework event", function() {
    this.visitEvent( "Main.index" )
        .visitEvent( "posts.4" );
} );
```