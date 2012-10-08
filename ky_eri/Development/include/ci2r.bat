@echo off
setlocal
Rem -- Steve Doody - OPA CoE - August 2010
Rem -- CI2R: Copy Includes to Release Directories  
Rem -- To customize look and feel, many files in the Release directory structure must be changed.
Rem -- These files may be lost if the release folder is re-built.
Rem -- Relative paths assume this command is run from the OPM "include" folder
Rem -- Logpath is used to record the result of the commands, the log is overwritten each time
set logpath="ci2r.log"

REM ------
cls
echo CI2R:Running
echo CI2R running at %DATE% %TIME% > %logpath%
echo Note: Copying any gif image files from include to release
copy /Y *.gif ..\..\Release\web-determinations\WEB-INF\classes\images >> ci2r.log

echo Note: Copying any properties files from include to release
copy /Y *.properties ..\..\Release\web-determinations\WEB-INF\classes\configuration >> ci2r.log

echo Note: Copying any css files from include to release
copy /Y *.css ..\..\Release\web-determinations\WEB-INF\classes\templates >> ci2r.log

echo Note: Copying any .jar plugin files from include to release
copy /Y *.jar ..\..\Release\web-determinations\WEB-INF\classes\plugins >> ci2r.log

echo CI2R: Completed, Log details in %logpath%

