PRO CREATE_HEADER, OUTFILE,samples,lines,bands,bandNames      ; Procedure to generate generic header for each output
HEADER_OUT=STRMID(OUTFILE,0,STRLEN(OUTFILE)-3)+'hdr'
IF FILE_TEST(HEADER_OUT) eq 1 THEN FILE_DELETE, HEADER_OUT
OPENW,3, HEADER_OUT
printf,3,'ENVI'
printf,3,'description = {'
printf,3,'  '+'Generic ENVI-header for '+FILE_BASENAME(OUTFILE)+'}'
printf,3,'samples = ' + string(samples)
printf,3,'lines   = ' + string(lines)
printf,3,'bands   = ' + string(bands)
printf,3,'header offset = 0'
printf,3,'file type = ENVI Standard'
printf,3,'data type = 1'
printf,3,'interleave = bsq'
printf,3,'sensor type = MODIS'
printf,3,'byte order = 0'
printf,3,'map info = {Geographic Lat/Lon, 1.0000, 1.0000, 33.7889, 5.6265, 2.4130000000e-003, 2.4130000000e-003, WGS-84, units=Degrees}'
printf,3,'band names = ' + bandNames
CLOSE,3

END ; CREATE_HEADER
