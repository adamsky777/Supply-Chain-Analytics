reset;

param D; # Demand (usage rate) per year
param A; # Order costs (Fixed costs per order)
param v; # unit variable costs
param r; # inventory holding rate per year


var Q >= 0; # Order Quanitity unknown

minimize TCR: A*D/Q + v * r * Q/2; # Minimize the Totoal relevant costs
	
s.t. const1: Q>=0; # Non-negativity constraint

# Sample data:
data;

param D:= 1000;
param A:= 200;
param v:= 500;
param r:= 0.10;

option solver Bonmin; # Use open sorce Bonmin solver to solve nonlinear integer problems.
solve;
display Q;

# Output:
# bonmin: Optimal
# Q = 89.4427
#