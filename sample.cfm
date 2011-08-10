<cfsetting enablecfoutputonly="true">
<cfset variables.uservoice_subdomain = getProfileString("config.ini", "Keys", "uservoice_subdomain")> 
<cfset variables.sso_key = getProfileString("config.ini", "Keys", "sso_key")>
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
