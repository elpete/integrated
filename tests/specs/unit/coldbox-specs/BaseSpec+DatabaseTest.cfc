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
        describe('BaseSpec — Database Helpers', function() {

            beforeEach(function() {
                variables.mockUsersTable = queryNew(
                    'id,username,email',
                    'integer,varchar,varchar',
                    [
                        { id = 1, username = 'johnny_boy', email ='john@example.com' },
                        { id = 2, username = 'lady_jo', email ='josephene@example.com' },
                        { id = 3, username = 'jack', email ='jack@example.com' }
                    ]
                );
            });

            feature('seeInTable matcher', function() {
                it('verifies data in the database', function() {
                    expect(function() {
                        this.CUT.expect({ email = 'john@example.com'}).toBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.expect({ email = 'jane@example.com'}).toBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).toThrow('TestBox.AssertionFailed');
                });

                it('provides a `not` matcher as well', function() {
                    expect(function() {
                        this.CUT.expect({ email = 'jane@example.com'}).notToBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.expect({ email = 'john@example.com'}).notToBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).toThrow('TestBox.AssertionFailed');
                });

                it('provides a detailed error message on failure', function() {
                    expect(function() {
                        this.CUT.expect({ email = 'jane@example.com'}).toBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Unable to find row in database table \[users\] that matched attributes \[\{\"EMAIL\"\:\"jane\@example\.com\"\}\]\.'
                    );

                    expect(function() {
                        this.CUT.expect({ email = 'john@example.com'}).notToBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Found unexpected records in database table \[users\] that matched attributes \[\{\"EMAIL\"\:\"john\@example\.com\"\}\]\.'
                    );
                });

                it('fails if no arguments are passed in', function() {
                    expect(function() {
                        this.CUT.expect({ email = 'jane@example.com'}).toBeInTable();
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = "Must pass a table to this matcher\."
                    );
                });

                it('accepts an optional datasource', function() {
                    expect(function() {
                        this.CUT.expect({ email = 'jane@example.com'}).notToBeInTable(table = 'users', datasource = 'testing', query = variables.mockUsersTable);
                    }).notToThrow();
                });

                it('fails if a datasource is passed in, but not a table', function() {
                    expect(function() {
                        this.CUT.expect({ email = 'jane@example.com'}).toBeInTable(datasource = 'testing');
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = "Must pass a table to this matcher\."
                    );
                });

                it('can optionally set the type of the data to be verified', function() {
                    fail('test not implemented yet.');
                });
            });

        });
    }
}
