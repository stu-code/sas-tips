/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 10/08/24    
                   Generation Numbers
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    SAS datasets have the ability to automatically back themselves up
    with generation numbers. This is a permanent attribute of the SAS dataset.
    Whenever you overwrite the dataset, it will create a backup of that dataset.
    You can control the maximum number of backups with the "genmax=" option
    before it begins to overwrite the oldest dataset.

****************************************************/

/* Create a dataset with a max generation number of 10 */
data overwrite_me(genmax=10);
    do i = 1 to 100;
        value = rand('normal');
        output;
    end;
run;

/* Overwrite it with other data */
data overwrite_me;
    set sashelp.cars;
run;

/* Revert back to the last version */
data overwrite_me;
    set overwrite_me(gennum=-1);
run;

/* Revert to a specific version */
data overwrite_me;
    set overwrite_me(gennum=1);
run;


/* Let's see what happens when we overwrite it 20 times with a max of 10 */
%macro make_data;
    %do i = 1 %to 20;
        data overwrite_me;
            do i = 1 to 100;
                vaue = rand('normal');
                output;
            end;
        run;
    %end;
%mend;
%make_data;

/* Delete all the datasets, including their generations */
proc datasets lib=work nolist;
    delete overwrite_me(gennum=all);
run;

