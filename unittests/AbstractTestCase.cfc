<!---
   Copyright 2011 Ezra Parker, Josh Wines, Mark Mandel

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 --->

<cfcomponent hint="An abstract test case for default setup, teardown, and util methods" extends="mxunit.framework.TestCase" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="_trace" access="private">
	<cfargument name="s">
	<cfset var g = "">
	<cfsetting showdebugoutput="true">
	<cfsavecontent variable="g">
		<cfdump var="#arguments.s#">
	</cfsavecontent>
	<cftrace text="#g#">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>