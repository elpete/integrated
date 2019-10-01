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
    public string function parseFrameworkRoute( required string url ) {
        var htmlBaseUrl = getController().getSetting( "HTMLBaseUrl" );
        // trim off the ending slash if it exists
        htmlBaseUrl = right(htmlBaseUrl, 1) == "/" ? left( htmlBaseUrl, len( htmlBaseUrl ) - 1 ) : htmlBaseUrl;
        var SESBaseUrl = getController().getSetting( "SESBaseUrl" );

        if ( left( arguments.url, 1 ) == "/" ) {
            arguments.url = htmlBaseUrl & arguments.url;
        }

        arguments.url = replaceNoCase( arguments.url, SESBaseUrl, "" );

        // if there is still http(s) on the front of the string, get rid of it.
        arguments.url = REReplaceNoCase( arguments.url, "^https?:", "/", "ALL" );

        // convert all . to /
        arguments.url = replace( arguments.url, ".", "/", "all" );
        if ( ! len( arguments.url ) ) {
            return "/";
        }

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
            local.method = local.event.getValue( "_method", arguments.method );
            var eventMock = prepareMock(local.event);
            // Set the HTTP Method
            eventMock.$("getHTTPMethod", local.method );
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
