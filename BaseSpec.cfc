component extends='coldbox.system.testing.BaseTestCase' {

    // The jsoup parser object
    property name='parser';
    // The parsed jsoup document object
    property name='page';
    // The ColdBox event object
    property name='event';
    // The way we last made a request
    property name='requestMethod';
    // The struct of form input values
    property name='inputs' default='{}';

    /**
    * Sets up the needed dependancies for Integrated.
    *
    * @parser Optional. A Jsoup parser. It is provided here so it can be overridden for testing. Default: createObject('java', 'org.jsoup.Jsoup').
    *
    * @returns Integrated.BaseSpec
    */
    function beforeAll(parser = createObject('java', 'org.jsoup.Jsoup')) {
        // Set up the ColdBox BaseTestCase
        super.beforeAll();
        
        // Initialize all component variables
        variables.parser = arguments.parser;
        variables.page = '';
        variables.event = '';
        variables.requestMethod = '';
        variables.inputs = {};

        return this;
    }


    /***************************** Interactions *******************************/


    /**
    * Makes a request to a ColdBox route.
    *
    * @route The ColdBox route to visit, e.g. `/login` or `/posts/4`. Integrated will build the full url based on ColdBox settings (including `index.cfm`, if needed).
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function visit(required string route) {
        return makeRequest(method = 'GET', route = arguments.route);
    }

    /**
    * Makes a request to a ColdBox event.
    *
    * @event The ColdBox event to visit, e.g. `Main.index` or `Posts.4`.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function visitEvent(required string event) {
        return makeRequest(method = 'GET', event = arguments.event);
    }

    /**
    * Clicks on a link in the current page.
    *
    * @selectorOrText A selector of a link or the text of the link to click.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function click(required string link) {
        // First try to find using the argument as a selector
        var anchorTag = getParsedPage().select('#arguments.link#');

        // If there is no value, try to find the link by text
        if (ArrayLen(anchorTag) == 0) {
            anchorTag = getParsedPage().select('a:contains(#arguments.link#)');
        }

        var route = anchorTag.attr('href');

        this.visit(route);

        return this;
    }

    /**
    * Types a value in to a form field.
    *
    * @text The value to type in the form field.
    * @element The element selector or name to type the value in to.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function type(required string text, required string element) {
        return storeInput(arguments.element, arguments.text);
    }

    /**
    * Checks a checkbox.
    *
    * @element The selector or name of the checkbox to check.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function check(required string element) {
        return storeInput(arguments.element, true);
    }

    /**
    * Unchecks a checkbox.
    *
    * @element The selector or name of the checkbox to uncheck.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function uncheck(required string element) {
        return storeInput(arguments.element, false);
    }

    /**
    * Selects a given option in a given select field.
    *
    * @option The value or text to select.
    * @element The selector or name to choose the option in.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function select(required string option, required string element) {
        var value = findOption(arguments.option, arguments.element);

        return storeInput(arguments.element, value);
    }

    /**
    * Press a submit button.
    *
    * @button The selector or name of the button to press.
    * @overrideEvent Optional. The event to run instead of the form's default. Default: ''.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function press(required string button, string overrideEvent = '') {
        return this.submitForm(
            button = arguments.button,
            inputs = variables.inputs,
            overrideEvent = arguments.overrideEvent
        );
    }

    /**
    * Submits a form
    *
    * @button The selector or name of the button to press.
    * @inputs Optional. The form values to submit.  If not provided, uses the values stored in Integrated combined with any values on the current page. Default: {}.
    * @overrideEvent Optional. The event to run instead of the form's default. Defeault: ''.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function submitForm(
        required string button,
        struct inputs = {},
        string overrideEvent = ''
    ) {
        // Find the form for this button
        var pageForm = findForm(arguments.button);

        if (StructIsEmpty(arguments.inputs)) {
            // Put the form values from the current page in to the variables.input struct
            extractValuesFromForm(pageForm);

            arguments.inputs = variables.inputs;
        }

        if (arguments.overrideEvent != '') {
            makeRequest(
                method = pageForm.attr('method'),
                event = arguments.overrideEvent,
                parameters = arguments.inputs
            );
        }
        else {
            makeRequest(
                method = pageForm.attr('method'),
                route = parseActionFromForm(pageForm.attr('action')),
                parameters = arguments.inputs
            );
        }

        return this;
    }


    /***************************** Expectations *******************************/


    /**
    * Verifies the route of the current page.
    * This method cannot be used after visiting a page using an event.
    *
    * @route The expected route.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seePageIs(required string route) {
        if (variables.requestMethod == 'visitEvent') {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'You cannot assert the page when you visited using the visitEvent() method. Please use visit() instead.'
            );
        }

        var actualUrl = getEvent().getCurrentRoutedUrl();

        expect(actualUrl).toBe(
            arguments.route,
            "Failed asserting that the url [#actualUrl#] (actual) equalled [#arguments.route#] (expected)."
        );

        return this;
    }

    /**
    * Verifies the title of the current page.
    *
    * @title The expected title.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeTitleIs(required string title) {
        var actualTitle = getParsedPage().title();

        expect(arguments.title).toBe(actualTitle,
            'Failed asserting that [#actualTitle#] (actual) equalled [#arguments.title#] (expected).'
        );

        return this;
    }

    /**
    * Verifies the ColdBox view of the current page.
    *
    * @view The expected view.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeViewIs(required string view) {
        var actualView = getEvent().getCurrentView();
        expect(actualView).toBe(
            arguments.view,
            'Failed asserting that view [#actualView#] (actual) equalled [#arguments.view#] (expected).'
        );

        return this;
    }

    /**
    * Verifies the ColdBox handler of the current page.
    *
    * @handler The expected handler.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeHandlerIs(required string handler) {
        var actualHandler = getEvent().getCurrentHandler();
        expect(actualHandler).toBe(
            arguments.handler,
            'Failed asserting that handler [#actualHandler#] (actual) equalled [#arguments.handler#] (expected).'
        );

        return this;
    }

    /**
    * Verifies the ColdBox action of the current page.
    *
    * @action The expected action.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeActionIs(required string action) {
        var actualAction = getEvent().getCurrentAction();
        expect(actualAction).toBe(
            arguments.action,
            'Failed asserting that action [#actualAction#] (actual) equalled [#arguments.action#] (expected).'
        );

        return this;
    }

    /**
    * Verifies the ColdBox event of the current page.
    *
    * @event The expected event.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeEventIs(required string event) {
        var actualEvent = getEvent().getCurrentEvent();
        expect(actualEvent).toBe(
            arguments.event,
            'Failed asserting that event [#actualEvent#] (actual) equalled [#arguments.event#] (expected).'
        );

        return this;
    }

    /**
    * Verifies that the given text exists in any element on the current page.
    *
    * @text The expected text.
    * @negate Optional. If true, throw an exception if the text IS found on the current page. Default: false.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function see(required string text, boolean negate = false) {
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
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function dontSee(required string text) {
        return this.see(text = arguments.text, negate = true);
    }

    /**
    * Verifies that the given element contains the given text on the current page.
    *
    * @element The provided element.
    * @text The expected text.
    * @negate Optional. If true, throw an exception if the element DOES contain the given text on the current page. Default: false.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeInElement(
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
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function dontSeeInElement(
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
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeLink(required string text, string url = '') {
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
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function dontSeeLink(required string text, string url = '') {
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
    * @text The expected value of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeInField(required string element, required string value, boolean negate = false) {
        var inputs = findField(arguments.element);

        var inputsWithValue = inputs.select('[value=#arguments.value#');

        if (!negate) {
            expect(ArrayLen(inputsWithValue)).notToBe(0, 'Failed asserting that [#arguments.value#] appears in a [#arguments.element#] input or textarea on the page.');
        }
        else {
            expect(ArrayLen(inputsWithValue)).toBe(0, 'Failed asserting that [#arguments.value#] does not appear in a [#arguments.element#] input or textarea on the page.');
        }

        return this;
    }

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function dontSeeInField(required string element, required string value) {
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
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeIsChecked(required string element, boolean negate = false) {
        var checkboxes = findCheckbox(arguments.element);

        var checkedCheckboxes = checkboxes.select('[checked]');

        if (!negate) {
            expect(ArrayLen(checkedCheckboxes)).notToBe(
                0,
                'Failed asserting that [#arguments.element#] is checked on the page.'
            );
        }
        else {
            expect(ArrayLen(checkedCheckboxes)).toBe(
                0,
                'Failed asserting that [#arguments.element#] is not checked on the page.'
            );
        }

        return this;
    }

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    *
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function dontSeeIsChecked(required string element) {
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
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function seeIsSelected(required string element, required string value, boolean negate = false) {
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
    * @returns Integrated.BaseSpec
    */
    public BaseSpec function dontSeeIsSelected(required string element, required string value) {
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
    * @returns org.jsoup.nodes.Document
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
    * Retrives the last ColdBox request context (event) ran.
    * Throws an exception if there is no event available.
    *
    * @throws TestBox.AssertionFailed
    * @returns coldbox.system.web.context.RequestContext
    */
    private function getEvent() {
        if (IsSimpleValue(variables.event)) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Cannot make assertions until you visit a page.  Make sure to run visit() or visitEvent() first.'
            );
        }

        return variables.event;
    }

    /**
    * Returns true if the current page has a given link.
    * Throws an exception if there is no anchor tags available.
    *
    * @throws TestBox.AssertionFailed
    * @returns boolean
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
    * Parses an html string.
    * If an empty string is passed in, the current page is set to an empty string instead of parsing the page.
    */
    private function parse(htmlString) {
        if (arguments.htmlString == '') {
            variables.page = arguments.htmlString;
            return;
        }

        variables.page = variables.parser.parse(htmlString);

        return;
    }

    /**
    * Returns the html string from a ColdBox `execute()` call.
    *
    * @returns string
    */
    private string function getHTML(event) {
        var rc = event.getCollection();

        if (StructKeyExists(rc, 'cbox_rendered_content')) {
            return rc.cbox_rendered_content;
        }

        return '';
    }

    /**
    * Stores a value in an in-memory input struct with the element name as the key.
    *
    * @element The selector or name of an form field.
    * @value The value to store in-memory.
    * @overwrite Optional. Specifies whether to overwrite any existing in-memory input values.  Default: true.
    *
    * @returns Integrated.BaseSpec
    */
    private BaseSpec function storeInput(
        required string element,
        required string value,
        boolean overwrite = true
    ) {
        // First verify that the given element exists
        findElement(arguments.element);

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
    * Returns a normalized key name for a form field selector or name.
    * Removes pound signs (#) from selectors.
    *
    * @element The selector or name of an form field.
    *
    * @returns string
    */
    private string function generateInputKey(required string element) {
        return replace(arguments.element, '##', '', 'all');
    }

    /**
    * Store values found in the parsed form in the in-memory input struct.
    *
    * @pageForm org.jsoup.nodes.Element The form jsoup node.
    *
    * @returns string
    */
    private void function extractValuesFromForm(required pageForm) {
        var inputs = pageForm.select('[name]');

        for (var input in inputs) {
            storeInput(
                element = input.attr('name'),
                value = input.val(),
                overwrite = false
            );
        }

        return;
    }

    /**
    * Returns the route portion of a form action.
    * Removes the SESBaseUrl from the form action.
    *
    * @action The form action attribute
    *
    * @returns string
    */
    private string function parseActionFromForm(required string action) {
        var baseUrl = controller.getSetting('SESBaseUrl');

        return replace(arguments.action, baseUrl, '');
    }

    /**
    * Makes a request internally through ColdBox using `execute()`.
    * Either a route or an event must be passed in.
    *
    * @method The HTTP method to use for the request.
    * @route Optional. The ColdBox route to execute.
    * @event Optional. The ColdBox event to execute.
    * @parameters Optional. A struct of parameters to attach to the request.  The parameters are attached to ColdBox's RequestContext collection.
    *
    * @throws TestBox.AssertionFailed
    * @returns Integrated.BaseSpec
    */
    private BaseSpec function makeRequest(
        required string method,
        string route,
        string event,
        struct parameters = {}
    ) {
        // Make sure the method is always all caps
        arguments.method = UCase(arguments.method);

        // Must pass in a route or an event.
        if (!IsDefined('arguments.route') && !IsDefined('arguments.event')) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Must pass either a route or an event to the makeRequest() method.'
            );
        }

        // Clear out the requestMethod in case the call fails
        variables.requestMethod = '';

        // Setup a new ColdBox request
        setup();

        // cache the request context
        local.event = getRequestContext();

        // Set the parameters to the RequestContext collection
        for (var key in arguments.parameters) {
            local.event.setValue(key, arguments.parameters[key]);
        }

        // Only mock the HTTP method if needed
        if (arguments.method != 'GET' && arguments.method != 'POST') {
            // Prepare a request context mock
            var eventMock = prepareMock(local.event);
            // Set the HTTP Method
            eventMock.$("getHTTPMethod", arguments.method);
        }

        try {
            if (IsDefined('arguments.route')) {
                variables.event = execute(route = arguments.route, renderResults = true);
            }
            else {
                variables.event = execute(event = arguments.event, renderResults = true);   
            }
        }
        catch (HandlerService.EventHandlerNotRegisteredException e) {
            if (IsDefined('arguments.route')) {
                throw(
                    type = 'TestBox.AssertionFailed',
                    message = 'Could not find any route called [#arguments.route#].',
                    detail = e.message
                );
            }
            else {
                throw(
                    type = 'TestBox.AssertionFailed',
                    message = 'Could not find any event called [#arguments.event#].',
                    detail = e.message
                );
            }
        }

        // Clear out the inputs for the next request.
        variables.inputs = {};

        // Set the requestMethod now that we've finished the request.
        if (IsDefined('arguments.route')) {
            variables.requestMethod = 'visit';
        }
        else {
            variables.requestMethod = 'visitEvent';   
        }

        // Parse the html and set it to the current page
        var html = getHTML(variables.event);
        parse(html);

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
    * @returns org.jsoup.select.Elements
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
    * @returns org.jsoup.select.Elements
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
    * @returns org.jsoup.select.Elements
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
    * @returns org.jsoup.select.Elements
    */
    private function findElement(
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
    *
    * @throws TestBox.AssertionFailed
    * @returns org.jsoup.select.Elements
    */
    private function findOption(
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

    /**
    * Finds a form on the current page.
    * If a button selector or text is provided, only find the form for the given button.
    * Throws if no form is found with a button with the given selector or text.
    * Throws if no button selector or text is provided and no form is found on the entire page.
    *
    * @selectorOrText The selector or text of a submit button.
    *
    * @throws TestBox.AssertionFailed
    * @returns org.jsoup.select.Elements
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

}
