- - - - 15 / 04 / 2014 - - - - 

this code is intendent to run both on linux enviorment and windows with a unix-like enviroment ( for example : cygwin). 
The system requirements are :

 * An active internet connection.
 * IDL Virtual Machine Installed.

The code checks for new updates from USGS - updates the storage - and runs the entire process up to the csv output.
To run the code you'll need a configuration .txt file , an example for a valid configuration file can be found in this folder.

To run the code you need to run the following command line ( assuming idl VM installed) :

idl -vm=emodisshell.sav -args "config.txt"

where "config.txt" can be any path to a valid configuration file.
emodisshell.sav is the compiled version of the code in this folder.


For any issue i available in gitHub or by email : mike_brv@hotmail.com



