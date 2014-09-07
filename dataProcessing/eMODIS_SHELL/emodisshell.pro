FUNCTION Url_Callback, status, progress, data

 

   ; print the info msgs from the url object

   ;PRINT, status

 

   ; return 1 to continue, return 0 to cancel

   RETURN, 1

END

 



PRO eModisShell , settingsFilePath

;; This code runs automatticaly the entire eModis process with the following steps :

;; 1 - check for new data from USGS
;; 2 - if exists download and extract it.
;; 3 - create bil file with full temporal data 
;; 4 - calculate per pixel temporal : mean , std , zNDVI and diagnostics.
;; 5 - aggregate per administrative regions the zNDVI scores.
;; 6 - cumulate per administrative region per seasone the aggregated zScores.



;; Input :
;;  settingFilePath : a path to a txt file which includes all the nesseceray setting to this code . an example  :
;; - - - - - - - Example for a settingFile - - - - - - ;;
;;  WorkingFolder = "c:\IBLI\"
;;  SUBSET=[ 5300  ,  7200   , 3400   , 4300]
;; - - - - - - - End of Example - - - - - - - - - -- - ;;


;; Output :
;; The outputs are updated CSV files.


;; - - - - Step 0 : Read Input File - - - -
tempsettingsFilePath = command_line_args(count=nparams)
IF (nparams GE 1) THEN BEGIN
settingsFilePath = tempsettingsFilePath
ENDIF

IF ((nparams LT 1) and (settingsFilePath EQ '')) THEN BEGIN
  print, 'Please Enter a valid file'
  STOP
ENDIF

IF FILE_TEST(settingsFilePath) EQ 0 THEN BEGIN
    print , 'Could not find the settings File in the path specified . . . '
    STOP
ENDIF





OPENR, lun, settingsFilePath, /GET_LUN
line = ''
WHILE NOT EOF(lun) DO BEGIN & $
  READF, lun, line & $
  ;print,line
  
  if (strpos(line,'=') GT 1) then begin
  
print,strmid(line,0,strpos(line,'='))
    print,strmid(line,strpos(line,'=')+1,strlen(line)-strpos(line,'='))
    
  if NOT(KEYWORD_SET(dataStruct)) then begin
    dataStruct = create_struct(strtrim(strmid(line,0,strpos(line,'=')),2),strtrim(strmid(line,strpos(line,'=')+1,strlen(line)-strpos(line,'=')),2))
  endif else  begin
    tmpStruct = create_struct(strtrim(strmid(line,0,strpos(line,'=')),2),strtrim(strmid(line,strpos(line,'=')+1,strlen(line)-strpos(line,'=')),2))
    dataStruct = struct_addtags(dataStruct,tmpStruct)
  endelse
    
    
  
  
  
  ;WAIT,5
  
  ;suc = EXECUTE(line)
;  IF suc NE 1 THEN BEGIN
    ;print, 'Check your settings file to be in the format requested . . .'
    ;STOP
  ;ENDIF 
  endif
ENDWHILE
; Close the file and free the file unit
FREE_LUN, lun

IF NOT(tag_exist(dataStruct,'WorkingFolder')) THEN BEGIN
    print, 'Check your settings file to be in the format requested . . . (Seems like the WorkingFolder was not defined)'
    STOP
ENDIF ELSE BEGIN
    WorkingFolder=dataStruct.WorkingFolder 
ENDELSE

;IF NOT(tag_exist(dataStruct,'MatlabFolder')) THEN BEGIN
    ;print, 'Check your settings file to be in the format requested . . . (Seems like the MATLAB was not defined)'
    ;STOP
;ENDIF ELSE BEGIN
    ;WorkingFolder=dataStruct.WorkingFolder 
;ENDELSE


IF NOT(tag_exist(dataStruct,'SUBSET')) THEN BEGIN
    print, 'Check your settings file to be in the format requested . . . (Seems like the SUBSET was not defined)'
    STOP
ENDIF ELSE BEGIN
    data = strsplit(dataStruct.SUBSET,'[',/EXTRACT)
    data = strsplit(data,']',/EXTRACT)
    data = strsplit(data,',',/EXTRACT)
    SUBSET = UINT(data)
ENDELSE

IF NOT(tag_exist(dataStruct,'map_info')) THEN BEGIN
    print, 'Check your settings file to be in the format requested . . . (Seems like the map_info was not defined)'
    STOP
ENDIF ELSE BEGIN
    map_info = dataStruct.map_info
ENDELSE

IF NOT(tag_exist(dataStruct,'adminFile')) THEN BEGIN
    print, 'Check your settings file to be in the format requested . . . (Seems like the admin file (with the devisions) was not defined)'
    STOP
ENDIF ELSE BEGIN
    adminFile=dataStruct.adminFile
ENDELSE

