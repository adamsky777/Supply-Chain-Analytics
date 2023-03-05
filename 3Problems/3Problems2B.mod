# Problem 2B
reset;

param T; # number of periods

param hc {1..T}; #inventory holding cost peri period.
param d {1..T}; # Demand per period.
param cap {1..T}; # Production cap in period t.
param vc {1..T}; # Variable cost per unit in period t.
param init_inv >=0;
param sc {1..T}; # Setup cost per period t.


var X{1..T} >=0; # Amount to produce in period t.
var I{1..T} >=0; # Inventory level in period t.
var Y{1..T} binary; # takes one if we produce in period t otherwise takes 0.

minimize TC:  sum {t in 1..T} hc[t] * I[t]
			+ sum {t in 1..T} X[t] * vc[t]
			+ sum {t in 1..T} sc[t] * Y[t];



s.t. cap_const {t in 1..T}: 
	X[t] <= cap[t] * Y[t];
	
s.t. Inventory_const {t in 2..T}:
	I[t] = I[t-1]+ X[t] - d[t];
	
	
s.t. Inv_const_first_period:
	I[1] = init_inv + X[1] - d[1];
	
data;

param T:= 8;

param init_inv:= 0;

param hc:=
	1	4
	2	4
	3	4
	4	4
	5	4
	6	5
	7	5
	8	5;
	
	
param vc:=
	1	11
	2	16
	3	13
	4	13
	5	18
	6	17
	7	20
	8	17;
	
param d:=
	1	292
	2	118
	3	321
	4	386
	5	343
	6	452
	7	250
	8	258;
	
	
param cap:=
	1	600
	2	600
	3	600
	4	200
	5	200
	6	700
	7	700
	8	700;
	
	
	
param sc:=
	1	2500
	2	2500
	3	2500
	4	3300
	5	3300
	6	4400
	7	3300
	8	2500;

	
option solver gurobi;

solve;
display TC, X, I ,Y;

# TC = 57880

#    X     I    Y    :=
#1   600   308   1
#2   262   452   1
#3   600   731   1
#4     0   345   0
#5     0     2   0
#6   700   250   1
#7     0     0   0
#8   258     0   1

	
	


