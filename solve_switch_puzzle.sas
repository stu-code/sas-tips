/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 04/02/24     
     Solving the Lever Puzzle in Amnesia: The Dark Descent
    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

/* Amnesia: The Dark Descent is a 2010 survival horror game full of puzzles.
   I was playing this through the first time when I encountered the Lever Puzzle:

       I   V   VI  V   II  II
       |   |   |   |   |   |
       o   o   o   o   o   o
       |   |   |   |   |   |
      III III  V   I   II  IV
   
  The position of the lever in the center can either be up or down. If a
  lever is down, the number on the bottom is activated. If the lever is up,
  the number on the top is activated. The sum of the activated numbers must be 8.
  What's a data scientist to do? Well, I can't be bothered spending time guessing
  and checking. Let's make the computer do that with OPTMODEL. All we need to do
  is translate this puzzle into an optimization problem:

    - Variables: t, b: Binary, indicates whether a lever is activated on the top or bottom
    - Constraint 1: The sum of the activated top levers must be 8
    - Constraint 2: The sum of the activated bottom levers must be 8
    - Constraint 3: b or t must have a value of 1 or 0, and they both can only be in one position
                    In other words: for all levers, b + t = 1
   
  Let's solve it.
*/

proc optmodel;

    /* There are 6 levers */
    set LEVERS init {1..6};

    /* These are the top and bottom values */
    num top{LEVERS} = [3 3 5 1 2 4];
    num bot{LEVERS} = [1 5 6 5 2 2];

    /* Lever positions: top or bottom */
    var   t{LEVERS} binary 
        , b{LEVERS} binary
    ;
    
    con top_con: sum{i in LEVERS} t[i]*top[i]  = 8; /* The top must sum to 8 */
    con bot_con: sum{i in LEVERS} b[i]*bot[i]  = 8; /* The bottom must sum to 8 */ 
    con one_per_row {i in LEVERS}: b[i] + t[i] = 1; /* lever can only be in one position at a time */

    solve;

    /* Print the solution */
    print top t b bot;
run;