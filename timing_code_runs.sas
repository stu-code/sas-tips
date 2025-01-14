/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 01/14/25     
                     timeit macro
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    Ever have multiple ways of running your code and want to
    figure out which one is fastest? Test it! The timeit macro
    is inspired by the %%timeit magic function in Jupyter Notebooks.
    This is an easy-to-use function that only requires you to paste
    your code chunks into it. At the end it will print a report
    with the average and standard deviation of all runs in seconds.

    This program will test if a where clause as an output dataset option
    is faster or slower than a where clause directly in a SQL join for
    two SAS datasets. For details, see the header in:
    https://github.com/stu-code/sas/blob/master/utility-macros/timeit.sas
    

****************************************************/

/* Create some test data */
%macro bigloop(n);
    %do i = 1 %to &n;
        sashelp.cars
    %end;
%mend;

data table1;
    set %bigloop(1500);
    if(_N_ LE 500000);
run;

data table2;
    set sashelp.cars;
    where make IN('BMW', 'Audi', 'Porsche');
run;

%macro timeit(trials=100);

    /* If testing macro functions, make sure these are local */
    %local i n t start now;
    %do i = 1 %to 10;
        %local time&i;
        %local desc&i;
    %end;


    %let now = %sysfunc(transtrn(%sysfunc(datetime()), ., %str()));

    %do t = 1 %to &trials;

        %let n = 0; /* Do not change */

     /* Define your code chunks below 

        **** Important ****

        You must increment the variable n with each code chunk. To create 
        a code chunk to test, use this skeleton code:

        %let n = %eval(&n+1);
        %let desc&n = Method 1;
        %let start=%sysfunc(datetime());
            <code>
        %let time&n = %sysevalf(%sysfunc(datetime())-&start); 
     */
        /**** Code 1 ****/
        %let n      = %eval(&n+1);
        %let desc&n = Where dataset option;
        %let start  = %sysfunc(datetime());
           proc sql noprint;
                create table test(where=(make = 'BMW')) as
                    select t1.make, t2.model
                    from table1 as t1
                    join table2 as t2
                    on t1.make = t2.make
                ;
            quit;
        %let time&n = %sysevalf(%sysfunc(datetime())-&start);

        /**** Code 2 ****/
        %let n      = %eval(&n+1);
        %let desc&n = Where clause;
        %let start  = %sysfunc(datetime());
             proc sql noprint;
                create table test2 as
                    select t1.make, t2.model
                    from table1 as t1
                    join table2 as t2
                    on t1.make = t2.make
                    where t1.make='BMW'
                ;
            quit;
        %let time&n = %sysevalf(%sysfunc(datetime())-&start);

        data trial_&now;
            %do i = 1 %to &n;
                time&i = &&time&i;
            %end;
        run;

        proc append base=times_&now data=trial_&now;
        run;
    %end;

    proc sql;
        select mean(time1) as avg_time1 label="Avg (s): &desc1" format=8.3
             , std(time1)  as std_time1 label="Std (s): &desc1" format=8.3
             %do i = 2 %to &n;
             , mean(time&i) as avg_time&i label="Avg (s): &&desc&i" format=8.3
             , std(time&i)  as std_time&i label="Std (s): &&desc&i" format=8.3
             %end;

        from times_&now;
    quit;

    proc datasets lib=work nolist;
        delete trial_&now times_&now;
    quit;

%mend;
%timeit;