import Integrated.Engines.Assertion.Contracts.APIAssertionEngine;

component extends="testbox.system.BaseSpec" implements="Integrated.Engines.Assertion.Contracts.APIAssertionEngine" {

    property name="parsedJson";

    public function init() {
        variables.parsedJson = [];
    }

    public Integrated.Engines.Assertion.Contracts.APIAssertionEngine function parse( required string json ) {
        variables.parsedJson = deserializeJSON( arguments.json );
        return this;
    }

    public Integrated.Engines.Assertion.Contracts.APIAssertionEngine function seeJsonEquals( required any json, boolean negate = false ) {
        if ( negate ) {
            expect( getParsedJson() ).notToBe( arguments.json, "JSON contents matched but were not expected to." );
        }
        else {
            expect( getParsedJson() ).toBe( arguments.json, "JSON contents did not match." );
        }
        return this;
    }

    public Integrated.Engines.Assertion.Contracts.APIAssertionEngine function dontSeeJsonEquals( required any json ) {
        arguments.negate = true;
        return seeJsonEquals( argumentCollection = arguments );
    }

    public any function getParsedJson() {
        return variables.parsedJson;
    }

}