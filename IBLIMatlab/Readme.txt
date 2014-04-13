Instructions to generate premium rates and final indexes and inemdnities:

1) Open genLRLDrate in matlab
2) Ensure LRLDbasedata.mat is in same path, and that base NDVI data is in folder called z-scoring_first_CalibratedSeries in same folder. 
3) Ensure that final end season NDVI data is in folder called finalNDVI in same folder.
4) Run code (F5) 

Final rates as well as Final Index and Indemnity/loss rate values are processed in this function and will export those csv's. 

Will export LRLDratefinal10.csv and LRLDratefinal15.csv, the final rates, 
as well as final indemnities (%loss) and final index values as LRLDratefinalIndem10.csv, LRLDratefinalIndem15.csv, and LRLDfinalIndex.csv

Same steps for SRSD.

For updating, the only thing that needs to be done once the new NDVI data are placed in teh folder is on lines 4 and 5 of the  genLRLDrate and genSRSDrate files, 
the last year for which data are available for each season needs to be entered (as of 4-11-2014, the last year of data in those files is 2012 for each season).




