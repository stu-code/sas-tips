/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 02/20/24     
            Sort and Dedupe with a DATA Step
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* You can use a hash table to both sort and dedupe with only
   a DATA step */

/* Sorting sashelp.class by Height */
data _null_;

    /* Sets up PDV without loading the table */
    if(0) then set sashelp.class;

    /* Load sashelp.class into memory ordered by Height. Do not remove duplicates. */
    dcl hash sortit(dataset:'sashelp.class', ordered:'yes', multidata:'yes');
        sortit.defineKey('Height');     * Order by height;
        sortit.defineData(all:'yes');   * Keep all variables in the output dataset;
    sortit.defineDone();

    /* Output to a dataset called class_sorted */
    sortit.Output(dataset:'class_sorted');
run;

/* Sorting and de-duping sashelp.class by Height */
data _null_;

    /* Sets up PDV without loading the table */
    if(0) then set sashelp.class;

    /* Load sashelp.class into memory ordered by Height. Do not keep duplicates. */
    dcl hash dedupe(dataset:'sashelp.class', ordered:'yes');
        dedupe.defineKey('Height');     * Order by height;
        dedupe.defineData(all:'yes');   * Keep all variables in the output dataset;
    dedupe.defineDone();

    /* Output to a dataset called class_sorted */
    dedupe.Output(dataset:'class_deduped');
run;