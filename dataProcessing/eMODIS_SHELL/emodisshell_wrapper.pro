PRO eModisShell_Wrapper , settingsFilePath

print, 'OK1'
;; This is a wrapper to emodisshell , it makes sure the code runs each day at midnight and manages the log files.
tempsettingsFilePath = command_line_args(count=nparams)
IF (nparams GE 1) THEN BEGIN
settingsFilePath = tempsettingsFilePath
ENDIF

print, 'OK2'

IF ((nparams LT 1) and (settingsFilePath EQ '')) THEN BEGIN
  print, 'Please Enter a valid file'
  STOP
ENDIF


print, 'OK3'
IF FILE_TEST(settingsFilePath) EQ 0 THEN BEGIN
    print , 'Could not find the settings File in the path specified . . . '
    STOP
ENDIF



print, 'ok4'
WHILE(1) DO BEGIN



CALDAT,SYSTIME(/JULIAN),Month,Day,Year,Hour ; Get the current date.
print, 'ok5'
print,settingsFilePath
print,'log_'+strtrim(string(Day,1))+'_'+strtrim(string(Month,1))+'_'+strtrim(string(Year,1))+'_'+strtrim(string(Hour,1))
spawn , 'idl -rt=emodisshell.sav -args "'+settingsFilePath+'">log_'+strtrim(string(Day,1))+'_'+strtrim(string(Month,1))+'_'+strtrim(string(Year,1))+'_'+strtrim(string(Hour,1))


WAIT,UINT(60*60*12)
ENDWHILE

END