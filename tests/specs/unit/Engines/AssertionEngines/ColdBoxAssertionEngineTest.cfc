component extends='testbox.system.BaseSpec' {
    function beforeAll() {
        this.CUT = new Integrated.Engines.ColdBoxAssertionEngine();
        getMockBox().prepareMock( this.CUT );
    }

    function run() {
        describe( "JSoup Parser", function() {
            it( "adheres to the FrameworkAssertionEngine interface", function() {
                expect( this.CUT ).toBeInstanceOf( "Integrated.Engines.FrameworkAssertionEngine" );
            } );

            beforeEach(function() {
                // Add a mock ColdBox request context
                mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                variables.rc = { email = 'john@example.com' };
                variables.prc = { birthday = '01/01/1980' };
                mockEvent.$('getCollection').$args(private = false).$results(rc);
                mockEvent.$('getCollection').$args(private = true).$results(prc);
                this.CUT.$property(propertyName = 'event', mock = mockEvent);

                // Set the default request method to 'visit'
                this.CUT.$property(propertyName = 'requestMethod', mock = 'visit');
            });

            feature('seePageIs', function() {
                it('verifies the url of the page', function() {
                    mockEvent.$('getCurrentRoutedUrl').$results('/login-page.html');

                    expect(function() {
                        this.CUT.seePageIs('/login-page.html');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seePageIs('/random-page.html');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the url \[\/login-page\.html\] \(actual\) equalled \[\/random\-page\.html\] \(expected\)\.'
                    );
                });

                it('throws an exception if trying to verify the url of a page visited by `visitEvent`', function() {
                    mockEvent.$('getCurrentRoutedUrl').$results('');
                    this.CUT.$property(propertyName = 'requestMethod', mock = 'visitEvent');

                    expect(function() {
                        this.CUT.seePageIs('/sample-page.html');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'You cannot assert the page when you visited using the visitEvent\(\) method\. Please use visit\(\) instead\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seePageIs('/sample-page.html');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeViewIs', function() {
                it('verifies the currently routed ColdBox view', function() {
                    mockEvent.$('getCurrentView').$results('main.index');

                    expect(function() {
                        this.CUT.seeViewIs('main.index'); }
                    ).notToThrow();

                    expect(function() {
                        this.CUT.seeViewIs('main.doesntExist');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that view \[main\.index\] \(actual\) equalled \[main\.doesntExist\] \(expected\)\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seeViewIs('main.index');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeHandlerIs', function() {
                it('verifies the currently routed ColdBox handler', function() {
                    mockEvent.$('getCurrentHandler').$results('Main');

                    expect(function() {
                        this.CUT.seeHandlerIs('Main'); }
                    ).notToThrow();

                    expect(function() {
                        this.CUT.seeHandlerIs('DoesntExist');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that handler \[Main\] \(actual\) equalled \[DoesntExist\] \(expected\)\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seeHandlerIs('Main');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeActionIs', function() {
                it('verifies the currently routed ColdBox action', function() {
                    mockEvent.$('getCurrentAction').$results('index');

                    expect(function() {
                        this.CUT.seeActionIs('index'); }
                    ).notToThrow();

                    expect(function() {
                        this.CUT.seeActionIs('doesntExist');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that action \[index\] \(actual\) equalled \[doesntExist\] \(expected\)\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seeActionIs('index');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeEventIs', function() {
                it('verifies the currently routed ColdBox event', function() {
                    mockEvent.$('getCurrentEvent').$results('Main.index');

                    expect(function() {
                        this.CUT.seeEventIs('Main.index'); }
                    ).notToThrow();

                    expect(function() {
                        this.CUT.seeEventIs('Main.doesntExist');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that event \[Main\.index\] \(actual\) equalled \[Main\.doesntExist\] \(expected\)\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seeEventIs('Main.index');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeInCollection', function() {
                it('verifies that a key exists in the request collection', function() {
                    expect(function() {
                        this.CUT.seeInCollection('email');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInCollection('username');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[username\] exists in the request collection\.'
                    );
                });

                it('verifies that a key exists in the private request collection', function() {
                    expect(function() {
                        this.CUT.seeInCollection(key = 'birthday', private = true);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInCollection(key = 'username', private = true);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[username\] exists in the private request collection\.'
                    );
                });

                it('verifies that a key with a given value exists in the request collection', function() {
                    expect(function() {
                        this.CUT.seeInCollection('email', 'john@example.com');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInCollection('username', 'johnny_boy');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[username\] with the value \[johnny\_boy\] exists in the request collection\.'
                    );
                });

                it('verifies that a key with a given value exists in the private request collection', function() {
                    expect(function() {
                        this.CUT.seeInCollection(key = 'birthday', value = '01/01/1980', private = true);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInCollection(key = 'username', value = 'johnny_boy', private = true);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[username\] with the value \[johnny_boy\] exists in the private request collection\.'
                    );
                });

                it('fails if the key does exist but not with the given value in the request collection', function() {
                    expect(function() {
                        this.CUT.seeInCollection('email', 'john@example.com');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInCollection('email', 'johnny_boy@example.com');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[email\] with the value \[johnny\_boy\@example\.com\] exists in the request collection\.'
                    );
                });

                it('fails if the key does exist but not with the given value in the private request collection', function() {
                    expect(function() {
                        this.CUT.seeInCollection(key = 'birthday', value = '01/01/1980', private = true);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInCollection(key = 'birthday', value = '02/29/2016', private = true);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[birthday\] with the value \[02\/29\/2016\] exists in the private request collection\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seeInCollection('email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('dontSeeInCollection', function() {
                it('verifies that a key does not exist in the request collection', function() {
                    expect(function() {
                        this.CUT.dontSeeInCollection('username');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeInCollection('email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[email\] does not exist in the request collection\.'
                    );
                });

                it('verifies that a key does not exist in the private request collection', function() {
                    expect(function() {
                        this.CUT.dontSeeInCollection(key = 'username', private = true);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeInCollection(key = 'birthday', private = true);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[birthday\] does not exist in the private request collection\.'
                    );
                });

                it('verifies that a key with a given value does not exist in the request collection', function() {
                    expect(function() {
                        this.CUT.dontSeeInCollection('username', 'johnny_boy');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeInCollection('email', 'john@example.com');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[email\] with the value \[john\@example\.com\] does not exist in the request collection\.'
                    );
                });

                it('verifies that a key with a given value does not exist in the private request collection', function() {
                    expect(function() {
                        this.CUT.dontSeeInCollection(key = 'username', value = 'johnny_boy', private = true);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeInCollection(key = 'birthday', value = '01/01/1980', private = true);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that the key \[birthday\] with the value \[01\/01\/1980\] does not exist in the private request collection\.'
                    );
                });

                it('does not fail if the key does exist but not with the given value in the request collection', function() {
                    expect(function() {
                        this.CUT.dontSeeInCollection('email', 'johnny_boy@example.com');
                    }).notToThrow();
                });

                it('does not fail if the key does exist but not with the given value in the private request collection', function() {
                    expect(function() {
                        this.CUT.dontSeeInCollection(key = 'birthday', value = '02/29/2016', private = true);
                    }).notToThrow();
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.dontSeeInCollection('email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });
        } );
    }
}