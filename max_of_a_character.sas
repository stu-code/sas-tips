/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 02/13/24     
            Max of a Character in CAS and SQL
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/              

/* Start a CAS session */
cas;
libname casuser caslib='casuser';

/* Load sample data into CAS */
data casuser.cars;
    set sashelp.cars;
run;

/* Use a CAS action */
proc cas;
    fedql.execDirect /
        query="select max(make) from casuser.cars";
quit;

/* Or, use fedsql directly */
proc fedsql sessref=casauto;
    select max(make)
    from casuser.cars;
quit;

/* It also works with standard SAS SQL */
proc sql;
    select max(make)
    from sashelp.cars;
quit;