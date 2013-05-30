echo off
set local
rem --------
rem SD: 2013-05-29
rem --------
echo ---
echo Copies Lipstick, to Tomcat 7.0 siebel-web-determinations, web-determinations, and OPM Release
echo Note: Synchronizes siebel-web-determinations (baseline) to web-determinations (sync target)
echo ---
SET /P ANSWER=Continue (y)?
if /i {%ANSWER%}=={y} (goto :doit)
if /i {%ANSWER%}=={Y} (goto :doit)
goto :abort
:doit
echo off

set sourcePath0=C:\Dev\RB\KY_Rulebase\Tomcat\webapps\siebel-web-determinations\WEB-INF\classes\templates
set sourcePath1=C:\Dev\RB\KY_Rulebase\Tomcat\webapps\siebel-web-determinations\WEB-INF
set sourcePath2=C:\Dev\RB\KY_Rulebase\Tomcat\webapps\web-determinations\WEB-INF

set targetPath_00=C:\Dev\RB\KY_Rulebase\Tomcat\webapps\web-determinations\WEB-INF\classes\templates
set targetPath_01="C:\Program Files\Apache Software Foundation\Tomcat 7.0\webapps\siebel-web-determinations\WEB-INF"
set targetPath_02="C:\Dev\RB\KY_Rulebase\ky_ui_fc\Release\web-determinations\WEB-INF"
set targetPath_03="C:\Program Files\Apache Software Foundation\Tomcat 7.0\webapps\web-determinations\WEB-INF"

set exclude_01="C:\Program Files\Apache Software Foundation\Tomcat 7.0\webapps\siebel-web-determinations\WEB-INF\classes\rulebases"
rem --------
echo on
echo Synchronizing siebel-web-determinations to web-determinations
robocopy %sourcePath0% %targetPath_00% /S /IS /NP /XD /LOG+:build_output.log
IF ERRORLEVEL 4 GOTO fail04
robocopy %sourcePath1% %targetPath_01% /S /IS /NP /XD %exclude_01% /LOG+:build_output.log
IF ERRORLEVEL 4 GOTO fail04
robocopy %sourcePath2% %targetPath_02% /S /IS /NP /XD %exclude_01% /LOG+:build_output.log
IF ERRORLEVEL 4 GOTO fail04
robocopy %sourcePath2% %targetPath_03% /S /IS /NP /XD %exclude_01% /LOG+:build_output.log
IF ERRORLEVEL 4 GOTO fail04
echo All Copies Completed.  Restart Tomcat 7 and Test!
exit /B 0

:abort
echo Copy Aborted.
exit /B 1

:fail04
echo Failed: Robust Copy ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%
