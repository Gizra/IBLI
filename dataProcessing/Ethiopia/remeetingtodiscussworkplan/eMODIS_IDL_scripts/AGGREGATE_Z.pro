; _____________________________________________________________________________________________
;
; NAME:
;   AGGREGATE_Z
;
; PURPOSE:
;   Calculate the aggregated NDVI seasonal Z-scores for each dekad/time period
;
; INPUTS:
;   - BIL-stacks of yearly z-scored NDVI
;   - Image with ID codes of admin polygons (converted to raster) in same geometry as the BIL-stacks
;   - diagnostics file
;
; CONDITIONS USED (otherwise result = mask value):
;   - diagnostics-file should indicate that all is fine (value=0)
;   
; NOTE!!
;   - this program may perform a lot faster: it uses old GIMMS things (because there accounting for different weights)
;
; CALLING SEQUENCE:
;   AGGREGATE_CUM_GIMMS
;
; MODIFICATION HISTORY:
;   Written by:  Anton Vrieling, May 2013
;
; _____________________________________________________________________________________________


PRO AGGREGATE_Z

STARTTIME = SYSTIME(1)

dataSet = ['GIMMS', 'SPOT', 'MODIS', 'eMODIS']
dataSet = dataSet[3]
dataPath= 'G:\BACKUP\IMAGES\IBLI\'

