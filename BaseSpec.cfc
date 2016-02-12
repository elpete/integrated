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

    function beforeAll(parser = createObject('java', 'org.jsoup.Jsoup')) {
        // Set up the ColdBox BaseTestCase
        super.beforeAll();
        
        // Set up the jsoup parser.  It is passed in as an argument to allow for mocking.
        variables.parser = arguments.parser;
        variables.page = '';
        variables.event = '';
        variables.requestMethod = '';
        variables.inputs = {};

        return this;
    }

    /***************************** Interactions *******************************/

    public BaseSpec function visit(required string route) {
        return this.makeRequest(method = 'GET', route = arguments.route);
    }

    public BaseSpec function visitEvent(required string event) {
        return this.makeRequest(method = 'GET', event = arguments.event);
    }

    public BaseSpec function click(required string name) {
        // verify that the link exists
        this.seeLink(arguments.name);

        // First try to find using the argument as a selector
        var anchorTag = getParsedPage().select('#arguments.name#');

        // If there is no value, try to find the link by text
        if (ArrayLen(anchorTag) == 0) {
            anchorTag = getParsedPage().select('a:contains(#arguments.name#)');
        }

        var route = anchorTag.attr('href');

        this.visit(route);

        return this;
    }

    public BaseSpec function type(required string text, required string element) {
        return this.storeInput(arguments.element, arguments.text);
    }

    public BaseSpec function check(required string element) {
        return this.storeInput(arguments.element, true);
    }

    public BaseSpec function uncheck(required string element) {
        return this.storeInput(arguments.element, false);
    }

    public BaseSpec function select(required string option, required string element) {
        var value = this.findOptionValue(arguments.option);

        return this.storeInput(arguments.element, value);
    }

    public BaseSpec function press(required string buttonSelectorOrText) {
        return this.submitForm(arguments.buttonSelectorOrText, variables.inputs);
    }

    public BaseSpec function submitForm(required string buttonSelectorOrText, struct inputs = {}) {
        var pageForm = this.findForm(arguments.buttonSelectorOrText);

        // Put the form values in to the variables.input struct        
        this.extractValuesFromForm(pageForm);

        this.makeRequest(
            method = pageForm.attr('method'),
            route = this.parseActionFromForm(pageForm.attr('action')),
            parameters = variables.inputs
        );

        return this;
    }

    /***************************** Expectations *******************************/

    public BaseSpec function seePageIs(required string expectedUrl) {
        if (variables.requestMethod == 'visitEvent') {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'You cannot assert the page when you visited using the visitEvent() method. Please use visit() instead.'
            );
        }

        var actualUrl = getEvent().getCurrentRoutedUrl();

        expect(actualUrl).toBe(
            arguments.expectedUrl,
            "Failed asserting that the url [#actualUrl#] (actual) equalled [#arguments.expectedUrl#] (expected)."
        );

        return this;
    }

    public BaseSpec function seeTitleIs(required string expectedTitle) {
        var actualTitle = getParsedPage().title();

        expect(arguments.expectedTitle).toBe(actualTitle,
            'Failed asserting that [#actualTitle#] (actual) equalled [#arguments.expectedTitle#] (expected).'
        );

        return this;
    }

    public BaseSpec function seeViewIs(required string expectedView) {
        var actualView = getEvent().getCurrentView();
        expect(actualView).toBe(
            arguments.expectedView,
            'Failed asserting that view [#actualView#] (actual) equalled [#arguments.expectedView#] (expected).'
        );

        return this;
    }

    public BaseSpec function seeHandlerIs(required string expectedHandler) {
        var actualHandler = getEvent().getCurrentHandler();
        expect(actualHandler).toBe(
            arguments.expectedHandler,
            'Failed asserting that handler [#actualHandler#] (actual) equalled [#arguments.expectedHandler#] (expected).'
        );

        return this;
    }

    public BaseSpec function seeActionIs(required string expectedAction) {
        var actualAction = getEvent().getCurrentAction();
        expect(actualAction).toBe(
            arguments.expectedAction,
            'Failed asserting that action [#actualAction#] (actual) equalled [#arguments.expectedAction#] (expected).'
        );

        return this;
    }

    public BaseSpec function seeEventIs(required string expectedEvent) {
        var actualEvent = getEvent().getCurrentEvent();
        expect(actualEvent).toBe(
            arguments.expectedEvent,
            'Failed asserting that event [#actualEvent#] (actual) equalled [#arguments.expectedEvent#] (expected).'
        );

        return this;
    }

    public BaseSpec function see(required string text, boolean negate = false) {
        var elems = getParsedPage().select('*:contains(#arguments.text#)');

        if (!negate) {
            expect(ArrayLen(elems)).notToBe(0, 'Failed asserting that [#arguments.text#] was found on the page.');
        }
        else {
            expect(ArrayLen(elems)).toBe(0, 'Failed asserting that [#arguments.text#] was not found on the page.');
        }

        return this;
    }

    public BaseSpec function dontSee(required string text) {
        return this.see(text = arguments.text, negate = true);
    }

    public BaseSpec function seeInElement(
        required string element,
        required string text,
        boolean negate = false
    ) {
        var elems = getParsedPage().select('#arguments.element#');

        if (ArrayLen(elems) == 0) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Element [#arguments.element#] does not exist on the page.'
            );
        }

        var elemsWithText = elems.select(':contains(#arguments.text#)');

        if (!negate) {
            expect(ArrayLen(elemsWithText)).notToBe(0, 'Failed asserting that [#arguments.text#] appears in a [#arguments.element#] on the page.');
        }
        else {
            expect(ArrayLen(elemsWithText)).toBe(0, 'Failed asserting that [#arguments.text#] did not appear in a [#arguments.element#] on the page.');
        }

        return this;
    }

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

    public BaseSpec function seeLink(required string text, string url = '') {
        var errorMessage = 'No links were found matching the pattern [#arguments.text#]';

        if (arguments.url != '') {
            errorMessage &= ' and URL [#arguments.url#]';
        }

        errorMessage &= '.';

        expect(this.hasLink(arguments.text, arguments.url)).toBeTrue(errorMessage);

        return this;
    }

    public BaseSpec function dontSeeLink(required string text, string url = '') {
        var errorMessage = 'A link was found with expected text [#arguments.text#]';

        if (arguments.url != '') {
            errorMessage &= ' and URL [#arguments.url#]';
        }

        errorMessage &= '.';

        expect(this.hasLink(arguments.text, arguments.url)).toBeFalse(errorMessage);

        return this;
    }

    public BaseSpec function seeInField(required string selector, required string text, boolean negate = false) {
        var inputs = this.findFieldBySelectorOrName(arguments.selector);

        var inputsWithValue = inputs.select('[value=#arguments.text#');

        if (!negate) {
            expect(ArrayLen(inputsWithValue)).notToBe(0, 'Failed asserting that [#arguments.text#] appears in a [#arguments.selector#] input on the page.');
        }
        else {
            expect(ArrayLen(inputsWithValue)).toBe(0, 'Failed asserting that [#arguments.text#] does not appear in a [#arguments.selector#] input on the page.');
        }

        return this;
    }

    public BaseSpec function dontSeeInField(required string selector, required string text) {
        return this.seeInField(
            selector = arguments.selector,
            text = arguments.text,
            negate = true
        );
    }

    public BaseSpec function seeIsChecked(required string selector, boolean negate = false) {
        var checkboxes = this.findCheckboxBySelectorOrName(arguments.selector);

        var checkedCheckboxes = checkboxes.select('[checked]');

        if (!negate) {
            expect(ArrayLen(checkedCheckboxes)).notToBe(
                0,
                'Failed asserting that [#arguments.selector#] is checked on the page.'
            );
        }
        else {
            expect(ArrayLen(checkedCheckboxes)).toBe(
                0,
                'Failed asserting that [#arguments.selector#] is not checked on the page.'
            );
        }

        return this;
    }

    public BaseSpec function dontSeeIsChecked(required string selector) {
        return this.seeIsChecked(
            selector = arguments.selector,
            negate = true
        );
    }

    public BaseSpec function seeIsSelected(required string selector, required string value, boolean negate = false) {
        var selectFields = this.findSelectFieldBySelectorOrName(arguments.selector);

        var selectedOption = selectFields.select('option[selected]');

        expect(selectedOption).notToBeEmpty('Failed to find any selected options in [#arguments.selector#] select field on the page.');

        if (!negate) {
            var isValue = selectedOption.val() == arguments.value || selectedOption.html() == arguments.value;
            expect(isValue).toBeTrue('Failed asserting that [#arguments.value#] is selected in a [#arguments.selector#] input on the page.');
        }
        else {
            var isNotValue = selectedOption.val() != arguments.value && selectedOption.html() != arguments.value;
            expect(isNotValue).toBeTrue('Failed asserting that [#arguments.value#] is not selected in a [#arguments.selector#] input on the page.');
        }

        return this;
    }

    public BaseSpec function dontSeeIsSelected(required string selector, required string value) {
        return this.seeIsSelected(
            selector = arguments.selector,
            value = arguments.value,
            negate = true
        );
    }



    /**************************** Helper Methods ******************************/

    private function getParsedPage() {
        if (IsSimpleValue(variables.page)) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Cannot make assertions until you visit a page.  Make sure to run visit() or visitEvent() first.'
            );
        }

        return variables.page;
    }

    private function getEvent() {
        if (IsSimpleValue(variables.event)) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Cannot make assertions until you visit a page.  Make sure to run visit() or visitEvent() first.'
            );
        }

        return variables.event;
    }

    private boolean function hasLink(required string value, string url = '') {
        var anchorTags = getParsedPage().select('a');

        if (ArrayLen(anchorTags) == 0) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'No links found on the page.'
            );
        }

        // First try to find the link by selector
        var linksWithTextAndUrl = anchorTags.select('#arguments.value#');

        // If we didn't find any by selector, try by text
        if (ArrayLen(linksWithTextAndUrl) == 0) {
            linksWithTextAndUrl = anchorTags.select(':contains(#arguments.value#)');
        }

        if (arguments.url != '') {
            linksWithTextAndUrl = anchorTags.select('[href="#arguments.url#"]');
        }

        return ArrayLen(linksWithTextAndUrl) > 0;
    }

    private function parse(htmlString) {
        if (arguments.htmlString == '') {
            variables.page = arguments.htmlString;
            return;
        }

        variables.page = variables.parser.parse(htmlString);

        return;
    }

    private string function getHTML(event) {
        var rc = event.getCollection();

        if (StructKeyExists(rc, 'cbox_rendered_content')) {
            return rc.cbox_rendered_content;
        }

        return '';
    }

    private BaseSpec function storeInput(required string element, required string value, boolean overwrite = true) {
        this.findElementBySelectorOrName(arguments.element);

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

    private string function generateInputKey(required string element) {
        return replace(arguments.element, '##', '', 'all');
    }

    private void function extractValuesFromForm(required pageForm) {
        var inputs = pageForm.select('[name]');

        for (var input in inputs) {
            this.storeInput(
                element = input.attr('name'),
                value = input.val(),
                overwrite = false
            );
        }

        return;
    }

    private string function parseActionFromForm(required string action) {
        var baseUrl = controller.getSetting('SESBaseUrl');

        return replace(arguments.action, baseUrl, '');
    }

    private function makeRequest(required string method, string route, string event, struct parameters = {}) {
        if (!IsDefined('arguments.route') && !IsDefined('arguments.event')) {
            throw(message = 'Must pass either a route or an event to the makeRequest() method.');
        }

        // Clear out the requestMethod in case the call fails
        variables.requestMethod = '';

        // Setup a new ColdBox request
        setup();
        // Prepare a request context mock
        var eventMock = prepareMock(getRequestContext());
        // Set the HTTP Method
        eventMock.$("getHTTPMethod", arguments.method);
        // Set the parameters to the form or url scope
        for (var key in arguments.parameters) {
            eventMock.setValue(key, arguments.parameters[key]);
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

        variables.inputs = {};

        if (IsDefined('arguments.route')) {
            variables.requestMethod = 'visit';
        }
        else {
            variables.requestMethod = 'visitEvent';   
        }

        variables.page = variables.parser.parse(getHTML(variables.event));

        return this;
    }

    /**************************** Finder Methods ******************************/

    private function findSelectFieldBySelectorOrName(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] select field on the page.'
    ) {
        var elements = this.findElementBySelectorOrName(arguments.selectorOrName, arguments.errorMessage);

        var selectFields = elements.select('select');

        expect(selectFields).notToBeEmpty(arguments.errorMessage);

        return selectFields;
    }

    private function findCheckboxBySelectorOrName(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] checkbox on the page.'
    ) {
        var fields = this.findElementBySelectorOrName(arguments.selectorOrName, arguments.errorMessage);

        // Filter down to checkboxes
        var checkboxes = fields.select('[type=checkbox]');

        expect(checkboxes).notToBeEmpty(arguments.errorMessage);

        return checkboxes;
    }

    private function findFieldBySelectorOrName(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] input on the page.'
    ) {
        var elements = this.findElementBySelectorOrName(arguments.selectorOrName, arguments.errorMessage);

        // Filter down to elements that have values
        var fields = elements.select('[value]');

        expect(fields).notToBeEmpty(arguments.errorMessage);

        return fields;
    }

    private function findElementBySelectorOrName(
        required string selectorOrName,
        string errorMessage = 'Failed to find a [#arguments.selectorOrName#] element on the page.'
    ) {
        // First try to find the field by selector
        var elements = getParsedPage().select('#arguments.selectorOrName#');

        // If we couldn't find it by selector, try by name
        if (ArrayLen(elements) == 0) {
            elements = getParsedPage().select('[name=#arguments.selectorOrName#]');
        }

        expect(elements).notToBeEmpty(arguments.errorMessage);

        return elements;
    }

    private function findOptionValue(required string value) {
        // First try to find the field by value
        var options = getParsedPage().select('option[value=#arguments.value#]');

        // If we couldn't find it by selector, try by text
        if (ArrayLen(options) == 0) {
            options = getParsedPage().select('option:contains(#arguments.value#)');
        }

        expect(options).notToBeEmpty('Failed to find an option with value or text [#arguments.value#].');

        return options.val();
    }

    private function findForm(string buttonSelectorOrText = '') {
        if (buttonSelectorOrText != '') {
            var pageForm = getParsedPage().select('form:has(button#arguments.buttonSelectorOrText#)');

            if (ArrayLen(pageForm) == 0) {
                pageForm = getParsedPage().select('form:has(button:contains(#arguments.buttonSelectorOrText#))');
            }

            expect(pageForm).notToBeEmpty('Failed to find a form with a button [#arguments.buttonSelectorOrText#].');

            return pageForm;
        }

        var pageForm = getParsedPage().select('form');

        expect(pageForm).notToBeEmpty('Failed to find a form with a button [#arguments.buttonSelectorOrText#].');

        return pageForm;
    }

}
