# Problem 2A
reset;

param T; # number of periods

param hc {1..T}; #inventory holding cost peri period.
param d {1..T}; # Demand per period.
param cap {1..T}; # Production cap in period t.
param vc {1..T}; # Variable cost per unit in period t.
param init_inv >=0;


var X{1..T} >=0; # Amount to produce in period t.
var I{1..T} >=0; # Inventory level in period t.

minimize TC: sum{t in 1..T} hc[t] * I[t]
			+ sum{t in 1..T} X[t] * vc[t];



s.t. cap_const {t in 1..T}: 
	X[t] <= cap[t];
	
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
	
option solver gurobi;

solve;
display TC, X, I ;

# TC = 38890
#:    X     I     :=
#1   460   168
#2     0    50
#3   600   329
#4   200   143
#5   200     0
#6   452     0
#7   250     0
#8   258     0
	
	
	


