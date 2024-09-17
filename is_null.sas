/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 09/17/24     
                     is_null Macro
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    If a macro variable does not exist, you'll get an error if you try using it
    in a conditional statement. If your macro variable is null, then it will exist
    but not have a value. Checking in a single statement if a macro variable is either 
    missing or has a null value requires a little bit of work, but the below macro
    makes it extremely easy to cover both situations. Here's how it works:

    %is_null(macrovar): Returns 1 if it is null or if it does not exist, 0 otherwise
    
    Example:

    %macro check;
        %let foo=;

        %if(%is_null(sysuserid)) %then %put sysuserid exists and has a value.;
        %if(%is_null(foo))       %then %put foo exists and has no value;
        %if(%is_null(bar))       %then %put bar does not exist;
    %mend;
    %check;

****************************************************/

/* is_null macro. Add this to your includes */
%macro is_null(macvar);
    %if %symexist(&macvar.) %then %do;
        %sysevalf(%superq(%superq(macvar)) =, boolean)
    %end;
        %else 1
%mend is_null;

/* Let's try using a conditional with a non-existent macro variable */
%macro test1;
    %if(&foo NE) %then %put Foo is not null;
        %else %put Foo is null;
%mend;
%test1;

/* This gives an error. Now let's assign it a null value and see what happens. */
%macro test2;
    %let foo=;
    %if(&foo NE) %then %put Foo is not null;
        %else %put Foo is null;
%mend;
%test2;

/* It works! But let's say we want to cover both situations. This is where
   isnull comes into play. None of these will give an error. */
%macro test3;
    %let bar=;
    %let baz=10;

	%if(%is_null(foo) )    %then %put **** Macro variable foo does not exist;
	%if(%is_null(bar) )    %then %put **** Macro variable bar is null;
	%if(%is_null(baz) = 0) %then %put **** Macro variable notblank has a value;
%mend;
%test3;

/* If you need to check if a macro variable is null, empty, or if it has a value,
   you canuse %is_null(macrovar) instead. */