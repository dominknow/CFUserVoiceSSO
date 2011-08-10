<cfsetting enablecfoutputonly="true">
<cfset variables.accountKey = getProfileString("config.ini", "Keys", "accountKey")> 
<cfset variables.apiKey = getProfileString("config.ini", "Keys", "apiKey")>
<cfoutput>
<!DOCTYPE html>
<html>
	<head>
		<title>UserVoice SSO test page</title>
	</head>
	<body>
	</body>
</html>
</cfoutput>
