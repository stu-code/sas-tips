/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 09/02/25     
              My Favorite PROCs: PROC TIMESERIES
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    PROC TIMESERIES is an important tool to both analyze
    and prepare time series data. It's one of the first
    steps you want to do before modeling. Not only that,
    but it can help you fill in gaps, do basic interoplation,
    time alignment, spectral analysis, and ensure that 
    all of your series are complete.
****************************************************/

ods graphics on;

/* Get a whole bunch of analyses */
proc timeseries data=sashelp.air plots=all;
    id date interval=month;
    var air;
run;

/* Accumulate from month to year and align to the start. This
   means every SAS date will always be the first of the month.
   This is very convenient for querying. You can set it to either
   the beginning, middle, or end. */
proc timeseries data=sashelp.air out=air_year;
    id date interval   = year 
            accumulate = total 
            align      = beginning
    ;

    var air;
run;

/* PROC TIMESERIES can even sort your time for you with the
   NOTSORTED option. Note that this is very different than
   the NOTSORTED option for BY groups */
proc sql;
    create table citiday_rand as
        select * from sashelp.citiday
        order by rand('uniform')
    ;
quit;

proc timeseries data=citiday_rand out=citiday_ts;
    id date interval   = day 
            setmissing = previous
            notsorted
    ;
    var DCD1M DCP07 DFXWCAN;
run;

/* You can also use it to easily extend a series. For example,
   if you dynamically needed to convert a series to week and 
   extend it by 12 weeks, PROC TIMESERIES can very easily do this */

proc sql noprint;
    select intnx('week', max(date), 12, 'B') format=date9.
    into :end
    from citiday_rand;
quit;

proc timeseries data=citiday_rand out=citiday_extend;
    id date interval   = week
            accumulate = last 
            setmissing = missing
            align      = beginning
            end        = "&end"d
            notsorted
    ;

    /* You can also do different transformations to vars independently */
    var DCD1M;
    var DCP07 / accumulate=average;
    var DFXWCAN / transform=log;
run;