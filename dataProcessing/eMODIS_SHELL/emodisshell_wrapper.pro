PRO eModisShell_Wrapper , settingsFilePath


;; This is a wrapper to emodisshell , it makes sure the code runs each day at midnight and manages the log files.
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




WHILE(1) DO BEGIN



CALDAT,SYSTIME(/JULIAN),Month,Day,Year,Hour ; Get the current date.
spawn , 'id -rt=emodisshell.sav -args "'+settingsFilePath+'">log_'+strtrim(string(Day,1))+'_'+strtrim(string(Month,1))+strtrim(string(Year,1))+strtrim(string(Hour,1))


WAIT,60*60*12
ENDWHILE

END