/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: xx/xx/xxxx     
   Programmatically Change Visual Analytics Data Sources
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    This tip applies to SAS Viya 2023.07 or higher.

    If you need to regularly change data sources or otherwise perform 
    programmatic operations in Visual Analtyics, the VA API is the way
    to go. You can do a number of operations such as:
        - Copy reports
        - Change data sources
        - Change data roles
        - Add objects to a page
        - And more

    One of the most common tasks people need to do is change a data source.
    The code below will run in SAS Studio and is an easy way to change data
    sources programmatically from SAS. This same JSON payload will work great
    in cURL, Postman, or any application that talks and authenticates with
    your Viya server. You just need to get an OAuth token first. The nice thing
    about doing it in SAS is that SAS can pass a valid token automatically.

    For more information on this, see:

    https://developer.sas.com/rest-apis/visualAnalytics/updateReport

****************************************************/

%let report = REPORT URI HERE;          * URI of the report. Not the name. Get this from Copy Link in VA;
%let folder = OUTPUT FOLDER URI HERE;   * URI of the folder. Not the name. Get this from the /folders/folders endpoint;
%let url    = %sysfunc(getoption(SERVICESBASEURL)); *Automaticaly get the URL from the SAS server;

filename resp temp;

/* Send a JSON payload using the changeData operation from the Visual Analytics API.
   The VA API is located at:
   https://your-viya-server.com/visualAnalytics/reports/{report-uri-here} 

   The parts you need to change are surrounded by stars * and start with "CHANGEME:"
*/
proc http
	url   = "&url/visualAnalytics/reports/&report"
	method = PUT
	out    = resp
	oauth_bearer=sas_services /* Easy OAuth authentication */
	in='
{
    "version": 1,
    "resultFolder": "/folders/folders/&folder",
    "resultReportName": "**** CHANGEME: REPORT NAME GOES HERE ****",
    "resultNameConflict": "replace",
    "operations": [
      {
        "changeData": {
          "originalData": {
            "cas": {
			  "server":  "cas-shared-default",
			  "library": "**** CHANGEME: OLD LIBRARY NAME GOES HERE **** ",
              "table":   "**** CHANGEME: OLD TABLE NAME GOES HERE ****"
            }
          },
          "replacementData": {
            "cas": {
			  "server":  "cas-shared-default",
			  "library": "**** CHANGEME: NEW LIBRARY NAME GOES HERE **** ",
              "table":   "**** CHANGEME: NEW TABLE NAME GOES HERE ****"
            }
          }
        }
      }
    ]
}
'
	;
	headers
		"If-Unmodified-Since"="Fri, 01 Jan 9999 00:00:00 GMT"
		"Content-Type"="application/json"
		"Accept"="application/json";
run;

/* Print the result to the log */
data _null_;
	infile resp;
	input;
	put _INFILE_;
run;