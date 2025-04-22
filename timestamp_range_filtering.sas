/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 04/22/25     
       Efficiently filtering time series with ranges
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* If you have a large time series that needs to be filtered to valid ranges,
   you have a few options available to you. For example, consider two datasets:
   
   1. A time series dataset which holds timestamps of events
   2. A range dataset which holds start/end times of valid events

   You need to filter the time series dataset to only the valid ranges
   within the range dataset. SQL is not going to cut it: in fact, it may
   crash your server. Instead, you need to use a DATA Step with timestamp-based
   logic to easily filter your dataset to only valid start/end ranges. Here's 
   the basic idea:

   1. The time series dataset is sorted in ascending order by timestamp
   2. The range dataset is sorted in ascending order by start
   3. Check the timestamp with the start/end range. If it's > than the end, get the next range.
   4. If the timestamp is between the start/end range, output
   5. Continue until the end of the dataset

   Let's take a look at all three ways you can achieve this.
*/


/* Create a relatively good-sized time series dataset */
data timeseries;
    format timestamp datetime.;
    do timestamp = intnx('dtyear', datetime(), -2) to datetime();
        output;
    end;
run;

/* Create a random set of ranges */
data ranges;
    call streaminit(42);
    format start end datetime.;

    do timestamp = intnx('dtyear', datetime(), -2) to datetime() by 7200;
        start = timestamp - rand('integer', 1, 600);
        end   = start + rand('integer', 1, 1800);
        output;
    end;

    drop timestamp;
run;

/* Option 1: Hash table + hash iterator
   Benefits: Fast, sorting the range table is done for you by the hash table.
   Downside: More code to write, range table must fit in memory, very large range tables may be slow to load */
data timeseries_filtered_hash;
    set timeseries;
    retain start end rc;

    if(_N_ = 1) then do;
        format start end datetime.;
        dcl hash range(dataset: 'ranges', ordered: 'yes');
            range.defineKey('start', 'end');
            range.defineData('start', 'end');
        range.defineDone();

        dcl hiter iter('range');

        call missing(start, end);

        /* Get the first value from the hash table */
        rc = iter.first();
    end;

    /* If we'ved to a new run, get the next timestamp */
    if(timestamp > end) then rc = iter.next();

    /* Only output if there's a value and the timestamp is between start/end */
    if(rc = 0 and start <= timestamp <= end) then output;

    drop rc start end;
run;

/* Option 2: Double-set statement.
   Benefits: Fast, less code, data is always on-disk
   Downside: Range data must be sorted in a separate step if it is not already */
proc sort data=ranges;
    by start;
run;

data timeseries_filtered_set;
    set timeseries;
    retain start end;

    /* If we'ved to a new run, get the next timestamp */
    if( ( _N_ = 1 OR timestamp > end) AND p <= n_ranges) then do;
        p+1;
        set ranges point=p nobs=n_ranges;
    end;

    /* Only output if the timestamp is between start/end */
    if(start <= timestamp <= end) then output;

    drop start end;
run;

/* Option 3: SQL
   Benefits: Very straight forward, standard SQL code
   Downside: Slow and not scalable for even medium-sized datasets 

                   *********** WARNING *********** 
   An obs filter is applied so you can see how slow it is on even small data. 
   This is EXTREMELY computationally expensive if you remove the obs filter.
   With the obs filter, SQL will have to compare 100,000 x 10,000 (1 BILLION) obs.
   Without the obs filter, SQL will have to compare over 700 BILLION obs, so it will
   probably never finish on your machine. Try at your own risk. */
proc sql;
    create table timeseries_filtered_sql as
        select timestamp
        from timeseries(obs=100000) as t
        left join
             ranges as r
        on t.timestamp between r.start AND r.end
    ;
quit;

/* For fun, let's compare the set vs. hash datasets to be sure they're the same */
proc compare base    = timeseries_filtered_hash 
             compare = timeseries_filtered_set;
run;