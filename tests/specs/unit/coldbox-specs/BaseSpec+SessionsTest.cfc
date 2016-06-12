component extends='testbox.system.BaseSpec' {
    
    function beforeAll() {
        this.CUT = new BaseSpecs.ColdBoxBaseSpec();
        getMockBox().prepareMock(this.CUT);

        // Set the appMapping for testing
        variables.mockBaseTestCase = getMockBox().createMock('coldbox.system.testing.BaseTestCase');
        this.CUT.$property(propertyName = 'baseTestCase', mock = mockBaseTestCase);
        variables.mockBaseTestCase.$property(propertyName = 'appMapping', mock = '/SampleApp');
        variables.mockBaseTestCase.beforeAll();

        // Set up the parent ColdBox BaseTestCase
        this.CUT.beforeAll();
    }

    function run() {
        describe('BaseSpec — Session Persistance', function() {

            feature('session persistance across tests', function() {
                it('clears the session before every spec by default', function() {
                    var specStub = createStub().$('body');
                    this.CUT.$('clearSessionScope');

                    this.CUT.persistSessionScope = false;
                    this.CUT.shouldPersistSessionScope(specStub);
                    expect(this.CUT.$once('clearSessionScope')).toBeTrue();
                });

                it('lets you persist the session scope across specs', function() {
                    var specStub = createStub().$('body');
                    this.CUT.$('clearSessionScope');
                    
                    this.CUT.persistSessionScope = true;
                    this.CUT.shouldPersistSessionScope(specStub);
                    expect(this.CUT.$never('clearSessionScope')).toBeTrue();
                });
            });

        });
    }
}
