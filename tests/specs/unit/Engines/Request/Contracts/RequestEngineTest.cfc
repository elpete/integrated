/**
* @doc_abstract true
*/
component extends='testbox.system.BaseSpec' {

    function isAbstractSpec() {
        var md = getMetadata(this);
        return structKeyExists( md, 'doc_abstract' ) && md.doc_abstract == true;
    }

    function getCUT() {
        throw('Method is abstract and must be implemented in a concrete test component. Return the component from this method.');
    }

    function beforeAll() {
        if (isAbstractSpec()) {
            return;
        }

        this.CUT = getCUT();
        this.CUT.beforeAll();
        getMockBox().prepareMock( this.CUT );
        this.CUT.$("getRequestContext", "event-object");
    }

    function run() {
        if (isAbstractSpec()) {
            debug( "This spec is not run directly.  To run these tests, extend this class from a concrete component." );
            return;
        }

        describe('Request Engine — #getMetadata(this).fullname#', function() {
            it('visits a url', function() {
                this.CUT.$( "execute" )
                    .$args( route = "/exists", renderResults = true )
                    .$results( "event-object" );

                expect(function() {
                    var event = this.CUT.makeRequest(
                        method = "GET",
                        route = "/exists"
                    );
                }).notToThrow();

                var callLog = this.CUT.$callLog().execute;
                expect( callLog ).toHaveLength( 1 );
                expect( callLog[1]["route"] ).toBe( "/exists" );
                expect( callLog[1]["renderResults"] ).toBe( true );
            });

            it('fails when the url cannot be found', function() {
                this.CUT.$( "execute" )
                    .$args( route = "/does-not-exist", renderResults = true )
                    .$throws(
                        type = "TestBox.AssertionFailed",
                        message = "Could not find any route called [/does-not-exist]."
                    );

                expect(function() {
                    this.CUT.makeRequest(
                        method = "GET",
                        route = "/does-not-exist"
                    );
                }).toThrow(
                    type = 'TestBox.AssertionFailed',
                    regex = 'Could not find any route called \[\/does-not-exist\]\.'
                );

                var callLog = this.CUT.$callLog().execute;
                expect( callLog ).toHaveLength( 1 );
                expect( callLog[1]["route"] ).toBe( "/does-not-exist" );
                expect( callLog[1]["renderResults"] ).toBe( true );
            });

            it('visits a framework event', function() {
                this.CUT.$( "execute" )
                    .$args( event = "Main.index", renderResults = true )
                    .$results( "event-object" );

                expect(function() {
                    this.CUT.makeRequest(
                        method = "GET",
                        event = "Main.index"
                    );
                }).notToThrow();

                var callLog = this.CUT.$callLog().execute;
                expect( callLog ).toHaveLength( 1 );
                expect( callLog[1]["event"] ).toBe( "Main.index" );
                expect( callLog[1]["renderResults"] ).toBe( true );
            });

            it('fails when the event cannot be found', function() {
                this.CUT.$( "execute" )
                    .$args( event = "Main.doesntExist", renderResults = true )
                    .$throws(
                        type = "TestBox.AssertionFailed",
                        message = "Could not find any event called [Main.doesntExist]."
                    );

                expect(function() {
                    this.CUT.makeRequest(
                        method = "GET",
                        event = "Main.doesntExist"
                    );
                }).toThrow(
                    type = 'TestBox.AssertionFailed',
                    regex = 'Could not find any event called \[Main\.doesntExist\]\.'
                );

                var callLog = this.CUT.$callLog().execute;
                expect( callLog ).toHaveLength( 1 );
                expect( callLog[1]["event"] ).toBe( "Main.doesntExist" );
                expect( callLog[1]["renderResults"] ).toBe( true );
            });

            it( "passes along any parameters to the request", function() {
                var mockEvent = getMockBox().createMock("coldbox.system.web.context.RequestContext");
                getMockBox().prepareMock(mockEvent);

                mockEvent.$("setValue");

                this.CUT.$( "execute" )
                    .$args( route = "/exists", renderResults = true )
                    .$results( "event-object" );

                this.CUT.$( "getRequestContext", mockEvent );

                this.CUT.makeRequest(
                    method = "GET",
                    route = "/exists",
                    parameters = {
                        email = "bob@example.com",
                        password = "my_awesome_password"
                    }
                );

                var callLog = mockEvent.$callLog().setValue;

                expect( callLog ).toHaveLength( 2, "Two parameters were passed so setValue should have been called twice." );

                if ( callLog[1][1] == "PASSWORD" ) {
                    expect( callLog[1][1] ).toBe( "PASSWORD" );
                    expect( callLog[1][2] ).toBe( "my_awesome_password" );

                    expect( callLog[2][1] ).toBe( "EMAIL" );
                    expect( callLog[2][2] ).toBe( "bob@example.com" );
                } else {
                    expect( callLog[1][1] ).toBe( "EMAIL" );
                    expect( callLog[1][2] ).toBe( "bob@example.com" );

                    expect( callLog[2][1] ).toBe( "PASSWORD" );
                    expect( callLog[2][2] ).toBe( "my_awesome_password" );
                }

            });
        });
    }
}
