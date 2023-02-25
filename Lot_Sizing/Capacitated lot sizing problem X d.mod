# Capacitated lot Sizing Problem with two products.
#The model in c) is a starting point for a company that wants to optimise its campaign planning. A campaign means that the company reduces the price of a product in a given period. The price reduction will then lead to increased demand for the given product in the given period.
#Imagine that a campaign implies a price reduction of 10%, and that the corresponding demand then increases by 20%. For simplicity, assume that demand for other periods and other products is not affected.
#Assume that the company has decided to run at most 3 campaigns during the planning horizon (but that it has not been decided for which products and which periods the campaigns will be run).
#Extend the above model so that it will simultaneously suggest a production plan and the products and periods for which the campaigns should be run, so that total profit is maximized



# Problem X d,
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
param sp {1..P};		# Sales price for product p without reduction.
param reduction; 		# price reduction of the campaign / discount.
param booster; 			# demand booster at campaign.
param maxCamp >=0;		# Maximum number of campaign periods.


var X {1..T, 1..P} >=0;	# Amount to produce
var Y {1..T, 1..P} binary; # setup binary variable if we produce product p at period t.
var	I {1..T, 1..P} >=0; # Inventory
var Z {1..T} binary; # Campaign binary varaible for each period.

maximize TotalProfit:
	# revenue = amount sold * price of the product
	# if we run campaing price = salesprice - reduction if we don't run there is no reduction.
	+ sum {t in 1..T, p in 1..P} X[t, p] * (sp[p] - (Z[t] * sp[p] * reduction))
	- sum {t in 1..T, p in 1..P} hc[t, p] * I[t, p] 
	- sum {t in 1..T, p in 1..P} vc[t, p] * X[t, p] 
	- sum {t in 1..T, p in 1..P} sc[t, p] * Y[t, p];
	
s.t. InventoryBalance_Firts_period {p in 1..P}:
	# if we run campaign at the first period the demand must alos increase in the first period.
	I[1, p] = initial_inventory[p] + X[1, p] - (d[1,p] +(Z[1] * d[1, p] *  booster));
	
	
s.t. InventoryBalance_EveryOther_Period {t in 2..T, p in 1..P}:
	# If we un campaign in every other period, the demand must also increase in every other period.
	I[t,p] = I[t-1,p] + X[t,p] - (d[t,p] +(Z[t] * d[t, p] * booster));

s.t. CapacityConstraint {t in 1..T, p in 1..P}:
	X[t, p] <= (k[t] * Y[t, p]) - (st[p] * Y[t,p]);

	
s.t. maxCampaign:
	# Max 3 campaigns allowed.
	 sum{t in 1..T} Z[t] <= maxCamp;


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


param sp:=
		1	35
		2	32;


param initial_inventory:= 

		1	0
		2	0;


param booster:= 1.2;
param reduction:= 0.1;
param maxCamp := 3; 

solve;
display TotalProfit, X, I,Y, Z;

#TotalProfit = 5840200

	
	