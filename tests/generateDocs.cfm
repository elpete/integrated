<cfscript>

docbox = new docbox.DocBox(properties = {
	projectTitle = "Integrated",
	outputDir = "#ExpandPath("/apidocs")#"
});

docbox.generate(
	source = "#ExpandPath('/')#",
	mapping = '',
	excludes = 'test|docbox'
);

</cfscript>

<cfoutput>
	<cfhtmlhead text="<title>Apidocs generated!</title>" />
	<h2>Api docs generated to <code>/apidocs</code>!</h2>
</cfoutput>