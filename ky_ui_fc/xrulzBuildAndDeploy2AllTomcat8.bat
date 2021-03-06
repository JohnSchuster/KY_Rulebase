@echo off
setlocal
echo xRulz OPM Build and Deploy Rulebases: ky_fpr, ky_ui_fc, to Tomcat 8
rem --------------------------------
rem Paths
rem --------------------------------
set sourcePath=C:\Dev\RB\KY_Rulebase\ky_ui_fc\Development\output
set targetPath1=C:\Program Files\Apache Software Foundation\Tomcat 8.0\webapps\siebel-web-determinations\WEB-INF\classes\rulebases
set targetPath2=C:\Program Files\Apache Software Foundation\Tomcat 8.0\webapps\web-determinations\WEB-INF\classes\rulebases

set opm_compiler=C:\Program Files (x86)\Oracle\Policy Modeling\bin\Oracle.Policy.Modeling.CommandLineCompiler.exe
set rb_ky_fpr=C:\Dev\RB\KY_Rulebase\ky_fpr\Development\ky_fpr.xprj
set rb_ky_ui_fc=C:\Dev\RB\KY_Rulebase\ky_ui_fc\Development\ky_ui_fc.xprj

rem --- Build as a Module,  
echo Building Module: %rb_ky_fpr%
"%opm_compiler%" "%rb_ky_fpr%" -m -sb -vds -n v0.0.1.0 > build_output.log
IF ERRORLEVEL 1 GOTO fail01

echo Building OWD: %rb_ky_ui_fc%
"%opm_compiler%" "%rb_ky_ui_fc%" -sb -vds -n v0.0.1.0 >> build_output.log
IF ERRORLEVEL 1 GOTO fail02

rem --------------------------------- 
set configPath1="%targetPath1%"
set configPath2="%targetPath2%"
rem set imagesPath="%targetPath%"\images\
rem set resourcePath="%targetPath%"\resources\
rem set templatePath="%targetPath%"\templates\
rem --------

robocopy %sourcePath% %configPath1% *.rmod *.zip /TS /NP /LOG+:build_output.log
IF ERRORLEVEL 4 GOTO fail03
robocopy %sourcePath% %configPath2% *.rmod *.zip /TS /NP /LOG+:build_output.log
IF ERRORLEVEL 4 GOTO fail04

echo OPM Build Success... Output Rulebases copied to Tomcat 8
EXIT /B 0

:fail01 
echo Fail 01, Your FPR Module build, ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%
:fail02 
echo Fail 02, Your OWD Pixels are not shiny enough, ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%
:fail03 
echo Fail 03, Robust Copy to Tomcat 8, siebel-web-determinations, ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%
:fail04 
echo Fail 04, Robust Copy to Tomcat 8, web-determinations, ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%

