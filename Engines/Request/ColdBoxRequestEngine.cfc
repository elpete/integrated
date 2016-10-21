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
        var htmlBaseUrl = getController().getSetting('HTMLBaseUrl');
        var SESBaseUrl = getController().getSetting('SESBaseUrl');

        if ( left( arguments.url, 1 ) == "/" ) {
            arguments.url = left( htmlBaseUrl, len( htmlBaseUrl ) - 1) & arguments.url;
        }

        arguments.url = replaceNoCase( arguments.url, SESBaseUrl, '' );
        // convert all . to /
        arguments.url = replace( arguments.url, ".", "/", "all" );

        return arguments.url;
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
            var value = arguments.parameters[ key ];
            value = isArray( value ) ? ArrayToList( value ) : value;
            local.event.setValue(key, value);
        }

        // Only mock the HTTP method if needed
        if (arguments.method != 'GET') {
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
                    message = e.message
                );
            }
            else {
                throw(
                    type = 'TestBox.AssertionFailed',
                    message = e.message
                );
            }
        }
    }

}
