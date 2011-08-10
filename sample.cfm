<cfsetting enablecfoutputonly="true">
<cfset variables.configFilePath = replaceNoCase(replace(getCurrentTemplatePath(), "\", "/", "all"), "sample.cfm", "config.ini")>
<cfset variables.uservoice_subdomain = trim(getProfileString(variables.configFilePath, "Keys", "uservoice_subdomain"))> 
<cfset variables.sso_key = trim(getProfileString(variables.configFilePath, "Keys", "sso_key"))>
<cfset variables.forum_url = trim(getProfileString(variables.configFilePath, "Keys", "forum_url"))>
<cfset variables.userVoiceSSO = createObject("component", "UserVoiceSSO").init(variables.uservoice_subdomain, variables.sso_key)>
<cfset variables.user = structNew()>
<cfset variables.user["guid"] = getProfileString(variables.configFilePath, "User", "guid")>
<cfif trim(getProfileString(variables.configFilePath, "User", "email")) NEQ "">
	<cfset variables.user["email"] = trim(getProfileString(variables.configFilePath, "User", "email"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "expires")) NEQ "" AND isDate(getProfileString(variables.configFilePath, "User", "expires"))>
	<cfset variables.user["expires"] = parseDateTime(getProfileString(variables.configFilePath, "User", "expires"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "display_name")) NEQ "">
	<cfset variables.user["display_name"] = trim(getProfileString(variables.configFilePath, "User", "display_name"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "locale")) NEQ "">
	<cfset variables.user["locale"] = trim(getProfileString(variables.configFilePath, "User", "locale"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "owner")) NEQ "">
	<cfset variables.user["owner"] = trim(getProfileString(variables.configFilePath, "User", "owner"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "admin")) NEQ "">
	<cfset variables.user["admin"] = trim(getProfileString(variables.configFilePath, "User", "admin"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "allow_forums")) NEQ "">
	<cfset variables.user["allow_forums"] = trim(getProfileString(variables.configFilePath, "User", "allow_forums"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "deny_forums")) NEQ "">
	<cfset variables.user["deny_forums"] = trim(getProfileString(variables.configFilePath, "User", "deny_forums"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "url")) NEQ "">
	<cfset variables.user["url"] = trim(getProfileString(variables.configFilePath, "User", "url"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "avatar_url")) NEQ "">
	<cfset variables.user["avatar_url"] = trim(getProfileString(variables.configFilePath, "User", "avatar_url"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "updates")) NEQ "">
	<cfset variables.user["updates"] = trim(getProfileString(variables.configFilePath, "User", "updates"))>
</cfif>
<cfif trim(getProfileString(variables.configFilePath, "User", "comment_updates")) NEQ "">
	<cfset variables.user["comment_updates"] = trim(getProfileString(variables.configFilePath, "User", "comment_updates"))>
</cfif>
<cfset variables.token = variables.userVoiceSSO.generateToken(variables.user, true) />

<cfoutput>
<!DOCTYPE html>
<html>
	<head>
		<title>UserVoice SSO test page</title>
	</head>
	<body>
		<cfdump var="#variables#" />
		<a href="#variables.forum_url#?sso=#variables.token#">Launch Forum</a>
	</body>
</html>
</cfoutput>
