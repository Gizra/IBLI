- - - - 15 / 04 / 2014 - - - - 

this code is intendent to run both on linux enviorment and windows with a unix-like enviroment ( for example : cygwin). 
The system requirements are :

 * An active internet connection.
 * IDL Virtual Machine Installed.

The code checks for new updates from USGS - updates the storage - and runs the entire process up to the csv output.
To run the code you'll need a configuration .txt file , an example for a valid configuration file can be found in this folder.

To run the code you need to run the following command line ( assuming idl VM installed) :

idl -vm=emodisshell.sav -args "config.txt"

where "config.txt" can be any path to a valid configuration file.
emodisshell.sav is the compiled version of the code in this folder.


- - - - 30/04/2014 - - - - 

an example for a dummy configuration file is (as can be seen in this folder the file "config.txt"): 



WorkingFolder=/home/mbrv/tryUNIX/
SUBSET=[ 5300  ,  7200   , 3400, 4300]
map_info = {Geographic Lat/Lon, 1.0000, 1.0000, 33.7889, 5.6265, 2.4130000000e-003, 2.4130000000e-003, WGS-84, units=Degrees}
adminFile = /media/sf_sideProjects/NDVI_NIR/divisionID.img
startYearData = 2013
nImagesYear = 9     
periodLag   =  10   
startPeriodLong = 7 
numberPeriodsLong = 21
startPeriodShort = 28 
numberPeriodsShort = 15 



The configuratio file is indifferent to tab and space 
The different input settings are :

1.  workingFolder - a valid path to a folder which will include the local repository and processed images and output csv files.
2.  SUBSET -  is  the bounding box of the subset NDVI in the total east africa ENVI image coordinates [ULsample, ULline, LRsample, LRline].
3.  map_input - is the mapping information needed to georefference the image.
4.  adminFile - a full path to the administrative file with the administrative division of the area.
5.  startYearData - The first year we want to run the process from , for USGS EMODIS this is usually 2001
6.  nImagesYear - number of images per year. for USGS EMODIS data this is always 36
7.  perioLag - first image of the year - July ( always 1)
8.  startPeriodsLong -  start Period for long rains ( always 7)
9.  numberPeriodsLong - how many periods (10-day) are in the long season (always 21)
10. startPeriodShort - start Period for long rains = 28 (first of October)
11. numberPeriodsShort - how many periods (10-day) are in the short season (always 15)




The Order of operations in the code (already automated) is :

1. update FULL Repository - the code checks if the workingFolder Contains all the base repository. from 2001 up to today. if not it downloads and extract the missing parts. the repository will be at : WorkingFolder/RAW
2. update last month from the updated USGS repository ( a month back is updated because of post-processing USGS does which uses multi-temporal data to clean the images and can effect images that have been already downloaded up to a month back)
3. after repository is completly up-to-date : stack all images together and construct one large multi-temporal image names. the stacked image will be at : WorkingFolder/PROCCESSED/eMODIS_FEWS_Kenya.bil
4. after images are stacked we calculate the seasonal mean and std as well as do a quick diagnostics to through out bad pixels  (mainly low data variance). all those files are save at : WorkingFolder/PROCCESSED/eMODIS_FEWS_Kenya_avg.bil , WorkingFolder/PROCCESSED/eMODIS_FEWS_sd.bil ,WorkingFolder/PROCCESSED/eMODIS_FEWS_dia.bil. after calculating all those we can calculate the normalized zNDVI per pixel. the file is saved at : WorkingFolder/PROCCESSED/eMODIS_FEWS_Kenya_Z.bil
   this part of the codes simply uses the already written function : ZNORMBIL_8BIT.pro 
5. after images are stacked we calculate the aggregated and cumulated data (per devision) . the code does that using the already written functions :  AGGREGATE_Z and CUMULATE_Z_PER_DIVISION - and using the division file given in the configuration file created the wanted CSV files in the folder WorkingFolder/CSV.


this entire process is ran and governed using the compiled code emodisshell.sav which needs only a valid configuration file to run. simply run the following command line on a linux with IDL on it : 


idl -vm=emodisshell.sav -args "config.txt"




For any issue i available in gitHub or by email : mike_brv@hotmail.com

- - - - - - - - - - - - - - - -  15.06.2014 - - - - - - - - - - - - - - - 

How to run the shell ?


1. enter the server (41.204.190.27)
2. go to : "/opt/IBLI/dataProcessing/eMODIS_SHELL/"
3. type : idl -rt=emodisshell.sav -args "config_0905.txt">log.txt

the "config_0905.txt" is the config file and log.txt is the log file to which the output of the code will be written.

4. the code should run now.





