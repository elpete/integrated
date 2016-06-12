/**
* Easily do integration tests by using ColdBox's internal request system.
*/
component extends='Integrated.BaseSpecs.AbstractBaseSpec' {

    property name="baseTestCase" type="coldbox.system.testing.BaseTestCase";

    function beforeAll() {
        super.beforeAll();

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


    /***************************** Additional Expectations *******************************/

    /**
    * Verifies that the given key and optional value exists in the ColdBox request collection.
    *
    * @key The key to find in the collection.
    * @value The value to find in the collection with the given key.
    * @private If true, use the private collection instead of the default collection. Default: false.
    * @negate If true, verify that the key and value is not found in the collection. Default: false.
    *
    * @return string
    */
    public ColdBoxBaseSpec function seeInCollection(
        required string key,
        string value,
        boolean private = false,
        boolean negate = false
    ) {
        var collection = getEvent().getCollection(private = arguments.private);

        var failureMessage = generateCollectionFailureMessage(argumentCollection = arguments);

        if (!negate) {
            // If a value was provided and the key exists...
            if (StructKeyExists(arguments, 'value') && StructKeyExists(collection, arguments.key)) {
                expect(collection[arguments.key]).toBe(arguments.value, failureMessage);
            }
            // Otherwise, just verify the existance of the key
            else {
                expect(collection).toHaveKey(arguments.key, failureMessage);    
            }
        }
        else {
            // If a value was provided and the key exists...
            if (StructKeyExists(arguments, 'value') && StructKeyExists(collection, arguments.key)) {
                expect(collection[arguments.key]).notToBe(arguments.value, failureMessage);
            }
            // Otherwise, just verify the existance of the key
            else {
                expect(collection).notToHaveKey(arguments.key, failureMessage);    
            }
        }

        return this;
    }

    /**
    * Verifies that the given key and optional value does not exist in the ColdBox request collection.
    *
    * @key The key that should not be found in the collection.
    * @value The value that should not be founc in the collection with the given key.
    * @private If true, use the private collection instead of the default collection. Default: false.
    *
    * @return string
    */
    public ColdBoxBaseSpec function dontSeeInCollection(
        required string key,
        string value,
        boolean private = false
    ) {
        arguments.negate = true;
        return seeInCollection(argumentCollection = arguments);
    }


    /**************************** Additional Debug Methods ******************************/


    /**
    * Pipes the request collection (rc) to the debug() output
    *
    * @return Integrated.BaseSpecs.ColdBoxBaseSpec
    */
    public ColdBoxBaseSpec function debugCollection() {
        debug(variables.event.getCollection());

        return this;
    }

    /**
    * Pipes the private request collection (prc) to the debug() output
    *
    * @return Integrated.BaseSpecs.ColdBoxBaseSpec
    */
    public ColdBoxBaseSpec function debugPrivateCollection() {
        debug(variables.event.getPrivateCollection());

        return this;
    }


    /**************************** Additional Helper Methods ******************************/


    /**
    * Generates the failure message string for the `seeInCollection` function.
    *
    * @key The key to find in the collection.
    * @value The value to find in the collection with the given key.
    * @private If true, use the private collection instead of the default collection. Default: false.
    * @negate If true, verify that the key and value is not found in the collection. Default: false.
    *
    * @return string
    */
    private string function generateCollectionFailureMessage(
        required string key,
        string value,
        boolean private = false,
        boolean negate = false
    ) {
        var failureMessage = 'Failed asserting that the key [#arguments.key#]';
        var existancePhrase = arguments.negate ? 'does not exist' : 'exists';

        if (StructKeyExists(arguments, 'value')) {
            failureMessage &= ' with the value [#arguments.value#]';
        }

        if (arguments.private) {
            failureMessage &= ' #existancePhrase# in the private request collection.';
        }
        else {
            failureMessage &= ' #existancePhrase# in the request collection.';   
        }

        return failureMessage;
    }

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
