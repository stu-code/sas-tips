/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 04/30/24     
             Hash Joins, Lookups and more
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Hash tables are an extremely powerful tool in SAS that can be used to 
   perform ultra-fast joins, arbitrarily traverse them, build in-memory tables, output them, 
   and much more.  The simplest use case of a hash table is using it to look up one or more values
   and pull them down into the DATA Step. The beauty of a hash table is that you do
   do not need to pre-sort your data when joining and you get to use all the power of the 
   DATA Step without complex sets of SQL CASE statements or doing a bunch of separate steps to
   get what you need. Think of a hash table as this in-memory table that floats in space. 
   It's independent of the data that you're reading from in a set or merge statement. 
   The hash table has two important values:

   1. Keys - This is the lookup value or set of values that you need to match in your dataset
   2. Data - This is the data that will be pulled from your hash table down into the data step and vis-versa

   With these two things, you can do some seriously powerful stuff.

   It also has a very important default property that you should not forget:
   
   ***** Hash tables will remove any duplicate keys and keep the first unique set of keys *****

   We won't worry too much about that for now. Just keep it in mind.  
   To get your feet wet, we'll start with the most basic usage of hash tables: joins

   Hash joins are awesome because of how ludicrously fast they are. You don't need to 
   pre-sort your data. You can just join it right there. Hash tables are best used 
   in SPRE and *not* in CAS. CAS is ludicrously fast already, doesn't need sorting,
   and is multi-threaded. Running a hash table in CAS will cause the hash table to be
   replicated for every thread. It's just simply not needed there. But for things 
   in SPRE or 9.4? Use them to your heart's desire.

   What this covers:
        1. Starting simple: The Hash Lookup
        2. The Hash Inner Join
        3. The Hash Left Outer Join
        4. Hash Dataset Options
        5. Multiple Keys
        6. Big Joins
        7. Big tables and hashexp
        8. Non-unique keys
*/

/******************************************/
/******************************************/
/** 1. Starting simple: The Hash Lookup ***/
/******************************************/
/******************************************/

/* Let's first create our sample data. We'll start off simple and use sashelp.cars for
   a lookup. We want to identify the make from a small list of unique models. Note that
   these models are all unique. This is important. Hash tables remove duplicate keys by default,
   which can be a good thing if you are doing a lookup with a big table full of duplicates. 
   We'll talk about how to handle that at the end. */

data have;
    set sashelp.cars;
    keep model;
run;

data lookup;
    set sashelp.cars(obs=50);
    keep make model;
run;

data left;
    set have;

    /* We only want to define the hash table once. Without this if statement,
       it reloads every observation unnecessarily. You need to load it once. */
    if(_N_ = 1) then do;

        /* You must define all key and data variables used in your hash table or it will error.
           Many people do the "if(0) then set data" trick. I do not like this because it will
           force LOCF and could cause invalid values to carry forward. I prefer to define 
           my variables myself or use a macro to get the lengths for me. */
        length make $20.; 

        dcl hash lookup_model(dataset: 'lookup'); /* Declare a hash table called 'get_model' */
            lookup_model.defineKey('model'); /* Define the lookup key variable */
            lookup_model.defineData('make'); /* Define the data we want to pull from the hash table */
        lookup_model.defineDone(); /* We're done defining the hash table */

        call missing(make); /* Prevents 'variable uninitialized' warnings */
    end;

    /* For every observation, check the value of Model in the data step table against the value of
       Model in the hash table. If we find it, it gives us a return code of 0. If we don't, it gives
       us another number. */

    rc = lookup_model.Find();

    /* Instead of a return code, you can also create a simple indicator */
    model_found = (lookup_model.Find() = 0);

    /* Because we're outputting every value, this is effectively 
       a left join. It's that easy! */
run;

/******************************************/
/******************************************/
/********* 2. The Hash Inner Join *********/
/******************************************/
/******************************************/

