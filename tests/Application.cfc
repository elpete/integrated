/**
********************************************************************************
Copyright 2005-2007 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.ortussolutions.com
********************************************************************************
*/
component{

	this.name 				= "ColdBoxTestingSuite" & hash(getCurrentTemplatePath());
	this.sessionManagement 	= true;
	this.sessionTimeout 	= createTimeSpan( 0, 0, 15, 0 );
	this.applicationTimeout = createTimeSpan( 0, 0, 15, 0 );
	this.setClientCookies 	= true;

	// Create testing mapping
	testsPath = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings["/tests"] = testsPath;

	// Map back to its root
	rootPath = REReplaceNoCase( this.mappings[ "/tests" ], "tests(\\|/)", "" );
	this.mappings["/root"] = rootPath;

	// Map to the SampleApp
	this.mappings["/SampleApp"] = testsPath & "resources/SampleApp";
	this.mappings["/coldbox"] = testsPath & "resources/SampleApp/coldbox";
    this.mappings[ "/testbox" ] = rootPath & "/testbox";
    this.mappings[ "/docbox" ] = rootPath & "/docbox";

    this.javaSettings = { loadPaths = [ "/lib" ], reloadOnChange = false };
}
