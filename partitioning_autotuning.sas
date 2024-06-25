/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 06/25/24     
           Partitioning and Autotuning ML models
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Partitoning and autotuning in Viya can be done all in a single step.
   With the default values, you can save a lot of time by simply specifying
   "autotune;" and still get good results. Remember that it is important
   to only autotune when you split into at least a training and validation dataset,
   otherwise you risk overfitting the model.

   **** IMPORTANT ****
   Splitting into training and validation datasets is not deterministic. If you
   reload the data or change the number of compute nodes for the data, you will
   get different results. You can solve this by creating your training/validation
   partitions first, then saving them as a part of the dataset. You can specify
   your validation and test datsets within the partition statement:
   
   partition role=GroupVar(test='Group 1' train='Group 2')

   To create these initial partitions, use PROC PARTITION first.
*/

cas;
caslib _ALL_ assign;

/* Load data */
filename data http 'https://raw.githubusercontent.com/sassoftware/sas-viya-dmml-pipelines/master/data/hmeq.csv';

proc import 
    file=data
    out=casuser.hmeq
    dbms=csv
    replace;
run;

proc gradboost data=casuser.hmeq;
    partition fraction(validate=0.3 seed=42);
    autotune;
    target bad / level=nominal;
    input loan mortdue value yoj derog delinq clage ninq clno debtinc;
    input reason job / level=nominal;
run;

/* Train, partition, and autotune a fully connected neural network */
proc nnet data=casuser.hmeq;
    train outmodel=casuser.nnet_model;
    partition fraction(validate=0.3 seed=42);
    autotune;
    target bad / level=nominal;
    input loan mortdue value yoj 
     	  derog delinq clage ninq clno debtinc
    ;
    input reason job / level=nominal;
run;

/* Partitioning ahead of time and then passing it into a partition statement.
   1 = Train
   0 = Validate */
proc partition data=casuser.hmeq partind samppct=70 seed=42;
    output out=casuser.hmeq_partition;
run;

proc gradboost data=casuser.hmeq_partition;
    partition role=_PartInd_(train='1' validate='0');
    autotune;
    target bad / level=nominal;
    input loan mortdue value yoj derog delinq clage ninq clno debtinc;
    input reason job / level=nominal;
run;
