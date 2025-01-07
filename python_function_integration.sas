/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 01/07/25     
          Python Intrgration and FCMP Functions
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    FCMP functions are a great way to create simple, repeatable custom functions
    throughout your SAS programs. Did you know that you can run Python through it
    as well? With a minor amount of setup, you can easily integrate Python into
    your code flow and create complex Python functions that can be called from
    PROC FCMP. For this example, we'll make a simple Leap Year function in both
    SAS and Python, then call them together in a DATA Step.

    Pre-requisites:
        1. You have SAS 9.4M6 or higher
        2. Set the following Environment variables:
            MASM2_PATH: ...\SASHome\SASFoundation\9.4\tkmas\sasmisc\mas2py.py
            MAS_PYPATH: ...\python.exe
        
        These directories are to your SASHome install and your python.exe install, respectively.
        Once you set these environment variables, restart your SAS session.
****************************************************/

/* Determine if it's a leap year:
   1. If the year is a multiple of 4 and not a multiple of 100 OR;
   2. The year is a multiple of 400 */
proc fcmp outlib=work.funcs.date;
   function isLeapYear(date);
        year = year(date);

        if( ( mod(year, 4) = 0 AND mod(year, 100) NE 0 ) OR mod(year, 400) = 0)
            then result = 1;
        else result = 0;

        return(result);
    endfunc;
run;

/* Create a python function that determines if it's a leap year.
   Note that we can import any packages that we want and write any python
   code that we want. We just need to return a result. 

   We can convert from a SAS date to a Python date by adding a time delta
   of the SAS date to Jan 1st 1960. Note that there is very little code formatting
   here because Python is very picky about indents. I don't recommend trying to make
   this look pretty, but you can at least work with carriage returns to help improve
   readability. Also you can simply use the calendar.isleap(year) function, but what's
   the fun in that? */
proc fcmp outlib=work.funcs.date;
function pyIsLeapYear(date);

declare object py(python);
submit into py;

from datetime import datetime, timedelta

def is_leap_year(sas_date):
    "Output: r"
    
    date = (datetime(1960, 1, 1) + timedelta(days=sas_date))

    if (date.year % 4 == 0 and date.year % 100 != 0) or (date.year % 400 == 0):
        result = 1
    else:
        result = 0

    return result
endsubmit;

rc = py.publish();
rc = py.call("is_leap_year", date); 

result = py.results["r"];
return(result);

endfunc;

run;

options cmplib=work.funcs;

/* Let's test it out */
data _null_;
    date = today();

    /* SAS FCMP function */
    if(isLeapYear(date)) then put date year4. ' is a leap year';
        else put date year4. ' is not a leap year';

    /* Python function */
    if(pyIsLeapYear(date)) then put date year4. ' is a leap year and we used Python in SAS';
        else put date year4. ' is not a leap year and we used Python in SAS';
run;