IF NOT(tag_exist(dataStruct,'calcNewZ')) THEN BEGIN
  calcNewZ=0;
ENDIF ELSE BEGIN
  calcNewZ=dataStruct.calcNewZ;
ENDELSE



 
IF (NOT(tag_exist(dataStruct,'startYearData')) OR NOT(tag_exist(dataStruct,'nImagesYear')) OR NOT(tag_exist(dataStruct,'periodLag'))  OR NOT(tag_exist(dataStruct,'startPeriodLong')) OR NOT(tag_exist(dataStruct,'numberPeriodsLong')) OR NOT(tag_exist(dataStruct,'startPeriodShort')) OR NOT(tag_exist(dataStruct,'numberPeriodsShort'))) THEN BEGIN
    print, 'Check your settings file to be in the format requested . . . (Seems like the period definitions has a problem . . .)'
    STOP
ENDIF ELSE BEGIN
  startYearData=float(dataStruct.startYearData)
  nImagesYear=float(dataStruct.nImagesYear)
  periodLag=float(dataStruct.periodLag)
  startPeriodLong=float(dataStruct.startPeriodLong)
  numberPeriodsLong=float(dataStruct.numberPeriodsLong)
  startPeriodShort=float(dataStruct.startPeriodShort)
  numberPeriodsShort=float(dataStruct.numberPeriodsShort)
ENDELSE



If FILE_TEST(WorkingFolder) NE 1 THEN BEGIN 
print, 'Creating Folder : '+WorkingFolder + '. . .' 
FILE_MKDIR , WorkingFolder
ENDIF 


rawDataPath = WorkingFolder + 'RAW'
If FILE_TEST(rawDataPath) NE 1 THEN BEGIN 
print, 'Creating Folder : '+rawDataPath + '. . .' 
FILE_MKDIR , rawDataPath
ENDIF 
procDataPath = WorkingFolder + 'PROCESSED'
If FILE_TEST(procDataPath) NE 1 THEN BEGIN 
print, 'Creating Folder : '+procDataPath + '. . .' 
FILE_MKDIR , procDataPath
ENDIF 
csvDataPath = WorkingFolder + 'CSV'
If FILE_TEST(csvDataPath) NE 1 THEN BEGIN 
print, 'Creating Folder : '+csvDataPath + '. . .' 
FILE_MKDIR , csvDataPath
ENDIF 



;; - - - - Step 0 : Check repository for fullness and new data from USGS - - - - - ;;

CALDAT,SYSTIME(/JULIAN),Month,Day,Year ; Get the current date.
Year=Year-2000
Print ,  SYSTIME(0)+' - - - - Beginning Chain - - - - ' ;
Print ,  SYSTIME(0)+' - - - - Checking For Repository Fullnes - - - - ' ;

;; Step 0.1 : Go from beginning till date and make sure repository is complete - - ;;
 FOR Y=1,Year DO BEGIN 
 maxM=12
 ;IF Y LT 10 THEN ySTR = STRCOMPRESS('0'+STRING(Y),/REMOVE_ALL) ELSE  ySTR=STRCOMPRESS(STRING(Y),/REMOVE_ALL)
 ySTR = STRMID('0'+STRCOMPRESS(STRING(Y), /REMOVE_ALL), 1,2, /REVERSE_OFFSET) 
 IF (Y EQ Year) THEN maxM=Month-2
  FOR M=1,maxM DO BEGIN
  mSTR = STRMID('0'+STRCOMPRESS(STRING(M), /REMOVE_ALL), 1,2, /REVERSE_OFFSET)  
  ;IF M LT 10 THEN mSTR = STRCOMPRESS('0'+STRING(M),/REMOVE_ALL) ELSE mSTR = STRCOMPRESS(STRING(M))   
    TokFile = 1 ; TokFile - binary to indicate fullness of all files in this month
   FOR S = 6*M-4,6*M,2 DO BEGIN
      sSTR = STRMID('0'+STRCOMPRESS(STRING(S), /REMOVE_ALL), 1,2, /REVERSE_OFFSET)
      okFile = FILE_TEST(rawDataPath+'/'+'20'+ySTR+sSTR+'.img')
      IF NOT(okFile) THEN TokFile = 0 
  ENDFOR
  
  IF (TokFile NE 1) THEN BEGIN ; If you see that one of the files in a month is missing download and extract the entire month bulk zip 

    ; - - - Download Zip File 
  oUrl = OBJ_NEW('IDLnetUrl')
  oUrl->SetProperty, CALLBACK_FUNCTION ='Url_Callback'
  oUrl->SetProperty, VERBOSE = 0
  oUrl->SetProperty, TIMEOUT = 3600
  oUrl->SetProperty, url_scheme = 'http'
  oUrl->SetProperty, URL_HOST = 'earlywarning.usgs.gov'
  oUrl->SetProperty, URL_PATH = '/ftp2/eMODIS/east/east'+ySTR+mSTR+'.zip'
    
  fn = oUrl->Get(FILENAME =rawDataPath+'/east'+ySTR+mSTR+'.zip' )
  
   OBJ_DESTROY, oUrl 
