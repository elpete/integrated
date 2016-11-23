component extends='testbox.system.BaseSpec' {

    function beforeAll() {
        this.CUT = new BaseSpecs.ColdBoxBaseSpec();
        getMockBox().prepareMock(this.CUT);
        variables.requestEngine = getMockBox().createMock("Integrated.Engines.Request.ColdBoxRequestEngine");

        // Set up the parent ColdBox BaseTestCase
        this.CUT.beforeAll(
            variables.requestEngine,
            {
                "appMapping" = "/SampleApp"
            }
        );
    }

    function run() {
        describe('BaseSpec — Interactions', function() {

            describe('visit methods', function() {
                beforeEach(function() {
                    var html = fileRead(expandPath('/tests/resources/login-page.html'));

                    makePublic(this.CUT, 'parse', 'parsePublic');
                    this.CUT.parsePublic(html);
                });

                feature('visit', function() {
                    beforeEach(function() {
                        mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                        var html = fileRead(expandPath('/tests/resources/login-page.html'));
                        mockEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                        mockEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                        mockEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                        mockEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });
                        requestEngine.$('getRequestContext', mockEvent);
                        requestEngine.$('execute').$args(route = '/login', renderResults = true).$results(mockEvent);
                    });

                    it('visits a url', function() {
                        expect(
                            function() { this.CUT.visit('/login'); }
                        ).notToThrow();
                    });

                    it('fails when the event cannot be found', function() {
                        variables.requestEngine
                            .$(
                                method = 'execute',
                                throwException = true,
                                throwType = 'HandlerService.EventHandlerNotRegisteredException'
                            )
                            .$args(route = '/contact', renderResults = true);

                        expect(
                            function() { this.CUT.visit('/contact'); }
                        ).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });

                    it('correctly sets the requestMethod', function() {
                        this.CUT.visit('/login');

                        var actualRequestMethod = this.CUT.getRequestMethod();

                        expect(actualRequestMethod).toBe('visit');
                    });

                    it('clears out the requestMethod after an invalid call', function() {
                        variables.requestEngine
                            .$(
                                method = 'execute',
                                throwException = true,
                                throwType = 'HandlerService.EventHandlerNotRegisteredException'
                            )
                            .$args(route = '/contact', renderResults = true);

                        expect(
                            function() { this.CUT.visit('/contact'); }
                        ).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );

                        var actualRequestMethod = this.CUT.getRequestMethod();

                        expect(actualRequestMethod).toBe('');
                    });
                });

                feature('visitEvent', function() {
                    beforeEach(function() {
                        mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                        var html = fileRead(expandPath('/tests/resources/login-page.html'));
                        mockEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                        mockEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                        mockEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                        mockEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });

                        requestEngine.$('getRequestContext', mockEvent);
                        requestEngine.$('execute').$args(event = 'Main.index', renderResults = true).$results(mockEvent);
                    });

                    it('visits a ColdBox event', function() {
                        expect(
                            function() { this.CUT.visitEvent('Main.index'); }
                        ).notToThrow();
                    });

                    it('fails when the event cannot be found', function() {
                        variables.requestEngine
                            .$(
                                method = 'execute',
                                throwException = true,
                                throwType = 'HandlerService.EventHandlerNotRegisteredException'
                            )
                            .$args(event = 'Main.doesntExist', renderResults = true);

                        expect(
                            function() { this.CUT.visitEvent('Main.doesntExist'); }
                        ).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });

                    it('correctly sets the requestMethod', function() {
                        this.CUT.visitEvent('Main.index');

                        var actualRequestMethod = this.CUT.getRequestMethod();

                        expect(actualRequestMethod).toBe('visitEvent');
                    });

                    it('clears out the requestMethod after an invalid call', function() {
                        variables.requestEngine
                            .$(
                                method = 'execute',
                                throwException = true,
                                throwType = 'HandlerService.EventHandlerNotRegisteredException'
                            )
                            .$args(event = 'Main.doesntExist', renderResults = true);

                        expect(
                            function() { this.CUT.visitEvent('Main.doesntExist'); }
                        ).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );

                        var actualRequestMethod = this.CUT.getRequestMethod();

                        expect(actualRequestMethod).toBe('');
                    });
                });
            });

            describe('interaction methods', function() {
                beforeEach(setUpRequests);

                feature('click', function() {
                    it('clicks on links (anchor tags)', function() {
                        this.CUT.visit('/login')
                                .seeTitleIs('Login Page')
                                .click('About')
                                .seeTitleIs('About Page');
                    });

                    it('fails if the anchor tag has no href attribute with a route failed', function() {
                        expect(function(){
                            this.CUT.visit('/login')
                                    .seeTitleIs('Login Page')
                                    .click('##test-link');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );


                    });
                });

                feature('press', function() {
                    it('presses a button', function() {
                        var mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                        mockEvent.$('setValue', mockEvent);
                        variables.requestEngine.$('getRequestContext', mockEvent);

                        this.CUT.visit('/login')
                                .type('john@example.com', 'email')
                                .type('mY@wes0mep2ssw0rD', 'password')
                                .press('Log In')
                                .seeTitleIs('Secured Page');

                        // The implementation is currently correct.
                        // However, I am not sure how to test it. ¯\_(ツ)_/¯

                        // var setValueCallLog = mockEvent.$callLog().setValue;

                        // // convert the strange array of arrays into a struct
                        // var setValueCallLogStruct = {};
                        // for (var call in setValueCallLog) {
                        //     setValueCallLogStruct[call[1]] = call[2];
                        // }

                        // expect(setValueCallLogStruct).toHaveKey('email');
                        // expect(setValueCallLogStruct.email).toBe('john@example.com');
                        // expect(setValueCallLogStruct).toHaveKey('password');
                        // expect(setValueCallLogStruct.password).toBe('mY@wes0mep2ssw0rD');
                    });

                    it('can take an optional override event', function() {
                        var mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                        mockEvent.$('setValue', mockEvent);
                        variables.requestEngine.$('getRequestContext', mockEvent);

                        this.CUT.visit('/login')
                                .type('john@example.com', 'email')
                                .type('mY@wes0mep2ssw0rD', 'password')
                                .press('Log In', 'about')
                                .seeTitleIs('About Page');

                        // The implementation is currently correct.
                        // However, I am not sure how to test it. ¯\_(ツ)_/¯

                        // var setValueCallLog = mockEvent.$callLog().setValue;

                        // // convert the strange array of arrays into a struct
                        // var setValueCallLogStruct = {};
                        // for (var call in setValueCallLog) {
                        //     setValueCallLogStruct[call[1]] = call[2];
                        // }

                        // expect(setValueCallLogStruct).toHaveKey('email');
                        // expect(setValueCallLogStruct.email).toBe('john@example.com');
                        // expect(setValueCallLogStruct).toHaveKey('password');
                        // expect(setValueCallLogStruct.password).toBe('mY@wes0mep2ssw0rD');
                    });
                });

                feature('submitForm', function() {
                    it('submits a form', function() {
                        var mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                        mockEvent.$('setValue', mockEvent);
                        variables.requestEngine.$('getRequestContext', mockEvent);
                        
                        this.CUT.visit('/login')
                                .submitForm('Log In')
                                .seeTitleIs('Secured Page');
                    });

                    it('accepts an optional struct of form data', function() {
                        var mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                        mockEvent.$('setValue', mockEvent);
                        variables.requestEngine.$('getRequestContext', mockEvent);

                        this.CUT.visit('/login')
                                .submitForm('Log In', {
                                    email = 'john@example.com',
                                    password = 'mY@wes0mep2ssw0rD'
                                })
                                .seeTitleIs('Secured Page');

                        // The implementation is currently correct.
                        // However, I am not sure how to test it. ¯\_(ツ)_/¯

                        // var setValueCallLog = mockEvent.$callLog().setValue;

                        // // convert the strange array of arrays into a struct
                        // var setValueCallLogStruct = {};
                        // for (var call in setValueCallLog) {
                        //     setValueCallLogStruct[call[1]] = call[2];
                        // }

                        // expect(setValueCallLogStruct).toHaveKey('email');
                        // expect(setValueCallLogStruct.email).toBe('john@example.com');
                        // expect(setValueCallLogStruct).toHaveKey('password');
                        // expect(setValueCallLogStruct.password).toBe('mY@wes0mep2ssw0rD');
                    });

                    it('can take an optional override event', function() {
                        var mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                        mockEvent.$('setValue', mockEvent);
                        variables.requestEngine.$('getRequestContext', mockEvent);

                        this.CUT.visit('/login')
                                .submitForm('Log In', {
                                    email = 'john@example.com',
                                    password = 'mY@wes0mep2ssw0rD'
                                }, 'about')
                                .seeTitleIs('About Page');

                        // The implementation is currently correct.
                        // However, I am not sure how to test it. ¯\_(ツ)_/¯

                        // var setValueCallLog = mockEvent.$callLog().setValue;

                        // // convert the strange array of arrays into a struct
                        // var setValueCallLogStruct = {};
                        // for (var call in setValueCallLog) {
                        //     setValueCallLogStruct[call[1]] = call[2];
                        // }

                        // expect(setValueCallLogStruct).toHaveKey('email');
                        // expect(setValueCallLogStruct.email).toBe('john@example.com');
                        // expect(setValueCallLogStruct).toHaveKey('password');
                        // expect(setValueCallLogStruct.password).toBe('mY@wes0mep2ssw0rD');
                    });

                    it( "throws when the form does not have an action", function() {
                        expect(function() {
                            this.CUT.visit('/login')
                                .submitForm('Invalid Form');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed',
                            regex = 'The specified form is missing an action\.'
                        );
                    } );
                });
            });

            describe('redirect methods', function() {
                it('follows redirects in an event', function() {
                    var mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(true);
                    mockSecuredEvent.$('getValue').$args('setNextEvent_event').$results('Main.login');
                    mockSecuredEvent.$('getValue').$args('setNextEvent_persist', '').$results('');
                    mockSecuredEvent.$('getValue').$args('setNextEvent_persistStruct', {}).$results({});
                    variables.requestEngine.$('execute').$args(event = 'Main.secured', renderResults = true).$results(mockSecuredEvent);

                    var mockLoginEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    mockLoginEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                    mockLoginEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                    mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                    var html = fileRead(expandPath('/tests/resources/login-page.html'));
                    mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });
                    mockLoginEvent.$('getCurrentEvent', 'Main.login');
                    variables.requestEngine.$('execute').$args(event = 'Main.login', renderResults = true).$results(mockLoginEvent);

                    this.CUT.visitEvent('Main.secured').seeEventIs('Main.login');   
                });

                it('follows redirects in a route', function() {
                    var mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(true);
                    mockSecuredEvent.$('getValue').$args('setNextEvent_event').$results('/index.cfm/login');
                    mockSecuredEvent.$('getValue').$args('setNextEvent_persist', '').$results('');
                    mockSecuredEvent.$('getValue').$args('setNextEvent_persistStruct', {}).$results({});
                    variables.requestEngine.$('execute').$args(route = '/secured', renderResults = true).$results(mockSecuredEvent);

                    var mockLoginEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    mockLoginEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                    mockLoginEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                    mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                    var html = fileRead(expandPath('/tests/resources/login-page.html'));
                    mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });
                    mockLoginEvent.$('getCurrentRoutedUrl', '/login');
                    variables.requestEngine.$('execute').$args(route = '/login', renderResults = true).$results(mockLoginEvent);

                    this.CUT.visit('/secured').seePageIs('/login');   
                });

                it('persists data in a redirect', function() {
                    var mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                    mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(true);
                    mockSecuredEvent.$('getValue').$args('setNextEvent_event').$results('/index.cfm/login');
                    mockSecuredEvent.$('getValue').$args('setNextEvent_persist', '').$results('email');
                    mockSecuredEvent.$('valueExists').$args('email').$results(true);
                    mockSecuredEvent.$('getValue').$args('email').$results('john@example.com');
                    mockSecuredEvent.$('getValue').$args('setNextEvent_persistStruct', {}).$results({ birthday = '01/01/1980' });
                    variables.requestEngine.$('execute').$args(route = '/securedWithPersistedData', renderResults = true).$results(mockSecuredEvent);

                    var mockLoginEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    mockLoginEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
                    mockLoginEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
                    mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                    var html = fileRead(expandPath('/tests/resources/login-page.html'));
                    mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });
                    mockLoginEvent.$('getCurrentRoutedUrl', '/login');
                    variables.requestEngine.$('execute').$args(route = '/login', renderResults = true).$results(mockLoginEvent);

                    var inputSpy = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    inputSpy.$('setValue');
                    variables.requestEngine.$('getRequestContext', inputSpy);

                    this.CUT.visit('/securedWithPersistedData')
                            .seePageIs('/login');

                    var callLog = inputSpy.$callLog().setValue;

                    var argOne = callLog[1];
                    var argTwo = callLog[2];

                    if (argOne[1] == 'birthday') {
                        expect(argOne[1]).toBe('birthday');
                        expect(argOne[2]).toBe('01/01/1980');

                        expect(argTwo[1]).toBe('email');
                        expect(argTwo[2]).toBe('john@example.com');
                    }
                    else if (argOne[1] == 'email') {
                        expect(argOne[1]).toBe('email');
                        expect(argOne[2]).toBe('john@example.com');

                        expect(argTwo[1]).toBe('birthday');
                        expect(argTwo[2]).toBe('01/01/1980');
                    }
                    else {
                        fail('Unknown key returned #argOne[1]#');
                    }
                });
            });
        });
    }

    private function setUpRequests() {
        setUpLoginPage();
        setUpAboutPage();
        setUpSecuredPage();
        throwOnOtherRequests();
    }

    private function setUpLoginPage() {
        var loginPage = fileRead(expandPath('/tests/resources/login-page.html'));

        mockLoginEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
        mockLoginEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
        mockLoginEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
        mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
        mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = loginPage });
        variables.requestEngine.$('execute').$args(route = '/login', renderResults = true).$results(mockLoginEvent);
    }

    private function setUpAboutPage() {
        var aboutPage = fileRead(expandPath('/tests/resources/about-page.html'));

        this.CUT.$('parseFrameworkRoute')
            .$args("/about")
            .$results("/about");

        mockAboutEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
        mockAboutEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
        mockAboutEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
        mockAboutEvent.$('valueExists').$args('setNextEvent_event').$results(false);
        mockAboutEvent.$(method = 'getCollection', returns = { cbox_rendered_content = aboutPage });

        variables.requestEngine.$('execute').$args(event = 'about', renderResults = true).$results(mockAboutEvent);
        variables.requestEngine.$('execute').$args(route = '/about', renderResults = true).$results(mockAboutEvent);
    }

    private function setUpSecuredPage() {
        var securedPage = fileRead(expandPath('/tests/resources/secured-page.html'));

        this.CUT.$('parseFrameworkRoute')
            .$args("http://127.0.0.1:12121/SampleApp/index.cfm/secured")
            .$results("/secured");

        mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
        mockSecuredEvent.$('valueExists').$args('setNextEvent_URI').$results(false);
        mockSecuredEvent.$('valueExists').$args('setNextEvent_URL').$results(false);
        mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(false);
        mockSecuredEvent.$(method = 'getCollection', returns = { cbox_rendered_content = securedPage });

        variables.requestEngine.$('execute').$args(route = '/secured', renderResults = true).$results(mockSecuredEvent);
    }

    private function throwOnOtherRequests() {
        variables.requestEngine.$(
            method = 'execute',
            callback = function() {
                throw(type = 'HandlerService.EventHandlerNotRegisteredException');
            }
        );
    }
}
