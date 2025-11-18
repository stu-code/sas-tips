/****************************************************
           #######          #          ######
         ####              # #        #   
         ###  ###         #   #       #      
          ###   ###      #     #       #####
            ###  ###    #########           #
         #      ###    #         #          # 
          # #####     #           #   ######  
                                      
                 Tip Tuesday: 11/18/25     
          Creating Groups with Network Analysis
    
    Suppose you have data in which you have two IDs:
    ID1 and ID2. ID1 and ID2 relate to each other, and
    form unique groups. These are your rules:

    - All rows with the same ID1 should have the same value of Group.
    - All rows with the same ID2 should have the same value of Group.
    - The two above conditions have to be combined.  
      For example if A->Z and also B->Z, then all rows 
      with ID1 = A or ID1 = B should have the same value of Group, 
      since they share at least one ID2. Conversely, all rows 
      with ID2 = Y or ID2 = X should have the same value of Group, 
      since they share at least one ID1 (=A).

    Seems like a complex problem, right? This is actually a network problem.
    Instead, we have networks of IDs that are all connected to each other,
    and each one forms its own community. We want to identify the communities.
    We can do this with PROC OPTNETWORK (Viya) and PROC OPTNET (9.4).

    We will treat this problem as an undirected network and output the
    connected components. Solved in just 7 lines!
 
    Not only that, but you can load this into Visual Analytics to see it yourself
    with the Network Analysis node. Simply run the final bit of code and add it
    to a Network Analysis object with the following roles:

    Source: ID1
    Target: ID2
    Color:  Community

    -----------------------------------------------
    Stu Sztukowski | https://linkedin.com/in/StatsGuy
                   | https://github.com/stu-code
****************************************************/

data have;
    input ID1$ ID2$;
    datalines;
A Z
A Y
A X
B Z
B Y
C W
D W
E V
E U
F T
;
run;

/* PROC OPTNETWORK solves this all in one step, and even
   puts the connected components back for you */
proc optnetwork 
    links=have
    direction=undirected
    outlinks=want(rename=(concomp=group));
    connectedcomponents;
    linksvar from=id1 to=id2;
run;

/* Or, you can use PROC OPTNET. You will need to join the
   data back with the original data in order to get the
   groups */
proc optnet 
    links=have
    direction=undirected
    out_nodes=outnodes;
    concomp;
    data_links_var from=id1 to=id2;
run;

proc sql;
    create table want as
    select t1.*, t2.concomp as group
    from have as t1
    left join 
         outnodes as t2
    on t1.id1=t2.node;
quit;

/* Load data to CAS and add this to a Network Analysis node to 
   visualize it */
cas; caslib _ALL_ assign;

data casuser.have(promote=yes);
    input ID1$   ID2$;
    datalines;
A Z
A Y
A X
B Z
B Y
C W
D W
E V
E U
F T
X .
Y .
Z .
W .
V .
U .
T .
;
run;