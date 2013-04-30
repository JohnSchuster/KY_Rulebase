echo off
echo Build and Deploy
set local
rem --------------------------------
rem set up some base directory paths
rem --------------------------------
set sourcePath=C:\Dev\RB\KY_Rulebase\ky_ui_fc\Development\output
set targetPath=C:\Program Files\Apache Software Foundation\Tomcat 6.0\webapps\web-determinations\WEB-INF\classes\rulebases

set opm_compiler=C:\Program Files (x86)\Oracle\Policy Modeling\bin\Oracle.Policy.Modeling.CommandLineCompiler.exe
set rb_ky_fpr=C:\Dev\RB\KY_Rulebase\ky_fpr\Development\ky_fpr.xprj
set rb_ky_ui_fc=C:\Dev\RB\KY_Rulebase\ky_ui_fc\Development\ky_ui_fc.xprj

echo Building %rb_ky_fpr%
"%opm_compiler%" "%rb_ky_fpr%" -m -sb -vd > build_output.log
echo Building %rb_ky_ui_fc%
"%opm_compiler%" "%rb_ky_ui_fc%" -sb -vd -n v0.0.1.0 >> build_output.log

rem --------------------------------- 
set configPath="%targetPath%"
rem set imagesPath="%targetPath%"\images\
rem set resourcePath="%targetPath%"\resources\
rem set templatePath="%targetPath%"\templates\
rem --------
echo on
robocopy %sourcePath% %configPath% *.rmod *.zip >> build_output.log
