/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 05/14/24     
                 The Summary Siblings:
                   Speedy Statistics
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* There are a lot of ways to summarize data in SAS! These are the three
   Summary Siblings that you may not have known about:
      - PROC SUMMARY   | The original standard threaded summary procedure
      - PROC HPSUMMARY | High performance summary that takes advantage of multiple machines and threads
      - PROC MDSUMMARY | Extremely fast, CAS-enabled summary proc

   My opinion: If you are on SPRE or 9.4, use HPSUMMARY on big data.
   If you are on Viya, get that data into CAS and use your favorite summary PROC:
   MEANS, SUMMARY, and MDSUMMARY.

   Let's try it out on a billion rows of data.
*/

cas;
libname casuser cas caslib='casuser';

/* Create a billion random obs drawn from a standard normal distribution */
data billion;
    do i = 1 to 1000000000;
        x = rand('normal');
        output;
    end;
    drop i;
run;

/* Load to CAS */
proc casutil outcaslib='casuser';
    load data=billion;
run;

/* Basic PROC SUMMARY */
proc summary data=billion ;
    var x;
    output out=stats 
        min= max= n= nmiss= mean= sum= std= stderr=
	    var= uss= css= cv= t= prt= skewness= kurtosis=
    / autoname;
quit;

/* High-performance SUMMARY */
proc hpsummary data=billion ;
    var x;
    output out=stats 
        min= max= n= nmiss= mean= sum= std= stderr=
        var= uss= css= cv= t= prt= skewness= kurtosis=
    / autoname;
quit;

/* CAS-powered MDSUMMARY */
proc mdsummary data=casuser.billion;
    var x;
    output out=casuser.stats;
quit;