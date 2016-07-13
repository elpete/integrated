/**
* Custom TestBox matchers for making expectations against the database
*/
component {

	/**
	* Verifies that a row with specified values exists in a given table.
	*
	* @expectation TestBox Expectation object. (testbox.system.Expectation)
	* @args A struct of arguments passed to the `toBeInTable` function
	*
	* @throws TestBox.AssertionFailed
	*/
	function toBeInTable(expectation, args = {}) {
		var noArgs = StructCount(arguments.args) == 0;

		var fields = expectation.actual;

		// I'd love to use ArrayEvery, but CF doesn't support it. :-(
		var positionalParameters = true;
		for (var arg in StructKeyArray(arguments.args)) {
			if (! IsNumeric(arg)) {
				positionalParameters = false;
			}
		}

		var noTablePassed = !positionalParameters && !StructKeyExists(arguments.args, 'table');
		if (noArgs || noTablePassed) {
			throw(
				type = 'TestBox.AssertionFailed',
				message = 'Must pass a table to this matcher.'
			);
		}

		var table = '';
		var datasource = '';
		var query = '';
		if (positionalParameters) {
			var argsCount = StructCount(arguments.args);
			table = arguments.args[1];
			datasource = argsCount >= 2 ? arguments.args[2] : '';
			query = argsCount >= 3 ? arguments.args[3] : '';
		}
		else {
			table = arguments.args.table;
			datasource = StructKeyExists(arguments.args, 'datasource') ? arguments.args.datasource : '';
			query = StructKeyExists(arguments.args, 'query') ? arguments.args.query : '';
		}

		var verifyQuery = new Query();

		if (IsQuery(query)) {
			verifyQuery.setDBType('query');
			// This is a strange syntax, but it is needed to make ACF (<= 11) happy
			verifyQuery.setAttributes(argumentCollection = { "#table#" = query });
		}
		else if (datasource != '') {
			verifyQuery.setDatasource(datasource);
		}

		var sqlString = "SELECT 1 FROM #table# WHERE 1 = 1";

		for (var key in fields) {
			// Can't use hyphens in params
			var uniqueKey = '#key#_#replace(createUUID(), '-', '_', 'all')#';
			var paramArgs = isStruct(fields[key]) ? fields[key] : { value = fields[key] };
			paramArgs.name = uniqueKey;

			if (!StructKeyExists(paramArgs, 'value')) {
				throw(
					type = 'TestBox.AssertionFailed',
					message = 'Must pass a value key if assigning a struct to a fields key.'
				);
			}
			verifyQuery.addParam(argumentCollection = paramArgs);

	        sqlString &= " AND #key# IN (:#uniqueKey#)";
		}
		
		verifyQuery.setSQL(sqlString);

		var result = verifyQuery.execute().getResult();

		if (expectation.isNot) {
			expectation.message = "Found unexpected records in database table [#table#] that matched attributes [#SerializeJSON(fields)#].";
			return result.RECORDCOUNT == 0;
		}
		else {
			expectation.message = "Unable to find row in database table [#table#] that matched attributes [#SerializeJSON(fields)#].";
			return result.RECORDCOUNT > 0;
		}

	}

}