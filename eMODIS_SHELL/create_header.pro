PRO CREATE_HEADER, OUTFILE,samples,lines,bands,bandNames,map_info      ; Procedure to generate generic header for each output
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
printf,3,'interleave = bil'
printf,3,'sensor type = MODIS'
printf,3,'byte order = 0'
printf,3,'map info = ' + map_info  
printf,3,'band names = ' + bandNames
CLOSE,3

END ; CREATE_HEADER
