# sas-tips

                                         #######          #          ######
                                       ####              # #        #   
                                       ###  ###         #   #       #      
                                        ###   ###      #     #       #####
                                          ###  ###    #########           #
                                       #      ###    #         #          # 
                                        # #####     #           #   ######  
                        
                                                       T I P S 
          Fancy ASCII art until I can do something cool in GIMP (which may never happen at this point)

A collection of SAS examples and tips. All SAS programs are self-contained and will run independently. 
Any programs with an external data dependency are downloaded within the program from the data folder.

Date          | Program       | Description | Tags
------------- | ------------- | ------------|-------
02/13/24 | [max_of_a_character.sas](https://github.com/stu-code/sas-tips/blob/main/max_of_a_character.sas) | Get the max of a character column using CASL, FedSQL and SQL | Data Engineering, SQL, Viya
02/20/24 | [sort_dedupe_with_a_data_step.sas](https://github.com/stu-code/sas-tips/blob/main/sort_dedupe_with_a_data_step.sas) | Both sort and dedupe data using only a DATA Step | Data Engineering, DATA Step
02/27/24 | [fuzzy_left_join_by_time.sas](https://github.com/stu-code/sas-tips/blob/main/fuzzy_left_join_by_time.sas) | Perform a fuzzy left join on two datasets with differing time intervals | Data Engineering, Time Series
03/05/24 | [collapse_a_dataset.sas](https://github.com/stu-code/sas-tips/blob/main/collapse_a_dataset.sas) | Collapse a sparse dataset down to only a single row per by group | Data Engineering, DATA Step 
03/12/24 | [lead_methods.sas](https://github.com/stu-code/sas-tips/blob/main/lead_methods.sas) | 3 ways to create a lead in SAS, plus an efficient DATA Step lead macro | Data Engineering, DATA Step, Lead
03/19/24 | [sastrace.sas](https://github.com/stu-code/sas-tips/blob/main/sastrace.sas) | See what your database is doing when running SAS code against it in only one line of code | Efficiency, Data Engineering, Database
04/02/24 | [solve_lever_puzzle.sas](https://github.com/stu-code/sas-tips/blob/main/solve_lever_puzzle.sas) | Use OPTMODEL to solve the [lever puzzle](https://amnesia.fandom.com/wiki/Machine_Room#Walkthrough) from the 2010 survival horror game, Amnesia: The Dark Descent | Operational Research, Optimization, OR
04/09/24 | [sql_magic.sas](https://github.com/stu-code/sas-tips/blob/main/sql_magic.sas) | Influence the SQL optimizer with magic to improve join performance. Seriously. | Efficiency, Fast, Performance, SQL
04/30/24 | [hash_joins_and_more.sas](https://github.com/stu-code/sas-tips/blob/main/hash_joins_and_more.sas) | Learn how to do ultra fast joins with the DATA Step without needing to sort and more! You'll never join tables the same way again. | DATA Step, Hash, Performance
05/07/24 | [get_va_report_data_sources.sas](https://github.com/stu-code/sas-tips/blob/main/get_va_report_data_sources.sas) | A program that automatically identifies the data sources in Visual Analytics reports on a Viya server | Administration, VA, Visual Analytics, Viya 
05/14/24 | [speedy_stats.sas](https://github.com/stu-code/sas-tips/blob/main/speedy_stats.sas) | Calculate over a dozen statistics on a billion rows of data in seconds | CAS, Data Science, Efficiency, Fast,  Performance, PROCs, Statistics, Viya
05/21/24 | [hpds2.sas](https://github.com/stu-code/sas-tips/blob/main/hpds2.sas) | Run a high-performance version of PROC DS2 with barely any code changes. Run DS2 code over 100% faster! | Data Engineering, DS2, Efficiency, Fast, Performance
05/28/24 | [unique_ids_in_cas.sas](https://github.com/stu-code/sas-tips/blob/main/unique_ids_in_cas.sas) | Create a unique row ID three different ways in CAS | CAS, Data Engineering, Viya
06/04/24 | [sequential_macro_variables.sas](https://github.com/stu-code/sas-tips/blob/main/sequential_macro_variables.sas) | Two ways to dynamically generate sequentially-ordered macro variables with SQL and the DATA Step | Data Engineering, DATA Step, Macro, SQL
06/25/24 | [partitioning_autotuning.sas](https://github.com/stu-code/sas-tips/blob/main/partitioning_autotuning.sas) | Autotune and partition machine learning models in just two lines of code | AI, CAS, Data Science, Machine Learning, Viya
07/23/24 | [sql_remerging_summary_statistics.sas](https://github.com/stu-code/sas-tips/blob/main/sql_remerge_summary_statistics.sas) | NOTE: The query requires remerging summary statistics back with the original data. What does this mean? It's actually one of SAS's coolest SQL features! | Data Engineering, Efficiency, SQL
08/13/24 | [drop_single_value_variables.sas](https://github.com/stu-code/sas-tips/blob/main/drop_single_value_variables.sas) | How to find and drop all variables with too low cardinality from a dataset | CAS, Data Engineering, Data Science, Viya
09/17/24 | [is_null.sas](https://github.com/stu-code/sas-tips/blob/main/is_null.sas) | A macro that determines if a macro variable is either null or non-existent | Data Engineering, Macro
10/01/24 | [minoperator.sas](https://github.com/stu-code/sas-tips/blob/main/minoperator.sas) | How to enable and use the IN operator with macro lists | Data Engineering, Macro
10/08/24 | [genmax.sas](https://github.com/stu-code/sas-tips/blob/main/genmax.sas) | Automatically create backups of your SAS datasets with the genmax dataset option | DATA Step, Data Engineering
01/07/25 | [python_function_integration.sas](https://github.com/stu-code/sas-tips/blob/main/python_function_integration.sas) | Create Python functions in SAS and use them within a DATA Step | DATA Step, Data Engineering, FCMP, Open Source, Python
01/14/25 | [timing_code_runs.sas](https://github.com/stu-code/sas-tips/blob/main/timing_code_runs.sas) | An example of using the [timeit macro](https://github.com/stu-code/sas/blob/master/utility-macros/timeit.sas) to test how fast code runs on average. | Benchmarking, Data Engineering, timeit, Timing
