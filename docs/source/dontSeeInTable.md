---
extends: _layouts.master
section: content
page: "/dontSeeInTable"
title: "dontSeeInTable"
---
        
<h1 class="title is-1">dontSeeInTable</h1>
<h2 class="subtitle is-4">
    Verifies that a given struct of keys and values does not exist in a row in a given table.
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
            <td class="title is-5"><strong>table</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">The table name to look for the data in.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>data</strong></td>
            <td class="title is-5">struct</td>
            <td class="title is-5">true</td>
            <td class="title is-5"></td>
            <td class="title is-5">A struct of data to verify does not exist in a row in the given table.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>datasource</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">A datasource to use instead of the default datasource.</td>
        </tr>
        <tr>
            <td class="title is-5"><strong>query</strong></td>
            <td class="title is-5">string</td>
            <td class="title is-5">false</td>
            <td class="title is-5"></td>
            <td class="title is-5">A query to use for a query of queries.  Mostly useful for testing.</td>
        </tr>
    </tbody>
</table>

<h3 class="subtitle is-5">Examples</h3>

```js
it( "can verify data does not exist in a table", function() {
    this.visit( "/login" )
        .type( "scotty@uss.enterprise", "email" )
        .type( "miracle_worker", "password" )
        .press( "Log In" )
        .dontSeeInTable( "remember_me", {
            email = "scotty@uss.enterprise"
        } );
} );
```