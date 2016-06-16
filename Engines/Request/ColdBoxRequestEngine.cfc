component extends="coldbox.system.testing.BaseTestCase" implements="Integrated.Engines.Request.Contracts.RequestEngine" {

    property name="baseTestCase" type="coldbox.system.testing.BaseTestCase";

    function beforeAll() {
        super.beforeAll();
    }

    function afterAll() {
        super.afterAll();
    }
 
    /**
    * Make a request
    *
    * @method The HTTP method to use for the request.
    * @route Optional. The route to execute. Default: ''.
    * @event Optional. The event to execute. Default: ''.
    * @parameters Optional. A struct of parameters to attach to the request collection (rc) Default: {}.
    *
    * @throws TestBox.AssertionFailed
    * @returns framework event (if any)
    */
    public any function makeRequest(
        required string method,
        string event,
        string route,
        struct parameters = {}
    ) {
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
            if (StructKeyExists(arguments, 'route')) {
                return execute(route = arguments.route, renderResults = true);
            }
            else {
                return execute(event = arguments.event, renderResults = true);   
            }
        }
        catch (HandlerService.EventHandlerNotRegisteredException e) {
            if (StructKeyExists(arguments, 'route')) {
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
    }

}