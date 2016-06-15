/**
* Easily do integration tests by using ColdBox's internal request system.
*/
component extends='Integrated.BaseSpecs.AbstractBaseSpec' {

    property name="baseTestCase" type="coldbox.system.testing.BaseTestCase";

    function beforeAll() {
        super.beforeAll(frameworkAssertionEngine = new Integrated.Engines.Assertion.ColdBoxAssertionEngine());

        variables.baseTestCase = new coldbox.system.testing.BaseTestCase();
        passOnMetadata(baseTestCase);
        baseTestCase.beforeAll();
    }

    function afterAll() {
        super.afterAll();
        baseTestCase.afterAll();
    }

    /***************************** Abstract Method Implementations *******************************/


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
    * Returns the framework route portion of a url.
    * Removes the SESBaseUrl from the form action.
    *
    * @url A full url
    *
    * @return string
    */
    private string function parseFrameworkRoute(required string url) {
        var baseUrl = variables.baseTestCase.getController().getSetting('SESBaseUrl');

        return replaceNoCase(arguments.url, baseUrl, '');
    }

    /**
    * @doc_abstract true
    *
    * Returns true if the response is a redirect
    *
    * @event The ColdBox event object (coldbox.system.web.context.RequestContext)
    *
    * @return boolean
    */
    private boolean function isRedirect(event) {
        return event.valueExists('setNextEvent_event');
    }

    /**
    * Returns the redirect event name
    *
    * @event The ColdBox event object (coldbox.system.web.context.RequestContext)
    *
    * @return string
    */
    private string function getRedirectEvent(event) {
        return event.getValue('setNextEvent_event');
    }

    /**
    * Returns the inputs for the redirect event, if any.
    *
    * @event The ColdBox event object (coldbox.system.web.context.RequestContext)
    *
    * @return struct
    */
    private struct function getRedirectInputs(event) {
        var persistKeys = ListToArray(event.getValue('setNextEvent_persist', ''));

        var persistStruct = {};
        for (var key in persistKeys) {
            persistStruct[key] = event.getValue(key);
        }

        structAppend(persistStruct, event.getValue('setNextEvent_persistStruct', {}));

        return persistStruct;
    }


    /**************************** Additional Helper Methods ******************************/


    private function passOnMetadata(baseTestCase) {
        var md = getMetadata(this);
        // Inspect for appMapping annotation
        if (structKeyExists(md, "appMapping")) {
            arguments.baseTestCase.setAppMapping(md.appMapping);
        }
        // Configuration File mapping
        if (structKeyExists(md, "configMapping")) {
            arguments.baseTestCase.setConfigMapping(md.configMapping);
        }
        // ColdBox App Key
        if (structKeyExists(md, "coldboxAppKey")) {
            arguments.baseTestCase.setColdboxAppKey(md.coldboxAppKey);
        }
        // Load coldBox annotation
        if (structKeyExists(md, "loadColdbox")) {
            arguments.baseTestCase.loadColdbox = md.loadColdbox;
        }
        // unLoad coldBox annotation
        if (structKeyExists(md, "unLoadColdbox")) {
            arguments.baseTestCase.unLoadColdbox = md.unLoadColdbox;
        }
    }


}
