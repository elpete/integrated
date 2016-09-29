import Integrated.Engines.Assertion.Contracts.DOMAssertionEngine;

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
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeTitleIs(required string title);

    /**
    * Verifies that the given text exists in any element on the current page.
    *
    * @text The expected text.
    * @negate Optional. If true, throw an exception if the text IS found on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function see(required string text, boolean caseSensitive, boolean negate);

    /**
    * Verifies that the given text does not exist in any element on the current page.
    *
    * @text The text that should not appear.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSee(required string text, boolean caseSensitive);

    /**
    * Verifies that the given element contains the given text on the current page.
    *
    * @text The expected text.
    * @selectorOrName The provided selector or name to check for the text in.
    * @negate Optional. If true, throw an exception if the element DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeInElement(required string text, required string selectorOrName, boolean negate);

    /**
    * Verifies that the given element does not contain the given text on the current page.
    *
    * @text The text that should not be found.
    * @selectorOrName The provided selector or name to check for the text in.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeInElement(required string text, required string selectorOrName);

    /**
    * Verifies that a link with the given text exists on the current page.
    * Can also take an optional url parameter.  If provided, it verifies the link found has the given url.
    *
    * @text The expected text of the link.
    * @url Optional. The expected url of the link. Default: ''.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeLink(required string text, string url);

    /**
    * Verifies that a link with the given text does not exist on the current page.
    * Can also take an optional url parameter.  If provided, it verifies the link found does not have the given url.
    *
    * @text The text of the link that should not be found.
    * @url Optional. The url that should not be found. Default: ''.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeLink(required string text, string url);

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @value The expected value of the field.
    * @selectorOrName The selector or name of the field.
    * @negate Optional. If true, throw an exception if the field DOES contain the given text on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeInField(required string value, required string selectorOrName, boolean negate);

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @value The value of the field to not find.
    * @selectorOrName The selector or name of the field.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeInField(required string value, required string selectorOrName);

    /**
    * Verifies that a checkbox is checked on the current page.
    *
    * @selectorOrName The selector or name of the checkbox.
    * @negate Optional. If true, throw an exception if the checkbox IS checked on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeIsChecked(required string selectorOrName, boolean negate);

    /**
    * Verifies that a field with the given value exists on the current page.
    *
    * @selectorOrName The selector or name of the field.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeIsChecked(required string selectorOrName);

    /**
    * Verifies that a given selector has a given option selected.
    *
    * @value The value or text of the option that should exist.
    * @selectorOrName The selector or name of the select field.
    * @negate Optional. If true, throw an exception if the option IS selected in the given select field on the current page. Default: false.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeIsSelected(required string value, required string selectorOrName, boolean negate);

    /**
    * Verifies that a given selector does not have a given option selected.
    *
    * @value The value or text of the option that should exist.
    * @selectorOrName The selector or name of the select field.
    *
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeIsSelected(required string value, required string selectorOrName);

    /**
    * Returns the html of the page
    *
    * @return string
    */
    public string function getPage();

    /**
    * Throws if no elements are found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    * @negate Optional. If true, throw an exception if the element DOES exist on the current page. Default: false.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function seeElement(required string selectorOrName, string errorMessage, boolean negate);

    /**
    * Throws if an element is found with the given selector or name.
    *
    * @selectorOrName The selector or name for which to search.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return Integrated.Engines.Assertion.Contracts.DOMAssertionEngine
    */
    public Integrated.Engines.Assertion.Contracts.DOMAssertionEngine function dontSeeElement(required string selectorOrName, string errorMessage);

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
    public function findSelectField(required string selectorOrName, string errorMessage); 

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
    public function findOption(required string value, required string selectorOrName, string errorMessage);

    /**
    * Returns the option value found with a given value or name in a select field with a given selector or name.
    * Throws if the given option is not found in the select field found with the given selector or name.
    *
    * @value The option value or text to find.
    * @selectorOrName The select field selector or name to find the option in.
    * @errorMessage The error message to throw if an assertion fails.
    *
    * @throws TestBox.AssertionFailed
    * @return org.jsoup.select.Elements
    */
    public any function findOptionValue(required string value, required string selectorOrName, string errorMessage);

    /**
    * Finds the href of a link in the current page.
    *
    * @link A selector of a link or the text of the link to find.
    *
    * @return string
    */
    public string function findLinkHref(required string link);

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
    public array function getFormInputs(string selectorOrText);

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
    public string function getFormMethod(string selectorOrText);

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
    public string function getFormAction(string selectorOrText);

}