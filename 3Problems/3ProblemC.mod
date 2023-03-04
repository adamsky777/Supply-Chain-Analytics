reset;
set F; # Factories
set M; # Markets

param d {M}>=0; #demand

param vc {F, M}>=0; # variable costs 
param cap {F} >=0; # capcity at each factory
param min_level{F} >=0;

var X{F,M} >=0; # Quantities to be shiped from  Factory F to Market M.
var Y{F} binary; #Binary varaible if we produce at factory F

minimize TC: # minimize the total costs.
	sum{f in F, m in M} vc[f,m] * X[f,m];

s.t. demand_const{m in M}:
	sum{f in F} X[f,m] = d[m];
	
s.t. capconst {f in F}: # link the production capacity to the binary variable, we only have capacity if we produce at factory f.
	sum{m in M} X[f,m] <= cap[f] * Y[f];

s.t. min_const {f in F}: # if we produce we at factory f we must produce more than the min_level at f factory.
	sum{m in M} X[f,m]  >= Y[f] * min_level[f];


data;
set F :=	A	B	C;
set M := 1	2	3	4;


param  cap :=
	A	100
	B	140
	C	110;
	
param d:=
	1	55
	2	60
	3	35
	4	50;

param vc:		1	2	3	4 :=

			A	7	4	9	6
			B	3	8	5	4
			C	6	5	4	11;


param min_level:=
	A	70
	B	80
	C	75;
			
option solver gurobi;			
solve;

display TC, X, Y;			
			
			