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
        describe('BaseSpec — Redirects', function() {
            it('follows redirects in an event', function() {
                var mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(true);
                mockSecuredEvent.$('getValue').$args('setNextEvent_event').$results('Main.login');
                mockSecuredEvent.$('getValue').$args('setNextEvent_persist', '').$results('');
                mockSecuredEvent.$('getValue').$args('setNextEvent_persistStruct', {}).$results({});
                variables.mockBaseTestCase.$('execute').$args(event = 'Main.secured', renderResults = true).$results(mockSecuredEvent);

                var mockLoginEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                var html = fileRead(expandPath('/tests/resources/login-page.html'));
                mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });
                mockLoginEvent.$('getCurrentEvent', 'Main.login');
                variables.mockBaseTestCase.$('execute').$args(event = 'Main.login', renderResults = true).$results(mockLoginEvent);

                this.CUT.visitEvent('Main.secured').seeEventIs('Main.login');   
            });

            it('follows redirects in a route', function() {
                var mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(true);
                mockSecuredEvent.$('getValue').$args('setNextEvent_event').$results('/login');
                mockSecuredEvent.$('getValue').$args('setNextEvent_persist', '').$results('');
                mockSecuredEvent.$('getValue').$args('setNextEvent_persistStruct', {}).$results({});
                variables.mockBaseTestCase.$('execute').$args(route = '/secured', renderResults = true).$results(mockSecuredEvent);

                var mockLoginEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                var html = fileRead(expandPath('/tests/resources/login-page.html'));
                mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });
                mockLoginEvent.$('getCurrentRoutedUrl', '/login');
                variables.mockBaseTestCase.$('execute').$args(route = '/login', renderResults = true).$results(mockLoginEvent);

                this.CUT.visit('/secured').seePageIs('/login');   
            });

            it('persists data in a redirect', function() {
                var mockSecuredEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                mockSecuredEvent.$('valueExists').$args('setNextEvent_event').$results(true);
                mockSecuredEvent.$('getValue').$args('setNextEvent_event').$results('/login');
                mockSecuredEvent.$('getValue').$args('setNextEvent_persist', '').$results('email');
                mockSecuredEvent.$('getValue').$args('email').$results('john@example.com');
                mockSecuredEvent.$('getValue').$args('setNextEvent_persistStruct', {}).$results({ birthday = '01/01/1980' });
                variables.mockBaseTestCase.$('execute').$args(route = '/securedWithPersistedData', renderResults = true).$results(mockSecuredEvent);

                var mockLoginEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                mockLoginEvent.$('valueExists').$args('setNextEvent_event').$results(false);
                var html = fileRead(expandPath('/tests/resources/login-page.html'));
                mockLoginEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });
                mockLoginEvent.$('getCurrentRoutedUrl', '/login');
                variables.mockBaseTestCase.$('execute').$args(route = '/login', renderResults = true).$results(mockLoginEvent);

                var inputSpy = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                inputSpy.$('setValue');
                variables.mockBaseTestCase.$('getRequestContext', inputSpy);

                this.CUT.visit('/securedWithPersistedData')
                        .seePageIs('/login');

                var callLog = inputSpy.$callLog().setValue;
                var birthdayArg = callLog[1];
                var emailArg = callLog[2];

                expect(birthdayArg[1]).toBe('birthday');
                expect(birthdayArg[2]).toBe('01/01/1980');

                expect(emailArg[1]).toBe('email');
                expect(emailArg[2]).toBe('john@example.com');
            });
        });
    }

}