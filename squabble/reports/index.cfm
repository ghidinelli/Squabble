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
 ---><cfsilent>


<!---
	A very simple report output to screen for now.

	TODO: 	Move template in custom tag wrappers
			Add some styling to format the output nicely
			Move Data structure into API call
--->

<cfif structKeyExists(form, "fieldnames")>
	<cfparam name="form.testName" type="string" default="">

	<cfscript>
		totalVisitors = application.squabble.getGateway().getTotalVisitors(form.testName);
	</cfscript>
</cfif>

</cfsilent><!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Squabble Simple Report</title>
	<style type="text/css">
		* { margin: 0; padding: 0; }
		html { height: 100%; width: 100%; }
		body { margin: 20px; }

		#testData { margin-top: 20px; }

		#testData table { margin-top: 15px; border: solid 1px #ccc; }
		th { font-weight: bold; }
		td, th { text-align: center; padding: 8px 15px; }
		.header { background-color: #ddd; }
		.odd { background-color: #efefef;  }
	</style>
</head>
<body>
	<form method="post">
		<cfset tests = application.squabble.getGateway().getAllTests()>

		<strong>Choose Test:</strong>

		<cfif arrayLen(tests)>
			<select name="testName">
				<cfloop array="#tests#" index="testName">
					<cfoutput><option value="#testName#" <cfif structKeyExists(form, "testName") AND form.testName EQ testName>selected="selected"</cfif>>#testName#</option></cfoutput>
				</cfloop>
			</select>

			<input type="submit" value="Show Me" />
		<cfelse>
			No Tests Recorded!
		</cfif>

		<cfif structKeyExists(form, "fieldnames") AND totalVisitors GT 0>
			<cfscript>
				totalConversions = application.squabble.getGateway().getTotalConversions(form.testName);
				conversions = totalConversions.recordcount EQ 1 AND totalConversions.total_conversions GT 0;
			</cfscript>

			<div id="testData">
				<cfoutput>
					<h2>#form.testName#</h2>

					<table cellspacing="0">
						<tr class="header">
							<th>Visitors</th>
							<th>Conv.</th>
							<th>Conv. Rate</th>
							<th>Total Conv. Value</th>
							<th>Average Conv. Value</th>
						</tr>
						<tr>
							<td>#totalVisitors#</td>
							<cfif conversions>
								<td>#totalConversions.total_conversions#</td>
								<td>#decimalFormat(totalConversions.total_conversions / totalVisitors * 100)#%</td>
								<td>#decimalFormat(val(totalConversions.total_value))#</td>
								<td>#decimalFormat(val(totalConversions.total_value) / totalConversions.total_conversions)#</td>
							<cfelse>
								<td>0</td>
								<td>NA</td>
								<td>NA</td>
								<td>NA</td>
							</cfif>
						</tr>
					</table>
				</cfoutput>

				<cfif conversions>
					<cfscript>
						combinationTotalVisitors = application.squabble.getGateway().getCombinationTotalVisitors(form.testName);
						combinationTotalConversions = application.squabble.getGateway().getCombinationTotalConversions(form.testName);
						goalTotalConversions = application.squabble.getGateway().getGoalTotalConversions(form.testName);

						/* Debug*/
							writeDump(var=combinationTotalVisitors, expand=false);
							writeDump(var=combinationTotalConversions, expand=false);
							writeDump(var=goalTotalConversions, expand=false);

					</cfscript>

					<table cellspacing="0">
						<tr class="header">
							<th>Combination</th>
							<th>Hits</th>
							<th>Conversions</th>
							<th>Conv. Rate</th>
							<th>Conv. Value</th>
							<th>Avg Conv. Value</th>

							<th>Goal</th>
							<th>Conversions</th>
							<th>Conv. Rate</th>
							<th>Conv. Value</th>
							<th>Avg Conv. Value</th>
						</tr>

						<cfset combinationCount = 0>

						<cfoutput query="goalTotalConversions" group="combination">
							<cfset combinationCount++>
							<cfset goalCount = 0>
							<cfset totalGoals = 0>
							<cfoutput><cfset totalGoals++></cfoutput>

							<cfoutput>
								<cfset goalCount++>
								<cfset combinationVisitors = combinationTotalVisitors.total_visitors[combinationCount]>
								<cfset combinationConversions = combinationTotalConversions.total_conversions[combinationCount]>
								<cfset combinationConversionTotal = combinationTotalConversions.total_value[combinationCount]>

								<tr <cfif combinationCount MOD 2 EQ 0>class="odd"</cfif>>
									<cfif goalCount EQ 1>
										<td rowspan="#totalGoals#"><strong>#combination#</strong></td>
										<td rowspan="#totalGoals#">#combinationVisitors#</td>
										<td rowspan="#totalGoals#">#combinationConversions#</td>
										<td rowspan="#totalGoals#">#decimalFormat(combinationConversions / combinationVisitors * 100)#%</td>
										<td rowspan="#totalGoals#"><cfif isNumeric(combinationConversionTotal)>#combinationConversionTotal#<cfelse>NA</cfif></td>
										<td rowspan="#totalGoals#"><cfif isNumeric(combinationConversionTotal)>#decimalFormat(val(combinationConversionTotal) / combinationConversions)#<cfelse>NA</cfif></td>
									</cfif>

									<td>#conversion_name#</td>
									<td>#total_conversions#</td>
									<td>#decimalFormat(total_conversions / combinationVisitors * 100)#%</td>
									<td><cfif isNumeric(total_value)>#total_value#<cfelse>NA</cfif></td>
									<td><cfif isNumeric(total_value)>#decimalFormat(val(total_value) / total_conversions)#<cfelse>NA</cfif></td>
								</tr>
							</cfoutput>
						</cfoutput>

					</table>
				</cfif>
			</div>
		<cfelseif structKeyExists(form, "fieldnames")>
			<br /><br />No Test Data Found
		</cfif>
	</form>
</body>
</html>