;http://earlywarning.usgs.gov//ftp2/eMODIS/east/east0101.zip
;http://earlywarning.usgs.gov//ftp2/eMODIS/east/east1402.zip
;http://earlywarning.usgs.gov//ftp2/eMODIS/east/east1402.zip
  spawn, 'unzip '+[rawDataPath+'/east'+ySTR+mSTR+'.zip']+' -d '+rawDataPath 
  spawn, 'rm '+rawDataPath+'/*.zip'
  FOR S = 6*M-4,6*M,2 DO BEGIN
        sSTR = STRMID('0'+STRCOMPRESS(STRING(S), /REMOVE_ALL), 1,2, /REVERSE_OFFSET)
        IF FILE_TEST(rawDataPath+'/ea'+STRCOMPRESS(STRING(S),/REMOVE_ALL)+ySTR+'.tif') THEN BEGIN
        NDVIimage = read_tiff(rawDataPath+'/ea'+STRCOMPRESS(STRING(S),/REMOVE_ALL)+ySTR+'.tif',SUB_RECT=SUBSET)
        OPENW, W1, rawDataPath+'/'+'20'+ySTR+sSTR+'.img', /GET_LUN
        WRITEU, W1, NDVIimage
        FREE_LUN, W1
       
       CREATE_HEADER , rawDataPath+'/'+'20'+ySTR+sSTR+'.img',SUBSET(2),SUBSET(3),1,'{NDVI}',map_info
       ENDIF
  ENDFOR
  
  spawn, 'rm '+rawDataPath+'/*.tif'
  spawn, 'rm '+rawDataPath+'/*.tfw'
  

  ENDIF
  
  
 ENDFOR
 
ENDFOR
Print , SYSTIME(0)+ ' >  - - - - The Repository is up to date - - - - ' ;

Print , SYSTIME(0)+' > - - - - Updating Last Month New NDVI data - -' ;



;IF NOT((Day EQ 4) OR (Day EQ 14) OR (Day EQ 24)) THEN BEGIN
    ;print, 'Repository Doesnt need update ... process STOPED'
    ;STOP
;ENDIF

;; Step 0.2 :  Update month back from now

IF (1) THEN BEGIN

curWIY = 6*Month-4+2*((Day-3)/10-1); // WIY = Week In Year
 FOR k=0,5  DO BEGIN ;- REMEMBER TO RETURN !!!!!!!!!!! 04/06/2014
;FOR k=0,-1  DO BEGIN ; ; ; - - - - REMEMBER TO TAKE BACK TO 9 - - - - ; ; ;

Print, SYSTIME(0)+'> - - - Updating : ' + string(k) + ' / 5  - - ' ;
 
 toUpdateMonth = curWIY-2*k
 IF toUpdateMonth LE 0 THEN BEGIN
    toUpdateMonth= toUpdateMonth+72
    toUpdateYear = Year - 1
 ENDIF ELSE BEGIN
    toUpdateYear = Year
 ENDELSE
  
  
 ySTR = STRCOMPRESS(string(toUpdateYear),/REMOVE_ALL)
 mSTR = STRCOMPRESS(string(toUpdateMonth),/REMOVE_ALL)
  oUrl = OBJ_NEW('IDLnetUrl')
  oUrl->SetProperty, CALLBACK_FUNCTION ='Url_Callback'
  oUrl->SetProperty, VERBOSE = 0
  oUrl->SetProperty, TIMEOUT = 3600
  oUrl->SetProperty, url_scheme = 'http'
  oUrl->SetProperty, URL_HOST = 'earlywarning.usgs.gov'
  oUrl->SetProperty, URL_PATH = '/ftp2/africa/emodis/ea'+mSTR+ySTR+'.zip'
  fn = oUrl->Get(FILENAME =rawDataPath+'/east'+ySTR+mSTR+'.zip' )
  spawn, 'unzip '+[rawDataPath+'/east'+ySTR+mSTR+'.zip']+' -d '+rawDataPath 
  spawn, 'rm '+rawDataPath+'/*.zip'
  
  IF FILE_TEST(rawDataPath+'/ea'+mSTR+ySTR+'m.tif') THEN BEGIN
        
        NDVIimage = read_tiff(rawDataPath+'/ea'+mSTR+ySTR+'m.tif',SUB_RECT=SUBSET)
        OPENW, W1, rawDataPath+'/'+'20'+ySTR+STRMID('0'+mSTR, 1,2, /REVERSE_OFFSET)+'.img', /GET_LUN
        WRITEU, W1, NDVIimage
        FREE_LUN, W1
       
       CREATE_HEADER ,rawDataPath+'/'+'20'+ySTR+STRMID('0'+mSTR, 1,2, /REVERSE_OFFSET)+'.img',SUBSET(2),SUBSET(3),1,'{NDVI}',map_info
   ENDIF
       
  spawn, 'rm '+rawDataPath+'/*.tif'
  spawn, 'rm '+rawDataPath+'/*.tfw'
  