; General settings (to be changed for different input)
IF dataSet eq 'GIMMS' THEN BEGIN
  dataPath='G:\BACKUP\IMAGES\IBLI\GIMMS\z-scoring-first\'         ; location where administrative region-file is located
  inFile = dataPath+'Kenya_NDVI3g_filteredSG_cm1_Z.bil'           ; input file with z-scores
  diaFile = dataPath+'Kenya_NDVI3g_filteredSG_cm1_dia.img'        ; file with diagnostics
  adminFile = 'G:\BACKUP\IMAGES\IBLI\GIMMS\divisionID.img'        ; input File for division codes
  nl=132                             ; number of lines
  ns=112                             ; number of samples
  nb=732                             ; number of bands in z-scored NDVI file
  ratioAdmin=10                      ; number indicates how many times the spatial resolution of Admin-layer is higher than NDVI
  bandArray=['198107-1', '198107-2', '198108-1', '198108-2', '198109-1', '198109-2', '198110-1', '198110-2', '198111-1', '198111-2', '198112-1', '198112-2', '198201-1', '198201-2', '198202-1', '198202-2', '198203-1', '198203-2', '198204-1', '198204-2', '198205-1', '198205-2', '198206-1', '198206-2', '198207-1', '198207-2', '198208-1', '198208-2', '198209-1', '198209-2', '198210-1', '198210-2', '198211-1', '198211-2', '198212-1', '198212-2', '198301-1', '198301-2', '198302-1', '198302-2', '198303-1', '198303-2', '198304-1', '198304-2', '198305-1', '198305-2', '198306-1', '198306-2', '198307-1', '198307-2', '198308-1', '198308-2', '198309-1', '198309-2', '198310-1', '198310-2', '198311-1', '198311-2', '198312-1', '198312-2', '198401-1', '198401-2', '198402-1', '198402-2', '198403-1', '198403-2', '198404-1', '198404-2', '198405-1', '198405-2', '198406-1', '198406-2', '198407-1', '198407-2', '198408-1', '198408-2', '198409-1', '198409-2', '198410-1', '198410-2', '198411-1', '198411-2', '198412-1', '198412-2', '198501-1', '198501-2', '198502-1', '198502-2', '198503-1', '198503-2', '198504-1', '198504-2', '198505-1', '198505-2', '198506-1', '198506-2', '198507-1', '198507-2', '198508-1', '198508-2', '198509-1', '198509-2', '198510-1', '198510-2', '198511-1', '198511-2', '198512-1', '198512-2', '198601-1', '198601-2', '198602-1', '198602-2', '198603-1', '198603-2', '198604-1', '198604-2', '198605-1', '198605-2', '198606-1', '198606-2', '198607-1', '198607-2', '198608-1', '198608-2', '198609-1', '198609-2', '198610-1', '198610-2', '198611-1', '198611-2', '198612-1', '198612-2', '198701-1', '198701-2', '198702-1', '198702-2', '198703-1', '198703-2', '198704-1', '198704-2', '198705-1', '198705-2', '198706-1', '198706-2', '198707-1', '198707-2', '198708-1', '198708-2', '198709-1', '198709-2', '198710-1', '198710-2', '198711-1', '198711-2', '198712-1', '198712-2', '198801-1', '198801-2', '198802-1', '198802-2', '198803-1', '198803-2', '198804-1', '198804-2', '198805-1', '198805-2', '198806-1', '198806-2', '198807-1', '198807-2', '198808-1', '198808-2', '198809-1', '198809-2', '198810-1', '198810-2', '198811-1', '198811-2', '198812-1', '198812-2', '198901-1', '198901-2', '198902-1', '198902-2', '198903-1', '198903-2', '198904-1', '198904-2', '198905-1', '198905-2', '198906-1', '198906-2', '198907-1', '198907-2', '198908-1', '198908-2', '198909-1', '198909-2', '198910-1', '198910-2', '198911-1', '198911-2', '198912-1', '198912-2', '199001-1', '199001-2', '199002-1', '199002-2', '199003-1', '199003-2', '199004-1', '199004-2', '199005-1', '199005-2', '199006-1', '199006-2', '199007-1', '199007-2', '199008-1', '199008-2', '199009-1', '199009-2', '199010-1', '199010-2', '199011-1', '199011-2', '199012-1', '199012-2', '199101-1', '199101-2', '199102-1', '199102-2', '199103-1', '199103-2', '199104-1', '199104-2', '199105-1', '199105-2', '199106-1', '199106-2', '199107-1', '199107-2', '199108-1', '199108-2', '199109-1', '199109-2', '199110-1', '199110-2', '199111-1', '199111-2', '199112-1', '199112-2', '199201-1', '199201-2', '199202-1', '199202-2', '199203-1', '199203-2', '199204-1', '199204-2', '199205-1', '199205-2', '199206-1', '199206-2', '199207-1', '199207-2', '199208-1', '199208-2', '199209-1', '199209-2', '199210-1', '199210-2', '199211-1', '199211-2', '199212-1', '199212-2', '199301-1', '199301-2', '199302-1', '199302-2', '199303-1', '199303-2', '199304-1', '199304-2', '199305-1', '199305-2', '199306-1', '199306-2', '199307-1', '199307-2', '199308-1', '199308-2', '199309-1', '199309-2', '199310-1', '199310-2', '199311-1', '199311-2', '199312-1', '199312-2', '199401-1', '199401-2', '199402-1', '199402-2', '199403-1', '199403-2', '199404-1', '199404-2', '199405-1', '199405-2', '199406-1', '199406-2', '199407-1', '199407-2', '199408-1', '199408-2', '199409-1', '199409-2', '199410-1', '199410-2', '199411-1', '199411-2', '199412-1', '199412-2', '199501-1', '199501-2', '199502-1', '199502-2', '199503-1', '199503-2', '199504-1', '199504-2', '199505-1', '199505-2', '199506-1', '199506-2', '199507-1', '199507-2', '199508-1', '199508-2', '199509-1', '199509-2', '199510-1', '199510-2', '199511-1', '199511-2', '199512-1', '199512-2', '199601-1', '199601-2', '199602-1', '199602-2', '199603-1', '199603-2', '199604-1', '199604-2', '199605-1', '199605-2', '199606-1', '199606-2', '199607-1', '199607-2', '199608-1', '199608-2', '199609-1', '199609-2', '199610-1', '199610-2', '199611-1', '199611-2', '199612-1', '199612-2', '199701-1', '199701-2', '199702-1', '199702-2', '199703-1', '199703-2', '199704-1', '199704-2', '199705-1', '199705-2', '199706-1', '199706-2', '199707-1', '199707-2', '199708-1', '199708-2', '199709-1', '199709-2', '199710-1', '199710-2', '199711-1', '199711-2', '199712-1', '199712-2', '199801-1', '199801-2', '199802-1', '199802-2', '199803-1', '199803-2', '199804-1', '199804-2', '199805-1', '199805-2', '199806-1', '199806-2', '199807-1', '199807-2', '199808-1', '199808-2', '199809-1', '199809-2', '199810-1', '199810-2', '199811-1', '199811-2', '199812-1', '199812-2', '199901-1', '199901-2', '199902-1', '199902-2', '199903-1', '199903-2', '199904-1', '199904-2', '199905-1', '199905-2', '199906-1', '199906-2', '199907-1', '199907-2', '199908-1', '199908-2', '199909-1', '199909-2', '199910-1', '199910-2', '199911-1', '199911-2', '199912-1', '199912-2', '200001-1', '200001-2', '200002-1', '200002-2', '200003-1', '200003-2', '200004-1', '200004-2', '200005-1', '200005-2', '200006-1', '200006-2', '200007-1', '200007-2', '200008-1', '200008-2', '200009-1', '200009-2', '200010-1', '200010-2', '200011-1', '200011-2', '200012-1', '200012-2', '200101-1', '200101-2', '200102-1', '200102-2', '200103-1', '200103-2', '200104-1', '200104-2', '200105-1', '200105-2', '200106-1', '200106-2', '200107-1', '200107-2', '200108-1', '200108-2', '200109-1', '200109-2', '200110-1', '200110-2', '200111-1', '200111-2', '200112-1', '200112-2', '200201-1', '200201-2', '200202-1', '200202-2', '200203-1', '200203-2', '200204-1', '200204-2', '200205-1', '200205-2', '200206-1', '200206-2', '200207-1', '200207-2', '200208-1', '200208-2', '200209-1', '200209-2', '200210-1', '200210-2', '200211-1', '200211-2', '200212-1', '200212-2', '200301-1', '200301-2', '200302-1', '200302-2', '200303-1', '200303-2', '200304-1', '200304-2', '200305-1', '200305-2', '200306-1', '200306-2', '200307-1', '200307-2', '200308-1', '200308-2', '200309-1', '200309-2', '200310-1', '200310-2', '200311-1', '200311-2', '200312-1', '200312-2', '200401-1', '200401-2', '200402-1', '200402-2', '200403-1', '200403-2', '200404-1', '200404-2', '200405-1', '200405-2', '200406-1', '200406-2', '200407-1', '200407-2', '200408-1', '200408-2', '200409-1', '200409-2', '200410-1', '200410-2', '200411-1', '200411-2', '200412-1', '200412-2', '200501-1', '200501-2', '200502-1', '200502-2', '200503-1', '200503-2', '200504-1', '200504-2', '200505-1', '200505-2', '200506-1', '200506-2', '200507-1', '200507-2', '200508-1', '200508-2', '200509-1', '200509-2', '200510-1', '200510-2', '200511-1', '200511-2', '200512-1', '200512-2', '200601-1', '200601-2', '200602-1', '200602-2', '200603-1', '200603-2', '200604-1', '200604-2', '200605-1', '200605-2', '200606-1', '200606-2', '200607-1', '200607-2', '200608-1', '200608-2', '200609-1', '200609-2', '200610-1', '200610-2', '200611-1', '200611-2', '200612-1', '200612-2', '200701-1', '200701-2', '200702-1', '200702-2', '200703-1', '200703-2', '200704-1', '200704-2', '200705-1', '200705-2', '200706-1', '200706-2', '200707-1', '200707-2', '200708-1', '200708-2', '200709-1', '200709-2', '200710-1', '200710-2', '200711-1', '200711-2', '200712-1', '200712-2', '200801-1', '200801-2', '200802-1', '200802-2', '200803-1', '200803-2', '200804-1', '200804-2', '200805-1', '200805-2', '200806-1', '200806-2', '200807-1', '200807-2', '200808-1', '200808-2', '200809-1', '200809-2', '200810-1', '200810-2', '200811-1', '200811-2', '200812-1', '200812-2', '200901-1', '200901-2', '200902-1', '200902-2', '200903-1', '200903-2', '200904-1', '200904-2', '200905-1', '200905-2', '200906-1', '200906-2', '200907-1', '200907-2', '200908-1', '200908-2', '200909-1', '200909-2', '200910-1', '200910-2', '200911-1', '200911-2', '200912-1', '200912-2', '201001-1', '201001-2', '201002-1', '201002-2', '201003-1', '201003-2', '201004-1', '201004-2', '201005-1', '201005-2', '201006-1', '201006-2', '201007-1', '201007-2', '201008-1', '201008-2', '201009-1', '201009-2', '201010-1', '201010-2', '201011-1', '201011-2', '201012-1', '201012-2', '201101-1', '201101-2', '201102-1', '201102-2', '201103-1', '201103-2', '201104-1', '201104-2', '201105-1', '201105-2', '201106-1', '201106-2', '201107-1', '201107-2', '201108-1', '201108-2', '201109-1', '201109-2', '201110-1', '201110-2', '201111-1', '201111-2', '201112-1', '201112-2']
