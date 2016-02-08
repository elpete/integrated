component extends="coldbox.system.testing.BaseTestCase" {

    property name="parser";

    function beforeAll(
        parser = ""
    ) {
        variables.parser = createObject('java', 'org.jsoup.Jsoup');

        return this;
    }

    function parse(htmlString) {
        variables.currentPage = variables.parser.parse(htmlString);
    }

    function visitEvent(event) {
        var event = execute(event = arguments.event, renderResults = true);
        var html = getHTML(event);
        variables.currentPage = variables.parser.parse(html);

        return this;
    }

    function seeOnPage(text) {
        var elems = variables.currentPage.select('*:contains(#arguments.text#)')

        return ArrayLen(elems) > 0;
    }

    private function getHTML(event) {
        var rc = event.getCollection();

        if (StructKeyExists(rc, 'cbox_rendered_content')) {
            return rc.cbox_rendered_content;
        }

        return '';
    }
}
