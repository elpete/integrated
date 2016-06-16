/**
* Easily do integration tests by using ColdBox's internal request system.
*/
component extends='Integrated.BaseSpecs.AbstractBaseSpec' {

    function beforeAll(
        requestEngine = new Integrated.Engines.Request.ColdBoxRequestEngine(),
        overrideMetadata
    ) {
        passOnMetadata( arguments.requestEngine, arguments.overrideMetadata );
        requestEngine.beforeAll();

        super.beforeAll(
            frameworkAssertionEngine = new Integrated.Engines.Assertion.ColdBoxAssertionEngine(),
            requestEngine = arguments.requestEngine
        );
    }

    function afterAll() {
        super.afterAll();
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


    private function passOnMetadata(baseTestCase, overrideMetadata) {
        var md = IsDefined("overrideMetadata") ? overrideMetadata : getMetadata(this);
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
