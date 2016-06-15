interface displayname="DOMAssertionEngine" {

    /**
    * Parses an html string.
    * If an empty string is passed in, the current page is set to an empty string instead of parsing the page.
    *
    * @htmlString The html string to parse.
    */
    public void function parse(required string htmlString);

    /**
    * Verifies the title of the current page.
    *
    * @title The expected title.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeTitleIs(required string title);

    /**
    * Verifies that the given text exists in any element on the current page.
    *
    * @text The expected text.
    * @negate Optional. If true, throw an exception if the text IS found on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function see(required string text, boolean negate);

    /**
    * Verifies that the given text does not exist in any element on the current page.
    *
    * @text The text that should not appear.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSee(required string text);

    /**
    * Verifies that the given element contains the given text on the current page.
    *
    * @element The provided element.
    * @text The expected text.
    * @negate Optional. If true, throw an exception if the element DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeInElement(required string element, required string text, boolean negate);

    /**
    * Verifies that the given element does not contain the given text on the current page.
    *
    * @element The provided element.
    * @text The text that should not be found.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeInElement(required string element, required string text);

    /**
    * Verifies that a link with the given text exists on the current page.
    * Can also take an optional url parameter.  If provided, it verifies the link found has the given url.
    *
    * @text The expected text of the link.
    * @url Optional. The expected url of the link. Default: ''.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeLink(required string text, string url);

    /**
    * Verifies that a link with the given text does not exist on the current page.
    * Can also take an optional url parameter.  If provided, it verifies the link found does not have the given url.
    *
    * @text The text of the link that should not be found.
    * @url Optional. The url that should not be found. Default: ''.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeLink(required string text, string url);

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    * @value The expected value of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeInField(required string element, required string value, boolean negate);

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    * @value The value of the field to not find.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeInField(required string element, required string value);

    /**
    * Verifies that a checkbox is checked on the current page.
    *
    * @element The selector or name of the checkbox.
    * @negate Optional. If true, throw an exception if the checkbox IS checked on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeIsChecked(required string element, boolean negate = false);

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @element The selector or name of the field.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeIsChecked(required string element);

    /**
    * Verifies that a given selector has a given option selected.
    *
    * @element The selector or name of the select field.
    * @value The value or text of the option that should exist.
    * @negate Optional. If true, throw an exception if the option IS selected in the given select field on the current page. Default: false.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function seeIsSelected(required string element, required string value, boolean negate);

    /**
    * Verifies that a given selector does not have a given option selected.
    *
    * @element The selector or name of the select field.
    * @value The value or text of the option that should exist.
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function dontSeeIsSelected(required string element, required string value);

    /**
    * Pipes the html of the page to the debug() output
    *
    * @return Integrated.Engines.DOMAssertionEngine
    */
    public DOMAssertionEngine function debugPage();
}