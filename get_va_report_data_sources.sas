/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 05/07/24     
      Get all Viya VA reports and their data sources
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* If you have a lot of VA reports and a lot of data, you may be
   wondering which data is being used by which VA report. This program
   will help you do that. It uses the VA API to pull down each report ID,
   grab its XML, scan it and find out which data sources are being used.
   
   To use this program, run it in SAS Studio on the Viya server where the VA 
   reports are stored.

                            **** Important ****
   If you increase the limit to a very high value, you may tax the server.
*/

filename resp1 temp; * Response for JSON report list;
filename resp2 temp; * Response for XML;

%let limit = 20; *Limit the number of returned reports;

/* Get reports */
proc http
    url="https://%scan(&_baseurl, -2, /)/reports/reports?limit=&limit" 
    out=resp1
    method='get'
    oauth_bearer=SAS_SERVICES;
run;

libname reports json "%sysfunc(pathname(resp1))";

/* Save every report name and ID to a macro variable */
data _null_;
    set reports.items;

    call symputx(cats('id', _N_), id);
    call symputx(cats('name', _N_), name);
    call symputx('n_reports', _N_);
run;

/* Loop through every ID and macro variable, pull its XML and get its data sources */
%macro get_report_data;

    proc datasets lib=work nolist;
        delete report_data;
    quit;

    %do i = 1 %to &n_reports;
        %let id = &&id&i;
        %let name = &&name&i;
    
        /* Wait a few seconds between each attempt */
        %let rc = %sysfunc(sleep(3, 1));

        proc http
            url="https://%scan(&_baseurl, -2, /)/reports/reports/&id/content" 
            out=resp2
            method='get'
            oauth_bearer=SAS_SERVICES;
        run;

        data tmp;
            length name $100. id caslib table $50.;

            infile resp2 lrecl=32676 length=len;
            input line $varying32767. len;
    
            if(find(upcase(line), '<CASRESOURCE'));
    
            name   = "&name";
            id     = "&id";
            caslib = scan(line, 4, '"');
            table  = scan(line, 6, '"');
    
            drop line;
        run;

        proc append base=report_data data=tmp;
        run;
    %end;
%mend;
%get_report_data;
