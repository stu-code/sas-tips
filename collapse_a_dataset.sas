/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 03/04/24     
           Collapse a sparse dataset in 5 lines
                 AKA: The Update Trick
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Suppose you have a sparse dataset with by-groups, and
   you need to collapse it down to a single row per group.
   Beyond set, merge and modify, there is a fourth DATA Step statement
   called "update." The properties of the update statement can be
   applied in a neat trick that collapses all of the rows in
   only five lines of code. Though, it could just be all one line
   because SAS ends statements with semi-colons, but c'mon. 
   No one does that.
*/

/**** Sample data ****/
data have;
	input id var1 var2 var3$;
	datalines;
1 .  . a
1 10 . .
1 . 20 .
2 . 40 .
2 30 . .
2 .  . b
3 50 . .
3 .  . c
3 . 60 .
;
run;

/* The Update Trick */
data want;
	update have(obs=0)
		   have;
	by id;
run;

/* But what if you didn't have by-groups? Simply add one.*/

/**** Sample data ****/
data have2;
	array charvar[10] $;

	/* Make characters */
	do i = 1 to 10;
		charvar[i] = byte(96+i);
		output;
		charvar[i] = '';
	end;

	drop i;
run;

/* Add a constant ID column */
data have2_id;
	set have2;
	id = 1;
run;

/* Do the update trick */
data want2;
	update have2_id(obs=0)
		   have2_id;
	by id;

	drop id;
run;
