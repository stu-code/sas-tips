/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 03/12/24     
                 3 Ways to lead in SAS
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* The coveted 'lead' function does not exist in SAS. But, there are
   a number of easy ways you can do it. Here are three methods to
   generate a lead.
*/

/***************************************
 ******** Method 1: PROC EXPAND ********
 ***************************************/

 /* You can easily perform a lead on any numeric variable with
    PROC EXPAND's lead feature. You do not need a time id for this.
 */

proc expand data=sashelp.air out=air_lead_method1(drop=time);
    convert air=air_lead1 / method=none transform=(lead 1);
    convert air=air_lead2 / method=none transform=(lead 2);
run;

/* It also works with by-groups */
proc expand data=sashelp.stocks out=air_lead_by_method1(drop=time);
    by stock;
    convert close=close_lead1  / method=none transform=(lead 1);
    convert close=close_lead10 / method=none transform=(lead 10);
run;

/***************************************
 ******* Method 2: Sort and lag ********
 ***************************************/

/* This is a traditional 3-step method:
   1. Sort in descending order
   2. Apply a lag
   3. Resort it back to the original order

   This method is more difficult because you have to handle by-groups yourself.
   For every lag you do, you'll want to lag your last by-group variable to check
   and reset it.
*/

proc sort data=sashelp.stocks out=stocks;
    by stock descending close;
run;

data stocks_lead_method2;
    set stocks;
    by stock;

    /* Calculate leads which are really "lags" in this case */
    lead1_close  = lag(close);
    lead10_close = lag10(close);

    /* Keep track of by-variable. If the current value does not match
       the "lead" value, then we know we've entered a new by-group */
    lead1_by  = lag(stock);
    lead10_by = lag10(stock);

    if(stock NE lead1_by)  then call missing(lead1_close);
    if(stock NE lead10_by) then call missing(lead10_close);
run;

proc sort data=stocks_lead_method2;
    by stock close;
run;

/***************************************
 ** Method 3: Data Step (and macro!) ***
 ***************************************/

/* You can actually perform leads with a DATA step
   thanks to some great research done by Andrew Gannon.
   Check ou this paper 3699-2019: 
   Calculating Leads (and Lags) in SAS®: One Problem, Many Solutions 
   https://www.sas.com/content/dam/SAS/support/en/sas-global-forum-proceedings/2019/3699-2019.pdf

   This method makes use of loading a separate dataset and grabbing values one step ahead.
   You can generalize this to be n steps ahead, and even account for by-groups.

   Check out the %lead macro for a generalized version of this:
   https://github.com/stu-code/sas/blob/master/utility-macros/lead.sas
*/

data air_lead_method3;
    set sashelp.air;
    retain dsid;

    /* Open up the same dataset we're in */
    if(_N_ = 1) then dsid = open("sashelp.air");

    /* Fetch _N_+(lead) obs, and pull in a specific variable */
	rc = fetchobs(dsid, _N_+1);
    lead1_air = getvarn(dsid, varnum(dsid, "air"));
    
    rc = fetchobs(dsid, _N_+10);
    lead10_air = getvarn(dsid, varnum(dsid, "air"));

    /* If you have character variables, use getvarc instead */
    drop rc dsid;
run;

/* The macro version of the above. It is highoy performant in many situations and handles:
    - By-groups
    - Any number of lags
    - Any number of variables
    - Any type of variable
    More info: https://github.com/stu-code/sas/blob/master/utility-macros/lead.sas
*/
filename program url 'https://raw.githubusercontent.com/stu-code/sas/master/utility-macros/lead.sas';
%include program;

/* Calculate one lead ahead for one variables */
%lead(data=sashelp.air, out=air_lead_macro1, var=air);

/* Calculate two leads ahead for one variable */
%lead(data=sashelp.air, out=air_lead_macro2, var=air, lead=2);

/* Calculate one lead ahead for two variables, rename them, and add dataset options */
%lead(data=sashelp.stocks(where=(stock='IBM')), out=stocks_lead_macro1, var=open close, rename=open_lead close_lead, lead=10);

/* Calculate 10 leads ahead with a by-group */
%lead(data=sashelp.stocks, out=stocks_lead_by_macro2, var=open, by=stock, lead=10);