ENDFOR


Print , SYSTIME(0)+' > - - - - new NDVI data is is up to date - - - ' ; 
 
 
 
 Print, SYSTIME(0)+' > - - - - Stacking Temporal NDVI Images - - - - ' ;
 
 fileList = FILE_SEARCH(rawDataPath+'/*.img')
 bandList=STRMID(FILE_BASENAME(fileList),0,6) 
 OPENW , 1 ,procDataPath+'/eMODIS_FEWS_Kenya.bil'
 


;IF (0) THEN BEGIN
total = 0
jmp=0
FOR line=0, SUBSET(3)-1, 1L DO BEGIN
  FOR file=0, N_ELEMENTS(fileList)-1, 1L DO BEGIN
    OPENR, R1, fileList[file], /GET_LUN
    line_ass_data = ASSOC(R1, BYTARR(SUBSET(2)))
    dataline = line_ass_data[line]
    FREE_LUN, R1
    WRITEU, 1, dataline
    total=total+( float(1)/( (SUBSET(3)-1) * (N_ELEMENTS(fileList)-1) ))*100
    ;print,floor(total)
    
    IF (floor(total)  gt jmp) THEN BEGIN
    jmp=jmp+1;
    print , SYSTIME(0)+ ' > ' + string(total) + ' % Completed Stacking'
    ENDIF 
  ENDFOR
ENDFOR
CLOSE, /ALL
;ENDIF



FREE_LUN,1


CREATE_HEADER, procDataPath+'/eMODIS_FEWS_Kenya.bil',SUBSET(2),SUBSET(3),N_ELEMENTS(fileList),'{'+STRJOIN(bandList,', ')+'}',map_info      ; Procedure to generate generic header for each output



print, SYSTIME(0)+' > - - - Finished Stacking Temporal Layers - - - ';

   

        print, SYSTIME(0)+'> - - - Calculating IFTemporal Mean,STD,zNDVI and Diagnostics per pixel - - - ';
        
        print,ZNORMBIL_8BIT(procDataPath+'/eMODIS_FEWS_Kenya.bil', SUBSET(2), SUBSET(3), N_ELEMENTS(fileList), 10, 1, 1, 396, 0, 100, 200, 5, 102)
        
        ;;396

ENDIF ; END OF DEBUG MODE

        print , SYSTIME(0)+'> - - - Begin zScore aggregation per division - - - '
        AGGREGATE_Z , 'eMODIS',WorkingFolder,adminFile,SUBSET(3),SUBSET(2),N_ELEMENTS(fileList),bandList
        
        ;; First Cummulate for full seasones 
        CUMULATE_Z_PER_DIVISION  ,csvDataPath , startYearData , nImagesYear , periodLag , startPeriodLong , numberPeriodsLong , startPeriodShort , numberPeriodsShort,''
        ;; For the current seasone - cummulate only for what you've got
        CUMULATE_Z_PER_DIVISION  ,csvDataPath , startYearData , nImagesYear , periodLag , startPeriodLong , max([curWIY/2-7,1]) , startPeriodShort , max([curWIY/2-28,1]),'_ADDITION'
        zCum_Percentile , csvDataPath

        print , SYSTIME(0)+'> - - - Copying CSV Files to MATLAB Folder - - - '
        print,'cp -R ' + csvDataPath+'/zCumNDVI_aggregated_eMODIS.csv ' +'/opt/IBLI/dataProcessing/IBLIMatlab/z-scoring_first_CalibratedSeries/zCumNDVI_aggregated_eMODIS.csv'
        spawn , 'cp -R ' + csvDataPath+'/zCumNDVI_aggregated_eMODIS.csv ' +'/opt/IBLI/dataProcessing/IBLIMatlab/z-scoring_first_CalibratedSeries/zCumNDVI_aggregated_eMODIS.csv'
        
        print , SYSTIME(0)+'> - - - Starting Premium Calculation using MATLAB  - - - '
        spawn , '/usr/local/MATLAB/R2014a/bin/matlab -r "cd /opt/IBLI/dataProcessing/IBLIMatlab/ ; genLRLDrate ; exit"'
        spawn , '/usr/local/MATLAB/R2014a/bin/matlab -r "cd /opt/IBLI/dataProcessing/IBLIMatlab/ ; genSRSDrate ; exit"'
        print , SYSTIME(0)+'> - - - Completed Process : new Premium Values are now available '
        STOP
END
 
 

