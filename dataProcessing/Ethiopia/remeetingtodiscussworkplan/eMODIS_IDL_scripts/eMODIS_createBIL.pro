; NAME:
;   eMODIS_createBIL
;
; PURPOSE:
;   WRITE BINARY INDIVIDUAL eMODIS NDVI composite time series into a BIL-file
;
; INPUTS:
;   binary files for each dekad
;
; USAGE:
;   eMODIS_createBIL
;
; OUTPUT:
;   one large BIL-stack
;
; NOTES:
;   in current implementation we skip the in-between composites and only retain 1-10, 11-20, and
;   21-end of each month
;
; MODIFICATION HISTORY:
;   Written by:  Anton Vrieling, May 2013


;*************************************************************************************************************************

PRO CREATE_HEADER, OUTFILE, bandList      ; Procedure to generate generic header for each output
HEADER_OUT=STRMID(OUTFILE,0,STRLEN(OUTFILE)-3)+'hdr'
IF FILE_TEST(HEADER_OUT) eq 1 THEN FILE_DELETE, HEADER_OUT
OPENW,3, HEADER_OUT
printf,3,'ENVI'
printf,3,'description = {'
printf,3,'  '+'Generic ENVI-header for '+FILE_BASENAME(OUTFILE)+'}'
printf,3,'samples = 3400'
printf,3,'lines   = 4300'
printf,3,'bands   = 470'
printf,3,'header offset = 0'
printf,3,'file type = ENVI Standard'
printf,3,'data type = 1'
printf,3,'interleave = bil'
printf,3,'sensor type = MODIS'
printf,3,'byte order = 0'
printf,3,'map info = {Geographic Lat/Lon, 1.0000, 1.0000, 33.7889, 5.6265, 2.4130000000e-003, 2.4130000000e-003, WGS-84, units=Degrees}'
printf,3,'band names = {'+STRJOIN(bandList,', ')+'}'
CLOSE,3
END ; CREATE_HEADER

;*************************************************************************************************************************


PRO eMODIS_createBIL

STARTTIME = SYSTIME(1)

dataPath = 'F:\DATA\eMODIS_FEWSNET\data\'
workPath = 'F:\DATA\eMODIS_FEWSNET\processing\'
ns=3400
nl=4300

IF FILE_TEST(workPath) eq 0 THEN FILE_MKDIR, workPath

fileList=FILE_SEARCH(dataPath+'20*\20*.img', COUNT=nb)
bandList=STRMID(FILE_BASENAME(fileList),0,6)
sorted = SORT(LONG(bandList))                      ; sorting just to be sure
fileList=fileList[sorted]
bandList=bandList[sorted]

outFile=workPath+'eMODIS_FEWS_Kenya.bil'                      ; The output file
IF FILE_TEST(outFile) eq 1 THEN FILE_DELETE, outFile  ; Delete output file if an earlier version exists
OPENW, W1, outFile, /GET_LUN, /APPEND                  ; Open the file for writing

; write the data per line for every band
FOR line=0, nl-1, 1L DO BEGIN
  FOR file=0, nb-1, 1L DO BEGIN
    OPENR, R1, fileList[file], /GET_LUN
    line_ass_data = ASSOC(R1, BYTARR(ns))
    dataline = line_ass_data[line]
    FREE_LUN, R1
    WRITEU, W1, dataline
  ENDFOR
ENDFOR
CLOSE, /ALL

; now create header
CREATE_HEADER, outFile, bandList 

;*************************************************************************************************************************
; Evaluation of processing time
ELAPSED_TIME = FIX(SYSTIME(1) - STARTTIME)
MINUTES = ELAPSED_TIME / 60
SECS=ELAPSED_TIME MOD 60
PRINT, 'PROCESSING TOOK :'+STRCOMPRESS(MINUTES)+' MINUTES AND'+STRCOMPRESS(SECS)+' SECONDS'
PRINT, 'FINISHED ORGANIZING eMODIS FILES'

END ; {PROCEDURE TRMM_read_write.pro}

;*************************************************************************************************************************
