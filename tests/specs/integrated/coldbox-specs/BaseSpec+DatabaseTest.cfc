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
                    'id,username,email,last_logged_in',
                    'integer,varchar,varchar,timestamp',
                    [
                        { id = 1, username = 'johnny_boy', email ='john@example.com', last_logged_in = createDateTime(2016, 01, 01, 12, 01, 33) },
                        { id = 2, username = 'lady_jo', email ='josephene@example.com', last_logged_in = createDateTime(2016, 01, 02, 15, 01, 33) },
                        { id = 3, username = 'jack', email ='jack@example.com', last_logged_in = createDateTime(2016, 01, 05, 08, 01, 33) }
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

                it('matches multiple fields in a single row', function() {
                    expect(function() {
                        this.CUT.expect({ id = { value = '1', cfsqltype = 'CF_SQL_INTEGER' }, email = { value = 'john@example.com', cfsqltype = 'CF_SQL_VARHCHAR' } }).toBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).notToThrow();

                    expect(function() {
                        this.CUT.expect({ id = { value = '2', cfsqltype = 'CF_SQL_INTEGER' }, email = 'john@example.com'}).toBeInTable(table = 'users', query = variables.mockUsersTable);
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

                it('can pass an optional field struct for each field key', function() {
                    expect(function() {
                        this.CUT.expect({ last_logged_in = { value = createDateTime(2016, 01, 02, 15, 01, 33), cfsqltype = 'CF_SQL_TIMESTAMP' } }).toBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).notToThrow();
                });

                it('fails if a value key is not provided with the optional field struct', function() {
                    expect(function() {
                        this.CUT.expect({ id = { cfsqltype = 'CF_SQL_INTEGER' } }).toBeInTable(table = 'users', query = variables.mockUsersTable);
                    }).toThrow(
                        type = 'TestBox.AssertionFailed',
                        regex = 'Must pass a value key if assigning a struct to a fields key\.'
                    );
                });
            });

            feature('automatic database transactions', function() {
                it('has opt in database transactions', function() {
                    var specStub = createStub().$('body');
                    this.CUT.$('wrapInDatabaseTransaction');

                    this.CUT.shouldUseDatabaseTransactions(specStub);
                    expect(this.CUT.$never('wrapInDatabaseTransaction')).toBeTrue();
                    expect(specStub.$times(1, 'body')).toBeTrue();
                    
                    this.CUT.useDatabaseTransactions = true;
                    this.CUT.shouldUseDatabaseTransactions(specStub);
                    expect(this.CUT.$once('wrapInDatabaseTransaction')).toBeTrue();
                });
            });

        });
    }
}
