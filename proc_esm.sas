/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 07/01/25     
              My Favorite PROCs: PROC ESM
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    PROC ESM has a secret that you may not know about: if you
    have missing data in a time series, you can intelligently
    interpolate those missing values using one-step ahead forecasts.
    This can give good results, especially if the data is large and
    predictable. All you need to do is use the replacemissing option.
****************************************************/

/* Make some sample data */
data air;
    set sashelp.air;
    
    air_orig = air;

    if(   '01JAN1950'd LE date LE '01DEC1950'd
       OR '01MAY1955'd LE date LE '01NOV1955'd
       OR '01JUL1959'd LE date LE '01MAY1960'd
      )
    then air = .;
run;

/* Interpolate values with one-step ahead forecasts. This model
   and transformation was chosen based on the best model for the data. */
proc esm data=air out=interp lead=0;
    id date interval=month;
    forecast air / replacemissing model=addwinters transform=log;
run;
    
/* Merge data back so we can calculate the error and graph it */
data air_check;
    merge air 
          interp
    ;
    by date;

    if(    '01JAN1950'd LE date LE '01DEC1950'd
        OR '01MAY1955'd LE date LE '01NOV1955'd
        OR '01JUL1959'd LE date LE '01MAY1960'd
      )
    then do;
        abs_error = abs(air - air_orig);
        pct_error = abs_error/air_orig;
        air_orig  = .;
        shade     = 'shade';
    end;
        else air = .;

   /* Prevent line breaks */
    if(date IN('01JAN1950'd, '01DEC1950'd, 
               '01MAY1955'd, '01NOV1955'd, 
               '01JUL1959'd, '01MAY1960'd
              )
      )
    then air_orig = air;

    format pct_error percent8.2;
run;

title  'International Airline Travel';
title2 'Missing Values Interpolated with Exponential Smoothing';

proc sgplot data=air_check;
    label air = 'Interpolated'
          air_orig = 'Original'
    ;

    block  x=date block=shade / novalues nooutline fillattrs=(color=white) altfillattrs=(color=gray transparency=0.75) filltype=alternate;
    series x=date y=air_orig  / break lineattrs=(thickness=4 color=cornflowerblue);
    series x=date y=air       / break lineattrs=(thickness=2 color=darkred);
run;

/* Check the error to compare */
proc means data=air_check mean;
    var abs_error pct_error;
run;