/* Let's take advantage of that return code. Let's do an inner-join */
data inner;
    set have;

    if(_N_ = 1) then do;
        length make $20.; 

        dcl hash lookup_model(dataset: 'lookup');
            lookup_model.defineKey('model'); 
            lookup_model.defineData('make'); 
        lookup_model.defineDone(); 

        call missing(make); 
    end;

    /* We can use an if-without-then to prevent processing non-matching values. 
       The higher up this is, the faster your program will run */
    if(lookup_model.Find() = 0);
run;

/******************************************/
/******************************************/
/****** 3. The Hash Left Outer Join *******/
/******************************************/
/******************************************/

/* To do a left outer join, simply output when Find() is not 0. But in this case,
   we're going to do something a little special. defineData is optional. We're going
   to omit it. Since we want to only output when there is no match in the hash table,
   we can't actually pull anything from it. Instead, we're going to use a more efficient
   method called Check(). It's similar to Find(), except it does not pull down a value.
   It simply checks if the value of the key(s) in your set statement exist in your hash table */
data left_outer;
    set have;

    if(_N_ = 1) then do;
        dcl hash lookup_model(dataset: 'lookup');
            lookup_model.defineKey('model'); 
        lookup_model.defineDone(); 
    end;

    /* Only output non-matching values. Find() will return a non-zero number, which
       will cause this if statement to be true and continue to the implied output
       statement at the run boundary. */
    if(lookup_model.Check());

    /* This also works */
    /* if(lookup_model.Check() NE 0); */
run;

/* Why is this all so helpful? Because you're no longer limited to creating
   complex SQL logic or multiple steps to do what you want. You can do your
   join and take full advantage of the DATA Step's features. You can even
   do a lookup from one hash table, pull down the value, and use that value
   to lookup another hash table!
*/

/******************************************/
/******************************************/
/******** 4. Hash Dataset Options *********/
/******************************************/
/******************************************/

/* Hash tables fully support dataset options. You can add as many as you want. A
   common one is to use a where statement on your hash table. This way you do not 
   need to duplicate it. Note that we do not even need to define data here. It's
   completely optional. We can just look up the model. Since we already filtered it
   to BMWs, we know that we're only outputting BMWs */
data bmw_only;
    set have;

    if(_N_ = 1) then do;
        dcl hash lookup_model(dataset: 'sashelp.cars(where=(make="BMW"))');
            lookup_model.defineKey('model'); 
        lookup_model.defineDone(); 
    end;

    if(lookup_model.Check() = 0);
run;

/******************************************/
/******************************************/
/************ 5. Multiple Keys ************/
/******************************************/
/******************************************/

/* You can add as many key values and data items as you want. You are not
   limited to only one. Simply add them with a comma and a quote. */
data want;
    set sashelp.cars(keep=make model);

    if(_N_ = 1) then do;
        dcl hash h(dataset: 'sashelp.cars');
            h.defineKey('make', 'model');
            h.defineData('msrp', 'horsepower', 'mpg_city', 'mpg_highway');
        h.defineDone();

        /* This automatically declares each numeric variable so we do not need to use
           a length statement */
        call missing(msrp, horsepower, mpg_city, mpg_highway);
    end;

    /* Do a lookup on the combination of (make, model). If they both match, pull the data
       from the hash table. */
    rc = h.Find();

    /* Only keep this variable for debugging */
    drop rc;
run;

/******************************************/
/******************************************/
/************** 6. Big Joins **************/
/******************************************/
/******************************************/

/* This is where hash tables really shine. Big joins can be done exceptionally fast using hash tables.
   You don't need to sort anything. It can be totally randomly ordered. You'll find the performance
   is pretty darn good even if you try to load the big hash table into memory. But be careful - 
   if your table is too big, you can risk disk thrashing as the table goes in and out of virtual
   memory for lookups */
   
