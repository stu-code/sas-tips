/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 05/06/25     
    Quickly Counting Non-missing Values of Character Vars
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    If you need to count non-missing values of character columns,
    you might be tempted to create a loop running count(*) over
    every column: but there's an easier way. By leveraging 
    ODS Output from PROC FREQ, we can get a table that tells
    us exactly how many non-missing values are in every character
    column without needing to write a loop: and it's only 4 lines
    of code.
****************************************************/

/* Create a sample dataset */
data have;
    array category[10] $;

    do i = 1 to 10;
        do j = 1 to dim(category);
            select(mod(i, 3));
                when(1)   category[j] = 'a';
                when(2)   category[j] = 'b';
                otherwise category[j] = 'c';
            end;

            if(i < j) then category[j] = '';
        end;
        output;
    end;

    drop i j;
run;

/* Create a table for every character column, then output the
   OneWayFreqs table that SAS creates under the hood with
   the ods output statement. This table tells us exactly how many
   non-missing values there are for each column. We'll turn off  
   ODS for this so  we do not generate a bunch of ODS Output, 
   but we will still get the underlying table.

   If you have by-groups, simply add it here and modify the remaining SQL.

   You may be wondering why we do not just select the row where cumulative
   percent = 100. The reason is that sometimes it does not always exactly
   equal 100. You could filter it if the value is > 99.99999, but there's
   still a chance that it does not output only one row. It's safer to just
   output the count of all values and sum it up later. */
ods select none;

proc freq data=have;
   tables _CHARACTER_;
   ods output OneWayFreqs=OneWayFreqs(keep=table frequency);
run;

ods select all;

/* Now we can get our final category count */
proc sql;
    create table nonmissing_category_count as
        select substr(table, 7) as var, sum(frequency) as total
        from OneWayFreqs
        group by calculated var
        order by calculated total desc
    ;
quit;