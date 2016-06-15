component extends="testbox.system.BaseSpec" implements="Integrated.Engines.Assertion.Contracts.FrameworkAssertionEngine" {

    // The ColdBox RequestContext
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


    /************************ HELPERS **************************/

    /**
    * Retrives the last ColdBox request context (event) ran.
    * Throws an exception if there is no event available.
    *
    * @throws TestBox.AssertionFailed
    * @return coldbox.system.web.context.RequestContext
    */
    private function getEvent() {
        if (IsSimpleValue(variables.event)) {
            throw(
                type = 'TestBox.AssertionFailed',
                message = 'Cannot make assertions until you visit a page.  Make sure to run visit() or visitEvent() first.'
            );
        }

        return variables.event;
    }

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

    /**
    * Pipes the framework event to the debug() output
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function debugEvent() {
        debug( variables.event );

        return this;
    }

    /**
    * Pipes the framework request collection to the debug() output
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function debugCollection() {
        debug( variables.event.getCollection( private = false ) );

        return this;
    }

    /**
    * Pipes the framework private request collection to the debug() output
    *
    * @return Integrated.Engines.FrameworkAssertionEngine
    */
    public FrameworkAssertionEngine function debugPrivateCollection() {
        debug( variables.event.getCollection( private = true ) );

        return this;
    }
}