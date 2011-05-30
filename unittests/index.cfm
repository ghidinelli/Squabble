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

<html>

<body>

<cfscript>
	directoryTestSuite = createObject("component", "mxunit.runner.DirectoryTestSuite");
	result = directoryTestSuite.run(directory="#expandPath('/unittests')#"
									,componentPath="unittests"
									,recurse="true"
									);

</cfscript>

<cfoutput> #result.getResultsOutput("html")# </cfoutput>

</body>

</html>