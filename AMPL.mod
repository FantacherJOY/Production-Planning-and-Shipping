set CUST;
set PROD;
set PLANT;

param SalePrice{PROD, CUST} >=0 ;
param ProdCost{PROD, PLANT} >=0 ;
param ShipCost{CUST, PLANT} >=0 ;

param LaborHour{PROD, PLANT} >=0 ;
param AvailLaborHour{PLANT} >= 0;
param MachineHour{PROD, PLANT} >=0 ;
param AvailMachineHour{PLANT} >= 0;
param Material{PROD, PLANT} >=0 ;
param AvailMaterial > 0;

param MaxProdSales{PROD, CUST} >=0 ;

param Capacity > 0;

var ProduceP1{PROD, CUST} >= 0;
var ProduceP2{PROD, CUST} >= 0;
var ProduceP3{PROD, CUST} >= 0;

maximize Total_Revenue: sum{i in PROD, j in CUST}
		SalePrice[i,j]*(ProduceP1[i,j]+ProduceP2[i,j]+ProduceP3[i,j])
		- sum{i in PROD}((ProduceP1[i,'H']+ProduceP1[i,'R']+ProduceP1[i,'M'])*ProdCost[i,1]+
		(ProduceP2[i,'H']+ProduceP2[i,'R']+ProduceP2[i,'M'])*ProdCost[i,2]+
		(ProduceP3[i,'H']+ProduceP3[i,'R']+ProduceP3[i,'M'])*ProdCost[i,3])
		- sum{i in PROD, j in CUST}(ProduceP1[i,j]*ShipCost[j,1]
			+ ProduceP2[i,j]*ShipCost[j,2]+ProduceP3[i,j]*ShipCost[j,3]);
		
subject to Labor_Requi_1:
		sum{i in PROD, j in CUST}LaborHour[i,1]*ProduceP1[i,j] <= AvailLaborHour[1];
subject to Labor_Requi_2: 
		sum{i in PROD, j in CUST}LaborHour[i,2]*ProduceP2[i,j] <= AvailLaborHour[2];
subject to Labor_Requi_3:
		sum{i in PROD, j in CUST}LaborHour[i,3]*ProduceP3[i,j] <= AvailLaborHour[3];

subject to Machine_Requi_1: 
		sum{i in PROD, j in CUST}MachineHour[i,1]*ProduceP1[i,j] <= AvailMachineHour[1];
subject to Machine_Requi_2: 
		sum{i in PROD, j in CUST}MachineHour[i,2]*ProduceP2[i,j] <= AvailMachineHour[2];
subject to Machine_Requi_3:
		sum{i in PROD, j in CUST}MachineHour[i,3]*ProduceP3[i,j] <= AvailMachineHour[3];

subject to Material_Req:sum{i in PROD}
		((ProduceP1[i,'H']+ProduceP1[i,'R']+ProduceP1[i,'M'])*Material[i,1]+
		(ProduceP2[i,'H']+ProduceP2[i,'R']+ProduceP2[i,'M'])*Material[i,2]+
		(ProduceP3[i,'H']+ProduceP3[i,'R']+ProduceP3[i,'M'])*Material[i,3])<= AvailMaterial;

subject to Max_Sales{i in PROD, j in CUST}:
		SalePrice[i,j]*(ProduceP1[i,j]+ProduceP2[i,j]+ProduceP3[i,j]) <= MaxProdSales[i,j];
		
subject to Inspection:sum{i in PROD, j in CUST: j != 'M'}
	(ProduceP1[i,j]+ProduceP2[i,j]) <= Capacity;




