interface displayname="InteractionEngine" {
 
    /**
    * Sets the DOMAssertionEngine as a collaborator.
    * This can also be passed in as a constructor argument.
    *
    * @engine Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function setDOMAssertionEngine(required DOMAssertionEngine engine);

    /**
    * Types a value in to a form field.
    *
    * @text The value to type in the form field.
    * @selectorOrName The element selector or name to type the value in to.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function type(required string text, required string selectorOrName);

    /**
    * Checks a checkbox.
    *
    * @selectorOrName The selector or name of the checkbox to check.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function check(required string selectorOrName);

    /**
    * Unchecks a checkbox.
    *
    * @selectorOrName The selector or name of the checkbox to uncheck.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function uncheck(required string selectorOrName);

    /**
    * Selects a given option in a given select field.
    *
    * @option The value or text to select.
    * @selectorOrName The selector or name to choose the option in.
    * @multiple If true, add the selection instead of replacing it. Default: true.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function select(required string option, required string selectorOrName, boolean multiple);

    /**
    * Press a submit button.
    *
    * @button The text of the button to press.
    * @overrideEvent Optional. The event to run instead of the form's default. Default: ''.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function press(required string button, string overrideEvent);

    /**
    * Stores a value in an in-memory input struct with the element name as the key.
    *
    * @value The value to store in-memory.
    * @selectorOrName The selector or name of an form field.
    * @overwrite Optional. Specifies whether to overwrite any existing in-memory input values.  Default: true.
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function storeInput(required any value, required string selectorOrName, boolean overwrite);

    /**
    * Resets the inputs to empty
    *
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function reset();

    /**
    * Verifies that a field with the given value exists in the current inputs regardless of value.
    *
    * @selectorOrName The selector or name of the field.
    *
    * @return boolean
    */
    public boolean function fieldExists(required string selectorOrName);

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
    public InteractionEngine function seeInField(required string value, required string selectorOrName, boolean negate);

    /**
    * Verifies that a checkbox is checked in the stored inputs.
    *
    * @selectorOrName The selector or name of the checkbox.
    * @negate Optional. If true, throw an exception if the checkbox IS checked. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Interaction.Contracts.InteractionEngine
    */
    public InteractionEngine function seeIsChecked(required string selectorOrName, boolean negate);

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
    public InteractionEngine function seeIsSelected(required string value, required string selectorOrName, boolean negate);

}