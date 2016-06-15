component extends='tests.specs.unit.Engines.Assertion.Contracts.FrameworkAssertionEngineTest' {
    function getCUT() {
        return new Integrated.Engines.Assertion.ColdBoxAssertionEngine();
    }

    function setUpEvent() {
        var mockEvent = getMockBox().createMock('coldbox.system.web.context.RequestContext');
        variables.rc = { email = 'john@example.com' };
        variables.prc = { birthday = '01/01/1980' };
        mockEvent.$('getCollection').$args(private = false).$results(rc);
        mockEvent.$('getCollection').$args(private = true).$results(prc);

        return mockEvent;
    }
}