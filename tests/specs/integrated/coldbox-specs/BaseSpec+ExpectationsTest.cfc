component extends='testbox.system.BaseSpec' {
    
    function beforeAll() {
        this.CUT = new BaseSpecs.ColdBoxBaseSpec();
        getMockBox().prepareMock(this.CUT);

        // Set the appMapping for testing
        variables.mockBaseTestCase = getMockBox().createMock('coldbox.system.testing.BaseTestCase');
        this.CUT.$property(propertyName = 'baseTestCase', mock = mockBaseTestCase);
        variables.mockBaseTestCase.$property(propertyName = 'appMapping', mock = '/SampleApp');
        variables.mockBaseTestCase.beforeAll();

        // Set up the parent ColdBox BaseTestCase
        this.CUT.beforeAll();
    }

    function run() {
        describe('BaseSpec — Expectations', function() {

            beforeEach(function() {
                // Read in a sample html page
                var html = fileRead(expandPath('/tests/resources/login-page.html'));

                // Parse the html page in
                makePublic(this.CUT, 'parse', 'parsePublic');
                this.CUT.parsePublic(html);

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
                    this.CUT.parsePublic('');
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seePageIs('/sample-page.html');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeTitleIs', function() {
                it('verifies the title of the page', function() {
                    expect(function() {
                        this.CUT.seeTitleIs('Login Page'); }
                    ).notToThrow();

                    expect(function() {
                        this.CUT.seeTitleIs('Random Page');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[Login Page\] \(actual\) equalled \[Random Page\] \(expected\)\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seeTitleIs('Login Page');
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
                    this.CUT.parsePublic('');
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
                    this.CUT.parsePublic('');
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
                    this.CUT.parsePublic('');
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
                    this.CUT.parsePublic('');
                    this.CUT.$property(propertyName = 'event', mock = '');

                    expect(function() {
                        this.CUT.seeEventIs('Main.index');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('see', function() {
                it('verifies that the given text appears somewhere on the page', function() {
                    expect(function() {
                        this.CUT.see('Log In'); }
                    ).notToThrow();

                    expect(function() {
                        this.CUT.see('Log Out');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[Log Out\] was found on the page\.'
                    );
                });

                it('does not find the text inside html tags', function() {
                    expect(function() {
                        this.CUT.see('div');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[div\] was found on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.see('Log In');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('dontSee', function() {
                it('verifies that the given text does not appear somewhere on the page', function() {
                    expect(function() {
                        this.CUT.dontSee('Log Out'); }
                    ).notToThrow();

                    expect(function() {
                        this.CUT.dontSee('Log In');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[Log In\] was not found on the page\.'
                    );
                });

                it('does not find the text inside html tags', function() {
                    expect(function() {
                        this.CUT.dontSee('div'); }
                    ).notToThrow();
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.dontSee('Log Out');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeInElement', function() {
                it('verifies that the given text appears inside a given element', function() {
                    expect(function() {
                        this.CUT.seeInElement('label', 'Email');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInElement('h1', 'Email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[Email\] appears in a \[h1\] on the page\.'
                    );
                });

                it('fails if the given element does not exist on the page', function() {
                    expect(function() {
                        this.CUT.dontSeeInElement('span', 'Email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed to find a \[span\] element on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.dontSeeInElement('label', 'Email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('dontSeeInElement', function() {
                it('verifies that the given text does not appear inside a given element', function() {
                    expect(function() {
                        this.CUT.dontSeeInElement('h1', 'Email');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeInElement('label', 'Email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[Email\] did not appear in a \[label\] on the page\.'
                    );
                });

                it('fails if the given element does not exist on the page', function() {
                    expect(function() {
                        this.CUT.dontSeeInElement('span', 'Email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed to find a \[span\] element on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.dontSeeInElement('h1', 'Email');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeLink', function() {
                it('verifies that a link with the given text exists', function() {
                    expect(function() {
                        this.CUT.seeLink('About');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeLink('About', '/about');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeLink('About', 'http://google.com');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'No links were found matching the pattern \[About\]\ and URL \[http\:\/\/google\.com\].'
                    );

                    expect(function() {
                        this.CUT.seeLink('Contact Us');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'No links were found matching the pattern \[Contact Us\]\.'
                    );
                });

                it('verifies links given a selector', function() {
                    expect(function() {
                        this.CUT.seeLink('##test-link');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeLink('.some-link');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'No links were found matching the pattern \[\.some\-link\]\.'
                    );

                    expect(function() {
                        this.CUT.seeLink('Contact Us');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'No links were found matching the pattern \[Contact Us\]\.'
                    );
                });

                it('fails if no anchor tags exist on the page', function() {
                    var htmlWithoutLink = '<html><head><title>Sample Page</title></head><body><p>Random Content Here</p></body></html>';
                    this.CUT.parsePublic(htmlWithoutLink);
                    
                    expect(function() {
                        this.CUT.seeLink('About');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'No links found on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.seeLink('About');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('dontSeeLink', function() {
                it('verifies that a link with the given text does not exist', function() {
                    expect(function() {
                        this.CUT.dontSeeLink('Contact Us');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeLink('About', 'http://google.com');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeLink('About', '/about');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'A link was found with expected text \[About\]\ and URL \[\/about\]\.'
                    );

                    expect(function() {
                        this.CUT.dontSeeLink('About');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'A link was found with expected text \[About\]\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.dontSeeLink('Contact Us');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeInField', function() {
                it('verifies that a field has the value of the given text', function() {
                    expect(function() {
                        this.CUT.seeInField('##email', 'sample');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInField('##email', 'random');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[random\] appears in a \[##email\] input or textarea on the page\.'
                    );
                });

                it('fails if the given selector cannot be found', function() {
                    expect(function() {
                        this.CUT.seeInField('##doesntExist', 'random');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed to find a \[##doesntExist\] input or textarea on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.seeInField('##email', 'sample');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('dontSeeInField', function() {
                it('verifies that a field does not have the value of the given text', function() {
                    expect(function() {
                        this.CUT.dontSeeInField('##email', 'random');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeInField('##email', 'sample');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[sample\] does not appear in a \[##email\] input or textarea on the page\.'
                    );
                });

                it('finds fields by names as well as ids', function() {
                    expect(function() {
                        this.CUT.dontSeeInField('email', 'random');
                    }).notToThrow();
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.dontSeeInField('##email', 'sample');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeIsChecked', function() {
                it('verifies that a field is checked', function() {
                    expect(function() {
                        this.CUT.seeIsChecked('##remember-me');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeIsChecked('##spam-me');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[##spam\-me\] is checked on the page\.'
                    );
                });

                it('fails if it cannot find the specified checkbox', function() {
                    expect(function() {
                        this.CUT.seeIsChecked('##random-checkbox');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed to find a \[##random\-checkbox\] checkbox on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.seeIsChecked('##remember-me');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('dontSeeIsChecked', function() {
                it('verifies that a field is not checked', function() {
                    expect(function() {
                        this.CUT.dontSeeIsChecked('##spam-me');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeIsChecked('##remember-me');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[##remember\-me\] is not checked on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.dontSeeIsChecked('##email', 'sample');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('seeIsSelected', function() {
                it('verifies that a field has the given value selected', function() {
                    expect(function() {
                        this.CUT.seeIsSelected('##country', 'USA');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeIsSelected('##country', 'Canada');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[Canada\] is selected in a \[##country\] input on the page\.'
                    );
                });

                it('can verify by value or html', function() {
                    expect(function() {
                        this.CUT.seeIsSelected('##country', 'US');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeIsSelected('##country', 'USA');
                    }).notToThrow();
                });

                it('fails if it cannot find the specified select field', function() {
                    expect(function() {
                        this.CUT.seeIsSelected('##state', 'UT');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed to find a \[##state\] select field on the page\.'
                    );
                });

                it('fails if it cannot find any selected options in the select field', function() {
                    expect(function() {
                        this.CUT.seeIsSelected('##planet', 'Earth');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed to find any selected options in \[##planet\] select field on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.seeIsSelected('##country', 'USA');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Cannot make assertions until you visit a page\.  Make sure to run visit\(\) or visitEvent\(\) first\.'
                    );
                });
            });

            feature('dontSeeIsSelected', function() {
                it('verifies that a field does not have the given value selected', function() {
                    expect(function() {
                        this.CUT.dontSeeIsSelected('##country', 'Canada');
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeIsSelected('##country', 'USA');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Failed asserting that \[USA\] is not selected in a \[##country\] input on the page\.'
                    );
                });

                it('throws an exception if there is no parsed document', function() {
                    this.CUT.parsePublic('');

                    expect(function() {
                        this.CUT.dontSeeIsSelected('##country', 'Canada');
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

            feature('seeInTable', function() {
                it('verifies that a row exists in a table', function() {
                    var mockUsersTable = queryNew(
                        'id,username,email,last_logged_in',
                        'integer,varchar,varchar,timestamp',
                        [
                            { id = 1, username = 'johnny_boy', email ='john@example.com', last_logged_in = createDateTime(2016, 01, 01, 12, 01, 33) },
                            { id = 2, username = 'lady_jo', email ='josephene@example.com', last_logged_in = createDateTime(2016, 01, 02, 15, 01, 33) },
                            { id = 3, username = 'jack', email ='jack@example.com', last_logged_in = createDateTime(2016, 01, 05, 08, 01, 33) }
                        ]
                    );

                    expect(function() {
                        this.CUT.seeInTable(table = 'users', data = { email = 'john@example.com' }, query = mockUsersTable);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.seeInTable(table = 'users', data = { email = 'jane@example.com' }, query = mockUsersTable);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Unable to find row in database table \[users\] that matched attributes \[\{\"EMAIL\"\:\"jane\@example\.com\"\}\]\.'
                    );
                });
            });

            feature('dontSeeInTable', function() {
                it('verifies that a row does not exist in a table', function() {
                    var mockUsersTable = queryNew(
                        'id,username,email,last_logged_in',
                        'integer,varchar,varchar,timestamp',
                        [
                            { id = 1, username = 'johnny_boy', email ='john@example.com', last_logged_in = createDateTime(2016, 01, 01, 12, 01, 33) },
                            { id = 2, username = 'lady_jo', email ='josephene@example.com', last_logged_in = createDateTime(2016, 01, 02, 15, 01, 33) },
                            { id = 3, username = 'jack', email ='jack@example.com', last_logged_in = createDateTime(2016, 01, 05, 08, 01, 33) }
                        ]
                    );

                    expect(function() {
                        this.CUT.dontSeeInTable(table = 'users', data = { email = 'jane@example.com' }, query = mockUsersTable);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.dontSeeInTable(table = 'users', data = { email = 'john@example.com' }, query = mockUsersTable);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Found unexpected records in database table \[users\] that matched attributes \[\{\"EMAIL\"\:\"john\@example\.com\"\}\]\.'
                    );
                });
            });

        });
    }
}
