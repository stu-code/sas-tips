/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 06/24/25     
              My Favorite PROCs: PROC EXPAND
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    PROC EXPAND is as swiss-army knife of series data. You can
    use it for a TON of things, from interpolation to moving sums
    to forward moving averages to LOCF to lags to leads. You can even mix
    and combine multiple operations at once. It's a huge time saver
    that requires very little code to do a ton of things all at once.
    This tip shows a few of my favorite features.

    For all of the things you can do, check out the transformation operations:
    https://go.documentation.sas.com/doc/en/etsug/15.2/etsug_expand_details19.htm
****************************************************/

/* Make some sample data */
data timeseries;
    call streaminit(42);
    do group = 1 to 3;
        do date = '01JAN2024'd to '01FEB2024'd;
            value+1;
            output;
        end;
    end;
    format date date9.;
run;

data missing;
    input value @@;
    datalines;
1 2 3 . . . 4 5 6 . . . 7 8 9
;
run;

/* Do some transformation operations. In one step, we'll do by group:
    - 3 row moving average
    - 3 row forward moving average
    - 5 row centered moving average
    - 5 row moving sum
    - Reverse cumulative sum
    - Percent dif from 3 rows ago
    - Lag
    - Lead
    - Multiple operations at once

    Doing all of this with a DATA Step would be a nightmare
*/
proc expand data=timeseries out=transformations(drop=TIME);
    by group;
    convert value = movave  / method=none transform=(movave 3); /* 3 row moving avg */
    convert value = fmovave / method=none transform=(reverse movave 3 reverse); /* 3 row forward moving avg */
    convert value = cmovave / method=none transform=(cmovave 5);   /* 5 row centered moving avg */
    convert value = movsum  / method=none transform=(movsum 5);    /* 5 row moving sum */
    convert value = rsum    / method=none transform=(reverse sum); /* Reverse cumulative sum */
    convert value = pctdif  / method=none transform=(pctdif 3);    /* Percent dif from 3 rows ago */
    convert value = lag3_value / method=none transform=(lag 3);     /* Lag by 3*/
    convert value = lead3_value / method=none transform=(lead 3);   /* Lead by 3 */
    convert value = lots_of_stuff / method=none transform=(reverse lead 3 movsum 5 ratio 2);
run;

/* We can even convert to different time frequencies */
proc expand data=timeseries out   = to_week
                            from  = day 
                            to    = week
                            align = beginning;
    id date;
    by group;
    convert value / method=aggregate observed=total;
run;

/* Another useful method is Last Observation Carried Forward (LOCF)
   This can be done with the STEP method */
proc expand data=missing out=locf(drop=time);
    convert value = value_locf / method=step;
run;
