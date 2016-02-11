component extends='testbox.system.BaseSpec' {

    function beforeAll() {
        this.CUT = new BaseSpec();
        getMockBox().prepareMock(this.CUT);
        this.CUT.beforeAll();
    }

    function run() {
        describe('BaseSpec — Interactions', function() {

            beforeEach(function() {
                var html = fileRead(expandPath('/tests/resources/sample-page.html'));

                makePublic(this.CUT, 'parse', 'parsePublic');
                this.CUT.parsePublic(html);
            });

            feature('visit', function() {
                beforeEach(function() {
                    mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    var html = fileRead(expandPath('/tests/resources/sample-page.html'));
                    mockEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });

                    this.CUT.$('execute').$args(route = '/login', renderResults = true).$results(mockEvent);
                });

                it('visits a ColdBox event', function() {
                    expect(
                        function() { this.CUT.visit('/login') }
                    ).notToThrow();
                });

                it('fails when the event cannot be found', function() {
                    this.CUT
                        .$(
                            method = 'execute',
                            throwException = true,
                            throwType = 'HandlerService.EventHandlerNotRegisteredException'
                        )
                        .$args(route = '/contact', renderResults = true);

                    expect(
                        function() { this.CUT.visit('/contact') }
                    ).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Could not find any route called \[\/contact\]\.'
                    );
                });

                it('correctly sets the requestMethod', function() {
                    this.CUT.visit('/login');

                    var actualRequestMethod = this.CUT.$getProperty('requestMethod');

                    expect(actualRequestMethod).toBe('visit');
                });

                it('clears out the requestMethod after an invalid call', function() {
                    this.CUT
                        .$(
                            method = 'execute',
                            throwException = true,
                            throwType = 'HandlerService.EventHandlerNotRegisteredException'
                        )
                        .$args(route = '/contact', renderResults = true);

                    expect(
                        function() { this.CUT.visit('/contact') }
                    ).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Could not find any route called \[\/contact\]\.'
                    );

                    var actualRequestMethod = this.CUT.$getProperty('requestMethod');

                    expect(actualRequestMethod).toBe('');
                });
            });

            feature('visitEvent', function() {
                beforeEach(function() {
                    mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
                    var html = fileRead(expandPath('/tests/resources/sample-page.html'));
                    mockEvent.$(method = 'getCollection', returns = { cbox_rendered_content = html });

                    this.CUT.$('execute').$args(event = 'Main.index', renderResults = true).$results(mockEvent);
                });

                it('visits a ColdBox event', function() {
                    expect(
                        function() { this.CUT.visitEvent('Main.index') }
                    ).notToThrow();
                });

                it('fails when the event cannot be found', function() {
                    this.CUT
                        .$(
                            method = 'execute',
                            throwException = true,
                            throwType = 'HandlerService.EventHandlerNotRegisteredException'
                        )
                        .$args(event = 'Main.doesntExist', renderResults = true);

                    expect(
                        function() { this.CUT.visitEvent('Main.doesntExist') }
                    ).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Could not find any event called \[Main\.doesntExist\]\.'
                    );
                });

                it('correctly sets the requestMethod', function() {
                    this.CUT.visitEvent('Main.index');

                    var actualRequestMethod = this.CUT.$getProperty('requestMethod');

                    expect(actualRequestMethod).toBe('visitEvent');
                });

                it('clears out the requestMethod after an invalid call', function() {
                    this.CUT
                        .$(
                            method = 'execute',
                            throwException = true,
                            throwType = 'HandlerService.EventHandlerNotRegisteredException'
                        )
                        .$args(event = 'Main.doesntExist', renderResults = true);

                    expect(
                        function() { this.CUT.visitEvent('Main.doesntExist') }
                    ).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Could not find any event called \[Main\.doesntExist\]\.'
                    );

                    var actualRequestMethod = this.CUT.$getProperty('requestMethod');

                    expect(actualRequestMethod).toBe('');
                });
            });

            feature('click', function() {
                it('clicks on links (anchor tags)', function() {
                    fail('test not implemented yet');
                });
            });

            feature('type', function() {
                it('types a value in to a form field', function() {
                    fail('test not implemented yet');
                });
            });

            feature('check', function() {
                it('checks a checkbox', function() {
                    fail('test not implemented yet');
                });
            });

            feature('uncheck', function() {
                it('unchecks a checkbox', function() {
                    fail('test not implemented yet');
                });
            });

            feature('press', function() {
                it('presses a button', function() {
                    fail('test not implemented yet');
                });
            });

            feature('submitForm', function() {
                it('submits a form', function() {
                    fail('test not implemented yet');
                });

                it('accepts an optional struct of form data', function() {
                    fail('test not implemented yet');
                });
            });


        });
    }
}
