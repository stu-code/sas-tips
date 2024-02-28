/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 02/27/24     
                Fuzzy left join by time
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Suppose you have two tables: Table 1 collects data every 4-7 seconds, 
   and Table 2 collects data every 2-3 seconds. Chances are you can't 
   merge these by time perfectly, so you need to do a fuzzy join by time. 
   Join them together by the same hour or minute with SQL, then use a HAVING 
   clause that minimizes the time difference. Since it's SQL, you can do as 
   many data transformations as you want all at the same time.
*/

/* Read data: GPS and Heartrate data */
filename gps http 'https://raw.githubusercontent.com/stu-code/sas-tips/main/data/GPS.csv';
filename hr  http 'https://raw.githubusercontent.com/stu-code/sas-tips/main/data/HEARTRATE.csv';

/* GPS Data */
proc import
    file = gps
    out  = gps
    dbms = csv
    replace;
run;

/* Heartrate data */
proc import
    file = hr
    out  = hr
    dbms = csv
    replace;
run;

/* Fuzzy merge heartrate data with GPS data by time. Left-join them by the minute
   and find the closest timestamp that matches. */
proc sql;
    create table want(drop=dif) as
        select distinct gps.*, hr.bpm, abs(gps.timestamp - hr.timestamp) as dif
         from gps
         LEFT JOIN
              hr
         ON dhms(datepart(gps.timestamp), hour(gps.timestamp), minute(gps.timestamp), 0)
          = dhms(datepart(hr.timestamp), hour(hr.timestamp), minute(hr.timestamp), 0)
         group by gps
         having dif = min(dif)
         order by gps.timestamp
    ;
quit;