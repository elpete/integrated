component extends='coldbox.system.testing.BaseTestCase' {

    // The jsoup parser object
    property name='parser';
    // The parsed jsoup document object
    property name='page';
    // The ColdBox event object
    property name='event';
    // The way we last made a request
    property name='requestMethod';

    function beforeAll(parser = createObject('java', 'org.jsoup.Jsoup')) {
        // Set up the ColdBox BaseTestCase
        super.beforeAll();
        
        // Set up the jsoup parser.  It is passed in as an argument to allow for mocking.
        variables.parser = arguments.parser;
        variables.page = '';
        variables.event = '';
        variables.requestMethod = '';

        return this;
    }

    /***************************** Interactions *******************************/

    public BaseSpec function visit(required string route) {
        // Clear out the requestMethod in case the call fails
        variables.requestMethod = '';

        try {
            variables.event = execute(route = arguments.route, renderResults = true);
        }
        catch (HandlerService.EventHandlerNotRegisteredException e) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Could not find any route called [#arguments.route#].',
                detail = e.message
            )
        }

        variables.requestMethod = 'visit';
        variables.page = variables.parser.parse(getHTML(variables.event));

        return this;
    }

    public BaseSpec function visitEvent(required string event) {
        // Clear out the requestMethod in case the call fails
        variables.requestMethod = '';

        try {
            variables.event = execute(event = arguments.event, renderResults = true);
        }
        catch (HandlerService.EventHandlerNotRegisteredException e) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Could not find any event called [#arguments.event#].',
                detail = e.message
            )
        }

        variables.requestMethod = 'visitEvent';
        variables.page = variables.parser.parse(getHTML(variables.event));

        return this;
    }

    public BaseSpec function click(required string name) {
        fail('method not implemented yet');

        return this;
    }

    public BaseSpec function type(required string text, required string element) {
        fail('method not implemented yet');

        return this;
    }

    public BaseSpec function check(required string element) {
        fail('method not implemented yet');

        return this;
    }

    public BaseSpec function uncheck(required string element) {
        fail('method not implemented yet');

        return this;
    }

    public BaseSpec function select(required string option, required string element) {
        fail('method not implemented yet');

        return this;
    }

    public BaseSpec function press(required string buttonText) {
        fail('method not implemented yet');

        return this;
    }

    public BaseSpec function submitForm(required string buttonText, struct inputs = {}) {
        fail('method not implemented yet');

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
        var errorMessage = 'No links were found with expected text [#arguments.text#]';

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
        var inputs = getParsedPage().select('#arguments.selector#[value]');

        if (ArrayLen(inputs) == 0) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Failed to find an [#arguments.selector#] input on the page.'
            );
        }

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
        var checkboxes = getParsedPage().select('#arguments.selector#[type=checkbox]');

        if (ArrayLen(checkboxes) == 0) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Failed to find a [#arguments.selector#] checkbox on the page.'
            );
        }

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
        var selectFields = getParsedPage().select('select#arguments.selector#');

        if (ArrayLen(selectFields) == 0) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Failed to find a [#arguments.selector#] select field on the page.'
            );
        }

        var selectedOption = selectFields.select('option[selected]');

        expect(ArrayLen(selectedOption)).notToBe(
            0,
            'Failed to find any selected options in [#arguments.selector#] select field on the page.'
        );

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

    private boolean function hasLink(required string text, string url = '') {
        var anchorTags = getParsedPage().select('a');

        if (ArrayLen(anchorTags) == 0) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'No links found on the page.'
            );
        }

        var linksWithTextAndUrl = anchorTags.select(':contains(#arguments.text#)');

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

    private function getHTML(event) {
        var rc = event.getCollection();

        if (StructKeyExists(rc, 'cbox_rendered_content')) {
            return rc.cbox_rendered_content;
        }

        return '';
    }
}
