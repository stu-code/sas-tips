/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 10/21/25     
               The double transpose trick
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    If you have data that looks like this:

    group subgroup   value1 value2
    A     S1         100    200
    A     S2         300    400
    B     S1         500    600
    B     S2         700    800

    And you need to go to this:

    group value1_S1 value2_S2 value1_S1 value2_S2
    A     100       200       300       400
    B     500       600       700       800

    You can use the double transpose trick to resolve this.
    
    First, transpose the data so it is tall:

    Group Subgroup      _NAME_  COL1
    A      S1            value1    510
    A      S1            value2    750
    A      S2            value1    750
    A      S2            value2    730
    B      S1            value1    410
    B      S1            value2    700
    B      S2            value1    530
    B      S2            value2    920

    Then transpose it again, using (_NAME_ subgroup) as the ID,
    delimited by an underscore. This will put together Subgroup
    and _NAME_, then associate it with the transposed value, COL1.

    The double transpose trick is really helpful for this situation!

    Thanks Tom for the help!
    https://stackoverflow.com/questions/64809941/transpose-multiple-variables-to-columns-suffixed-with-dates
****************************************************/

data groups;
    call streaminit(42);

    do group = 'A', 'B', 'C';
        do subgroup = 'S1', 'S2', 'S3';
            value1 = round(rand('integer', 1000), 10);
            value2 = round(rand('integer', 1000), 10);
            value3 = round(rand('integer', 1000), 10);
            output;
        end;
    end;
run;

proc transpose data=groups out=tall;
    by group subgroup;
    var value1-value3;
run;

proc transpose data=tall out=wide(drop=_NAME_) delim=_;
    by group;
    id _NAME_ subgroup;
    var col1;
run;