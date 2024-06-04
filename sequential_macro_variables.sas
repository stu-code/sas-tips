/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 06/04/24     
               Sequential macro variables
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Creating sequential macro variables is important if you need to store something
   that may exceed the macro variable length limit. This allows you to create individual
   macro variables that are unique to themselves. Here are two easy ways to do it. 
*/

%macro list_macvars;
    %do i = 1 %to &n_macvars;
        %put macvar&i=&&macvar&i;
    %end;
%mend;

/**************************/
/***** Method 1: SQL ******/
/**************************/

proc sql noprint;
    select model, count(*)
    into :macvar1-, :n_macvars
    from sashelp.cars
    ;
quit;

%put Total macro variableS: &n_macvars;
%list_macvars;

/**************************/
/*** Method 2: DATA Step **/
/**************************/

/* You can also do this with a DATA Step and call symputx() */
data _null_;
    set sashelp.cars;

    /* We use _N_ as our counter. Note that _N_ is the number of iterations of a 
       DATA Step, and you may need to use your own counter if you have a subsetting
       IF statement. */
    call symputx(cats('macvar', _N_), model);

    /* This gets us the total number of macro variables it will update 
       the macro variable with the last value of _N_, which is the last 
       DATA step iteration */
    call symputx('n_macvars', _N_); 
run;

/* What's nice about the DATA Step is that you can do things like subsetting
   if statements to do additional logic and then create your macro variables 
   after that statement */
data _null_;
    set sashelp.cars;

    if(horsepower > 250);
    n+1;

    call symputx(cats('macvar', n), model);
    call symputx('n_macvars', n); 
run;

%put Total macro variableS: &n_macvars;
%list_macvars;