Instructions to generate premium rates and final indexes and inemdnities for Ethiopia contract:
jdw 6-2014
1) Open genLRLDrate in matlab
2) Ensure LRLDbasedata.mat is in same path, and that base NDVI data is in folder called z-scoring_first_CalibratedSeries in same folder. 
3) Ensure that final end season NDVI data is in folder called finalNDVI in same folder.
4) Run code (F5) 

Final rates as well as Final Index and Indemnity/loss rate values are processed in this function and will export those csv's. 

Will export XXXXratefinalxx.csv and, the final rates, for season XXXX = {LRLD SRSD} and trigger level xx
as well as final indemnities (%loss) and final index values as XXXXratefinalIndemxx.csv

Inputs for NDVI are the exact same ones for the Kenya contract, as we use the combined file (Ken + Eth). This file parses out those for Ethiopia contract.


For updating, the only thing that needs to be done once the new NDVI data are placed in teh folder is on lines 4 and 5 of the  genLRLDrate and genSRSDrate files, 
the last year for which data are available for each season needs to be entered (as of 4-11-2014, the last year of data in those files is 2012 for each season).


Final Index values and final indemx based on values in FinalNDVI folder are output to csv in OutCurrentIndex folder.

Shapefile order is the last 10 elements in Ken+Eth shapefile in this folder.

Order of Woredas in output:
COUNTRY		PROVINCE DISTRICT DIVI_WOR IBLI_UNIT 		IBLI_ID

ETHIOPIA	OROMIA	BORANA	ARERO		ARERO		201
ETHIOPIA	OROMIA	BORANA	DHAAS		DHAAS		202
ETHIOPIA	OROMIA	BORANA	DILLO		DILLO		203
ETHIOPIA	OROMIA	BORANA	DIRE		DIRE		204
ETHIOPIA	OROMIA	BORANA	DUDGA DAWA	DUDGA DAWA	205
ETHIOPIA	OROMIA	BORANA	MELKA 		SODAMELKA SODA	206
ETHIOPIA	OROMIA	BORANA	MIYO		MIYO		207
ETHIOPIA	OROMIA	BORANA	MOYALE		MOYALE		208
ETHIOPIA	OROMIA	BORANA	TELTELE		TELTELE		209
ETHIOPIA	OROMIA	BORANA	YABELLO		YABELLO		210
