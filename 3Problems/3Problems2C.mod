# Problem 2B
reset;

param T; # number of periods
param P; # number of products

param hc {1..T, 1..P}; #inventory holding cost peri period.
param d {1..T, 1..P}; # Demand per period.
param cap {1..T}; # Production cap in period t.
param vc {1..T, 1..P}; # Variable cost per unit in period t.
param init_inv {1..P} >=0;
param sc {1..T, 1..P}; # Setup cost per period t.


var X{1..T, 1..P} >=0; # Amount to produce in period t.
var I{1..T, 1..P} >=0; # Inventory level in period t.
var Y{1..T, 1..P} binary; # takes one if we produce in period t otherwise takes 0.

minimize TC:  sum {t in 1..T, p in 1..P} hc[t,p] * I[t,p]
			+ sum {t in 1..T, p in 1..P} X[t,p] * vc[t,p]
			+ sum {t in 1..T, p in 1..P} sc[t, p] * Y[t,p];



s.t. cap_const {t in 1..T ,p in 1..P}:
	 X[t,p]  <= cap[t] * Y[t,p];
	
s.t. cap_const2 {t in 1..T}: 
	sum{p in 1..P} X[t,p]  <= cap[t];
	
s.t. Inventory_const {t in 2..T, p in 1..P}:
	I[t,p] = I[t-1,p] + X[t,p] - d[t,p];
	
	
s.t. Inv_const_first_period {p in 1..P}: 
	I[1,p] = init_inv[p] + X[1,p] - d[1,p];
	

	 
	
data;

param T:= 8;
param P:= 2;


param init_inv:= 
		1	0
		2	0;

param hc:
		1	2 :=
		
	1	4	3
	2	4	3
	3	4	3
	4	4	3	
	5	4	3	
	6	5	3
	7	5	3
	8	5	3;
	
	
param vc: 
		1	2 :=
	
	1	11	12
	2	16	12
	3	13	12
	4	13	12
	5	18	12
	6	17	12
	7	20	12
	8	19	12;
	
param d:
		1	2 :=
		
	1	292 100
	2	118 100
	3	321 100
	4	386 100
	5	343 200
	6	452 200
	7	250 200
	8	258 200;
	
	
param cap:=
	1	600
	2	600
	3	600
	4	200
	5	200
	6	700
	7	700
	8	700;
	
	
	
param sc:
		1		2 :=
	1	2500	5000
	2	2500	5000
	3	2500	5000
	4	3300	5000
	5	3300	5000
	6	4400	5000
	7	3300	5000
	8	2500	5000;

	
option solver gurobi;

solve;
display TC, X, I ,Y;




