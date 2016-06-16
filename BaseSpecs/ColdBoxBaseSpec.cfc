/**
* Easily do integration tests by using ColdBox's internal request system.
*/
component extends='Integrated.BaseSpecs.AbstractBaseSpec' {

    function beforeAll(
        requestEngine = new Integrated.Engines.Request.ColdBoxRequestEngine(),
        overrideMetadata = {}
    ) {
        passOnMetadata( arguments.requestEngine, arguments.overrideMetadata );
        requestEngine.beforeAll();

        super.beforeAll(
            requestEngine = arguments.requestEngine,
            domEngine = new Integrated.Engines.Assertion.JSoupAssertionEngine(),
            frameworkEngine = new Integrated.Engines.Assertion.ColdBoxAssertionEngine(),
            interactionEngine = new Integrated.Engines.Interaction.JSoupInteractionEngine()
        );
    }

    function afterAll() {
        super.afterAll();
        // IMPORTANT: otherwise, ColdBox keeps the last request cached or something
        requestEngine.afterAll();
    }

    private function passOnMetadata(baseTestCase, overrideMetadata = {}) {
        var md = structIsEmpty(arguments.overrideMetadata) ? getMetadata(this) : arguments.overrideMetadata;
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