ENDIF

IF dataSet eq 'SPOT' THEN BEGIN
  dataPath='G:\BACKUP\IMAGES\IBLI\SPOT\z-scoring-first\'         ; location where data are
  inFile = dataPath+'SPOT_VGT_filtered_Kenya_Z.bil'              ; input file with z-scores
  diaFile = dataPath+'SPOT_VGT_filtered_Kenya_dia.img'           ; file with diagnostics
  adminFile = 'G:\BACKUP\IMAGES\IBLI\SPOT\divisionID.img'        ; input File for division codes
  nl=1232                            ; number of lines
  ns=1008                            ; number of samples
  nb=543                             ; number of bands in z-scored NDVI file
  ratioAdmin=1                       ; number indicates how many times the spatial resolution of Admin-layer is higher than NDVI
  ; create a stringArray to hold identifiers for dekad-identifiers to be printed to file later
  bandArray=['199804-1', '199804-2', '199804-3', '199805-1', '199805-2', '199805-3', '199806-1', '199806-2', '199806-3', '199807-1', '199807-2', '199807-3', '199808-1', '199808-2', '199808-3', '199809-1', '199809-2', '199809-3', '199810-1', '199810-2', '199810-3', '199811-1', '199811-2', '199811-3', '199812-1', '199812-2', '199812-3', '199901-1', '199901-2', '199901-3', '199902-1', '199902-2', '199902-3', '199903-1', '199903-2', '199903-3', '199904-1', '199904-2', '199904-3', '199905-1', '199905-2', '199905-3', '199906-1', '199906-2', '199906-3', '199907-1', '199907-2', '199907-3', '199908-1', '199908-2', '199908-3', '199909-1', '199909-2', '199909-3', '199910-1', '199910-2', '199910-3', '199911-1', '199911-2', '199911-3', '199912-1', '199912-2', '199912-3', '200001-1', '200001-2', '200001-3', '200002-1', '200002-2', '200002-3', '200003-1', '200003-2', '200003-3', '200004-1', '200004-2', '200004-3', '200005-1', '200005-2', '200005-3', '200006-1', '200006-2', '200006-3', '200007-1', '200007-2', '200007-3', '200008-1', '200008-2', '200008-3', '200009-1', '200009-2', '200009-3', '200010-1', '200010-2', '200010-3', '200011-1', '200011-2', '200011-3', '200012-1', '200012-2', '200012-3', '200101-1', '200101-2', '200101-3', '200102-1', '200102-2', '200102-3', '200103-1', '200103-2', '200103-3', '200104-1', '200104-2', '200104-3', '200105-1', '200105-2', '200105-3', '200106-1', '200106-2', '200106-3', '200107-1', '200107-2', '200107-3', '200108-1', '200108-2', '200108-3', '200109-1', '200109-2', '200109-3', '200110-1', '200110-2', '200110-3', '200111-1', '200111-2', '200111-3', '200112-1', '200112-2', '200112-3', '200201-1', '200201-2', '200201-3', '200202-1', '200202-2', '200202-3', '200203-1', '200203-2', '200203-3', '200204-1', '200204-2', '200204-3', '200205-1', '200205-2', '200205-3', '200206-1', '200206-2', '200206-3', '200207-1', '200207-2', '200207-3', '200208-1', '200208-2', '200208-3', '200209-1', '200209-2', '200209-3', '200210-1', '200210-2', '200210-3', '200211-1', '200211-2', '200211-3', '200212-1', '200212-2', '200212-3', '200301-1', '200301-2', '200301-3', '200302-1', '200302-2', '200302-3', '200303-1', '200303-2', '200303-3', '200304-1', '200304-2', '200304-3', '200305-1', '200305-2', '200305-3', '200306-1', '200306-2', '200306-3', '200307-1', '200307-2', '200307-3', '200308-1', '200308-2', '200308-3', '200309-1', '200309-2', '200309-3', '200310-1', '200310-2', '200310-3', '200311-1', '200311-2', '200311-3', '200312-1', '200312-2', '200312-3', '200401-1', '200401-2', '200401-3', '200402-1', '200402-2', '200402-3', '200403-1', '200403-2', '200403-3', '200404-1', '200404-2', '200404-3', '200405-1', '200405-2', '200405-3', '200406-1', '200406-2', '200406-3', '200407-1', '200407-2', '200407-3', '200408-1', '200408-2', '200408-3', '200409-1', '200409-2', '200409-3', '200410-1', '200410-2', '200410-3', '200411-1', '200411-2', '200411-3', '200412-1', '200412-2', '200412-3', '200501-1', '200501-2', '200501-3', '200502-1', '200502-2', '200502-3', '200503-1', '200503-2', '200503-3', '200504-1', '200504-2', '200504-3', '200505-1', '200505-2', '200505-3', '200506-1', '200506-2', '200506-3', '200507-1', '200507-2', '200507-3', '200508-1', '200508-2', '200508-3', '200509-1', '200509-2', '200509-3', '200510-1', '200510-2', '200510-3', '200511-1', '200511-2', '200511-3', '200512-1', '200512-2', '200512-3', '200601-1', '200601-2', '200601-3', '200602-1', '200602-2', '200602-3', '200603-1', '200603-2', '200603-3', '200604-1', '200604-2', '200604-3', '200605-1', '200605-2', '200605-3', '200606-1', '200606-2', '200606-3', '200607-1', '200607-2', '200607-3', '200608-1', '200608-2', '200608-3', '200609-1', '200609-2', '200609-3', '200610-1', '200610-2', '200610-3', '200611-1', '200611-2', '200611-3', '200612-1', '200612-2', '200612-3', '200701-1', '200701-2', '200701-3', '200702-1', '200702-2', '200702-3', '200703-1', '200703-2', '200703-3', '200704-1', '200704-2', '200704-3', '200705-1', '200705-2', '200705-3', '200706-1', '200706-2', '200706-3', '200707-1', '200707-2', '200707-3', '200708-1', '200708-2', '200708-3', '200709-1', '200709-2', '200709-3', '200710-1', '200710-2', '200710-3', '200711-1', '200711-2', '200711-3', '200712-1', '200712-2', '200712-3', '200801-1', '200801-2', '200801-3', '200802-1', '200802-2', '200802-3', '200803-1', '200803-2', '200803-3', '200804-1', '200804-2', '200804-3', '200805-1', '200805-2', '200805-3', '200806-1', '200806-2', '200806-3', '200807-1', '200807-2', '200807-3', '200808-1', '200808-2', '200808-3', '200809-1', '200809-2', '200809-3', '200810-1', '200810-2', '200810-3', '200811-1', '200811-2', '200811-3', '200812-1', '200812-2', '200812-3', '200901-1', '200901-2', '200901-3', '200902-1', '200902-2', '200902-3', '200903-1', '200903-2', '200903-3', '200904-1', '200904-2', '200904-3', '200905-1', '200905-2', '200905-3', '200906-1', '200906-2', '200906-3', '200907-1', '200907-2', '200907-3', '200908-1', '200908-2', '200908-3', '200909-1', '200909-2', '200909-3', '200910-1', '200910-2', '200910-3', '200911-1', '200911-2', '200911-3', '200912-1', '200912-2', '200912-3', '201001-1', '201001-2', '201001-3', '201002-1', '201002-2', '201002-3', '201003-1', '201003-2', '201003-3', '201004-1', '201004-2', '201004-3', '201005-1', '201005-2', '201005-3', '201006-1', '201006-2', '201006-3', '201007-1', '201007-2', '201007-3', '201008-1', '201008-2', '201008-3', '201009-1', '201009-2', '201009-3', '201010-1', '201010-2', '201010-3', '201011-1', '201011-2', '201011-3', '201012-1', '201012-2', '201012-3', '201101-1', '201101-2', '201101-3', '201102-1', '201102-2', '201102-3', '201103-1', '201103-2', '201103-3', '201104-1', '201104-2', '201104-3', '201105-1', '201105-2', '201105-3', '201106-1', '201106-2', '201106-3', '201107-1', '201107-2', '201107-3', '201108-1', '201108-2', '201108-3', '201109-1', '201109-2', '201109-3', '201110-1', '201110-2', '201110-3', '201111-1', '201111-2', '201111-3', '201112-1', '201112-2', '201112-3', '201201-1', '201201-2', '201201-3', '201202-1', '201202-2', '201202-3', '201203-1', '201203-2', '201203-3', '201204-1', '201204-2', '201204-3', '201205-1', '201205-2', '201205-3', '201206-1', '201206-2', '201206-3', '201207-1', '201207-2', '201207-3', '201208-1', '201208-2', '201208-3', '201209-1', '201209-2', '201209-3', '201210-1', '201210-2', '201210-3', '201211-1', '201211-2', '201211-3', '201212-1', '201212-2', '201212-3', '201301-1', '201301-2', '201301-3', '201302-1', '201302-2', '201302-3', '201303-1', '201303-2', '201303-3', '201304-1', '201304-2', '201304-3']
