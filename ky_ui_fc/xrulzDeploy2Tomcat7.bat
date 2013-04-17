echo off
set local
rem --------------------------------
rem set up some base directory paths
rem --------------------------------
set sourcePath=C:\Dev\RB\KY_Rulebase\ky_ui_fc\Development\output
set targetPath=C:\Program Files\Apache Software Foundation\Tomcat 7.0\webapps\web-determinations\WEB-INF\classes\rulebases

rem --------------------------------- 
set configPath="%targetPath%"
rem set imagesPath="%targetPath%"\images\
rem set resourcePath="%targetPath%"\resources\
rem set templatePath="%targetPath%"\templates\
rem --------
echo on
robocopy %sourcePath% %configPath% *.rmod *.zip 
pause