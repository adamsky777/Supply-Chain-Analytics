# Capacitated lot Sizing Problem with two products.
# Problem X b,
reset;

param T; # number of periods
param P; # number of products

param sc {1..T, 1..P}; 	# setup cost
param hc {1..T, 1..P}; 	# holding cost
param d  {1..T, 1..P};	# demand per period
param vc {1..T, 1..P};	# variable cost / unit produced.
param k  {1..T};		# joint production capacity per period
param initial_inventory {1..P} >=0; 
param st {1..P}; 		# setup time


var X {1..T, 1..P} >=0;	# Amount to produce
var Y {1..T, 1..P} binary; # setup binary variable if we produce product p at period t.
var	I {1..T, 1..P} >=0; # Inventory


minimize TotalCost:
	  sum {t in 1..T, p in 1..P} hc[t, p] * I[t, p] 
	+ sum {t in 1..T, p in 1..P} vc[t, p] * X[t, p] 
	+ sum {t in 1..T, p in 1..P} sc[t, p] * Y[t, p];
	
s.t. InventoryBalance_Firts_period {p in 1..P}:
	I[1, p] = initial_inventory[p] + X[1, p] - d[1,p];
	
	
	
s.t. InventoryBalance_EveryOther_Period {t in 2..T, p in 1..P}:
	I[t,p] = I[t-1,p] + X[t,p] - d[t,p];

s.t. CapacityConstraint {t in 1..T, p in 1..P}:
	X[t, p] <= (k[t] * Y[t, p]) - (st[p] * Y[t,p]);

	

data;
param T := 6;
param P :=2;

param sc:	1		2		:=

		1	50000	30000	
		2	50000	30000
		3	50000	30000
		4	50000	30000
		5	50000	30000
		6	50000	30000;
		


param hc:	1	2	:=

		1	2	3	
		2	2	3
		3	2	3
		4	2	3
		5	2	3	
		6	2	3;



param d:	1		2 :=

		1	18000	12000
		2	16000	9000	
		3	18000	12000
		4	15000	8000
		5	13000	14000
		6	11000	16000;
		
param k:= 
		1	40000
		2	40000
		3	40000
		4	40000
		5	40000
		6	40000;
	
	


param vc:	1		2 :=

		1	12		15
		2	12		15	
		3	12		15
		4	12		15
		5	14		18	
		6	14		18;


param st:=
		1	3000
		2	2000;


param initial_inventory:= 

		1	0
		2	0;



solve;
display TotalCost, X, I,Y;

#TotalCost = 2650000	


	
	