/**
* @doc_abstract true
*/
component extends='testbox.system.BaseSpec' {

    function getCUT() {
        throw('Method is abstract and must be implemented in a concrete test component. Return the component from this method.');
    }

    function getDOMAssertionEngine() {
        throw('Method is abstract and must be implemented in a concrete test component. Return the DOMAssertionEngine from this method.');
    }

    function isAbstractSpec() {
        var md = getMetadata(this);
        return structKeyExists( md, 'doc_abstract' ) && md.doc_abstract == true;
    }

    function beforeAll() {
        if (isAbstractSpec()) {
            return;
        }

        variables.engine = getMockBox().createStub(
            implements = "Integrated.Engines.Assertion.Contracts.DOMAssertionEngine"
        );
        this.CUT = getCUT();
        this.CUT.setDOMAssertionEngine( engine );
        getMockBox().prepareMock(this.CUT);
    }

    function run() {
        if (isAbstractSpec()) {
            debug( "This spec is not run directly.  To run these tests, extend this class from a concrete component." );
            return;
        }

        describe( "Interaction Engine — #getMetadata(this).fullname#", function() {
            describe('interaction methods', function() {
                feature('type', function() {
                    it('types a value in to a form field', function() {
                        engine.$( "seeElement", engine );
                        this.CUT.type('john@example.com', '##email');

                        var inputs = this.CUT.getInputs();

                        expect(inputs.email).toBe('john@example.com');
                    });

                    it('fails if the form field does not exist', function() {
                        engine.$("seeElement").$args("credit-card-number").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.type('2626262626262626', 'credit-card-number');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('check', function() {
                    it('checks a checkbox', function() {
                        engine.$( "seeElement", engine );
                        this.CUT.check('##spam-me');

                        var inputs = this.CUT.getInputs();

                        expect(inputs['spam-me']).toBe(true);
                    });

                    it('fails if the checkbox does not exist', function() {
                        engine.$("seeElement").$args("terms").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('unchecks', function() {
                    it('unchecks a checkbox', function() {
                        engine.$( "seeElement", engine );
                        this.CUT.uncheck('##remember-me');

                        var inputs = this.CUT.getInputs();

                        expect(inputs['remember-me']).toBe(false);
                    });

                    it('fails if the checkbox does not exist', function() {
                        engine.$("seeElement").$args("terms").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('select', function() {
                    beforeEach(function() {
                        engine.$( "seeElement", engine );
                    });

                    it('selects an option', function() {
                        engine.$("findOptionValue").$args("CA", "##country").$results("CA");
                        this.CUT.select('CA', '##country');

                        var inputs = this.CUT.getInputs();

                        expect(inputs['country']).toBe('CA');
                    });

                    it('selects an option by name as well as value', function() {
                        engine.$("findOptionValue").$args("Canada", "##country").$results("CA");
                        this.CUT.select('Canada', '##country');

                        var inputs = this.CUT.getInputs();

                        expect(inputs['country']).toBe('CA');
                    });

                    it('fails if the select field does not exist', function() {
                        engine.$("findOptionValue").$args("Male", "gender").$throws(type = "TestBox.AssertionFailed");
                        expect(function() {
                            this.CUT.select('Male', 'gender');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });

                    it('fails if the option does not exist in the select field provided', function() {
                        engine.$("findOptionValue").$args("Earth", "country").$throws(type = "TestBox.AssertionFailed");
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
