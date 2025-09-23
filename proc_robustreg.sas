/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 09/23/25     
       Regression with Outliers using PROC ROBUSTREG
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    Outliers can be a doozy. You should never remove outliers unless you
    have a very good reason to. And I mean a *good* reason. If you can't, and
    shouldn't, then you need to use a robust regression technique. That's where
    PROC ROBUSTREG shines. It has multiple techniques available to create a robust
    linear regression model. Not only that, but it even tells you what method you
    should use if you might have chosen the wrong one! How cool is that?
    Check out the example below and see what the log says!

    Shoutout to Dr. Aric LaBarr for the original code and lesson!

    Details: https://go.documentation.sas.com/doc/en/pgmsascdc/v_066/casstat/casstat_kclus_overview.htm
****************************************************/

/* Download sample data */
filename workdir "%sysfunc(getoption(work))/growth.sas7bdat";

proc http
    method=get 
    url="https://github.com/stu-code/sas-tips/raw/refs/heads/main/data/growth.sas7bdat" 
    out=workdir;
run;

/* Use the estimation option that ROBUSTREG recommended */
proc robustreg data=growth method=MM plots=all;
    id country;
    model GDP = LFG GAP EQP NEQ / diagnostics leverage;
run;

proc robustreg data=growth plots=all;
    id country;
    model GDP = LFG GAP EQP NEQ / diagnostics leverage;
run;