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
    * @element The element selector or name to type the value in to.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function type(required string text, required string element) {
        return storeInput(arguments.element, arguments.text);
    }

    /**
    * Checks a checkbox.
    *
    * @element The selector or name of the checkbox to check.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function check(required string element) {
        return storeInput(arguments.element, true);
    }

    /**
    * Unchecks a checkbox.
    *
    * @element The selector or name of the checkbox to uncheck.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function uncheck(required string element) {
        return storeInput(arguments.element, false);
    }

    /**
    * Selects a given option in a given select field.
    *
    * @option The value or text to select.
    * @element The selector or name to choose the option in.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function select(required string option, required string element) {
        var value = variables.domEngine.findOptionValue(arguments.option, arguments.element);

        return storeInput(arguments.element, value);
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
    * @element The selector or name of an form field.
    * @value The value to store in-memory.
    * @overwrite Optional. Specifies whether to overwrite any existing in-memory input values.  Default: true.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function storeInput(
        required string element,
        required string value,
        boolean overwrite = true
    ) {
        // First verify that the given element exists
        variables.domEngine.seeElement(arguments.element);

        var key = generateInputKey(arguments.element);

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
    * @element The selector or name of the field.
    *
    * @return boolean
    */
    public boolean function fieldExists(required string element) {
        return structKeyExists( variables.inputs, generateInputKey(element));
    }

    /**
    * Verifies that a field with the given value exists in the current inputs with the given value.
    *
    * @element The selector or name of the field.
    * @value The expected value of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function seeInField(
        required string value,
        required string element,
        boolean negate = false
    ) {
        var key = generateInputKey(element);
        var exists = structKeyExists( variables.inputs, key );

        if ( ! exists ) {
            if ( negate ) {
                expect( exists ).toBeFalse( "Expected [#element#] to not exist in the stored inputs." );
            }
            else {
                expect( exists ).toBeTrue( "Expected [#element#] to exist in the stored inputs." );
            }
            return this;
        }

        var actualValue = variables.inputs[ key ];

        if ( negate ) {
            expect( actualValue ).notToBe( value, "Failed asserting that [#value#] does not appear in a [#element#] input or textarea on the page." );
        }
        else {
            expect( actualValue ).toBe( value, "Failed asserting that [#value#] appears in a [#element#] input or textarea on the page." );
        }

        return this;
    }

    /**
    * Verifies that a checkbox is checked in the stored inputs.
    *
    * @element The selector or name of the checkbox.
    * @negate Optional. If true, throw an exception if the checkbox IS checked. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function seeIsChecked(
        required string element,
        boolean negate = false
    ) {
        var key = generateInputKey(element);
        var exists = structKeyExists( variables.inputs, key );

        if ( ! exists ) {
            if ( negate ) {
                expect( exists ).toBeFalse( "Expected [#element#] to not exist in the stored inputs." );
            }
            else {
                expect( exists ).toBeTrue( "Expected [#element#] to exist in the stored inputs." );
            }
            return this;
        }

        var actualValue = variables.inputs[ key ];

        if ( negate ) {
            expect( actualValue )
                .toBeFalse( "Failed asserting that [#element#] is not checked on the page." );
        }
        else {
            expect( actualValue )
                .toBeTrue( "Failed asserting that [#element#] is checked on the page." );   
        }

        return this;
    }

    /**
    * Verifies that an option is selected in the stored inputs.
    *
    * @value The selector or name of the option to look for.
    * @element The selector or name of the element to look for the option in.
    * @negate Optional. If true, throw an exception if the option IS selected in the element. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function seeIsSelected(
        required string value,
        required string element,
        boolean negate = false
    ) {
        var key = generateInputKey(element);
        var exists = structKeyExists( variables.inputs, key );

        if ( ! exists ) {
            if ( negate ) {
                expect( exists ).toBeFalse( "Expected [#element#] to not exist in the stored inputs." );
            }
            else {
                expect( exists ).toBeTrue( "Expected [#element#] to exist in the stored inputs." );
            }
            return this;
        }

        var actualValue = variables.inputs[ key ];
        var option = variables.domEngine.findOption( actualValue, element );
        var optionText = option.text();

        if ( negate ) {
            expect( value == actualValue || value == optionText ).toBeFalse(
                "Failed asserting that [#value#] is not selected in a [#element#] element."
            );
        }
        else {
            expect( value == actualValue || value == optionText ).toBeTrue(
                "Failed asserting that [#value#] is selected in a [#element#] element."
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