ENDIF

IF dataSet eq 'eMODIS' THEN BEGIN
  dataPath='F:\DATA\eMODIS_FEWSNET\processing\'                  ; location where data are
  inFile = dataPath+'eMODIS_FEWS_Kenya_Z.bil'                    ; input file with z-scores
  diaFile = dataPath+'eMODIS_FEWS_Kenya_dia_oldest.img'                 ; file with diagnostics ; Note: before we used oldest (check)
  adminFile = 'G:\BACKUP\IMAGES\IBLI\eMODIS\divisionID.img'      ; input File for division codes
  nl=4300                            ; number of lines
  ns=3400                            ; number of samples
  nb=470                             ; number of bands in z-scored NDVI file
  ratioAdmin=1                       ; number indicates how many times the spatial resolution of Admin-layer is higher than NDVI
  ; create a stringArray to hold identifiers for dekad-identifiers to be printed to file later
  bandArray=['200102', '200104', '200106', '200108', '200110', '200112', '200114', '200116', '200118', '200120', '200122', '200124', '200126', '200128', '200130', '200132', '200134', '200136', '200138', '200140', '200142', '200144', '200146', '200148', '200150', '200152', '200154', '200156', '200158', '200160', '200162', '200164', '200166', '200168', '200170', '200172', '200202', '200204', '200206', '200208', '200210', '200212', '200214', '200216', '200218', '200220', '200222', '200224', '200226', '200228', '200230', '200232', '200234', '200236', '200238', '200240', '200242', '200244', '200246', '200248', '200250', '200252', '200254', '200256', '200258', '200260', '200262', '200264', '200266', '200268', '200270', '200272', '200302', '200304', '200306', '200308', '200310', '200312', '200314', '200316', '200318', '200320', '200322', '200324', '200326', '200328', '200330', '200332', '200334', '200336', '200338', '200340', '200342', '200344', '200346', '200348', '200350', '200352', '200354', '200356', '200358', '200360', '200362', '200364', '200366', '200368', '200370', '200372', '200402', '200404', '200406', '200408', '200410', '200412', '200414', '200416', '200418', '200420', '200422', '200424', '200426', '200428', '200430', '200432', '200434', '200436', '200438', '200440', '200442', '200444', '200446', '200448', '200450', '200452', '200454', '200456', '200458', '200460', '200462', '200464', '200466', '200468', '200470', '200472', '200502', '200504', '200506', '200508', '200510', '200512', '200514', '200516', '200518', '200520', '200522', '200524', '200526', '200528', '200530', '200532', '200534', '200536', '200538', '200540', '200542', '200544', '200546', '200548', '200550', '200552', '200554', '200556', '200558', '200560', '200562', '200564', '200566', '200568', '200570', '200572', '200602', '200604', '200606', '200608', '200610', '200612', '200614', '200616', '200618', '200620', '200622', '200624', '200626', '200628', '200630', '200632', '200634', '200636', '200638', '200640', '200642', '200644', '200646', '200648', '200650', '200652', '200654', '200656', '200658', '200660', '200662', '200664', '200666', '200668', '200670', '200672', '200702', '200704', '200706', '200708', '200710', '200712', '200714', '200716', '200718', '200720', '200722', '200724', '200726', '200728', '200730', '200732', '200734', '200736', '200738', '200740', '200742', '200744', '200746', '200748', '200750', '200752', '200754', '200756', '200758', '200760', '200762', '200764', '200766', '200768', '200770', '200772', '200802', '200804', '200806', '200808', '200810', '200812', '200814', '200816', '200818', '200820', '200822', '200824', '200826', '200828', '200830', '200832', '200834', '200836', '200838', '200840', '200842', '200844', '200846', '200848', '200850', '200852', '200854', '200856', '200858', '200860', '200862', '200864', '200866', '200868', '200870', '200872', '200902', '200904', '200906', '200908', '200910', '200912', '200914', '200916', '200918', '200920', '200922', '200924', '200926', '200928', '200930', '200932', '200934', '200936', '200938', '200940', '200942', '200944', '200946', '200948', '200950', '200952', '200954', '200956', '200958', '200960', '200962', '200964', '200966', '200968', '200970', '200972', '201002', '201004', '201006', '201008', '201010', '201012', '201014', '201016', '201018', '201020', '201022', '201024', '201026', '201028', '201030', '201032', '201034', '201036', '201038', '201040', '201042', '201044', '201046', '201048', '201050', '201052', '201054', '201056', '201058', '201060', '201062', '201064', '201066', '201068', '201070', '201072', '201102', '201104', '201106', '201108', '201110', '201112', '201114', '201116', '201118', '201120', '201122', '201124', '201126', '201128', '201130', '201132', '201134', '201136', '201138', '201140', '201142', '201144', '201146', '201148', '201150', '201152', '201154', '201156', '201158', '201160', '201162', '201164', '201166', '201168', '201170', '201172', '201202', '201204', '201206', '201208', '201210', '201212', '201214', '201216', '201218', '201220', '201222', '201224', '201226', '201228', '201230', '201232', '201234', '201236', '201238', '201240', '201242', '201244', '201246', '201248', '201250', '201252', '201254', '201256', '201258', '201260', '201262', '201264', '201266', '201268', '201270', '201272', '201302', '201304', '201306', '201308', '201310', '201312','201314', '201316', '201318', '201320', '201322', '201324', '201326', '201328', '201330', '201332', '201334', '201336','201338', '201340', '201342', '201344', '201346', '201348', '201350', '201352', '201354', '201356', '201358', '201360', '201362', '201364', '201366', '201368', '201370', '201372', '201402', '201404']
