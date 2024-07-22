/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 07/22/24     
               Remerging Summary Statistics
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Ever gotten this note before?

   NOTE: The query requires remerging summary statistics back with the original data

   This means you've selected a column that is not being grouped or sorted. This can
   be a good thing or a bad thing depending on what you're trying to do. In general,
   this is a massively convenient feature of SQL in SAS that can save you a lot of code!
   Let's find out why.
*/

/* Let's say you want to get the average horsepower of every make
   of car. That's a pretty easy query. */
proc sql;
    create table avg_make_horsepower as
        select make, mean(horsepower) as avg_horsepower
        from sashelp.cars
        group by make
    ;
quit;


/* Now suppose we want to compare every model's horsepower to the average 
   horsepower by their make. This means we need to bring in two columns, 
   model and horsepower. But, we don't want to group by make, model, and
   horsepower together. In other flavors of SQL, you would calculate 
   this with a subquery and a join */

proc sql;
    create table avg_horsepower_make_vs_model as
        select t1.make
             , t1.model
             , t1.horsepower
             , t2.avg_make_horsepower
        from sashelp.cars as t1
        LEFT JOIN
             (select make, mean(horsepower) as avg_make_horsepower
              from sashelp.cars
              group by make
             ) as t2
        ON t1.make = t2.make
    ;
quit;

/* In SAS, you don't need to do this. All you need to do is specify the columns 
   that you want in your final table and specify what you want to group by.
   We can get the exact same results with this query below. */
proc sql;
    create table avg_horsepower_make_vs_model as
        select make
             , model
             , horsepower
             , mean(horsepower) as avg_make_horsepower
        from sashelp.cars 
        group by make
    ;
quit;

/* If you look in the log, you'll see that SAS remerged automatically. Cool! 
   But what if you did not want to do this? This message can also serve as
   a warning that you might not be calculating your data the way you expect and
   you should check your columns. */