/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 07/08/25     
              My Favorite PROCs: PROC STDIZE
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    PROC STDIZE is used to standardize data, which is
    an important step to do before modeling. You can also
    use it to quickly replace missing values with zeros.
    This prevents you from needing to write a loop to go
    through all of your data and set them as zero. It is also
    significantly more efficient than using SQL or needing to
    make multiple PROC calls to achieve the standardization
    you need.
****************************************************/

/* Sample Data */
data bigwidetable;
    call streaminit(42);
    array x[1000];
    
    do i = 1 to 100000;
        do j = 1 to dim(x);
            if(rand('uniform') < 0.8) then x[j] = rand('exponential', 2);
        end;
        output;
    end;
    
    drop i j;
run;

/* Replace all missing values with zeros */
proc stdize data = bigwidetable
            out  = bigwidetable_zeros
            missing = 0
            reponly;
    var x:;
run;

/* Both standardize and replace missing values with zeros after standardizing */
proc stdize data = bigwidetable
            out  = bigwidetable_zeros_stdize
            method = std
            replace;
    var x:;
run;

/* Standardize all values and ignore missing */
proc stdize data = bigwidetable
            out  = bigwidetable_stdize
            method = std;
    var x:;
run;

/* DATA Step Equivalent of zeros */
data bigwidetable_zeros2;
    set bigwidetable;
    array x[*] x:;

    do i = 1 to dim(x);
        if(x[i] = .) then x[i] = 0;
    end;

    drop i;
run;

/* Manual standard deviation scaling with SQL */
%macro scale;
    proc sql;
        create table bigwidetable_stdize2 as
            select 
            %do i = 1 %to 1000;
                (x&i - mean(x&i))/std(x&i) as x&i
                    %if(&i < 1000) %then %do;    , %end;
            %end;
        from bigwidetable
        ;
    quit;
%mend;
%scale;
