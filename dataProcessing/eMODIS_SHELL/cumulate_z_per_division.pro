; _____________________________________________________________________________________________
;
; NAME:
;   CUMULATE_Z_PER_DIVISION
;
; PURPOSE:
;   Cumulate zNDVI for fixed seasons (for different aggregated zNDVI series)
;
; INPUTS:
;   - csv-file with aggregated division-level z-scores for each period (dekad, 15days)
;   - which NDVI series
;
; CONDITIONS USED (otherwise result = mask value):
;   - none
;
; CALLING SEQUENCE:
;   CUMULATE_Z_PER_DIVISION
;
; MODIFICATION HISTORY:
;   Written by:  Anton Vrieling, May 2013
;
; _____________________________________________________________________________________________



PRO CUMULATE_Z_PER_DIVISION  ,dataPath , startYearData , nImagesYear , periodLag , startPeriodLong , numberPeriodsLong , startPeriodShort , numberPeriodsShort

STARTTIME = SYSTIME(1)



; below provide the dataset-specific settings


; access the input csv-file
inFile=dataPath+'/zNDVI_aggregated_eMODIS.csv'
; read data
read = READ_ASCII(inFile,data_start=2,delimiter=',',HEADER=firstLine)
firstLine=firstLine[1]                 ; get rid of description
array=read.(0)
first2Columns=LONG(array[0:1,*])
zNDVIdata=array[2:*,*]
dimensions=size(zNDVIdata)
nTimePeriods=dimensions[1]
nDivisions=dimensions[2]

; define the precise access points (periods) in the file (in IDL-units), and create bandNameList
nYears = CEIL(FLOAT(nTimePeriods)/nImagesYear)            ; number of years to analyse
FOR year = 0, nYears, 1L DO BEGIN                         ; usually it would be till nYears-1, but just to be sure (we subset later)
  ; first create a bandNameList to be subsetted later
  sYear = STRCOMPRESS(year+startYearData,/REMOVE_ALL)
  startPeriodYear = [startPeriodLong,startPeriodShort]+year*nImagesYear-periodLag
  endPeriodYear = [startPeriodLong+numberPeriodsLong,startPeriodShort+numberPeriodsShort]-1+year*nImagesYear-periodLag
  IF year eq 0 THEN BEGIN                  ; do separately to first create the list, and later to update the list
    bandNameList=[sYear+'L',sYear+'S']
    startPeriods = startPeriodYear
    endPeriods = endPeriodYear
  ENDIF ELSE BEGIN
    bandNameList=[bandNameList, sYear+'L',sYear+'S']
    startPeriods = [startPeriods, startPeriodYear]
    endPeriods = [endPeriods,endPeriodYear]
  ENDELSE
ENDFOR
; now subset the above based on whether it fits in the data
index = WHERE(startPeriods ge 0 AND endPeriods lt nTimePeriods, nSeasons)
IF index[0] ne -1 THEN BEGIN
  startPeriods = startPeriods[index]
  endPeriods   = endPeriods[index]
  bandNameList = bandNameList[index]
ENDIF


; create an array to hold z-scores
zCumNDVIdata=FLTARR(nSeasons,nDivisions)

; CALCULATE!!!
FOR season=0,nSeasons-1,1L DO BEGIN
  zNDVIseasonLine = zNDVIdata[startPeriods[season]:endPeriods[season],*]
  cumZNDVIline = TOTAL(zNDVIseasonLine,1)
  zCumNDVIdata[season,*]=cumZNDVIline
ENDFOR

; Write the output to a CSV-file
outFile = dataPath+'/zCumNDVI_aggregated_eMODIS.csv'

IF FILE_TEST(outFile) eq 1 THEN FILE_DELETE, outFile
OPENW, W1, outFile, /GET_LUN, width=2000                        ; set width to get all data in one row
PRINTF,W1, ';Seasonal cumulation of Z-scored aggregated data for eMODIS of Kenyan divisions'
PRINTF,W1, 'adminID, pixels,'+STRJOIN(bandNameList,',')
FOR i=0, nDivisions-1, 1L DO BEGIN
  writeline = STRJOIN(STRCOMPRESS(first2Columns[*,i],/REMOVE_ALL),',')+','+STRJOIN(STRCOMPRESS(zCumNDVIdata[*,i],/REMOVE_ALL),',')
  printf, W1, writeline
ENDFOR
CLOSE, W1


; Evaluation of processing time
ELAPSED_TIME = FIX(SYSTIME(1) - STARTTIME)
MINUTES = ELAPSED_TIME / 60
SECS=ELAPSED_TIME MOD 60
PRINT, 'PROCESSING TOOK :'+STRCOMPRESS(MINUTES)+' MINUTES AND'+STRCOMPRESS(SECS)+' SECONDS'
PRINT, 'FINISHED CUMULATING'

END ;Procedure CUMULATE_Z_PER_DIVISION