ENDIF

;***********************************

; general activities
workPath=dataPath+'aggregate\'                                   ; location where output will be written to
IF dataSet eq 'eMODIS' THEN workPath = 'G:\BACKUP\IMAGES\IBLI\eMODIS\z-scoring-first\aggregate\update20140123\'
IF FILE_TEST(workPath) eq 0 THEN FILE_MKDIR, workPath

; Open the Admin1-file
OPENR, lun, adminFile, /GET_LUN
adminRef = ASSOC(lun, BYTARR(ratioAdmin*ns,ratioAdmin*nl)) ; note: if later we use INTARR for adminFile, then change!
adminRaster = adminRef[0]                                  ; the raster file holding the admin1 codes
free_lun, lun
adminList = adminRaster[UNIQ(adminRaster, SORT(adminRaster))]   ; array with unique admin codes (first=0) in file
noAdminCode =255                                                ; this is the value which does not correspond to an admin unit
index=WHERE(adminList NE noAdminCode)                           ; NOTE: perhaps this value needs changing??
IF index[0] ne -1 THEN adminList=adminList[index]               ; remove this value from the adminList

; Create access to lines of phenology-data: Depends if byte or integer
OPENR, R1, inFile, /GET_LUN                ; Open the stack-file for reading
lineAssZNDVI = ASSOC(R1, FLTARR(ns,nb))    ; Associate a line of data (with all bands)

