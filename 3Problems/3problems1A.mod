reset;
set F; # Factories
set M; # Markets

param d {M}>=0; #demand

param vc {F, M}>=0; # variable costs 
param cap {F} >=0; # capcity at each factory

var X{F,M} >=0; # Quantities to be shiped from  Factory F to Market M.

minimize TC: # minimize the total costs.
	sum{f in F, m in M} vc[f,m] * X[f,m];

s.t. demand_const{m in M}:
	sum{f in F} X[f,m] = d[m];
	
s.t. capconst {f in F}:
	sum{m in M} X[f,m] <= cap[f];

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
			
option solver gurobi;			
solve;

display TC;			
			
			
