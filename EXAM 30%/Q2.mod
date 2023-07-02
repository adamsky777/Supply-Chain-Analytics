reset;

#SETS AND INDICES 
set TERMINALS;  	 # 2 terminals
param WEEKS;         # 9-week horizon plan
param PRODUCTS; 	 # 2 product
param VESSELS;		 # 2 vessels

#PARAMETERS
param sales_forecast {1..PRODUCTS, 1..WEEKS, TERMINALS};  			# sales forecast for each product at each terminal in each week
param cap_20000;
param cap_16000;
param unit_value {1..PRODUCTS};				 	 					# value per ton of product p

param inventory_cost_F {1..PRODUCTS};  								# cost of holding one unit of each product
param initial_inventory_F {1..PRODUCTS} >= 0;  						# initial inventory level for each product
param inventory_capacity_F {1..PRODUCTS} >= 0;  					# maximum inventory capacity for each product 
param setup;														# setup time

#PARAMETERS_NEW
param shipping_cost {1..VESSELS, TERMINALS}; 						# cost of shipping of vessel v to terminal t
param vessel_capacity {1..VESSELS};			       					# capacity of vessel v
param inventory_cost_T {1..PRODUCTS, TERMINALS}; 					# cost of holding one unit of each product in inventory per terminal
param initial_inventory_T {1..PRODUCTS, TERMINALS} >= 0;  			# initial inventory level for each product
param inventory_capacity_T {1..PRODUCTS, TERMINALS} >= 0;  			# maximum inventory capacity for each product at each terminal

#DECISION VARIABLES
var production {1..PRODUCTS, 1..WEEKS} integer >= 0;  				# production quantities for product p in week w
var inventory_F {1..PRODUCTS, 1..WEEKS} integer >= 0;  				# inventory level for product p in week w at factory
var Y {1..PRODUCTS, 1..WEEKS} binary;								# if product p is produced in week w
var Z {1..WEEKS} binary;											# if both products are produced in week w

#DECISION VARIABLES_NEW
var inventory_T {1..PRODUCTS, 1..WEEKS, TERMINALS} integer >= 0; 	# inventory level for product p in week w at terminal t
var shipment {1..PRODUCTS, 1..WEEKS, TERMINALS} integer >= 0;  		# shipping quantities for product p in week w to terminal t 
var vessel {1..VESSELS, 1..WEEKS, TERMINALS} integer >=0;			# number of vessels v in week w to terminal t
#var W {1..VESSELS, 1..WEEKS, TERMINALS} binary;					# if shipment is made in week w to terminal t


#OBJECTIVE FUNCTION
maximize NetValue: 
	# production plan
	+ sum {p in 1..PRODUCTS, w in 1..WEEKS} production[p,w] * unit_value[p] * Y[p,w]
	# inventory plan
	- sum {p in 1..PRODUCTS, w in 1..WEEKS} inventory_F[p,w] * inventory_cost_F[p]
	- sum {p in 1..PRODUCTS, w in 1..WEEKS, t in TERMINALS} inventory_T[p,w,t] * inventory_cost_T[p,t]
	# transportation plan
	- sum {v in 1..VESSELS, w in 1..WEEKS, t in TERMINALS} vessel[v,w,t] * shipping_cost[v,t];

# Production Capacity Constraints
#s.t. ProdCap {w in 1..WEEKS}							:	sum {p in 1..PRODUCTS} production[p,w] <= cap_20000 * (1-Z[w]) + cap_16000 * Z[w];
s.t. ProdCapLinkYZ {w in 1..WEEKS}	 					:	Z[w] >= Y[1, w] + Y[2, w] - 1;
s.t. ProdCap {w in 1..WEEKS}							:	sum {p in 1..PRODUCTS} production[p,w] <= cap_20000 - (setup*Z[w]);

# Inventory Constraints at Factory
s.t. InventInitFact {p in 1..PRODUCTS}					: 	inventory_F[p,1] = initial_inventory_F[p] + production[p,1] - sum{t in TERMINALS} shipment[p,1,t];	
s.t. InventEndFact {p in 1..PRODUCTS, w in 2..WEEKS}	:	inventory_F[p,w] = inventory_F[p,w-1] + production[p,w] - sum{t in TERMINALS} shipment[p,w,t];	
s.t. StoreLimitFact {p in 1..PRODUCTS, w in 1..WEEKS}					:	inventory_F[p,w] <= inventory_capacity_F[p];

# Inventory Constraints at Terminal
s.t. InventInitTerm {p in 1..PRODUCTS, t in TERMINALS}					:	inventory_T[p,1,t] = initial_inventory_T[p,t] + shipment[p,1,t] - sales_forecast[p,1,t];	
s.t. InventEndTerm {p in 1..PRODUCTS, w in 2..WEEKS, t in TERMINALS}	:	inventory_T[p,w,t] = inventory_T[p,w-1,t] + shipment[p,w,t] - sales_forecast[p,w,t];
s.t. StoreLimitTerm {p in 1..PRODUCTS, w in 1..WEEKS, t in TERMINALS}	:	inventory_T[p,w,t] <= inventory_capacity_T[p,t];

# Transportation Constraints
s.t. VesselCap {t in TERMINALS, w in 1..WEEKS}			: sum {p in 1..PRODUCTS} shipment[p,w,t] <= sum {v in 1..VESSELS} vessel[v,w,t] * vessel_capacity[v];
#s.t. ShipmentCap {w in 1..WEEKS, v in 1..VESSELS}		: sum {t in TERMINALS, p in 1..PRODUCTS} shipment[p,w,t] <= sum {t in TERMINALS, p in 1..PRODUCTS}  inventory_F[p,w];


# With setup cost


#-----------------------------------------------------------------------------------------------------------
data;

set 	TERMINALS := Adelaide Brisbane;

param 	WEEKS := 9;
param 	PRODUCTS := 2;
param 	VESSELS := 2;

param sales_forecast:=
[*,*,Adelaide]:	1		2		3		4		5		6		7		8		9	:=
		1	4300	2500	2700	5000	4200	3200	3500	5000	4500
		2	1800	1600	1500	3500	9100	1000	7600	7500	9200

[*,*,Brisbane]:	1		2		3		4		5		6		7		8		9	:=
		1	2200	3400	3800	2700	4100	4500	2300	2700	4100
		2	3000	3100	4400	4700	7300	4000	8400	9200	6500;
					
param cap_20000:= 20000;
param cap_16000:= 16000;

param unit_value :=
	1	240
	2	285;
	
param inventory_cost_F :=
				1 8
				2 9;
param initial_inventory_F :=
				1 3700
				2 6500;
param inventory_capacity_F :=
				1 9000
				2 10500;
	
param inventory_cost_T :
	Adelaide	Brisbane :=
1	17			24
2	18			25;
		
param initial_inventory_T :
	Adelaide	Brisbane :=
1	2700		6300
2	3200		3500;

param inventory_capacity_T :
	Adelaide	Brisbane :=
1	10500		7500
2	12500		12000;
				
param setup := 4000; 

param shipping_cost :
		Adelaide	Brisbane  :=
	1	2800000		3700000
	2	2000000		2600000;

param vessel_capacity :=
	1	20000
	2	12000;


				
option solver gurobi;
solve;
display NetValue;
#display sales_forecast[1,9,'Adelaide'];
display production, inventory_F;
#display Y, Z;
display inventory_T;
display shipment;
display vessel;
display sum {v in 1..VESSELS, w in 1..WEEKS, t in TERMINALS} vessel[v,w,t] * shipping_cost[v,t];
#display W;