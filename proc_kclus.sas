/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 09/09/25     
              ABC Algorithm with PROC KCLUS
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    How many clusters should I choose? That is the age-old question
    when it comes to k-means clustering. Put 100 data scientists in
    a room with the same dataset and you'll get 100 different clusters.
    Thankfully, SAS has a way to help you figure it out: the ABC algorithm.
    The ABC method estimates the number of clusters for well-separated clusters.
    It uses within-cluster dispersion from the results of clustering as 
    an error measure, making the ABC method independent of the method 
    that is used for clustering. In order to estimate the number of clusters, 
    the ABC method compares the change in the error measure with the 
    change that is expected under an appropriate reference null distribution.

    Details: https://go.documentation.sas.com/doc/en/pgmsascdc/v_066/casstat/casstat_kclus_overview.htm
****************************************************/

/* Use the default ABC cluster selection options to find clusters */
proc kclus data=sashelp.baseball
    standardize=std
    maxclusters=10 
    noc=abc;
    input CrAtBat CrHits CrRuns CrRbi CrBB 
          Team League Division Position Div
    ;
run;

/* Adjust the ABC options for a different cluster selection criterion */
proc kclus data=sashelp.baseball
    standardize=std
    maxclusters=10
    noc=abc(minclusters=3 criterion=all b=10);
    input CrAtBat CrHits CrRuns CrRbi CrBB 
          Team League Division Position Div
    ;
run;