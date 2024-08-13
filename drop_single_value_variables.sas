/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 08/13/24     
           Drop variables with only one level
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    Sometimes you have really big data and you need to find variables
    that only have a cardinality of one. Other times you want to not
    only find those variables, but drop them entirely from your dataset.
    Here's how you do that using PROC FREQ and PROC CARDINALITY in Viya.
****************************************************/

/* Sample data */
data have;
    set sashelp.cars;
    dropme1 = 'foo';
    dropme2 = 'bar';
    dropme3 = 1;
run;

/* We need ODS output on to get this table, but we do not
   want to actually output anything. This options does that.*/
ods select none;

/* Calculate the cardinality of each variable 
   Alternatively in Viya, you can use PROC CARDINALITY. */
proc freq data=have nlevels;
   tables _ALL_ / noprint;
   ods output nlevels=cardinality;
run;

/* Reset our ODS option */
ods select all;

/* Select all variables with a cardinality of 1,
   save them into a macro variable */
proc sql noprint;
    select tablevar
    into :dropvars separated by ' '
    from cardinality
    where nlevels=1;
quit;

/* Drop the variables we don't want */
data want;
    set have;
    drop &dropvars;
run;

/***********************************************/
/*********** Get cardinality in Viya ***********/
/***********************************************/
cas;
caslib _ALL_ assign;

data casuser.have;
    set sashelp.cars;
    dropme1 = 'foo';
    dropme2 = 'bar';
    dropme3 = 1;
run;

proc cardinality data=casuser.have outcard=casuser.outcard;
run;