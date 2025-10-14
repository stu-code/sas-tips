/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 10/14/25     
            My Favorite PROCs: PROC GINSIDE
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code

    PROC GINSIDE is solves a simple sounding problem: is my point
    inside our outside a boundary on a map? It seems easy,
    but the code gets daunting when you attempt to solve it with
    SQL or a DATA Step on your own. GINSIDE makes this incredibly
    simple.

    In the example below, we're going to determine which random
    points in NC fall within a particular census tract. There are
    thousands of census tracts, so trying to find out where each
    one fits is a huge problem. GINSIDE makes quick, easy work of
    this in just a few lines of code.

****************************************************/

/*********************************/
/************* Setup *************/
/*********************************/

/* Download 2024 NC census tracts to a temp directory */
filename dl temp;

proc http
    method=get 
    url="https://www2.census.gov/geo/tiger/TIGER2024/TRACT/tl_2024_37_tract.zip" 
    out=dl;
run;

/* Extract the directory and cd into it to unzip it. 
   I am using Windows, and tar doesn't like long filenames 
   so here is one way to do it without installing other programs */
%let zip_file_path = %qsysfunc(pathname(dl));
%let zip_file  = %scan(&zip_file_path, -1, /\);
%let len_path  = %length(&zip_file_path);
%let len_file  = %length(&zip_file);
%let file_path = %substr(&zip_file_path, 1, %eval(&len_path - &len_file));

x %tslit(cd "&file_path" %nrstr(&&) tar -xf &zip_file);

/* Generate random NC addresses */
data random_addresses;
    call streaminit(42);

    min_lat = 33.7666;
    max_lat = 36.588;
    min_lon = -84.3201;
    max_lon = -75.4129;

    do i = 1 to 100;
        x = round(rand('uniform', min_lon, max_lon), .000001);
        y = round(rand('uniform', min_lat, max_lat), .000001);
        output;
    end;

    keep x y;
run;

/*********************************/
/*********** End Setup ***********/
/*********************************/

/* Import the NC census tracts */
proc mapimport 
    infile="&file_path/tl_2024_37_tract.shp"
    out=nc_census_tracts;
run;

/* Identify only points that fall within a census tract */
proc ginside data = random_addresses 
             map  = nc_census_tracts 
             out  = address_in_census_tract
             insideonly    /* Drop non-matching x/y values */
             includeborder /* Identifies if it's on a border */
             dropmapvars;  /* Only keep the matching geoid */
    id geoid name;
run;