PRO zCum_Percentile , dataPath

;; at the end of the process we have two CSV files : one which includes the cummulated aggreagated scores for full seasons in previous years and the second includes the not-full season scores in this year.  
;; This function unifies the two CSV files into one CSV file and also extract a new CSV file which is the precentile of each score in the temporal distribution of the division.


; - - Define Input Output
inFile=dataPath+'/zCumNDVI_aggregated_eMODIS.csv'
inFile_add=dataPath+'/zCumNDVI_aggregated_eMODIS_ADDITION.csv'
outFile=dataPath+'/zCumNDVI_Percentile.csv'


; - - Read Relevant CSV files.
csvdata =  READ_ASCII(inFile,data_start=2,delimiter=',',HEADER=firstLine)
csvdata_addition = READ_ASCII(inFile_add,data_start=2,delimiter=',',HEADER=firstLine_add)


; - - Combine Channel lists
bndList = strsplit(firstLine(1,*),',',/EXTRACT)
bndList = bndList(2:N_ELEMENTS(bndList)-1) ; get band list
bndListCor = strreplace(bndList,'.00','') ; remove '.00' side effect from the band time if exists
IF (N_ELEMENTS(bndListCor) GT 1) THEN BEGIN
bndList = bndListCor
ENDIF


bndList2 = strsplit(firstLine_add(1,*),',',/EXTRACT)
bndList2 = bndList2(2:N_ELEMENTS(bndList2)-1) ; get band list
bndListCor = strreplace(bndList2,'.00','') ; remove '.00' side effect from the band time if exists
IF (N_ELEMENTS(bndListCor) GT 1) THEN BEGIN
bndList2 = bndListCor
ENDIF






nDivisions = size(csvdata.FIELD01)
nTimes = nDivisions(1)
nDivisions = size(csvdata_addition.FIELD01)
nTimes_add = nDivisions(1) 
nDivisions = nDivisions(2)


IF FILE_TEST(outFile) eq 1 THEN FILE_DELETE, outFile


OPENW, W, outFile, /GET_LUN, width=2000                        ; set width to get all data in one row
PRINTF,W, ';percentile of cummulated Z-scored aggregated data for eMODIS of Kenyan divisions'
PRINTF,W, 'IBLI_UNIT_ID ,'+STRJOIN(bndList2,',')


FOR i=0, nDivisions-1, 1L DO BEGIN
  coData = csvdata.FIELD01(*,i)
  first2Columns = coData(0)
  coData2 = csvdata_addition.FIELD01(*,i)
  zCumNDVIdata = coData(2:nTimes-1)
  zCumNDVIdata2 = [coData(2:nTimes-1),coData2(nTimes:nTimes_add-1)]
  precentiles = percentiles(zCumNDVIdata,value=[0.15,0.30,0.45,0.65])
  zCumNDVIdataPrecentile = zCumNDVIdata2
  zCumNDVIdataPrecentile(where(zCumNDVIdata2 LT precentiles(0)))=1
  for j=1,n_elements(precentiles)-1 do begin
  zCumNDVIdataPrecentile(where((zCumNDVIdata2 LT precentiles(j))and(zCumNDVIdata2 GE precentiles(j-1))))=j+1
  endfor
  zCumNDVIdataPrecentile(where(zCumNDVIdata2 GE precentiles(n_elements(precentiles)-1)))=n_elements(precentiles)+1
  writeline = STRJOIN(STRCOMPRESS(first2Columns,/REMOVE_ALL),',')+','+STRJOIN(STRCOMPRESS(zCumNDVIdataPrecentile,/REMOVE_ALL),',')
  
  printf, W, writeline
  
ENDFOR
CLOSE, W







END