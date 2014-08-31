PRO zCum_Finalize , dataPath

;; at the end of the process we have two CSV files : one which includes the cummulated aggreagated scores for full seasons in previous years and the second includes the not-full season scores in this year.  
;; This function unifies the two CSV files into one CSV file and also extract a new CSV file which is the precentile of each score in the temporal distribution of the division.


; - - Define Input Output
inFile1=dataPath+'\zCumNDVI_aggregated_eMODIS.csv'
inFile2=dataPath+'\zCumNDVI_aggregated_eMODIS_ADDITION.csv'
outFile1=dataPath+'\zCumNDVI_TOTAL.csv'
outFile2=dataPath+'\zCumNDVI_Percentile.csv'


; - - Read Relevant CSV files.
csv2data =  READ_ASCII(inFile1,data_start=2,delimiter=',',HEADER=firstLine2)
csv1data =  READ_ASCII(inFile2,data_start=2,delimiter=',',HEADER=firstLine1)


; - - Combine Channel lists
bndList1 = strsplit(firstLine1(1,*),',',/EXTRACT)
bndList1 = bndList1(2:N_ELEMENTS(bndList1)-1) ; get band list
bndListCor1 = strreplace(bndList1,'.00','') ; remove '.00' side effect from the band time if exists
IF (bndListCor1) THEN BEGIN
bndList1 = bndListCor1
ENDIF

bndList2 = strsplit(firstLine2(1,*),',',/EXTRACT)
bndList2 = strreplace(bndList2(2:N_ELEMENTS(bndList2)-1),'.00','');
bndListCor2 = strreplace(bndList2,'.00','') ; remove '.00' side effect from the band time if exists
IF (bndListCor2) THEN BEGIN
bndList2 = bndListCor2
ENDIF


nDivisions = size(csv2data.FIELD01)
nDivisions = nDivisions(1)




IF FILE_TEST(outFile1) eq 1 THEN FILE_DELETE, outFile1
IF FILE_TEST(outFile2) eq 1 THEN FILE_DELETE, outFile2
OPENW, W1, outFile1, /GET_LUN, width=2000                        ; set width to get all data in one row
PRINTF,W1, ';TOTAL of cummulated Z-scored aggregated data for eMODIS of Kenyan divisions'
PRINTF,W1, 'adminID, pixels,'+STRJOIN(bndList2,',')

OPENW, W2, outFile2, /GET_LUN, width=2000                        ; set width to get all data in one row
PRINTF,W2, ';percentile of cummulated Z-scored aggregated data for eMODIS of Kenyan divisions'
PRINTF,W2, 'adminID, pixels,'+STRJOIN(bndList2,',')


FOR i=0, nDivisions-1, 1L DO BEGIN
  combinedData = [csv1data.FIELD01(*,i),csv2data.FIELD01(n_elements(csv2data.FIELD01(*,i))-n_elements(csv1data.FIELD01(*,i)),n_elements(csv2data.FIELD01(*,i))-1)]
  first2Columns = combinedData(0:1)
  zCumNDVIdata = combinedData(2:n_elements(combinedData))
  precentiles = percentiles(zCumNDVIdata,value=[0.15,0.30,0.45,0.65])
  zCumNDVIdataPrecentile = zCumNDVIdata
  zCumNDVIdataPrecentile(zCumNDVIdataPrecentile<precentiles(0))=1
  for j=1,n_elements(precentiles) do begin
  zCumNDVIdataPrecentile(where((zCumNDVIdataPrecentile<precentiles(j))and(zCumNDVIdataPrecentile>precentiles(j-1))))=j+1
  endfor
  writeline1 = STRJOIN(STRCOMPRESS(first2Columns,/REMOVE_ALL),',')+','+STRJOIN(STRCOMPRESS(zCumNDVIdata,/REMOVE_ALL),',')
  writeline2 = STRJOIN(STRCOMPRESS(first2Columns,/REMOVE_ALL),',')+','+STRJOIN(STRCOMPRESS(zCumNDVIdataPrecentile,/REMOVE_ALL),',')
  printf, W1, writeline1
  printf, W2, writeline2
ENDFOR
CLOSE, W1
CLOSE, W2






END