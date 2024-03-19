/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 03/19/24     
          SASTrace - your window into SAS/ACCESS
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* When you establish a connection to an external database with an ACCESS engine,
   SAS is translating as much of your code as possible into that database's language.
   If you pass an unsupported function, SAS will pull the entire database table over
   to your machine or server for processing. If this is a huge table, this can be a
   *big* problem for you and your IT admin. You can potentially crash the server!
   Not that I did that a bunch of times or anything...

   You can find out if you're using an unsupported function by using the most useful
   line of code you may ever run into in SAS:

        options sastrace=',,,d' sastraceloc=saslog;

   Check the log. If you see this:
   
        ACCESS ENGINE: SQL statement was not passed to the DBMS, SAS will do the processing.

   Stop the query and find out what's causing this issue. 
   Go to your DB specific SAS/ACCESS supported function reference page 
   and find out what functions are supported. Documentation:
   https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/acreldb/p1lp99cyhab6e3n1wp6ohbpz0z5e.htm
   
   The options I most recommend when working with an external DB:

   1. Use a "where" statement, filter your data as much as possible, only use
      supported functions, then do the rest of the processing in SAS

      OR

   2. Use SQL passthrough to run SQL directly on the database and let
      the database do all the work

   The sqlite database in this program will simulate an external database, and you can see the 
   effects of using the sastrace option by viewing the log. This will not give the ACCESS ENGINE
   note as shown above, but I encourage you to try different unsupported functions to see what it returns.

   There are a number of things you can do with sastrace. Check out all the rest of the options here:

   https://documentation.sas.com/doc/en/pgmsascdc/9.4_3.5/acreldb/n0732u1mr57ycrn1urf24gzo38sc.htm

   ---------------------------------------------------------------
   PRE-REQUISITE: Download the SQLite3 ODBC driver below:
                  http://www.ch-werner.de/sqliteodbc/

                  Use the 64-bit version if you have 64-bit SAS
                  Use the 32-bit version if you have 32-bit SAS

   Sample database provided by David Tippett:
   https://github.com/dtaivpp/car_company_database
   ---------------------------------------------------------------
*/

/******************************************/
/****************** Setup *****************/
/******************************************/

/* Download the database to the WORK directory*/
filename db temp;

proc http
    method=get 
    url="https://github.com/stu-code/sas-tips/raw/main/data/Car_Database.db" 
    out=db;
run;

/* Establish a sqlite odbc connection */
libname sqlite odbc 
    sql_functions=ALL /* Enable more functions, but the database may not understand it correctly */
    complete="dsn=SQLite3 Datasource; 
              Driver={SQLite3 ODBC Driver}; 
              Database=%sysfunc(pathname(db))"
    ;

/******************************************/
/************ sastrace=',,,d' *************/
/**** SQL conversion and preparation ******/
/******************************************/

/* Turn on sastrace to view detailed logs on how the SQL statement is being converted by SAS */
options sastrace=',,,d' sastraceloc=saslog;

proc sql noprint;
    create table car_parts as
    select count(part_id) as total_parts
    from sqlite.car_parts;
quit;

/* You can even check what it does with a data step. Here, you'll see that 
   it passes the where statement to filter the data first, but it will do 
   the rest of the processing in SAS. */
data want;
    set sqlite.car_parts;
    where manufacture_end_date > '01JAN2015'd;

    /* Unsupported function */
    manufacture_end_month = intnx('month', manufacture_end_date, 0, 'B');

    format manufacture_end_month monyy.;
run;

/******************************************/
/************ sastrace=',,,s' *************/
/********** Summary Statistics ************/
/******************************************/

/* You can do other things, like get summary statistics */
options sastrace=',,,s' sastraceloc=saslog;

data want;
    set sqlite.dealers;
    flag = (dealer_name = 'Joes Autos');
run;

/* You can also avoid translating SAS code entirely by using SQL passthrough.
   When using SQL passthrough, write everything in parentheses below in the 
   database's specific language */
proc sql;
    connect using sqlite;

    create table want2 as
        select *
        from connection to sqlite
            (select count(part_id) as total_parts
             from Car_Parts
            )
    ;

    disconnect from sqlite;
quit;