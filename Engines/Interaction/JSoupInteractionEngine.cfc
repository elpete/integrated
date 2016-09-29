import Integrated.Engines.Assertion.Contracts.DOMAssertionEngine;
import Integrated.Engines.Interaction.Contracts.InteractionEngine;

component extends="testbox.system.BaseSpec" implements="Integrated.Engines.Interaction.Contracts.InteractionEngine" {
    
    // The struct of form input values
    property name='inputs' type='struct' default='{}';

    public InteractionEngine function init(
        DOMAssertionEngine engine = new Integrated.Engines.Assertion.JSoupAssertionEngine()
    ) {
        variables.domEngine = arguments.engine;
        variables.inputs = {};

        return this;
    }

    /**
    * Sets the DOMAssertionEngine as a collaborator.
    * This can also be passed in as a constructor argument.
    *
    * @engine Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function setDOMAssertionEngine(required DOMAssertionEngine engine) {
        variables.domEngine = arguments.engine;

        return this;
    }

    /**
    * Types a value in to a form field.
    *
    * @text The value to type in the form field.
    * @selectorOrName The element selector or name to type the value in to.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function type(required string text, required string selectorOrName) {
        return storeInput(arguments.text, arguments.selectorOrName);
    }

    /**
    * Checks a checkbox.
    *
    * @selectorOrName The selector or name of the checkbox to check.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function check(required string selectorOrName) {
        return storeInput(true, arguments.selectorOrName);
    }

    /**
    * Unchecks a checkbox.
    *
    * @selectorOrName The selector or name of the checkbox to uncheck.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function uncheck(required string selectorOrName) {
        return storeInput(false, arguments.selectorOrName);
    }

    /**
    * Selects a given option in a given select field.
    *
    * @option The value or text to select.
    * @selectorOrName The selector or name to choose the option in.
    * @multiple If true, add the selection instead of replacing it. Default: true.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function select(
        required string option,
        required string selectorOrName,
        boolean multiple = false
    ) {
        var value = variables.domEngine.findOptionValue(arguments.option, arguments.selectorOrName);

        if ( multiple ) {
            var currentInput = getInput( arguments.selectorOrName );
            if ( ! isArray( currentInput ) ) {
                currentInput = [ currentInput ];
            }
            arrayAppend( currentInput, value );
            value = currentInput;
        }

        return storeInput(value, arguments.selectorOrName);
    }

    /**
    * Press a submit button.
    *
    * @button The text of the button to press.
    * @overrideEvent Optional. The event to run instead of the form's default. Default: ''.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function press(required string button, string overrideEvent = '') {
        return this.submitForm(
            button = arguments.button,
            overrideEvent = arguments.overrideEvent
        );
    }

    /**
    * Stores a value in an in-memory input struct with the element name as the key.
    *
    * @value The value to store in-memory.
    * @selectorOrName The selector or name of an form field.
    * @overwrite Optional. Specifies whether to overwrite any existing in-memory input values.  Default: true.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function storeInput(
        required any value,
        required string selectorOrName,
        boolean overwrite = true
    ) {
        // First verify that the given element exists
        variables.domEngine.seeElement(arguments.selectorOrName);

        var key = generateInputKey(arguments.selectorOrName);

        if (StructKeyExists(variables.inputs, key)) {
            if (arguments.overwrite) {
                variables.inputs[key] = arguments.value;
            }
        }
        else {
            variables.inputs[key] = arguments.value;
        }

        return this;
    }

    /**
    * Returns the value for a given selector or name
    *
    * @selectorOrName The selector or name of an form field.
    *
    * @return any
    */
    public any function getInput( required string selectorOrName ) {
        var key = generateInputKey(arguments.selectorOrName);

        if ( ! structKeyExists( variables.inputs, key ) ) {
            return [];
        }

        return variables.inputs[ key ];
    }

    /**
    * Returns the currently stored inputs
    *
    * @return struct
    */
    public struct function getInputs() {
        return variables.inputs;
    }

    /**
    * Resets the inputs to empty
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function reset() {
        variables.inputs = {};

        return this;
    }

    /**
    * Verifies that a field with the given value exists in the current inputs regardless of value.
    *
    * @selectorOrName The selector or name of the field.
    *
    * @return boolean
    */
    public boolean function fieldExists(required string selectorOrName) {
        return structKeyExists( variables.inputs, generateInputKey(selectorOrName));
    }

    /**
    * Verifies that a field with the given value exists in the current inputs with the given value.
    *
    * @value The expected value of the field.
    * @selectorOrName The selector or name of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function seeInField(
        required string value,
        required string selectorOrName,
        boolean negate = false
    ) {
        var key = generateInputKey(selectorOrName);
        var exists = structKeyExists( variables.inputs, key );

        if ( ! exists ) {
            if ( negate ) {
                expect( exists ).toBeFalse( "Expected [#selectorOrName#] to not exist in the stored inputs." );
            }
            else {
                expect( exists ).toBeTrue( "Expected [#selectorOrName#] to exist in the stored inputs." );
            }
            return this;
        }

        var actualValue = variables.inputs[ key ];

        if ( negate ) {
            expect( actualValue ).notToBe( value, "Failed asserting that [#value#] does not appear in a [#selectorOrName#] input or textarea on the page." );
        }
        else {
            expect( actualValue ).toBe( value, "Failed asserting that [#value#] appears in a [#selectorOrName#] input or textarea on the page." );
        }

        return this;
    }

    /**
    * Verifies that a checkbox is checked in the stored inputs.
    *
    * @selectorOrName The selector or name of the checkbox.
    * @negate Optional. If true, throw an exception if the checkbox IS checked. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function seeIsChecked(
        required string selectorOrName,
        boolean negate = false
    ) {
        var key = generateInputKey(selectorOrName);
        var exists = structKeyExists( variables.inputs, key );

        if ( ! exists ) {
            if ( negate ) {
                expect( exists ).toBeFalse( "Expected [#selectorOrName#] to not exist in the stored inputs." );
            }
            else {
                expect( exists ).toBeTrue( "Expected [#selectorOrName#] to exist in the stored inputs." );
            }
            return this;
        }

        var actualValue = variables.inputs[ key ];

        if ( negate ) {
            expect( actualValue )
                .toBeFalse( "Failed asserting that [#selectorOrName#] is not checked on the page." );
        }
        else {
            expect( actualValue )
                .toBeTrue( "Failed asserting that [#selectorOrName#] is checked on the page." );   
        }

        return this;
    }

    /**
    * Verifies that an option is selected in the stored inputs.
    *
    * @value The selector or name of the option to look for.
    * @selectorOrName The selector or name of the element to look for the option in.
    * @negate Optional. If true, throw an exception if the option IS selected in the element. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function seeIsSelected(
        required string value,
        required string selectorOrName,
        boolean negate = false
    ) {
        var key = generateInputKey(selectorOrName);
        var exists = structKeyExists( variables.inputs, key );

        if ( ! exists ) {
            if ( negate ) {
                expect( exists ).toBeFalse( "Expected [#selectorOrName#] to not exist in the stored inputs." );
            }
            else {
                expect( exists ).toBeTrue( "Expected [#selectorOrName#] to exist in the stored inputs." );
            }
            return this;
        }

        var actualValue = variables.inputs[ key ];
        var optionTexts = [];
        for (var val in actualValue) {
            var option = variables.domEngine.findOption( val, selectorOrName );
            arrayAppend( optionTexts, option.text() );
        }


        var exists = false;
        for ( var val in actualValue ) {
            exists = value == val;
            if ( exists ) {
                break;
            }
        }
        if ( ! exists ) {
            for ( var text in optionTexts ) {
                exists = value == text;
                if ( exists ) {
                    break;
                }
            }
        }

        if ( negate ) {
            expect( exists ).toBeFalse(
                "Failed asserting that [#value#] is not selected in a [#selectorOrName#] element."
            );
        }
        else {
            expect( exists ).toBeTrue(
                "Failed asserting that [#value#] is selected in a [#selectorOrName#] element."
            );
        }

        return this;
    }

    /******************* HELPER METHODS *******************/

    /**
    * Returns a normalized key name for a form field selector or name.
    * Removes pound signs (#) from selectors.
    *
    * @element The selector or name of an form field.
    *
    * @return string
    */
    private string function generateInputKey(required string element) {
        return replaceNoCase(arguments.element, '##', '', 'all');
    }

}