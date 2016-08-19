import Integrated.Engines.Assertion.Contracts.FrameworkAssertionEngine;

component extends="testbox.system.BaseSpec" implements="Integrated.Engines.Assertion.Contracts.FrameworkAssertionEngine" {

    // The framework event object
    property name="event";
    // The current request method
    property name="requestMethod";

    /**
    * Sets the current request method
    *
    * @event The current request method.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function setRequestMethod(required string requestMethod) {
        variables.requestMethod = arguments.requestMethod;

        return this;
    }

    /**
    * Gets the request method
    *
    * @return string
    */
    public string function getRequestMethod() {
        return variables.requestMethod;
    }

    /**
    * Sets the current framework event
    *
    * @event The framework event object.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function setEvent(required event) {
        variables.event = arguments.event;

        return this;
    }

    /**
    * Retrives the current framework event object.
    *
    * Throws an exception if there is no event available.
    *
    * @throws TestBox.AssertionFailed
    * @return coldbox.system.web.context.RequestContext
    */
    public any function getEvent() {
        if (IsSimpleValue(variables.event)) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Cannot make assertions until you visit a page.  Make sure to run visit() or visitEvent() first.'
            );
        }

        return variables.event;
    }

    /**
    * Returns the html string from a framework event.
    *
    * @return string
    */
    public string function getHTML() {
        var rc = getEvent().getCollection();

        if (StructKeyExists(rc, 'cbox_rendered_content')) {
            return rc.cbox_rendered_content;
        }

        return '';
    }


    /**
    * Returns true if the response is a redirect
    *
    * @event The ColdBox event object (coldbox.system.web.context.RequestContext)
    *
    * @return boolean
    */
    public boolean function isRedirect() {
        var event = getEvent();
        return event.valueExists('setNextEvent_URI') ||
            event.valueExists('setNextEvent_URL') ||
            event.valueExists('setNextEvent_event');
    }

    /**
    * Returns the redirect event name
    *
    * @event The ColdBox event object (coldbox.system.web.context.RequestContext)
    *
    * @return string
    */
    public string function getRedirectEvent() {
        var event = getEvent();

        if ( event.valueExists('setNextEvent_URI') ) {
            return event.getValue('setNextEvent_URI');
        }

        if ( event.valueExists('setNextEvent_URL') ) {
            return event.getValue('setNextEvent_URL');
        }

        return event.getValue('setNextEvent_event');
    }

    /**
    * Returns the inputs for the redirect event, if any.
    *
    * @event The ColdBox event object (coldbox.system.web.context.RequestContext)
    *
    * @return struct
    */
    public struct function getRedirectInputs() {
        var persistKeys = ListToArray(getEvent().getValue('setNextEvent_persist', ''));

        var persistStruct = {};
        for (var key in persistKeys) {
            persistStruct[key] = getEvent().getValue(key);
        }

        structAppend(persistStruct, getEvent().getValue('setNextEvent_persistStruct', {}));

        return persistStruct;
    }

    /**
    * Verifies the route of the current page.
    * This method cannot be used after visiting a page using an event.
    *
    * @route The expected route.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function seePageIs(required string route) {
        if (variables.requestMethod == 'visitEvent') {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'You cannot assert the page when you visited using the visitEvent() method. Please use visit() instead.'
            );
        }

        var actualUrl = getEvent().getCurrentRoutedUrl();

        // Add a leading slash if missing
        if ( left( actualUrl, 1 ) != "/" ) {
            actualUrl = "/" & actualUrl;
        }

        // Remove a trailing slash if present
        if ( right( actualUrl, 1 ) == "/" && len( actualUrl ) > 1 ) {
            actualUrl = left( actualUrl, len( actualUrl ) - 1 );    
        }

        expect(actualUrl).toBe(
            arguments.route,
            "Failed asserting that the url [#actualUrl#] (actual) equalled [#arguments.route#] (expected)."
        );

        return this;
    }

    /**
    * Verifies the framework view of the current page.
    *
    * @view The expected view.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function seeViewIs(required string view) {
        var actualView = getEvent().getCurrentView();
        expect(actualView).toBe(
            arguments.view,
            'Failed asserting that view [#actualView#] (actual) equalled [#arguments.view#] (expected).'
        );

        return this;
    }

    /**
    * Verifies the framework handler of the current page.
    *
    * @handler The expected handler.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function seeHandlerIs(required string handler) {
        var actualHandler = getEvent().getCurrentHandler();
        expect(actualHandler).toBe(
            arguments.handler,
            'Failed asserting that handler [#actualHandler#] (actual) equalled [#arguments.handler#] (expected).'
        );

        return this;
    }

    /**
    * Verifies the framework action of the current page.
    *
    * @action The expected action.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function seeActionIs(required string action) {
        var actualAction = getEvent().getCurrentAction();
        expect(actualAction).toBe(
            arguments.action,
            'Failed asserting that action [#actualAction#] (actual) equalled [#arguments.action#] (expected).'
        );

        return this;
    }

    /**
    * Verifies the framework event of the current page.
    *
    * @event The expected event.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function seeEventIs(required string event) {
        var actualEvent = getEvent().getCurrentEvent();
        expect(actualEvent).toBe(
            arguments.event,
            'Failed asserting that event [#actualEvent#] (actual) equalled [#arguments.event#] (expected).'
        );

        return this;
    }

    /**
    * Verifies that the given key and optional value exists in the framework request collection.
    *
    * @key The key to find in the collection.
    * @value The value to find in the collection with the given key.
    * @private If true, use the private collection instead of the default collection. Default: false.
    * @negate If true, verify that the key and value is not found in the collection. Default: false.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function seeInCollection(
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
    * Verifies that the given key and optional value does not exist in the framework request collection.
    *
    * @key The key that should not be found in the collection.
    * @value The value that should not be founc in the collection with the given key.
    * @private If true, use the private collection instead of the default collection. Default: false.
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function dontSeeInCollection(
        required string key,
        string value,
        boolean private = false
    ) {
        arguments.negate = true;
        return seeInCollection(argumentCollection = arguments);
    }

    /**
    * Returns the framework event
    *
    * @return any
    */
    public any function getFrameworkEvent() {
        return getEvent();
    }

    /**
    * Returns the framework request collection
    *
    * @return any
    */
    public any function getCollection() {
        return getEvent().getCollection( private = false );
    }

    /**
    * Returns the framework private request collection
    *
    * @return any
    */
    public any function getPrivateCollection() {
        return getEvent().getCollection( private = true );
    }


    /************************ HELPERS **************************/

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

}