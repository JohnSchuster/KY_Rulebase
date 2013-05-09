echo off
set local
rem --------
rem SD: 2013-05-09 Update To Siebel Web Determinations Deployment Target
rem --------
set sourcePath=C:\Dev\RB\KY_Rulebase\Tomcat\webapps\siebel-web-determinations\WEB-INF
set targetPath_01="C:\Program Files\Apache Software Foundation\Tomcat 7.0\webapps\siebel-web-determinations\WEB-INF"
set targetPath_02="C:\Dev\RB\KY_Rulebase\ky_ui_fc\Release\web-determinations\WEB-INF"
rem --------
echo on
robocopy %sourcePath% %targetPath_01% /S /IS
robocopy %sourcePath% %targetPath_02% /S /IS
pause
