interface displayname="APIAssertionEngine" {

    public Integrated.Engines.Assertion.Contracts.APIAssertionEngine function parse( required string json );

    public Integrated.Engines.Assertion.Contracts.APIAssertionEngine function seeJsonEquals( required any json, boolean negate );

    public Integrated.Engines.Assertion.Contracts.APIAssertionEngine function dontSeeJsonEquals( required any json );

}