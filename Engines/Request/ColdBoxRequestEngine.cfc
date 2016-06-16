component extends="coldbox.system.testing.BaseTestCase" implements="Integrated.Engines.Request.Contracts.RequestEngine" {

    /**
    * Set up the request engine
    */
    public void function beforeAll() {
        super.beforeAll();
    }

    /**
    * Clean up the request engine
    */
    public void function afterAll() {
        super.afterAll();
    }

    /**
    * Returns the framework route portion of a url.
    *
    * @url A full url
    *
    * @return string
    */
    public string function parseFrameworkRoute(required string url) {
        var baseUrl = getController().getSetting('SESBaseUrl');

        return replaceNoCase(arguments.url, baseUrl, '');
    }
 
    /**
    * Make a request
    *
    * @method The HTTP method to use for the request.
    * @route Optional. The route to execute. Default: ''.
    * @event Optional. The event to execute. Default: ''.
    * @parameters Optional. A struct of parameters to submit with the request. Default: {}.
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