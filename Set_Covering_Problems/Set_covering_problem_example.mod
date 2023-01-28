reset;

set NODES; # Set of Demand nodes
set FACILITIES; # Set of potential Facilities.


param supply{FACILITIES} >= 0;
param demand{NODES} >= 0;



param cost{FACILITIES} >= 0; # FIXED cost of building and / or running a facility.


var Y{NODES, FACILITIES} binary; # if demand node i covered by facility j.

var X{FACILITIES} binary; # if facility site j is selected (located) = 1
						  # otherwise 0.
	


minimize Total_Costs:
	sum{j in FACILITIES} cost[j] * X[j];

s.t. Const1:
	sum{i in NODES, j in FACILITIES} Y[i,j]* X[j] >=1;
	
	

data;
set NODES := N1, N2, N3, N4, N5, N6, N7, N8, N9;
set FACILITIES := F1, F2, F3;

param cost:=
	F1 120
	F2 150
	F3 90;

option solver gurobi;
solve;
display Total_Costs;