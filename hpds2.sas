/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 05/21/24     
                  High Performance DS2
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* There is a high-performance version of PROC DS2 called
   PROC HPDS2. This scales well across multiple cores and 
   machines in a grid environment. The Performance option
   will let you specify your grid environment as well as the
   number of threads you wish to run. If you're on a single machine,
   you can still take advantage of it as it will create multiple copies
   of the DS2 program for the threads that you have available. The best part?
   You hardly need to change your code.

   Let's run some computationally-expensive stuff: regex. We're going to   
   look at all the ways Shakespeare says "love" in all of his plays and find
   every line in which he uses some form of the word "love." For example:
   "lovely," "lover," "lovers," etc. We can accomplish that with this regex:

    \b(lov\w*)\b

    We'll compare it with DS2 and HPDS2 to see which is faster.
*/

filename resp temp;

/* Download all of Shakespeare's works */
proc http 
    url='https://ocw.mit.edu/ans7870/6/6.006/s08/lecturenotes/files/t8.shakespeare.txt'
    out=resp
    method=get;
run;

/* Read every line into a SAS dataset */
data shakespeare;
    infile resp length=len;
    input line $varying32767. len;
    line = strip(line);
run;

/* Find love */
proc ds2;
    data love_lines_ds2(overwrite=yes);
        method run();
            dcl package pcrxfind love('/\b(lov\w*)\b/');
            set shakespeare;

            if(love.match(line) > 0);
        end;
    enddata;
    run;
quit;

/* Find love faster */
proc hpds2 data=shakespeare out=love_lines_hpds2;
    performance cpucount=6;

    data DS2GTF.out;
        method run();
            dcl package pcrxfind love('/\b(lov\w*)\b/');
            set DS2GTF.in;

            if(love.match(line) > 0);
        end;
    enddata;
    run;
quit;
