reset;

#SETS AND INDICES 
param WEEKS;         # 9-week horizon plan
param PRODUCTS; 	 # 2 products
param TERMINALS;  	 # 2 terminals
param VESSELS;		 # 2 vessels

#PARAMETERS
param sales_forecast {1..PRODUCTS, 1..WEEKS};  				# sales forecast for each product at each terminal in each week
param cap_20000;
param cap_16000;
param unit_value {1..PRODUCTS};				 	 			# value per ton of product p
param inventory_cost {1..PRODUCTS};  						# cost of holding one unit of each product in inventory per terminal
param initial_inventory {1..PRODUCTS} >= 0;  				# initial inventory level for each product
param inventory_capacity {1..PRODUCTS} >= 0;  				# maximum inventory capacity for each product at each terminal
#param setup;												# setup time

#param shipping_cost {1..TERMINALS, 1..VESSELS}; 			# cost of shipping each vessel size to each terminal
#param vessel_capacity {1..VESSELS};			       		# capacity for each terminal and vessel size in each week

#DECISION VARIABLES
var production {1..PRODUCTS, 1..WEEKS} integer >= 0;  		# amount of each product produced at each terminal in each week
var inventory {1..PRODUCTS, 1..WEEKS} integer >= 0;  		# inventory level for each product at each terminal at the end of each week
var Y {1..PRODUCTS, 1..WEEKS} binary;						# if product p is produced in week w
var Z {1..WEEKS} binary;									# if both products are produced in week w

#var shipment {1..WEEKS, 1..TERMINALS, 1..VESSELS, 1..PRODUCTS} >= 0;  	# amount of each product shipped to each terminal by each vessel size in each week

#OBJECTIVE FUNCTION
maximize NetValue: 
	+ sum {p in 1..PRODUCTS, w in 1..WEEKS} production[p,w] * unit_value[p] * Y[p,w]
	- sum {p in 1..PRODUCTS, w in 1..WEEKS} inventory[p,w] * inventory_cost[p];

# Production Capacity Constraints
s.t. ProdCap {w in 1..WEEKS}						:	sum {p in 1..PRODUCTS} production[p,w] <= cap_20000 * (1-Z[w]) + cap_16000 * Z[w];
s.t. ProdCapLinkYZ {w in 1..WEEKS}	 				:	Z[w] >= Y[1, w] + Y[2, w] - 1;

# Inventory Constraints
s.t. InventInit {p in 1..PRODUCTS}					:	inventory[p,1] = initial_inventory[p] + production[p,1] - sales_forecast[p,1];	
s.t. InventEnd {p in 1..PRODUCTS, w in 2..WEEKS}	:	inventory[p,w] = inventory[p,w-1] + production[p,w] - sales_forecast[p,w];
s.t. StoreLimit {p in 1..PRODUCTS, w in 1..WEEKS}	:	inventory[p,w] <= inventory_capacity[p];

# With setup cost
# s.t. ProdCap {w in 1..WEEKS}				:	sum {p in 1..PRODUCTS} production[p,w] <= cap_20000 - (setup*Z[w]);

#-----------------------------------------------------------------------------------------------------------
data;

param WEEKS := 9;
param PRODUCTS := 2;
#param TERMINALS := 2;
#param VESSELS := 2;

param sales_forecast:
	1 		2		3		4		5		6		7		8		9:=
1	6500	5900	6500	7700	8300	7700	5800	7700	8600
2	4800	4700	5900	8200	16400	5000	13000	12500	11000;
					
param cap_20000:= 20000;
param cap_16000:= 16000;

param inventory_cost :=
				1 8
				2 9;

param unit_value :=
	1	240
	2	285;

param initial_inventory :=
				1 3700
				2 6500;

param inventory_capacity :=
				1 9000
				2 10500;
				
#param setup := 4000; 

#param shipping_cost :
#		1			2 :=
#	1	2800000		3700000
#	2	2000000		2600000;

#param vessel_capacity :=
#	1	12000
#	2	20000;


				
option solver gurobi;
solve;
display NetValue;
display production, inventory, Y, Z;