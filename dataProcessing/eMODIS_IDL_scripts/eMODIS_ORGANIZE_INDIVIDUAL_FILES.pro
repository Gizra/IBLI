; NAME:
;   eMODIS_ORGANIZE
;
; PURPOSE:
;   UNZIP, OPEN, SUBSET, AND WRITE eMODIS NDVI composites
;
; INPUTS:
;   monthly zipped TIFF-files
;
; USAGE:
;   eMODIS_ORGANIZE_INDIVIDUAL_FILES
;
; OUTPUT:
;   The other versions takes monthly zipped file (containing 6 files) as input. However, those are only available
;   a few months after as bulk download. For near real-time we need to get the data quicker.
;
; NOTES:
;   in current implementation we skip the in-between composites and only retain 1-10, 11-20, and
;   21-end of each month
;
; MODIFICATION HISTORY:
;   Written by:  Anton Vrieling, July 2013


;*************************************************************************************************************************

PRO CREATE_HEADER, OUTFILE      ; Procedure to generate generic header for each output
HEADER_OUT=STRMID(OUTFILE,0,STRLEN(OUTFILE)-3)+'hdr'
IF FILE_TEST(HEADER_OUT) eq 1 THEN FILE_DELETE, HEADER_OUT
OPENW,3, HEADER_OUT
printf,3,'ENVI'
printf,3,'description = {'
printf,3,'  '+'Generic ENVI-header for '+FILE_BASENAME(OUTFILE)+'}'
printf,3,'samples = 3400'
printf,3,'lines   = 4300'
printf,3,'bands   = 1'
printf,3,'header offset = 0'
printf,3,'file type = ENVI Standard'
printf,3,'data type = 1'
printf,3,'interleave = bsq'
printf,3,'sensor type = MODIS'
printf,3,'byte order = 0'
printf,3,'map info = {Geographic Lat/Lon, 1.0000, 1.0000, 33.7889, 5.6265, 2.4130000000e-003, 2.4130000000e-003, WGS-84, units=Degrees}'
printf,3,'band names = {NDVI}'
CLOSE,3
END ; CREATE_HEADER

;*************************************************************************************************************************


PRO eMODIS_ORGANIZE_INDIVIDUAL_FILES

STARTTIME = SYSTIME(1)

dataPath = 'F:\DATA\eMODIS_FEWSNET\originalData\'
workPath = 'F:\DATA\eMODIS_FEWSNET\data\'
region   = ['east','ea']                     ; note: region indicated differently in zip-file as in tiff-files
IF FILE_TEST(workPath) eq 0 THEN FILE_MKDIR, workPath

baseList = [2,4,6]            ; base composites (for January) that will be extracted (corresponding to 1-10, 11-20, 21-end of each month)

; bounding box --> list of statements to give bounding box in image coordinates (for TIFF)
nsOriginal = 12847   ; number of samples in original file
nlOriginal = 14712   ; number of lines in original file
boundingBox = [5301,7201,8700,11500]   ; bounding box in ENVI image coordinates [ULsample, ULline, LRsample, LRline]
dimensions_tiffRead = [boundingBox[0]-1,boundingBox[1]-1,boundingBox[2]-boundingBox[0]+1,boundingBox[3]-boundingBox[1]+1]

FOR year=2013, 2014, 1L DO BEGIN
  sYear  = STRCOMPRESS(YEAR, /REMOVE_ALL)
  sYearShort = STRMID(sYear,2,2)
  yearWorkPath = workPath+sYear+'\'
  IF FILE_TEST(yearWorkPath) eq 0 THEN FILE_MKDIR, yearWorkPath
  dataPath2 = dataPath + sYear + '\individualFiles\'
  fileList = FILE_SEARCH(dataPath2,'*.zip',COUNT=CNT)
  IF CNT gt 0 THEN BEGIN
    compositeList = FIX(STRMID(FILE_BASENAME(fileList),2,2))
    filesReadyList = FILE_SEARCH(workPath+sYear+'\','*.img',COUNT=CNT2)  ; to check if some of these data have already been extracted previously (note: if overwrite this becomes different, or delete before!)
    IF CNT2 gt 0 THEN lastComposite=MAX(FIX(STRMID(FILE_BASENAME(filesReadyList),4,2))) ELSE lastComposite=0
    index = WHERE(compositeList gt lastComposite AND (compositeList mod 2) eq 0)   ; make sure we only have even composites (not those in between and after lastComposite)
    IF index[0] ne -1 THEN BEGIN
      compositeList=compositeList[index]
      fileList=fileList[index]
      FOR i=0, N_ELEMENTS(index)-1, 1L DO BEGIN
        spawn, 'unzip '+fileList[i] +' -d '+dataPath2, /HIDE
        inFile=FILE_SEARCH(STRMID(fileList[i],0,STRLEN(fileList[i])-4)+'*.tif')
        NDVIimage = read_tiff(inFile,SUB_RECT=dimensions_tiffRead)
        
        outFile = yearWorkPath + sYear + STRMID('0'+STRCOMPRESS(compositeList[i], /REMOVE_ALL), 1,2, /REVERSE_OFFSET)+'.img'
        IF FILE_TEST(outFile) eq 1 THEN FILE_DELETE, outFile
        OPENW, W1, outFile, /GET_LUN
        WRITEU, W1, NDVIimage
        FREE_LUN, W1
        CLOSE, W1
        ; now create a header
        CREATE_HEADER, outFile
        
        spawn, 'del '+dataPath2+'*.t*', /HIDE     ; or use IDL-command FILE_DELETE
      ENDFOR
    ENDIF ELSE print, 'No new composites found in the individualFiles folder: considering deleting from processed data-folder if you want to overwrite'
  ENDIF ELSE print, 'No composites are located in the individualFiles folder'
ENDFOR

;*************************************************************************************************************************
; Evaluation of processing time
ELAPSED_TIME = FIX(SYSTIME(1) - STARTTIME)
MINUTES = ELAPSED_TIME / 60
SECS=ELAPSED_TIME MOD 60
PRINT, 'PROCESSING TOOK :'+STRCOMPRESS(MINUTES)+' MINUTES AND'+STRCOMPRESS(SECS)+' SECONDS'
PRINT, 'FINISHED ORGANIZING eMODIS FILES'

END ; {PROCEDURE TRMM_read_write.pro}

;*************************************************************************************************************************
