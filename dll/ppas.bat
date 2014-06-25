@echo off
SET THEFILE=ce-lib64.dll
echo Linking %THEFILE%
C:\lazarus\fpc\2.6.4\bin\x86_64-win64\ld.exe -b pei-x86-64  --gc-sections  -s --dll  --entry _DLLMainCRTStartup   --base-file base.$$$ -o ce-lib64.dll link.res
if errorlevel 1 goto linkend
dlltool.exe -S C:\lazarus\fpc\2.6.4\bin\x86_64-win64\as.exe -D ce-lib64.dll -e exp.$$$ --base-file base.$$$ 
if errorlevel 1 goto linkend
C:\lazarus\fpc\2.6.4\bin\x86_64-win64\ld.exe -b pei-x86-64  -s --dll  --entry _DLLMainCRTStartup   -o ce-lib64.dll link.res exp.$$$
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
