/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 05/20/25     
                Reading .tar.gz directly
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    It's not uncommon to find .tar.gz csv or delimited
    files. Typically you'll want to unzip these files and
    then work with them, but with Linux, it's easy to 
    work with them directly in SAS. In this example, we have
    two files:

    1. A .tar.gz file (tarball)
    2. a .zip file with a .gz file inside of it

    Using the pipe filename option, we can stream this
    data directly into a DATA Step.

    This example will not work on Windows.
****************************************************/


/* Specify output directory here */
%let outdir = %sysfunc(getoption(work));

/*********************************************/
/* Setup: Download data to a local directory */
/*********************************************/
%macro download_data(file);
    filename out "&outdir/&file";

    proc http 
        url="https://github.com/stu-code/sas-tips/raw/refs/heads/main/data/&file" 
        out=out 
        method=GET;
    run;
%mend;

%download_data(hmeq.tar.gz);
%download_data(hmeq.zip);

/*********************************************/
/******** Example 1: Reading a tarball *******/
/*********************************************/
filename tarball pipe "tar -xOzf &outdir/hmeq.tar.gz hmeq.csv";

data hmeq;
    infile tarball dsd dlm=',' firstobs=2;
    input BAD LOAN MORTDUE VALUE REASON$ JOB$ YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC;
run;

/*********************************************/
/**** Example 2: Reading a zipped gz file ****/
/*********************************************/

/* - hmeq.zip
        - hmeq.csv.gz
            - hmeq.csv

   Pipe the output of unzip directly into gunzip, then stream the results 
*/
filename zipgz pipe "unzip -p &outdir/hmeq.zip | gunzip -c";

data hmeq2;
    infile zipgz dsd dlm=',' firstobs=2;
    input BAD LOAN MORTDUE VALUE REASON$ JOB$ YOJ DEROG DELINQ CLAGE NINQ CLNO DEBTINC;
run;