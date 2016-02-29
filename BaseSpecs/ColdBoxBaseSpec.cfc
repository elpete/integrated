component extends='BaseSpecs.AbstractBaseSpec' {

    property name="baseTestCase" type="coldbox.system.testing.BaseTestCase";

    function beforeAll() {
        super.beforeAll();

        variables.baseTestCase = new coldbox.system.testing.BaseTestCase();
        baseTestCase.beforeAll();
    }

    /**
    * Make a ColdBox specifc request
    *
    * @method The HTTP method to use for the request.
    * @route Optional. The route to execute. Default: ''.
    * @event Optional. The event to execute. Default: ''.
    * @parameters Optional. A struct of parameters to attach to the request collection (rc) Default: {}.
    *
    * @throws TestBox.AssertionFailed
    * @returns coldbox.system.web.context.RequestContext
    */
    public coldbox.system.web.context.RequestContext function makeFrameworkRequest(
        required string method,
        string event,
        string route,
        struct parameters = {}
    ) {
        // Setup a new ColdBox request
        variables.baseTestCase.setup();

        // cache the request context
        local.event = variables.baseTestCase.getRequestContext();

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
                return variables.baseTestCase.execute(route = arguments.route, renderResults = true);
            }
            else {
                return variables.baseTestCase.execute(event = arguments.event, renderResults = true);   
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

    /**
    * Returns the route portion of a form action.
    * Removes the SESBaseUrl from the form action.
    *
    * @action The form action attribute
    *
    * @return string
    */
    private string function parseActionFromForm(required string action) {
        var baseUrl = variables.baseTestCase.getController().getSetting('SESBaseUrl');

        return replaceNoCase(arguments.action, baseUrl, '');
    }

    /**
    * Returns the html string from a ColdBox `execute()` call.
    *
    * @event The ColdBox event object (coldbox.system.web.context.RequestContext)
    *
    * @return string
    */
    private string function getHTML(event) {
        var rc = event.getCollection();

        if (StructKeyExists(rc, 'cbox_rendered_content')) {
            return rc.cbox_rendered_content;
        }

        return '';
    }

    /**************************** Debug Methods ******************************/


    public AbstractBaseSpec function debugCollection() {
        debug(variables.event.getCollection());

        return this;
    }

    public AbstractBaseSpec function debugPrivateCollection() {
        debug(variables.event.getPrivateCollection());

        return this;
    }

}
