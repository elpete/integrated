component extends='testbox.system.BaseSpec' {

    function beforeAll() {
        this.CUT = new BaseSpecs.ColdBoxBaseSpec();
        getMockBox().prepareMock(this.CUT);
        variables.requestEngine = getMockBox().createMock("Integrated.Engines.Request.ColdBoxRequestEngine");
        
        this.CUT.beforeAll(
            variables.requestEngine,
            {
                "appMapping" = "/SampleApp"
            }
        );
    }

    function run() {
        describe('BaseSpec — API', function() {
            feature( "json", function() {
                it( "visit throws an error if json is returned", function() {
                    expect( function() {
                        this.CUT.visit( "/api/posts" )
                    } ).toThrow( type = "TestBox.AssertionFailed" )
                } );

                it( "can get json from an api", function() {
                    this.CUT.json( "GET", "/api/posts" );
                } );

                describe( "can assert against the json returned", function() {
                    it( "seeJsonEquals", function() {
                        expect( function() {
                            this.CUT.json( "GET", "/api/posts" )
                                .seeJsonEquals( [
                                    { id = 1, name = "First Post!", body = "The body of my first post." },
                                    { id = 2, name = "Second Post!", body = "The body of my second post." }
                                ] );  
                        } ).notToThrow();
                        
                        expect( function() {
                            this.CUT.json( "GET", "/api/posts" )
                                .seeJsonEquals( [] );  
                        } ).toThrow( type = "TestBox.AssertionFailed" );
                    } );

                    it( "dontSeeJsonEquals", function() {
                        expect( function() {
                            this.CUT.json( "GET", "/api/posts" )
                                .dontSeeJsonEquals( [] );
                        } ).notToThrow();
                        
                        expect( function() {
                            this.CUT.json( "GET", "/api/posts" )
                                .dontSeeJsonEquals( [
                                    { id = 1, name = "First Post!", body = "The body of my first post." },
                                    { id = 2, name = "Second Post!", body = "The body of my second post." }
                                ] );  
                        } ).toThrow( type = "TestBox.AssertionFailed" );
                    } );
                } );
            } );
        });
    }
}
