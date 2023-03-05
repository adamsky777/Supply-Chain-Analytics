reset;
set F; # Factories
set M; # Markets

param d {M}>=0; #demand

param vc {F, M}>=0; # variable costs 
param cap {F} >=0; # capcity at each factory

param fc {F}; # Fixed cost of factory.


var X{F,M} >=0; # Quantities to be shiped from  Factory F to Market M.
var Y{F} binary; #Binary varaible if we produce at factory F

minimize TC: # minimize the total costs.
	sum{f in F, m in M} vc[f,m] * X[f,m]
	+ sum{f in F} Y[f] * fc[f]; # sum  fixed costs per site if we build.

s.t. demand_const{m in M}:
	sum{f in F} X[f,m] = d[m];
	
s.t. capconst {f in F}:
	sum{m in M} X[f,m] <= cap[f] * Y[f]; # Force the binary to be one if we produce..
	
	

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
			
			
param fc:=
	A	80
	B	90
	C	100;



option solver gurobi;			
solve;

display TC ,Y,X;			
			
			
