interface displayname="FrameworkAssertionEngine" {
    public FrameworkAssertionEngine function setEvent(required event);
    public FrameworkAssertionEngine function seePageIs(required string route);
    public FrameworkAssertionEngine function seeViewIs(required string view);
    public FrameworkAssertionEngine function seeHandlerIs(required string handler);
    public FrameworkAssertionEngine function seeActionIs(required string action);
    public FrameworkAssertionEngine function seeEventIs(required string event);
    public FrameworkAssertionEngine function seeInCollection(required string key, string value, boolean private, boolean negate);
    public FrameworkAssertionEngine function dontSeeInCollection(required string key, string value, boolean private);
}