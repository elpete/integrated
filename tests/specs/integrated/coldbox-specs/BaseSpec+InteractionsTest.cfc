component extends='testbox.system.BaseSpec' {

    function beforeAll() {
        this.CUT = new BaseSpecs.ColdBoxBaseSpec();
        getMockBox().prepareMock(this.CUT);

        // Set up the parent ColdBox BaseTestCase
        this.CUT.beforeAll();
        
        // Set the appMapping for testing
        variables.mockBaseTestCase = getMockBox().createMock('coldbox.system.testing.BaseTestCase');
        this.CUT.$property(propertyName = 'baseTestCase', mock = mockBaseTestCase);
        variables.mockBaseTestCase.$property(propertyName = 'appMapping', mock = '/SampleApp');
        variables.mockBaseTestCase.beforeAll();
    }

    function run() {
        describe('BaseSpec — Interactions', function() {
            describe('interaction methods', function() {
                beforeEach(setUpRequests);

                feature('type', function() {
                    it('types a value in to a form field', function() {
                        this.CUT.visit('/login')
                                .dontSeeInField('##email', 'john@example.com')
                                .type('john@example.com', '##email');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs.email).toBe('john@example.com');
                    });

                    it('fails if the form field does not exist', function() {
                        expect(function() {
                            this.CUT.visit('/login')
                                .type('2626262626262626', 'credit-card-number');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('check', function() {
                    it('checks a checkbox', function() {
                        this.CUT.visit('/login')
                                .dontSeeIsChecked('spam-me')
                                .check('##spam-me');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['spam-me']).toBe(true);
                    });

                    it('fails if the checkbox does not exist', function() {
                        expect(function() {
                            this.CUT.visit('/login')
                                    .check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('unchecks', function() {
                    it('unchecks a checkbox', function() {
                        this.CUT.visit('/login')
                                .seeIsChecked('remember-me')
                                .uncheck('##remember-me');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['remember-me']).toBe(false);
                    });

                    it('fails if the checkbox does not exist', function() {
                        expect(function() {
                            this.CUT.visit('/login')
                                    .check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('select', function() {
                    it('selects an option', function() {
                        this.CUT.visit('/login')
                                .seeIsSelected('##country', 'USA')
                                .select('CA', '##country');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['country']).toBe('CA');
                    });

                    it('selects an option by name as well as value', function() {
                        this.CUT.visit('/login')
                                .seeIsSelected('##country', 'USA')
                                .select('Canada', '##country');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['country']).toBe('CA');
                    });

                    it('fails if the select field does not exist', function() {
                        expect(function() {
                            this.CUT.visit('/login')
                                    .select('Male', 'gender');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });

                    it('fails if the option does not exist in the select field provided', function() {
                        expect(function() {
                            this.CUT.visit('/login')
                                    .select('Earth', 'country');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
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
        mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
        mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = loginPage });
        variables.mockBaseTestCase.$('execute').$args(route = '/login', renderResults = true).$results(mockLoginEvent);
    }

    private function setUpAboutPage() {
        var aboutPage = fileRead(expandPath('/tests/resources/about-page.html'));

        this.CUT.$('parseFrameworkRoute')
            .$args("/about")
            .$results("/about");

        mockAboutEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
        mockAboutEvent.$('valueExists').$args('setNextEvent_event').$results(false);
        mockAboutEvent.$(method = 'getCollection', returns = { cbox_rendered_content = aboutPage });

        variables.mockBaseTestCase.$('execute').$args(event = 'about', renderResults = true).$results(mockAboutEvent);
        variables.mockBaseTestCase.$('execute').$args(route = '/about', renderResults = true).$results(mockAboutEvent);
    }

    private function setUpSecuredPage() {
        var securedPage = fileRead(expandPath('/tests/resources/secured-page.html'));

        this.CUT.$('parseFrameworkRoute')
            .$args("http://127.0.0.1:12121/SampleApp/index.cfm/secured")
            .$results("/secured");

        mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
        mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(false);
        mockSecuredEvent.$(method = 'getCollection', returns = { cbox_rendered_content = securedPage });

        variables.mockBaseTestCase.$('execute').$args(route = '/secured', renderResults = true).$results(mockSecuredEvent);
    }

    private function throwOnOtherRequests() {
        variables.mockBaseTestCase.$(
            method = 'execute',
            callback = function() {
                throw(type = 'HandlerService.EventHandlerNotRegisteredException');
            }
        );
    }
}
