<!---
	Developed by Ryan McIlmoyl for dominKnow Learning Systems Inc.

	This code is provided freely to the public for any use, including in commercial projects, with no further requirements.  However,
	if you are going to modify the code, please consider contributing it back.
	http://github.com/ryanmcilmoyl/CFUserVoiceSSO
--->
<cfcomponent>
	<cfproperty name="accountKey" type="string" />
	<cfproperty name="apiKey" type="string" /> 

	<cfset variables.initVectorString = "OpenSSL for Ruby" /><!--- DO NOT CHANGE, constant for UV encrypt/decrypt --->
	<cfset variables.blockSize = 16 />
	
	<cffunction name="init" access="public" returntype="any" hint="The public constructor" output="false" >
		<cfargument name="accountKey" type="string" required="true" hint="Your UserVoice account key" />
		<cfargument name="apiKey" type="string" required="true" hint="Your UserVoice API key" />

		<cfset variables.accountKey = arguments.accountKey />
		<cfset variables.apiKey = arguments.apiKey />
		<cfset variables.initVectorBytes = variables.initVectorString.getBytes() />
		<cfset variables.encryptionKey = generateKey(arguments.accountKey, arguments.apiKey) />

		<cfreturn this />
	</cffunction>

	<cffunction name="generateToken" access="public" returntype="string" hint="Returns the Base64 encoded access token for the given user" output="false">
		<cfargument name="user" type="struct" required="true" hint="The user to generate a token for.  Requires a 'guid' field.  'expires' field will be generated (for 1 day from now) if not provided" />

		<cfset var userStruct = structNew() />
		<cfif NOT structKeyExists(arguments.user, "guid")>
			<cfthrow message="You must provide the 'guid' field'" />
		<cfelse>
			<cfset userStruct["guid"] = arguments.user.guid />
		</cfif>
		<cfscript>
			//Ensure any provided fields are lower-cased
			if (structKeyExists(arguments.user, "expires") AND isDate(arguments.user.expires)) {
				userStruct["expires"] = arguments.user.expires;
			}
			else {
				userStruct["expires"] = dateFormat(dateConvert("local2UTC", dateAdd("d", 1, now())), "yyyy-mm-dd") & " " & 
					timeFormat(dateConvert("local2utc", now()), "hh:mm:ss");
			}
			if (structKeyExists(arguments.user, "email")) {
				userStruct["email"] = arguments.user.email;
			}
			if (structKeyExists(arguments.user, "display_name")) {
				userStruct["display_name"] = arguments.user.display_name;
			}
			if (structKeyExists(arguments.user, "locale")) {
				userStruct["locale"] = arguments.user.locale;
			}
			if (structKeyExists(arguments.user, "owner")) {
				userStruct["owner"] = arguments.user.ownser;
			}
			if (structKeyExists(arguments.user, "admin")) {
				userStruct["admin"] = arguments.user.admin;
			}
			if (structKeyExists(arguments.user, "allow_forums")) {
				userStruct["allow_forums"] = arguments.user.allow_forums;
			}
			if (structKeyExists(arguments.user, "deny_forums")) {
				userStruct["deny_forums"] = arguments.user.deny_forums;	
			}
			if (structKeyExists(arguments.user, "url")) {
				userStruct["url"] = arguments.user.url;
			}
			if (structKeyExists(arguments.user, "avatar_url")) {
				userStruct["avatar_url"] = arguments.user.avatar_url;
			}
			if (structKeyExists(arguments.user, "updates")) {
				userStruct["updates"] = arguments.user.updates;
			}
			if (structKeyExists(arguments.user, "comment_updates")) {
				userStruct["comment_updats"] = arguments.user.comment_updates;
			}

			return encode(serializeJSON(userStruct));
		</cfscript>
	</cffunction>

	<!--- Private methods --->
	<cffunction name="applyIV" access="private" returntype="array" hint="Applies the IV to the byte array" output="false">
		<cfargument name="clearBytes" type="any" required="true" />

		<cfscript>
			var newBytes = arrayNew(1);
			var i = 0;

			for (i = 1; i <= variables.blockSize; i ++) {
				newBytes[i] = bitXor(arguments.clearBytes[i], variables.initVectorBytes[i]);
			}
			for (i = 17; i <= arrayLen(arguments.clearBytes); i ++) {
				newBytes[i] = arguments.clearBytes[i];
			}

			return javaCast("byte[]", newBytes);
		</cfscript>
	</cffunction>

	<cffunction name="encode" access="private" returntype="string" hint="Returns Base64 encoded string" output="false">
		<cfargument name="clearText" type="string" required="true" />

		<cfscript>
			var clearBytes = toBinary(toBase64(arguments.clearText));
			var newBytes = applyIV(clearBytes);
			var encodeBytes = encryptBinary(newBytes, variables.encryptionKey, "AES/CBC/PKCS5Padding", variables.initVectorBytes);

			return binaryEncode(encodeBytes, "Base64");
		</cfscript>
	</cffunction>

	<cffunction name="generateKey" access="private" returntype="string" hint="Generates the Base64 encoded encryption key" output="false">
		<cfargument name="accountKey" type="string" required="true" />
		<cfargument name="apiKey" type="string" required="true" />

		<cfscript>
			var salted = arguments.apiKey & arguments.accountKey;
			var hashed = binaryDecode(hash(salted, "sha"), "hex");
			var trunc = arrayNew(1);
			var i = 1;
			for (i = 1; i <= 16; i ++) {
				trunc[i] = hashed[i];
			}

			return binaryEncode(javaCast("byte[]", trunc), "Base64");
		</cfscript>
	</cffunction>

</cfcomponent>
