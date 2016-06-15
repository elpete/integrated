component extends='testbox.system.BaseSpec' {

    function beforeAll() {
        variables.engine = getMockBox().createStub(
            implements = "Integrated.Engines.Assertion.Contracts.DOMAssertionEngine"
        );
        this.CUT = new Integrated.Engines.Interaction.JSoupInteractionEngine( engine );
        getMockBox().prepareMock(this.CUT);
    }

    function run() {
        describe( "Interaction Engine Tests — #getMetadata(this).fullname#", function() {
            describe('interaction methods', function() {
                feature('type', function() {
                    it('types a value in to a form field', function() {
                        this.CUT.type('john@example.com', '##email');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs.email).toBe('john@example.com');
                    });

                    it('fails if the form field does not exist', function() {
                        engine.$("findElement").$args("credit-card-number").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.type('2626262626262626', 'credit-card-number');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('check', function() {
                    it('checks a checkbox', function() {
                        this.CUT.check('##spam-me');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['spam-me']).toBe(true);
                    });

                    it('fails if the checkbox does not exist', function() {
                        engine.$("findElement").$args("terms").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('unchecks', function() {
                    it('unchecks a checkbox', function() {
                        this.CUT.uncheck('##remember-me');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['remember-me']).toBe(false);
                    });

                    it('fails if the checkbox does not exist', function() {
                        engine.$("findElement").$args("terms").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('select', function() {
                    it('selects an option', function() {
                        engine.$("findOption").$args("CA", "##country").$results("CA");
                        this.CUT.select('CA', '##country');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['country']).toBe('CA');
                    });

                    it('selects an option by name as well as value', function() {
                        engine.$("findOption").$args("Canada", "##country").$results("CA");
                        this.CUT.select('Canada', '##country');

                        var inputs = this.CUT.$getProperty('inputs');

                        expect(inputs['country']).toBe('CA');
                    });

                    it('fails if the select field does not exist', function() {
                        engine.$("findOption").$args("Male", "gender").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.select('Male', 'gender');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });

                    it('fails if the option does not exist in the select field provided', function() {
                        engine.$("findOption").$args("Earth", "country").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.select('Earth', 'country');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });
            });
        });
    }
}
