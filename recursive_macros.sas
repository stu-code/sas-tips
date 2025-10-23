/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 10/28/25     
                  Recursion in Macros
    
    Recursion is a concept where a function calls itself.
    In SAS, you typically don't deal with recursion. But, 
    if you wanted to, macro functions can be recursive.
    Here are a few classic examples as well as a real example
    of how recursion works:

    1. Calculating the factorial of a number
    2. Calculating the fibonacci sequence of a number
    3. Creating nested case statements for SQL
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Calculate a factorial using recursion.
   This is the classic computer science intro-to-recursion
   problem. */
%macro factorial(n);
    %if &n = 0 %then %do;
        1
    %end;

    %else %do;
        %eval(&n * %factorial(%eval(&n-1)))
    %end;
%mend;

%put 10! is %factorial(10);

/* Calculate the fibonacci sequence of an number using recursion.
   This is another classic computer science intro-to-recursion
   problem. */
%macro fibonacci(n);
    %if &n = 0 %then %do;
        0
    %end;

    %else %if &n = 1 %then %do;
        1
    %end;

    %else %do;
        %eval(%fibonacci(%eval(&n-1)) + %fibonacci(%eval(&n-2)))
    %end;
%mend;

%put The fibonacci sequence of 10 is %fibonacci(10);

/* Build a nested case statement recursively:
    case when condition1 then value1
        else case when condition then value2
            else case when condition then value3
            end
        end
    end

    This expects name-value pairs in this format:
    condition1 value1
    condition2 value2
    condition3 value3
    etc.
*/
%macro build_case(max, n=1);
    %global case_stmt;

    %if(&n = 1) %then %let case_stmt =;

    %if(&n LE &max) %then %do;
        %let condition = condition&n;
        %let value     = value&n;

        %build_case(&max, n=%eval(&n + 1));

        %if(&n = &max) %then %let else =;
            %else %let else = else;

            %let case_stmt = case when &&condition&n then &&value&n &else &case_stmt end;
    %end;
%mend;

/* Define each condition and value */
%let condition1 = cost < 10;
%let value1     = 'Cheap';

%let condition2 = cost < 100;
%let value2     = 'Affordable';

%let condition3 = cost >= 500;
%let value3     = 'Expensive';

%build_case(3);

%put &case_stmt;

/* Test it out */
data test;
    input cost;
    datalines;
5
50
500
;
run;

proc sql;
    select cost, &case_stmt as type
    from test;
quit;