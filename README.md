<p align="center">
  <img src="https://github.com/user-attachments/assets/18e0cd3f-362a-485f-9e15-09172c800ba7">
</p>

A collection of SAS examples and tips. All SAS programs are self-contained and will run independently. 
Any programs with an external data dependency are downloaded within the program from the data folder.

Date          | Program       | Description | Tags
------------- | ------------- | ------------|-------
02/13/24 | [max_of_a_character.sas](./max_of_a_character.sas) | Get the max of a character column using CASL, FedSQL and SQL | Data Engineering, SQL, Viya
02/20/24 | [sort_dedupe_with_a_data_step.sas](./sort_dedupe_with_a_data_step.sas) | Both sort and dedupe data using only a DATA Step | Data Engineering, DATA Step
02/27/24 | [fuzzy_left_join_by_time.sas](./fuzzy_left_join_by_time.sas) | Perform a fuzzy left join on two datasets with differing time intervals | Data Engineering, Time Series
03/05/24 | [collapse_a_dataset.sas](./collapse_a_dataset.sas) | Collapse a sparse dataset down to only a single row per by group | Data Engineering, DATA Step 
03/12/24 | [lead_methods.sas](./lead_methods.sas) | 3 ways to create a lead in SAS, plus an efficient DATA Step lead macro | Data Engineering, DATA Step, Lead
03/19/24 | [sastrace.sas](./sastrace.sas) | See what your database is doing when running SAS code against it in only one line of code | Efficiency, Data Engineering, Database
04/02/24 | [solve_lever_puzzle.sas](./solve_lever_puzzle.sas) | Use OPTMODEL to solve the [lever puzzle](https://amnesia.fandom.com/wiki/Machine_Room#Walkthrough) from the 2010 survival horror game, Amnesia: The Dark Descent | Operational Research, Optimization, OR
04/09/24 | [sql_magic.sas](./sql_magic.sas) | Influence the SQL optimizer with magic to improve join performance. Seriously. | Efficiency, Fast, Performance, SQL
04/30/24 | [hash_joins_and_more.sas](./hash_joins_and_more.sas) | Learn how to do ultra fast joins with the DATA Step without needing to sort and more! You'll never join tables the same way again. | DATA Step, Hash, Performance
05/07/24 | [get_va_report_data_sources.sas](./get_va_report_data_sources.sas) | A program that automatically identifies the data sources in Visual Analytics reports on a Viya server | Administration, VA, Visual Analytics, Viya 
05/14/24 | [speedy_stats.sas](./speedy_stats.sas) | Calculate over a dozen statistics on a billion rows of data in seconds | CAS, Data Science, Efficiency, Fast,  Performance, PROCs, Statistics, Viya
05/21/24 | [hpds2.sas](./hpds2.sas) | Run a high-performance version of PROC DS2 with barely any code changes. Run DS2 code over 100% faster! | Data Engineering, DS2, Efficiency, Fast, Performance
05/28/24 | [unique_ids_in_cas.sas](./unique_ids_in_cas.sas) | Create a unique row ID three different ways in CAS | CAS, Data Engineering, Viya
06/04/24 | [sequential_macro_variables.sas](./sequential_macro_variables.sas) | Two ways to dynamically generate sequentially-ordered macro variables with SQL and the DATA Step | Data Engineering, DATA Step, Macro, SQL
06/25/24 | [partitioning_autotuning.sas](./partitioning_autotuning.sas) | Autotune and partition machine learning models in just two lines of code | AI, CAS, Data Science, Machine Learning, Viya
07/23/24 | [sql_remerging_summary_statistics.sas](./sql_remerge_summary_statistics.sas) | NOTE: The query requires remerging summary statistics back with the original data. What does this mean? It's actually one of SAS's coolest SQL features! | Data Engineering, Efficiency, SQL
08/13/24 | [drop_single_value_variables.sas](./drop_single_value_variables.sas) | How to find and drop all variables with too low cardinality from a dataset | CAS, Data Engineering, Data Science, Viya
09/17/24 | [is_null.sas](./is_null.sas) | A macro that determines if a macro variable is either null or non-existent | Data Engineering, Macro
10/01/24 | [minoperator.sas](./minoperator.sas) | How to enable and use the IN operator with macro lists | Data Engineering, Macro
10/08/24 | [genmax.sas](./genmax.sas) | Automatically create backups of your SAS datasets with the genmax dataset option | DATA Step, Data Engineering
01/07/25 | [python_function_integration.sas](./python_function_integration.sas) | Create Python functions in SAS and use them within a DATA Step | DATA Step, Data Engineering, FCMP, Open Source, Python
01/14/25 | [timing_code_runs.sas](./timing_code_runs.sas) | An example of using the [timeit macro](https://github.com/stu-code/sas/blob/master/utility-macros/timeit.sas) to test how fast code runs on average. | Benchmarking, Data Engineering, timeit, Timing
02/25/25 | [saspy_intro.ipynb](./saspy_intro.ipynb) | A brief introduction to using SASPy to build and compare models | Data Science, Data Engineering, Open Source, Python, SASPy
03/04/25 | [saspy_ods_output.ipynb](./saspy_ods_output.ipynb) | How to use ODS Output with SASPy to create graphs out of data and view output from statistical and machine learning models | Data Science, Data Engineering, ODS, Open Source, Python, SASPy
03/11/25 | [saspy_submit.ipynb](./saspy_submit.ipynb) | How to submit arbitrary SAS code in SASPy with sas.submit() | Data Science, Data Engineering, ODS, Open Source, Python, SASPy
04/22/25 | [timestamp_range_filtering.sas](./timestamp_range_filtering.sas) | Efficient (and inefficient) ways to filter timestamps in one dataset based on valid start/end ranges in a lookup dataset | Data Science, Data Engineering, DATA Step, Hash Tables, SQL, Time Series
05/06/25 | [count_nonmissing_char_vars.sas](./count_nonmissing_char_vars.sas) | An easy way to count the number of non-missing values in all character variables | Data Science, Data Engineering, Efficiency, PROC FREQ
05/20/25 | [read_tarball_zip_csv.sas](./read_tarball_zip_csv.sas) | Use the `filename pipe` statement to read .tar.gz files and zipped gz files in Linux | Data Science, Data Engineering, tarball, .tar.gz, zip
06/24/25 | [proc_expand.sas](./proc_expand.sas) | PROC EXPAND tricks to perform lags, leads LOCF, moving averages, forward moving averages, and much more | Data Science, Data Engineering, Lag, Lead, LOCF, PROC EXPAND 
07/01/25 | [proc_esm.sas](./proc_esm.sas) | PROC ESM tricks to perform intelligent interpolation by replacing missing values with one-step ahead forecasts | Data Science, Data Engineering, ESM, Forecasting, Interpolation, PROC ESM
07/08/25 | [proc_stdize.sas](./proc_stdize.sas) | PROC STDIZE will standardize your data efficiently and is needed before using certain types of models. But it's also great for replacing missing values with zeros with little code. | Data Science, Data Engineering, Normalization, Standardization
09/02/25 | [proc_kclus.sas](./proc_kclus.sas) | PROC KCLUS estimates clusters for both interval and nominal data. SAS includes the ABC algorithm to help estimate the number of clusters, making it easier to use than the elbow method. | Clustering, Data Science, Data Engineering, Unsupervised Learning
09/23/25 | [proc_robustreg.sas](./proc_robustreg.sas) | PROC ROBUSTREG is used to perform robust regression in the presence of outliers. This PROC will actually help you choose the best estimation method based on how many leverage points are in your data. | Data Science, Statistics
10/14/25 | [proc_ginside.sas](./proc_ginside.sas) | PROC GINSIDE is a geospatial procedure that finds all points that are inside of a region and returns the region that they are in. It only takes at most 4 lines of code to run. | Data Engineering, Data Science, Geospatial, Geospatial Analytics, Geo
10/21/25 | [double_transpose_trick.sas](./double_transpose_trick.sas) | If you need to go to an ultra wide dataset, then the double-transpose trick is what you need. First you go long. Then you go wide. It's that simple. | Data Engineering, Data Science, Transpose
