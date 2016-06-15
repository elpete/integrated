component extends='tests.specs.unit.Engines.Assertion.Contracts.DOMAssertionEngineTest' {
    function getCUT() {
        return new Integrated.Engines.Assertion.JSoupAssertionEngine();
    }
}