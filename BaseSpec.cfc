component extends="coldbox.system.testing.BaseTestCase" {

    property name="parser";
    property name="currentPage";

    function beforeAll(parser = createObject('java', 'org.jsoup.Jsoup')) {
        variables.parser = arguments.parser;

        return this;
    }

    /***************************** Interactions *******************************/

    public BaseSpec function visit(required string uri) {
        // Coming soon....
        // var event = execute(url = arguments.url, renderResults = true);

        return this;
    }

    public BaseSpec function visitEvent(required string event) {
        var event = execute(event = arguments.event, renderResults = true);
        var html = getHTML(event);
        variables.currentPage = variables.parser.parse(html);

        return this;
    }

    public BaseSpec function click(required string name) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function type(required string text, required string element) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function check(required string element) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function uncheck(required string element) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function select(required string option, required string element) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function press(required string buttonText) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function submitForm(required string buttonText, struct inputs = {}) {
        debug("Method not implemented yet");

        return this;
    }

    /***************************** Expectations *******************************/

    public BaseSpec function seePageIs() {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function seeTitleIs() {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function see(required string text, boolean negate = false) {
        var elems = variables.currentPage.select('*:contains(#arguments.text#)')

        if (negate) {
            expect(ArrayLen(elems)).toBe(0);
        }
        else {
            expect(ArrayLen(elems)).toNotBe(0);
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
        debug("Method not implemented yet");

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

        expect(this.hasLink(arguments.text, arguments.url)).toBeTrue(errorMessage);

        return this;
    }

    public BaseSpec function dontSeeLink(required string text, string url = '') {
        var errorMessage = 'A link was found with expected text [#arguments.text#]';

        if (arguments.url != '') {
            errorMessage &= ' and URL [#arguments.url#]';
        }

        expect(this.hasLink(arguments.text, arguments.url)).toBeFalse(errorMessage);

        return this;
    }

    public BaseSpec function seeInField(required string selector, required string expected) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function dontSeeInField(required string selector, required string value) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function seeIsChecked(required string selector) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function dontSeeIsChecked(required string selector) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function seeIsSelected(required string selector, required string expected) {
        debug("Method not implemented yet");

        return this;
    }

    public BaseSpec function dontSeeIsSelected(required string selector, required string value) {
        debug("Method not implemented yet");

        return this;
    }



    /**************************** Helper Methods ******************************/

    private boolean function hasLink(required string text, string url = '') {
        debug("Method not implemented yet");

        return true;
    }

    private function parse(htmlString) {
        variables.currentPage = variables.parser.parse(htmlString);
    }

    private function getHTML(event) {
        var rc = event.getCollection();

        if (StructKeyExists(rc, 'cbox_rendered_content')) {
            return rc.cbox_rendered_content;
        }

        return '';
    }
}
