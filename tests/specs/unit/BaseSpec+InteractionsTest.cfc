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
                it('visits a given url', function() {
                    fail('test not implemented yet');
                });

                it('correctly sets the requestMethod', function() {
                    fail('test not implemented yet');
                });
            });

            feature('visitEvent', function() {
                it('visits a ColdBox event', function() {
                    expect(
                        function() { this.CUT.visitEvent('Main.index') }
                    ).notToThrow();

                    expect(
                        function() { this.CUT.visitEvent('Main.doesntExist') }
                    ).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Could not find any event called \[Main\.doesntExist\]\.'
                    );
                });

                it('correctly sets the requestMethod', function() {
                    fail('test not implemented yet');
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
