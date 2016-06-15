component extends="testbox.system.BaseSpec" implements="Integrated.Engines.Assertion.Contracts.DOMAssertionEngine" {

    // The jsoup parser object
    property name='jsoup' type='org.jsoup.parser.Parser';
    // The parsed jsoup document object
    property name='page' type='org.jsoup.nodes.Document';

    /**
    * Set up the JSoupAssertionEngine
    *
    * @jsoup The JSoup parser
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function init() {
        variables.jsoup =  createObject( "java", "org.jsoup.Jsoup" ) ;

        return this;
    }

    /**
    * Parses an html string.
    * If an empty string is passed in, the current page is set to an empty string instead of parsing the page.
    *
    * @htmlString The html string to parse.
    */
    public void function parse(required string htmlString) {
        if (arguments.htmlString == '') {
            variables.page = arguments.htmlString;
            return;
        }

        variables.page = variables.jsoup.parse(htmlString);

        return;
    }

    /**
    * Verifies the title of the current page.
    *
    * @title The expected title.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeTitleIs(required string title) {
        var actualTitle = getParsedPage().title();

        expect(arguments.title).toBe(actualTitle,
            'Failed asserting that [#actualTitle#] (actual) equalled [#arguments.title#] (expected).'
        );

        return this;
    }

    /**
    * Verifies that the given text exists in any element on the current page.
    *
    * @text The expected text.
    * @negate Optional. If true, throw an exception if the text IS found on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function see(required string text, boolean negate = false) {
        var elems = getParsedPage().select('*:contains(#arguments.text#)');

        if (!negate) {
            expect(elems).notToBeEmpty('Failed asserting that [#arguments.text#] was found on the page.');
        }
        else {
            expect(elems).toBeEmpty('Failed asserting that [#arguments.text#] was not found on the page.');
        }

        return this;
    }

    /**
    * Verifies that the given text does not exist in any element on the current page.
    *
    * @text The text that should not appear.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSee(required string text) {
        return this.see(text = arguments.text, negate = true);
    }

    /**
    * Verifies that the given element contains the given text on the current page.
    *
    * @element The provided element.
    * @text The expected text.
    * @negate Optional. If true, throw an exception if the element DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeInElement(
        required string element,
        required string text,
        boolean negate = false
    ) {
        var elems = findElement(arguments.element);

        var elemsWithText = elems.select(':contains(#arguments.text#)');

        if (!negate) {
            expect(elemsWithText).notToBeEmpty('Failed asserting that [#arguments.text#] appears in a [#arguments.element#] on the page.');
        }
        else {
            expect(elemsWithText).toBeEmpty('Failed asserting that [#arguments.text#] did not appear in a [#arguments.element#] on the page.');
        }

        return this;
    }

    /**
    * Verifies that the given element does not contain the given text on the current page.
    *
    * @element The provided element.
    * @text The text that should not be found.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeInElement(
        required string element,
        required string text
    ) {
        return this.seeInElement(
            element = arguments.element,
            text = arguments.text,
            negate = true
        );
    }

    /**
    * Verifies that a link with the given text exists on the current page.
    * Can also take an optional url parameter.  If provided, it verifies the link found has the given url.
    *
    * @text The expected text of the link.
    * @url Optional. The expected url of the link. Default: ''.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeLink(required string text, string url = '') {
        var errorMessage = 'No links were found matching the pattern [#arguments.text#]';

        if (arguments.url != '') {
            errorMessage &= ' and URL [#arguments.url#]';
        }

        errorMessage &= '.';

        expect(hasLink(arguments.text, arguments.url)).toBeTrue(errorMessage);

        return this;
    }

    /**
    * Verifies that a link with the given text does not exist on the current page.
    * Can also take an optional url parameter.  If provided, it verifies the link found does not have the given url.
    *
    * @text The text of the link that should not be found.
    * @url Optional. The url that should not be found. Default: ''.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeLink(required string text, string url = '') {
        var errorMessage = 'A link was found with expected text [#arguments.text#]';

        if (arguments.url != '') {
            errorMessage &= ' and URL [#arguments.url#]';
        }

        errorMessage &= '.';

        expect(hasLink(arguments.text, arguments.url)).toBeFalse(errorMessage);

        return this;
    }

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    * @value The expected value of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeInField(required string element, required string value, boolean negate = false) {
        var inputs = findField(arguments.element);

        var inputsWithValue = inputs.select('[value=#arguments.value#');

        if (!negate) {
            expect(inputsWithValue).notToBeEmpty('Failed asserting that [#arguments.value#] appears in a [#arguments.element#] input or textarea on the page.');
        }
        else {
            expect(inputsWithValue).toBeEmpty('Failed asserting that [#arguments.value#] does not appear in a [#arguments.element#] input or textarea on the page.');
        }

        return this;
    }

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    * @value The value of the field to not find.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeInField(required string element, required string value) {
        return this.seeInField(
            element = arguments.element,
            value = arguments.value,
            negate = true
        );
    }

    /**
    * Verifies that a checkbox is checked on the current page.
    *
    * @element The selector or name of the checkbox.
    * @negate Optional. If true, throw an exception if the checkbox IS checked on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeIsChecked(required string element, boolean negate = false) {
        var checkboxes = findCheckbox(arguments.element);

        var checkedCheckboxes = checkboxes.select('[checked]');

        if (!negate) {
            expect(checkedCheckboxes).notToBeEmpty('Failed asserting that [#arguments.element#] is checked on the page.');
        }
        else {
            expect(checkedCheckboxes).toBeEmpty('Failed asserting that [#arguments.element#] is not checked on the page.');
        }

        return this;
    }

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeIsChecked(required string element) {
        return this.seeIsChecked(
            element = arguments.element,
            negate = true
        );
    }

    /**
    * Verifies that a given selector has a given option selected.
    *
    * @element The selector or name of the select field.
    * @value The value or text of the option that should exist.
    * @negate Optional. If true, throw an exception if the option IS selected in the given select field on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeIsSelected(required string element, required string value, boolean negate = false) {
        var selectFields = findSelectField(arguments.element);

        var selectedOption = selectFields.select('option[selected]');

        expect(selectedOption).notToBeEmpty('Failed to find any selected options in [#arguments.element#] select field on the page.');

        if (!negate) {
            var isValue = selectedOption.val() == arguments.value || selectedOption.html() == arguments.value;
            expect(isValue).toBeTrue('Failed asserting that [#arguments.value#] is selected in a [#arguments.element#] input on the page.');
        }
        else {
            var isNotValue = selectedOption.val() != arguments.value && selectedOption.html() != arguments.value;
            expect(isNotValue).toBeTrue('Failed asserting that [#arguments.value#] is not selected in a [#arguments.element#] input on the page.');
        }

        return this;
    }

    /**
    * Verifies that a given selector does not have a given option selected.
    *
    * @element The selector or name of the select field.
    * @value The value or text of the option that should exist.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeIsSelected(required string element, required string value) {
        return this.seeIsSelected(
            element = arguments.element,
            value = arguments.value,
            negate = true
        );
    }


    /**************************** Helper Methods ******************************/


    /**
    * Retrives the last parsed page.
    * Throws an exception if there is no parsed page available.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.nodes.Document
    */    
    private function getParsedPage() {
        if (IsSimpleValue(variables.page)) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Cannot make assertions until you visit a page.  Make sure to run visit() or visitEvent() first.'
            );
        }

        return variables.page;
    }

    /**
    * Returns true if the current page has a given link.
    * Throws an exception if there is no anchor tags available.
    *
    * @value The value to search for in the link.
    * @url Optional. The url to search for in the link. Default: ''.
    *
    * @throws TestBox.AssertionFailed
    * @return boolean
    */
    private boolean function hasLink(required string value, string url = '') {
        var anchorTags = getParsedPage().select('a');

        expect(anchorTags).notToBeEmpty('No links found on the page.');

        // First try to find the link by selector
        var linksWithTextAndUrl = anchorTags.select('#arguments.value#');

        // If we didn't find any by selector, try by text
        if (ArrayIsEmpty(linksWithTextAndUrl)) {
            linksWithTextAndUrl = anchorTags.select(':contains(#arguments.value#)');
        }

        if (arguments.url != '') {
            linksWithTextAndUrl = anchorTags.select('[href="#arguments.url#"]');
        }

        return ! ArrayIsEmpty(linksWithTextAndUrl);
    }


    /**************************** Debug Methods ******************************/


    /**
    * Pipes the html of the page to the debug() output
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function debugPage() {
        debug(variables.page.html());

        return this;
    }


    /**************************** Finder Methods ******************************/


    /**
    * Returns the select fields found with a given selector or name.
    * Throws if no select elements are found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    private function findSelectField(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] select field on the page.'
    ) {
        var elements = findElement(arguments.selectorOrName, arguments.errorMessage);

        var selectFields = elements.select('select');

        expect(selectFields).notToBeEmpty(arguments.errorMessage);

        return selectFields;
    }

    /**
    * Returns the checkboxes found with a given selector or name.
    * Throws if no checkboxes are found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    private function findCheckbox(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] checkbox on the page.'
    ) {
        var fields = findElement(arguments.selectorOrName, arguments.errorMessage);

        // Filter down to checkboxes
        var checkboxes = fields.select('[type=checkbox]');

        expect(checkboxes).notToBeEmpty(arguments.errorMessage);

        return checkboxes;
    }

    /**
    * Returns the input or textarea fields found with a given selector or name.
    * Throws if no input or textarea elements are found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    private function findField(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] input or textarea on the page.'
    ) {
        var elements = findElement(arguments.selectorOrName, arguments.errorMessage);

        // Filter down to elements that are inputs or textareas
        var fields = elements.select('input, textarea');

        expect(fields).notToBeEmpty(arguments.errorMessage);

        return fields;
    }

    /**
    * Returns the elements found with a given selector or name.
    * Throws if no elements are found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    public function findElement(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] element on the page.'
    ) {
        // First try to find the field by selector
        var elements = getParsedPage().select('#arguments.selectorOrName#');

        // If we couldn't find it by selector, try by name
        if (ArrayIsEmpty(elements)) {
            elements = getParsedPage().select('[name=#arguments.selectorOrName#]');
        }

        expect(elements).notToBeEmpty(arguments.errorMessage);

        return elements;
    }

    /**
    * Returns the select fields found with a given selector or name.
    * Throws if the given option is not found in the select field found with the given selector or name.
    *
    * @value The option value or text to find.
    * @selectorOrName The select field selector or name to find the option in.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    public function findOption(
        required string value,
        required string selectorOrName,
        string errorMessage = 'Failed to find an option with value or text [#arguments.value#] in [#arguments.selectorOrName#].'
    ) {
        var selectFields = findSelectField(arguments.selectorOrName, arguments.errorMessage);

        // First try to find the field by value
        var options = selectFields.select('option[value=#arguments.value#]');

        // If we couldn't find it by selector, try by text
        if (ArrayIsEmpty(options)) {
            options = selectFields.select('option:contains(#arguments.value#)');
        }

        expect(options).notToBeEmpty(arguments.errorMessage);

        // If the option does not have a value attribute, return the option text
        return options.val() != '' ? options.val() : options.text();
    }
}