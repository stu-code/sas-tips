/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 05/28/24     
             Create a unique row ID in CAS
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Since CAS is massively parallel and multithreaded, the
   traditional way of creating a unique row ID using _N_ or
   the monotonic() function in SQL will not work. Instead, you
   have to account for the fact that you have threaded, parallel
   workers all with their own _N_. This means _N_ can repeat. 
   Thankfully, there are a few very easy ways to create a unique
   row ID. If you have Visual Text Analytics, you have a CAS action
   available to you.
*/

cas;
caslib _ALL_ assign;

/****************************************/
/*************** Option 1 ***************/
/*************** rowid=yes **************/
/****************************************/

/* Use the addrowid=yes option to add your row ID as you load it into CAS */
data casuser.cars(addrowid=yes);
    set sashelp.cars;
run;

/****************************************/
/*************** Option 2 ***************/
/**** uuidgen(), _N_, and _THREADID_ ****/
/****************************************/

/* Create a unqiue ID three ways in CAS:
   1. Use uuidgen() 
   2. Concatenate _N_ with _THREADID_
   3. Use the cantor pairing function for a numeric unique ID:
      cantor(a, b) = 1/2*(a + b)(a + b + 1) + b 

      Idea comes from Bogdan_Teleuca, SAS Communities
      https://communities.sas.com/t5/SAS-Communities-Library/Creating-a-unique-ID-with-CAS-DATA-Step/tac-p/755824/highlight/true#M5796
*/
data casuser.cars;
    length char_id varchar(200)
           uuid    $36.
    ;

    set casuser.cars;

    uuid    = uuidgen();
    char_id = cats(_N_, '_', _THREADID_);
    num_id  = 1/2*(_THREADID_ + _N_)*(_THREADID_ + _N_ + 1) + _N_;
run;


/****************************************/
/*************** Option 3 ***************/
/****** textManagement.generateIDs ******/
/****************************************/

/* With Visual Text Analytics, textManagement.generateIDs will do it for you */
proc cas;
    textManagement.generateIds result=r / 
        table  = {name='cars' caslib='casuser'}
        casout = {name='cars_uniqueid' caslib='casuser'}
        id     = 'unique_id'
    ;
quit;

/* Check that all our IDs are unique with Option 2 */

/* We can use CAS-enabled proc sort with nodupkey */
proc sort data=casuser.cars dupout=casuser.dupes nodupkey;
    by uuid;
run;

proc sort data=casuser.cars dupout=casuser.dupes nodupkey;
    by char_id;
run;

proc sort data=casuser.cars dupout=casuser.dupes nodupkey;
    by num_id;
run;

/* Or we can use or textmanagement.validateIds */
proc cas;
    textManagement.validateIds result=r /
          table={name='cars' caslib='casuser'}
          casout={name='test_dup_uuid' caslib='casuser' replace=True}
          id='uuid'
    ;

    textManagement.validateIds result=r /
          table={name='cars' caslib='casuser'}
          casout={name='test_dup_char_id', caslib='casuser' replace=True}
          id='char_id'
    ;

    textManagement.validateIds result=r /
          table={name='cars' caslib='casuser'}
          casout={name='test_dup_num_id', caslib='casuser' replace=True}
          id='num_id'
    ;
quit;