; Create access to diagnostics file
OPENR, R2, diaFile, /GET_LUN                ; Open the diagnostics file
assDia = ASSOC(R2, BYTARR(ns,nl))    ; Associate a line of data (with all bands)
diaImage = assDia[0]

; Create the arrays where all aggregated values will be stored. One column for Admin1-units
; (standard value is mask value -1) --> therefore substract 1 from LONARR
zNDVI_array = FLTARR(nb,N_ELEMENTS(adminlist))-1
; note: in second column we will write the total number of pixels (*100)
weightArray = LONARR(N_ELEMENTS(adminList))

; Here the average cumNDVI per Admin1-region is calculated.
FOR admin=0,N_ELEMENTS(adminList)-1, 1L DO BEGIN
  adminCode = adminList[admin]                          ; assign adminCode-region to process
  ; create a weight-file in original GIMMS geometry that indicates % of adminArea per original GIMMS-pixel
  adminWeights=BYTARR(ns,nl)
  IF ratioAdmin gt 1 THEN BEGIN
    FOR i=0,ns-1,1L DO BEGIN                             ; Loop over lines of GIMMS-geometry
      FOR j=0,nl-1,1L DO BEGIN                           ; Loop over sample of GIMMS-geometry
        ; create 1st an 10*10 window to calculate percentages
        window = adminRaster[i*ratioAdmin:i*ratioAdmin+(ratioAdmin-1), j*ratioAdmin:j*ratioAdmin+(ratioAdmin-1)]
        ; For the 100 pixels, sum #pixels of admin-unit within GIMMS pixel.
        test = where(window eq adminCode, CNT1)
        adminWeights[i,j] = BYTE(CNT1)                 ; BYTE because maximum is 100 (with ratio 10, with ratios above 15: change!)
      ENDFOR
    ENDFOR
  ENDIF ELSE BEGIN                                   ; for all other cases we just assign weight '1' to all pixels within admin-unit
    index=WHERE(adminRaster eq adminCode)
    IF index[0] NE -1 THEN adminWeights[index]=1B
  ENDELSE
    
  ; Here first find out which lines to access: this depends both on adminWeights and diagnostics
  index = where(adminWeights gt 0 AND diaImage eq 0, COUNT)   
  
  IF index[0] NE -1 THEN BEGIN   ; Admin-code may not exist for some reason or not enough points in admin region with good weight --> output remains -1
    weightArrayAdmin = adminWeights[index]   ; put the weight for later multiplication
    ; here loop over relevant lines & build temporary array of all relevant pixels
    lines = index/ns
    uniqlines = lines[UNIQ(lines)]
    j = 0
    ; loop over lines of data where Admin region falls in
    WHILE j lt N_ELEMENTS(uniqlines) DO BEGIN
      zNDVIdataLine = lineAssZNDVI[uniqlines[j]]
      check = where(lines eq uniqlines[j], CNT)
      index2 = index[check] mod ns                 ; index for the relevant samples in the line
      IF j eq 0 THEN BEGIN
        zNDVIArrayAdminComplete = zNDVIdataLine[index2,*]
      ENDIF ELSE BEGIN
        zNDVIArrayAdminComplete = [zNDVIArrayAdminComplete, zNDVIdataLine[index2,*]]
      ENDELSE
      j++
    ENDWHILE
    totalWeight = LONG(TOTAL(weightArrayAdmin))       ; note; this is in general the total weight, but may adapt because of NaN-values...
    weightArray[admin]=totalWeight
    ; the final step of combining the weights with the zNDVIArrayAdminComplete
    FOR t=0, nb-1, 1L DO BEGIN            ; note: different as previously, because NaN can occur
      zNDVIAdmin_OneTimePeriod = zNDVIArrayAdminComplete[*,t]
      index=WHERE(FINITE(zNDVIAdmin_OneTimePeriod))
      zNDVIAdminAvg_OneTimePeriod = TOTAL(zNDVIAdmin_OneTimePeriod[index]*weightArrayAdmin[index])/TOTAL(weightArrayAdmin[index])
      zNDVI_array[t,admin] = zNDVIAdminAvg_OneTimePeriod
    ENDFOR
    ; note: below the older version (instead of FOR-loop): a lot faster, but does not account for NaN-values
    ;weights = weightArrayAdmin # replicate(1,nb)      ; array with weights 
    ;zNDVIAdminAvg = TOTAL((FLOAT(zNDVIArrayAdminComplete)* weights),1)/totalWeight
    ;zNDVI_array[*,admin] = zNDVIAdminAvg
  ENDIF

