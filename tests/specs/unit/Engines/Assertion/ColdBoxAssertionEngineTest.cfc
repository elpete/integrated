component extends='tests.specs.unit.Engines.Assertion.Contracts.FrameworkAssertionEngineTest' {
    function getCUT() {
        return new Integrated.Engines.Assertion.ColdBoxAssertionEngine();
    }
}