; NAME:
;   eMODIS_ORGANIZE_INDIVIDUAL_FILES_OP
;
; PURPOSE:
;   UNZIP, OPEN, SUBSET, AND WRITE recent eMODIS NDVI composites
;
; INPUTS:
;   most recent zipped TIFF-files for single dekads
;
; USAGE:
;   eMODIS_ORGANIZE_INDIVIDUAL_FILES_OP
;
; OUTPUT:
;   subset for Kenya of eMODIS NDVI for each dekad
;
; NOTES:
;   - in current implementation we skip the in-between composites and only retain 1-10, 11-20, and 21-end of each month
;   - eMODIS_ORGANIZE_OP takes monthly zipped file (containing 6 files) as input. However, those are only available
;     a few months after as bulk download. For near real-time we need to get the data quicker.
;   - due to filtering the most recent composites change: therefore when downloading/processing the newest files of the
;     past month need to be taken. This needs to be done prior to running this program (here we assume the good data are
;     downloaded) --> SO: in the individualFiles folder we assume that all relevant data to process are there. This means:
;       - Regularly delete old composites that are already processed (and/or part of month-files)
;       - Make sure that prior to execution the latest files are updated and are the most recent filtered version
;
; MODIFICATION HISTORY:
;   Written by:  Anton Vrieling, July 2013
;   Adapted for Gizra automation: March 2014
;       - removed SPAWN commands for unzipping and file deletion
;       - added platform-independent directory separator
;       - moved "individualFiles" folder to be year-independent. Now we just check what data are in the folder and we process them


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


PRO eMODIS_ORGANIZE_INDIVIDUAL_FILES_OP

STARTTIME = SYSTIME(1)

; ------ SET DATA DIRECTORIES ------
dataPath = 'F:\DATA\eMODIS_FEWSNET\originalData\'
workPath = 'F:\DATA\eMODIS_FEWSNET\data\'

; ------ DEFINE SUBSET IN IMAGE COORDINATES ------
; bounding box --> list of statements to give bounding box in image coordinates (for TIFF)
nsOriginal = 12847   ; number of samples in original file
nlOriginal = 14712   ; number of lines in original file
boundingBox = [5301,7201,8700,11500]   ; bounding box in ENVI image coordinates [ULsample, ULline, LRsample, LRline]
;!!! NOTE THAT CHANGING THIS SUBSET WILL AFFECT THE MAP_INFO (created in CREATE_HEADER). This is done manually for now...



; ------ BELOW HERE NOTHING SHOULD BE CHANGED ------
region   = ['east','ea']                     ; note: region indicated differently in zip-file as in tiff-files
IF FILE_TEST(workPath) eq 0 THEN FILE_MKDIR, workPath
dimensions_tiffRead = [boundingBox[0]-1,boundingBox[1]-1,boundingBox[2]-boundingBox[0]+1,boundingBox[3]-boundingBox[1]+1]
dirSep=PATH_SEP()

dataPath2 = dataPath +'individualFiles' + dirSep
fileList = FILE_SEARCH(dataPath2,'*.zip',COUNT=CNT)

; loop over files
FOR file=0, CNT-1, 1L DO BEGIN
  ; get proper string/integers for corresponding dekad number and year
  inFile = fileList[file]
  fileBase=FILE_BASENAME(inFile)
  IF STRLEN(fileBase) eq 10 THEN BEGIN
    sDekad = STRMID(fileBase,2,2)
    sYear = '20'+STRMID(fileBase,4,2)
  ENDIF ELSE BEGIN    ; if not then string length = 9 (for dekads below 10)
    sDekad = '0'+STRMID(fileBase,2,1)
    sYear = '20'+STRMID(fileBase,3,2)
  ENDELSE
  dekad = FIX(sDekad) & year=FIX(sYear)
  
  IF dekad MOD 2 EQ 0 THEN BEGIN                ; additional test to avoid processing odd dekad numbers (if for some reason they are downloaded)
    yearWorkPath = workPath+sYear+dirSep                               ; output path. For ease define on each iteration, as it may change for Dec/Jan
    IF FILE_TEST(yearWorkPath) eq 0 THEN FILE_MKDIR, yearWorkPath      ; create directory if inexistant

    ;spawn, 'unzip '+inFile +' -d '+dataPath2, /HIDE
    FILE_UNZIP, inFile, dataPath2
    inFile=FILE_SEARCH(STRMID(inFile,0,STRLEN(inFile)-4)+'*tif')            ; note that recent dekads now receive a letter 'm' after fileName, but this search should allow for that
    NDVIimage = read_tiff(inFile,SUB_RECT=dimensions_tiffRead)

    outFile = yearWorkPath + sYear + sDekad +'.img'
    IF FILE_TEST(outFile) eq 1 THEN FILE_DELETE, outFile
    OPENW, W1, outFile, /GET_LUN
    WRITEU, W1, NDVIimage
    FREE_LUN, W1
    CLOSE, W1
    ; now create a header
    CREATE_HEADER, outFile

    ;spawn, 'del '+dataPath2+'*.t*', /HIDE     ; or use IDL-command FILE_DELETE
    FILE_DELETE, FILE_SEARCH(dataPath2+'*.t*')           ; delete unzipped tif-files
  
  ENDIF
ENDFOR



;*************************************************************************************************************************
; Evaluation of processing time
ELAPSED_TIME = FIX(SYSTIME(1) - STARTTIME)
MINUTES = ELAPSED_TIME / 60
SECS=ELAPSED_TIME MOD 60
PRINT, 'PROCESSING TOOK :'+STRCOMPRESS(MINUTES)+' MINUTES AND'+STRCOMPRESS(SECS)+' SECONDS'
PRINT, 'FINISHED ORGANIZING eMODIS FILES'

END ; {PROCEDURE eMODIS_ORGANIZE_INDIVIDUAL_FILES_OP}

;*************************************************************************************************************************