ENDFOR
CLOSE, /ALL

; Write away the output to a CSV-file
outFile = workPath+'zNDVI_aggregated_'+dataSet+ '.csv'
IF FILE_TEST(outFile) eq 1 THEN FILE_DELETE, outFile
OPENW, W1, outFile, /GET_LUN, width=2000                        ; set width to get all data in one row
PRINTF,W1, ';Aggregated z-scored NDVI for '+dataSet+' of Kenyan divisions'
IF ratioAdmin eq 1 THEN PRINTF,W1, 'adminID, pixels,'+STRJOIN(bandArray,',')
IF ratioAdmin gt 1 THEN PRINTF,W1, 'adminID, pixels*'+STRTRIM(ratioAdmin^2,2)+','+STRJOIN(bandArray,',')
FOR i=0, N_ELEMENTS(adminList)-1, 1L DO BEGIN
  writeline = STRCOMPRESS(FIX(adminList[i]),/REMOVE_ALL)+','+STRCOMPRESS(weightArray[i],/REMOVE_ALL)+','+$
              STRJOIN(STRCOMPRESS(zNDVI_array[*,i],/REMOVE_ALL),',')
  printf, W1, writeline
ENDFOR
CLOSE, W1

; Evaluation of processing time
ELAPSED_TIME = FIX(SYSTIME(1) - STARTTIME)
MINUTES = ELAPSED_TIME / 60
SECS=ELAPSED_TIME MOD 60
PRINT, 'PROCESSING TOOK :'+STRCOMPRESS(MINUTES)+' MINUTES AND'+STRCOMPRESS(SECS)+' SECONDS'
PRINT, 'FINISHED AGGREGATING'

END ;Procedure AGGREGATE_CUM_SPOT