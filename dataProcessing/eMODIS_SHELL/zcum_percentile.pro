PRO zCum_Percentile , dataPath

;; at the end of the process we have two CSV files : one which includes the cummulated aggreagated scores for full seasons in previous years and the second includes the not-full season scores in this year.  
;; This function unifies the two CSV files into one CSV file and also extract a new CSV file which is the precentile of each score in the temporal distribution of the division.


; - - Define Input Output
inFile=dataPath+'/zCumNDVI_aggregated_eMODIS.csv'
outFile=dataPath+'/zCumNDVI_Percentile.csv'


; - - Read Relevant CSV files.
csvdata =  READ_ASCII(inFile,data_start=2,delimiter=',',HEADER=firstLine)



; - - Combine Channel lists
bndList = strsplit(firstLine(1,*),',',/EXTRACT)
bndList = bndList(2:N_ELEMENTS(bndList)-1) ; get band list
bndListCor = strreplace(bndList,'.00','') ; remove '.00' side effect from the band time if exists
IF (N_ELEMENTS(bndListCor) GT 1) THEN BEGIN
bndList = bndListCor
ENDIF


nDivisions = size(csvdata.FIELD01)
nTimes = nDivisions(1)
nDivisions = nDivisions(2)
 



IF FILE_TEST(outFile) eq 1 THEN FILE_DELETE, outFile


OPENW, W, outFile, /GET_LUN, width=2000                        ; set width to get all data in one row
PRINTF,W, ';percentile of cummulated Z-scored aggregated data for eMODIS of Kenyan divisions'
PRINTF,W, 'adminID, pixels,'+STRJOIN(bndList,',')


FOR i=0, nDivisions-1, 1L DO BEGIN
  coData = csvdata.FIELD01(*,i)
  first2Columns = coData(0:1)
  zCumNDVIdata = coData(2:nTimes-1)
  precentiles = percentiles(zCumNDVIdata,value=[0.15,0.30,0.45,0.65])
  zCumNDVIdataPrecentile = zCumNDVIdata
  zCumNDVIdataPrecentile(where(zCumNDVIdata LT precentiles(0)))=1
  for j=1,n_elements(precentiles)-1 do begin
  zCumNDVIdataPrecentile(where((zCumNDVIdata LT precentiles(j))and(zCumNDVIdata GE precentiles(j-1))))=j+1
  endfor
  zCumNDVIdataPrecentile(where(zCumNDVIdata GE precentiles(n_elements(precentiles)-1)))=n_elements(precentiles)+1
  writeline = STRJOIN(STRCOMPRESS(first2Columns,/REMOVE_ALL),',')+','+STRJOIN(STRCOMPRESS(zCumNDVIdataPrecentile,/REMOVE_ALL),',')
  
  printf, W, writeline
  
ENDFOR
CLOSE, W







END