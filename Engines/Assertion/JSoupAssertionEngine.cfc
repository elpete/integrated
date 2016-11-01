import Integrated.Engines.Assertion.Contracts.DOMAssertionEngine;

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
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function init(
        jsoup = createObject( "java", "org.jsoup.Jsoup" )
    ) {
        variables.jsoup = arguments.jsoup;

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
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeTitleIs(required string title) {
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
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function see(required string text, boolean caseSensitive = true, boolean negate = false) {

        if ( caseSensitive ) {
            var elems = getParsedPage().select('*:matchesOwn(#arguments.text#)');
        }
        else {
            var elems = getParsedPage().select('*:containsOwn(#arguments.text#)');   
        }

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
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSee(required string text, boolean caseSensitive = true) {
        arguments.negate = true;
        return this.see(argumentCollection = arguments);
    }

    /**
    * Verifies that the given element contains the given text on the current page.
    *
    * @text The expected text.
    * @selectorOrName The provided selector or name to check for the text in.
    * @negate Optional. If true, throw an exception if the element DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeInElement(
        required string text,
        required string selectorOrName,
        boolean negate = false
    ) {
        var elems = findElement(arguments.selectorOrName);

        var elemsWithText = elems.select(':contains(#arguments.text#)');

        if (!negate) {
            expect(elemsWithText).notToBeEmpty('Failed asserting that [#arguments.text#] appears in a [#arguments.selectorOrName#] on the page.');
        }
        else {
            expect(elemsWithText).toBeEmpty('Failed asserting that [#arguments.text#] did not appear in a [#arguments.selectorOrName#] on the page.');
        }

        return this;
    }

    /**
    * Verifies that the given element does not contain the given text on the current page.
    *
    * @text The text that should not be found.
    * @selectorOrName The provided selector or name to check for the text in.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeInElement(
        required string text,
        required string selectorOrName
    ) {
        return this.seeInElement(
            selectorOrName = arguments.selectorOrName,
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
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeLink(required string text, string url = '') {
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
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeLink(required string text, string url = '') {
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
    * @value The expected value of the field.
    * @selectorOrName The selector or name of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeInField(required string value, required string selectorOrName, boolean negate = false) {
        var inputs = findField(arguments.selectorOrName);

        var inputsWithValue = inputs.select('[value=#arguments.value#');

        if (!negate) {
            expect(inputsWithValue).notToBeEmpty('Failed asserting that [#arguments.value#] appears in a [#arguments.selectorOrName#] input or textarea on the page.');
        }
        else {
            expect(inputsWithValue).toBeEmpty('Failed asserting that [#arguments.value#] does not appear in a [#arguments.selectorOrName#] input or textarea on the page.');
        }

        return this;
    }

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @value The value of the field to not find.
    * @selectorOrName The selector or name of the field.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeInField(required string value, required string selectorOrName) {
        return this.seeInField(
            selectorOrName = arguments.selectorOrName,
            value = arguments.value,
            negate = true
        );
    }

    /**
    * Verifies that a checkbox is checked on the current page.
    *
    * @selectorOrName The selector or name of the checkbox.
    * @negate Optional. If true, throw an exception if the checkbox IS checked on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeIsChecked(required string selectorOrName, boolean negate = false) {
        var checkboxes = findCheckbox(arguments.selectorOrName);

        var checkedCheckboxes = checkboxes.select('[checked]');

        if (!negate) {
            expect(checkedCheckboxes).notToBeEmpty('Failed asserting that [#arguments.selectorOrName#] is checked on the page.');
        }
        else {
            expect(checkedCheckboxes).toBeEmpty('Failed asserting that [#arguments.selectorOrName#] is not checked on the page.');
        }

        return this;
    }

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @selectorOrName The selector or name of the field.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeIsChecked(required string selectorOrName) {
        return this.seeIsChecked(
            selectorOrName = arguments.selectorOrName,
            negate = true
        );
    }

    /**
    * Verifies that a given selector has a given option selected.
    *
    * @value The value or text of the option that should exist.
    * @selectorOrName The selector or name of the select field.
    * @negate Optional. If true, throw an exception if the option IS selected in the given select field on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeIsSelected(required string value, required string selectorOrName, boolean negate = false) {
        var selectFields = findSelectField(arguments.selectorOrName);

        var selectedOptions = selectFields.select('option[selected]');

        expect(selectedOptions).notToBeEmpty('Failed to find any selected options in [#arguments.selectorOrName#] select field on the page.');

        if (!negate) {
            var isValue = false;
            for ( var option in selectedOptions ) {
                isValue = option.val() == arguments.value || option.html() == arguments.value;
                if ( isValue ) {
                    break;
                }
            }
            expect(isValue).toBeTrue('Failed asserting that [#arguments.value#] is selected in a [#arguments.selectorOrName#] input on the page.');
        }
        else {
            var isNotValue = false;
            for ( var option in selectedOptions ) {
                isNotValue = option.val() != arguments.value && option.html() != arguments.value;
                if ( isNotValue ) {
                    break;
                }
            }
            expect(isNotValue).toBeTrue('Failed asserting that [#arguments.value#] is not selected in a [#arguments.selectorOrName#] input on the page.');
        }

        return this;
    }

    /**
    * Verifies that a given selector does not have a given option selected.
    *
    * @value The value or text of the option that should exist.
    * @selectorOrName The selector or name of the select field.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeIsSelected(required string value, required string selectorOrName) {
        return this.seeIsSelected(
            selectorOrName = arguments.selectorOrName,
            value = arguments.value,
            negate = true
        );
    }

    /**
    * Returns the html of the page
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public string function getPage() {
        return variables.page.html();
    }

    /**
    * Throws if no elements are found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeElement(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] element on the page.',
        boolean negate = false
    ) {
        findElement(argumentCollection = arguments);

        return this;
    }

    /**
    * Throws if an element is found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeElement(
        required string selectorOrName,
        string errorMessage = 'Found a [#arguments.selectorOrName#] element on the page.'
    ) {
        return this.seeElement(
            selectorOrName = arguments.selectorOrName,
            errorMessage = arguments.errorMessage,
            negate = true
        );
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

        return options;
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
    public any function findOptionValue(
        required string value,
        required string selectorOrName,
        string errorMessage = 'Failed to find an option with value or text [#arguments.value#] in [#arguments.selectorOrName#].'
    ) {
        var options = findOption(argumentCollection = arguments);

        // If the option does not have a value attribute, return the option text
        return options.val() != '' ? options.val() : options.text();
    }

    /**
    * Finds the href of a link in the current page.
    *
    * @link A selector of a link or the text of the link to find.
    *
    * @return string
    */
    public string function findLinkHref(required string link) {
        var anchorTag = findLink(argumentCollection = arguments);

        return anchorTag.attr('href');
    }

    /**
    * Finds a form on the current page and returns the inputs as an array.
    *
    * If a button selector or text is provided, only find the form for the given button.
    * Throws if no form is found with a button with the given selector or text.
    * Throws if no button selector or text is provided and no form is found on the entire page.
    *
    * @selectorOrText The selector or text of a submit button.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    public array function getFormInputs(string selectorOrText = '') {
        var pageForm = findForm(argumentCollection  = arguments);
        
        var inputs = pageForm.select('[name]');
        var returnInputs = [];
        for (var input in inputs) {
            // skip all buttons because we only want to include the button we "clicked"
            if ( input.tagName() == "button" ) {
                continue;
            }

            arrayAppend( returnInputs, {
                name = input.attr( "name" ),
                value = input.val()
            } );
        }

        // include the button we clicked in the form inputs if it has a name
        var button = getParsedPage().select('button[name]:contains(#selectorOrText#)');
        if ( ! arrayIsEmpty( button ) ) {
            arrayAppend( returnInputs, {
                name = button.attr( "name" ),
                value = button.val()
            } );
        }

        return returnInputs;
    }

    /**
    * Finds a form on the current page and returns the form method.
    * 
    * If a button selector or text is provided, only find the form for the given button.
    * Throws if no form is found with a button with the given selector or text.
    * Throws if no button selector or text is provided and no form is found on the entire page.
    *
    * @selectorOrText The selector or text of a submit button.
    *
    * @throws TestBox.AssertionFailed
    * @return string
    */
    public string function getFormMethod(string selectorOrText = '') {
        var pageForm = findForm(argumentCollection  = arguments);
        return pageForm.attr( "method" );
    }

    /**
    * Finds a form on the current page and returns the form action.
    *
    * If a button selector or text is provided, only find the form for the given button.
    * Throws if no form is found with a button with the given selector or text.
    * Throws if no button selector or text is provided and no form is found on the entire page.
    *
    * @selectorOrText The selector or text of a submit button.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    public string function getFormAction(string selectorOrText = '') {
        var pageForm = findForm(argumentCollection  = arguments);
        return pageForm.attr( "action" );
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

    /**
    * Finds a link in the current page.
    *
    * @link A selector of a link or the text of the link to find.
    *
    * @return string
    */
    private function findLink(
        required string link,
        string errorMessage = 'Failed to find a [#arguments.link#] link on the page.'
    ) {
        // First try to find using the argument as a selector
        var anchorTag = getParsedPage().select('#arguments.link#');

        // If there is no value, try to find the link by text
        if (ArrayIsEmpty(anchorTag)) {
            anchorTag = getParsedPage().select('a:contains(#arguments.link#)');
        }

        expect(anchorTag).notToBeEmpty(arguments.errorMessage);

        return anchorTag;
    }

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
    public function findSelectField(
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
    * Finds a form on the current page.
    * If a button selector or text is provided, only find the form for the given button.
    * Throws if no form is found with a button with the given selector or text.
    * Throws if no button selector or text is provided and no form is found on the entire page.
    *
    * @selectorOrText The selector or text of a submit button.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    private function findForm(string selectorOrText = '') {
        if (selectorOrText != '') {
            var pageForm = getParsedPage().select('form:has(button#arguments.selectorOrText#)');

            if (ArrayIsEmpty(pageForm)) {
                pageForm = getParsedPage().select('form:has(button:contains(#arguments.selectorOrText#))');
            }

            expect(pageForm).notToBeEmpty('Failed to find a form with a button [#arguments.selectorOrText#].');

            return pageForm;
        }

        var pageForm = getParsedPage().select('form');

        expect(pageForm).notToBeEmpty('Failed to find a form on the current page.');

        return pageForm;
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
    private any function findElement(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] element on the page.',
        boolean negate = false
    ) {
        // First try to find the field by selector
        try {
            var elements = getParsedPage().select('#arguments.selectorOrName#');
        }
        catch ( org.jsoup.select.Selector$SelectorParseException e ) {
            var elements = [];
        }

        // If we couldn't find it by selector, try by name
        if (ArrayIsEmpty(elements)) {
            elements = getParsedPage().select('[name=#arguments.selectorOrName#]');
        }

        if ( ! negate) {
            expect(elements).notToBeEmpty(arguments.errorMessage);
        }
        else {
            expect(elements).toBeEmpty(arguments.errorMessage);
        }

        return elements;
    }

}