/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 02/27/24     
                Fuzzy left join by time
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Suppose you have two tables: Table 1 collects data every 4-7 seconds, 
   and Table 2 collects data every 2-3 seconds. Chances are you can't 
   merge these by time perfectly, so you need to do a fuzzy join by time. 
   Join them together by the same hour or minute with SQL, then use a HAVING 
   clause that minimizes the time difference. Since it's SQL, you can do as 
   many data transformations as you want all at the same time.
*/