/* Create 100M rows of data in a random group and obs (this might take a bit) */
data bigdata;
    call streaminit(42);

    do i = 1 to 100000000;
        obs   = rand('integer', 1, 2147483647);
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

data smalldata_inner;
    set bigdata;

    if(_N_ = 1) then do;
        length status $12.;

        dcl hash lookup(dataset: 'smalldata');
            lookup.defineKey('group', 'obs');
            lookup.defineData('status');
        lookup.defineDone();

        call missing(status);
    end;

    if(lookup.Find() = 0);
run;


/******************************************/
/******************************************/
/***** 7. Big hash tables and hashexp *****/
/******************************************/
/******************************************/

/* What if you have two relatively big tables and you need to join them? 
   If you've got the memory, go for a hash table. Whenever
   you are working with large hash tables, there's a special argument
   that you want to use: hashexp. It ranges from 0 to 20 and defaults at 8.
   I won't get into the details of what this does, but just know that it may 
   improve performance at the cost of some more memory. Experiment yourself 
   with different values and see how it does. If you're interested in what  
   this option does, I highly recommend reading this webpage:
   https://sasnrd.com/sas-run-time-hash-object-hashexp-size/
*/

data kinda_big_data; 
    set bigdata;
    if(_N_ LE 10000000);

    status = 'Found it!';
run;

/* Let's use the default value and see how long it takes */
data kinda_big_data_left_hashexp8;
    set bigdata;

    if(_N_ = 1) then do;
        length status $12.;

        dcl hash lookup(dataset: 'kinda_big_data');
            lookup.defineKey('group', 'obs');
            lookup.defineData('status');
        lookup.defineDone();

        call missing(status);
    end;

    if(lookup.Find() = 0);
run;

/* Now let's increase the value of hashexp and see how long it takes */
data kinda_big_data_left_hashexp20;
    set bigdata;

    if(_N_ = 1) then do;
        length status $12.;

        dcl hash lookup(dataset: 'kinda_big_data', hashexp:20);
            lookup.defineKey('group', 'obs');
            lookup.defineData('status');
        lookup.defineDone();

        call missing(status);
    end;

    if(lookup.Find() = 0);
run;

/******************************************/
/******************************************/
/********** 8. Non-unique Keys ************/
/******************************************/
/******************************************/

/* When you load a hash table, it automatically dedupes the data.

   This means your hash table always has unique keys within it.
   Let's see what happens when we load Make from sashelp.cars into
   a hash table and then output its contents
*/

data _null_;
    if(0) then set sashelp.cars;

    if(_N_ = 1) then do;
        dcl hash h(dataset: 'sashelp.cars');
            h.defineKey('make');
        h.defineDone();
    end;

    /* The Output() method lets us output the contents of a hash table 
       to a SAS dataset */
    h.Output(dataset: 'check_it_out');
run;

/* But it's not in order. Let's fix that. We can use the ordered:'yes' argument. */
data _null_;
    if(0) then set sashelp.cars;

    /* Values values of ordered are "yes," "ascending," and "descending." "yes" and
       "ascending" do the same thing */
    if(_N_ = 1) then do;
        dcl hash h(dataset: 'sashelp.cars', ordered:'yes'); 
            h.defineKey('make');
        h.defineDone();
    end;

    h.Output(dataset: 'check_it_out_ordered');
run;

/* Whoa! Does that mean you just sorted and deduped using only a DATA Step?
   It sure does! Wait...that seems familiar...
   https://github.com/stu-code/sas-tips/blob/main/sort_dedupe_with_a_data_step.sas
*/

/* What if we want to keep all of our keys anyway? Use the multidata:'yes' argument. */
data _null_;
    if(0) then set sashelp.cars;

    if(_N_ = 1) then do;
        dcl hash h(dataset: 'sashelp.cars', ordered:'yes', multidata:'yes'); 
            h.defineKey('make');
        h.defineDone();
    end;

    h.Output(dataset: 'check_them_all_out');
run;