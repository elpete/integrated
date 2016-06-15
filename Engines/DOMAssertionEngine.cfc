interface displayname="DOMAssertionEngine" {
    public DOMAssertionEngine function init();
    public DOMAssertionEngine function seeTitleIs(required string title);
    public DOMAssertionEngine function seeEventIs(required string event);
    public DOMAssertionEngine function see(required string text, boolean negate);
    public DOMAssertionEngine function dontSee(required string text);
    public DOMAssertionEngine function seeInElement(required string element, required string text, boolean negate);
    public DOMAssertionEngine function dontSeeInElement(required string element, required string text);
    public DOMAssertionEngine function seeLink(required string text, string url);
    public DOMAssertionEngine function dontSeeLink(required string text, string url);
    public DOMAssertionEngine function seeInField(required string element, required string value, boolean negate);
    public DOMAssertionEngine function dontSeeInField(required string element, required string value);
    public DOMAssertionEngine function seeIsChecked(required string element, boolean negate = false);
    public DOMAssertionEngine function dontSeeIsChecked(required string element);
    public DOMAssertionEngine function seeIsSelected(required string element, required string value, boolean negate);
    public DOMAssertionEngine function dontSeeIsSelected(required string element, required string value);
    public DOMAssertionEngine function debugPage();
}