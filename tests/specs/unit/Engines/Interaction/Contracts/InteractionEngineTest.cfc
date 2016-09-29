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

        variables.blankEngine = getMockBox().createStub(
            implements = "Integrated.Engines.Assertion.Contracts.DOMAssertionEngine"
        );
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
            beforeEach(function() {
                variables.engine = getMockBox().createStub(
                    implements = "Integrated.Engines.Assertion.Contracts.DOMAssertionEngine"
                );
                this.CUT.setDOMAssertionEngine( engine );
            });

            afterEach( function() {
                this.CUT.$property( propertyName = "inputs", mock = {} );
            } );

            describe('interaction methods', function() {
                feature('type', function() {
                    it('types a value in to a form field', function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        this.CUT.type('john@example.com', '##email');

                        var inputs = this.CUT.getInputs();

                        expect(inputs.email).toBe('john@example.com');
                    });

                    it('fails if the form field does not exist', function() {
                        engine.$( method = "seeElement", throwException = true, throwType = "TestBox.AssertionFailed", preserveArguments = true);
                        expect(function() {
                            this.CUT.type('2626262626262626', 'credit-card-number');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('check', function() {
                    it('checks a checkbox', function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        this.CUT.check('##spam-me');

                        var inputs = this.CUT.getInputs();

                        expect(inputs['spam-me']).toBe(true);
                    });

                    it('fails if the checkbox does not exist', function() {
                        engine.$( method = "seeElement", throwException = true, throwType = "TestBox.AssertionFailed", preserveArguments = true);
                        expect(function() {
                            this.CUT.check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('unchecks', function() {
                    it('unchecks a checkbox', function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        this.CUT.uncheck('##remember-me');

                        var inputs = this.CUT.getInputs();

                        expect(inputs['remember-me']).toBe(false);
                    });

                    it('fails if the checkbox does not exist', function() {
                        engine.$( method = "seeElement", throwException = true, throwType = "TestBox.AssertionFailed", preserveArguments = true);
                        expect(function() {
                            this.CUT.check('terms');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature('select', function() {
                    beforeEach(function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                    });

                    it('selects an option', function() {
                        engine.$( method = "findOptionValue", returns = "CA", preserveArguments = true);
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

                    it('can select multiple options', function() {
                        engine.$("findOptionValue").$args("USA", "##country").$results("US");
                        engine.$("findOptionValue").$args("CA", "##country").$results("CA");
                        this.CUT.select(
                                    option = 'USA',
                                    selectorOrName = '##country'
                                ).select(
                                    option = 'CA',
                                    selectorOrName = '##country',
                                    multiple = true
                                );

                        var inputs = this.CUT.getInputs();

                        expect(inputs['country']).toBe(['US', 'CA']);
                    });

                    it('fails if the select field does not exist', function() {
                        engine.$(method = "findOptionValue", throwException = true, throwType = "TestBox.AssertionFailed", preserveArguments = true);
                        expect(function() {
                            this.CUT.select('Male', 'gender');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });

                    it('fails if the option does not exist in the select field provided', function() {
                        engine.$(method = "findOptionValue", throwException = true, throwType = "TestBox.AssertionFailed", preserveArguments = true);
                        expect(function() {
                            this.CUT.select('Earth', 'country');
                        }).toThrow(
                            type = 'TestBox.AssertionFailed'
                        );
                    });
                });

                feature( "seeInField", function() {
                    it( "throws if the field does not exist in the current inputs", function() {
                        expect(function() {
                            this.CUT.seeInField('john@example.com', '##email');
                        }).toThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );

                    it( "does not throw if the field does exist in the current input", function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.type('john@example.com', '##email')
                                .seeInField('john@example.com', '##email');
                        }).notToThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );

                    it( "throws if the field does exist but not with the specified value", function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.type('john@example.com', '##email')
                                .seeInField('scott@example.com', '##email');
                        }).toThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );

                    it( "does not throw if the field exists with the specified value", function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.type('john@example.com', '##email')
                                .seeInField('john@example.com', '##email');
                        }).notToThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );
                } );

                feature( "seeIsChecked", function() {
                    it( "throws if the field is not checked in the current inputs", function() {
                        expect(function() {
                            this.CUT.seeIsChecked('##remember-me');
                        }).toThrow(type = "TestBox.AssertionFailed");
                    } );

                    it( "does not throw if the checkbox is checked in the current input", function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.check('##remember-me')
                                .seeIsChecked('##remember-me');
                        }).notToThrow();
                    } );

                    it( "handles negate checks as well", function() {
                        expect(function() {
                            this.CUT.seeIsChecked('##remember-me', true);
                        }).notToThrow();

                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.check('##remember-me')
                                .seeIsChecked('##remember-me', true);
                        }).toThrow(type = "TestBox.AssertionFailed");
                    } );
                } );

                feature( "seeIsSelected", function() {
                    beforeEach(function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                    });

                    it( "throws if the option is not selected in the current inputs", function() {
                        expect(function() {
                            this.CUT.seeIsSelected('USA', '##country');
                        }).toThrow(type = "TestBox.AssertionFailed");
                    } );

                    it( "does not throw if the option is selected in the current input", function() {
                        var optionMock = getMockBox().createStub().$( "text", "United States" );
                        engine.$( method = "findOptionValue", returns = "USA", preserveArguments = true);
                        engine.$( method = "findOption", returns = optionMock, preserveArguments = true);
                        expect(function() {
                            this.CUT.select('USA', '##country')
                                .seeIsSelected('USA', '##country');
                        }).notToThrow();
                    } );

                    it( "handles negate checks as well", function() {
                        var optionMock = getMockBox().createStub().$( "text", "United States" );
                        engine.$( method = "findOptionValue", returns = "USA", preserveArguments = true);
                        engine.$( method = "findOption", returns = optionMock, preserveArguments = true);
                        expect(function() {
                            this.CUT.select('USA', '##country')
                                .seeIsSelected('Canada', '##country', true);
                        }).notToThrow();

                        // engine.$( method = "findOptionValue", returns = "USA", preserveArguments = true);
                        // expect(function() {
                        //     this.CUT.select('USA', '##country')
                        //         .seeIsSelected('USA', '##country', true);
                        // }).toThrow(type = "TestBox.AssertionFailed");
                    } );
                } );

                feature( "dontSeeInField", function() {
                    it( "throws if the field exists in the current inputs", function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.type('john@example.com', '##email')
                                .seeInField('john@example.com', '##email', true);
                        }).toThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );

                    it( "does not throw if the field does not exist in the current input", function() {
                        expect(function() {
                            this.CUT.seeInField('john@example.com', '##email', true);
                        }).notToThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );

                    it( "throws if the field exists with the specified value", function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.type('john@example.com', '##email')
                                .seeInField('john@example.com', '##email', true);
                        }).toThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );

                    it( "does not throw if the field exists but not with the specified value", function() {
                        engine.$( method = "seeElement", returns = blankEngine, preserveArguments = true );
                        expect(function() {
                            this.CUT.type('john@example.com', '##email')
                                .seeInField('scott@example.com', '##email', true);
                        }).notToThrow(
                            type = "TestBox.AssertionFailed"
                        );
                    } );
                } );
            });
        });
    }
}
