PRO eModisShell_Wrapper , settingsFilePath


;; This is a wrapper to emodisshell , it makes sure the code runs each day at midnight and manages the log files.

WHILE(1) DO BEGIN


CATCH,Error_Status
CALDAT,SYSTIME(/JULIAN),Month,Day,Year,Hour ; Get the current date.
spawn , 'id -rt=emodisshell.sav -args "'+settingsFilePath+'">log_'+strtrim(string(Day,1))+'_'+strtrim(string(Month,1))+strtrim(string(Year,1))+strtrim(string(Hour,1))


WAIT,60*60*12
ENDWHILE

END