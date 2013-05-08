@echo off
setlocal
echo xRulz OPM Build and Deploy Rulebases: ky_fpr, ky_ui_fc, to Tomcat 7
rem --------------------------------
rem Paths
rem --------------------------------
set sourcePath=C:\Dev\RB\KY_Rulebase\ky_ui_fc\Development\output
set targetPath=C:\Program Files\Apache Software Foundation\Tomcat 7.0\webapps\siebel-web-determinations\WEB-INF\classes\rulebases

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
set configPath="%targetPath%"
rem set imagesPath="%targetPath%"\images\
rem set resourcePath="%targetPath%"\resources\
rem set templatePath="%targetPath%"\templates\
rem --------

robocopy %sourcePath% %configPath% *.rmod *.zip /TS /NP /LOG+:build_output.log
IF ERRORLEVEL 4 GOTO fail03

echo OPM Build Success... Output Rulebases copied to Tomcat 7
EXIT /B 0

:fail01 
echo Fail 01, Your FPR Module build, ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%
:fail02 
echo Fail 02, Your OWD Pixels are not shiny enough, ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%
:fail03 
echo Fail 03, Robust Copy to Tomcat 7, ended badly with code %ERRORLEVEL%
EXIT /B %ERRORLEVEL%


