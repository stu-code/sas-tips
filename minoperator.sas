/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 10/01/24    
               minoperator and mindelimiter
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    You've probably run into this before: you have a list of macro variables like this:
    %let macrolist = a b c;

    You need to determine if 'a' is in the list. Why is there no IN operator?!
    Actually, there is. You just need to turn it on! There are two ways to do this:

    1. A system option
    2. A macro option

    I usually set the system option as always enabled because I use it so often:

    options minoperator
            mindelimiter=' '
    ;

    minoperator: Says to treat "IN" as an operator
    mindelimiter: What the delimiter should be for the IN operator

    Let's go through some scenarios

****************************************************/

options minoperator 
        mindelimiter=' '
;

%macro spaces;
    %let list = a b c;
    
    %if(a IN &list) %then %put a is in the list;

    /* Prefix it with the NOT operator to negate */
    %if(NOT (d IN &list) ) %then %put d is NOT in the list;

    /* You can also use this with %eval */
    %if(%eval(d IN &list) = 0) %then %put d is NOT in the list;
%mend;
%spaces;

/* What if your macro list contains spaces or pipes? You can control it
   with the mindelimiter option. You can override this on a per-macro basis. */
%macro pipes / mindelimiter='|';
    %let list = a|b|c;

    %if(a IN &list) %then %put a is in the list;

    /* Prefix it with the NOT operator to negate */
    %if(NOT (d IN &list) ) %then %put d is NOT in the list;

    /* You can also use this with %eval */
    %if(%eval(d IN &list) = 0) %then %put d is NOT in the list;
%mend;
%pipes;

/* Commas require some special attention. Commas indicate additional 
   arguments in functions. If you use it in %eval, SAS will error out.
   You need to quote the list with %str in this case. I highly recommend
   avoiding using commas as the macro delimiter unless absolutely necessary.
   Use spaces or pipes instead.  */
%macro commas / mindelimiter=',';
    %let list = a,b,c;

    %if(a IN &list) %then %put a is in the list;

    %if(NOT (d IN &list) ) %then %put d is NOT in the list;

    %if(%eval(d IN %str(&list)) = 0) %then %put d is NOT in the list;

%mend;
%commas;