/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 04/09/24     
          Influencing the SQL optimizer with magic
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* SAS has a number of optimized ways that joins can be performed:
        - Index joins
        - Sequential Loop
        - Merge
        - Hash
  You can influence the last three with the SQL "magic" option.
  - magic=101: Sequential loop
  - magic=102: Sort Merge
  - magic=103: Hash join

  Personally, I try to use hash joins whenever possible because memory is cheap
  and plentiful nowadays, so many of my SQL queries contain magic=103. I've used
  it on 500+GB datasets on relatively small machines without any issues at all.
  As always, experiment yourself to see what results you get! For a ton of
  information about these joins and how they work, check out the paper below:

  MWSUG-2012-S109: Add a Little Magic to Your Joins.
  Author: Kirk Paul Lafler
  https://www.mwsug.org/proceedings/2012/S1/MWSUG-2012-S109.pdf
*/

/* Create data in a random group and obs */
data bigdata;
    call streaminit(42);

    do i = 1 to 25000000;
        obs   = rand('integer', 1, 1000000000);
        group = rand('integer', 1, 5);
        value = rand('uniform');
        output;
    end;

    drop i;
run;

/* Get 10 random values */
data smalldata; 
    call streaminit(42);

    if(0) then set bigdata nobs=nobs;

    status = 'Found it!';

    do i=1 to 10;
        n=rand('uniform', 1, nobs); 
        set bigdata point=n;
        output; 
    end;

    stop;

    drop i value;
run;

/*************************************************/
/******** MAGIC=101: Sequential Loop Join ********/
/****** Used under a variety of conditions *******/
/*************************************************/

proc sql magic=101;
    create table magic_101 as 
        select t1.group, t1.obs, t1.value, t2.status
        from bigdata as t1
        INNER JOIN
             smalldata as t2
        ON t1.group=t2.group AND t1.obs=t2.obs;
quit;

/*************************************************/
/********** MAGIC=102: Sort Merge Join ***********/
/**** Good for when data can't fit in memory *****/
/*************************************************/

proc sql magic=102;
    create table magic_102 as 
        select t1.group, t1.obs, t1.value, t2.status
        from bigdata as t1
        INNER JOIN
             smalldata as t2
        ON t1.group=t2.group AND t1.obs=t2.obs;
quit;

/*************************************************/
/************* MAGIC=103: Hash Join **************/
/* Fast option for when you have lots of memory **/
/*************************************************/

proc sql magic=103;
    create table magic_103 as 
        select t1.group, t1.obs, t1.value, t2.status
        from bigdata as t1
        INNER JOIN
             smalldata as t2
        ON t1.group=t2.group AND t1.obs=t2.obs;
quit;

/* For fun, let's see how well a data step hash table does */
data hash;
    set bigdata;

    if(_N_ = 1) then do;
        length status $12.;

        dcl hash lookup(dataset: 'smalldata');
            lookup.defineKey('group', 'obs');
            lookup.defineData('status');
        lookup.defineDone();

        call missing(status, obs);
    end;

    if(lookup.Find() = 0);
run;