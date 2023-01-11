@echo off

rem Clear temporary files
echo Clearing temporary files...
del /F /S /Q %TEMP%\*
del /F /S /Q %TMP%\*
del /F /S /Q %WINDIR%\Temp\*

rem Clear prefetch files
echo Clearing prefetch files...
del /F /S /Q %WINDIR%\Prefetch\*

rem Clear Windows event logs
echo Clearing event logs...
wevtutil el | Foreach-Object {wevtutil cl "$_"}

rem Clear memory dumps
echo Clearing memory dumps...
del /F /S /Q %WINDIR%\memory.dmp
del /F /S /Q %WINDIR%\Minidump\*

rem Clear crash dumps
echo Clearing crash dumps...
del /F /S /Q %LOCALAPPDATA%\CrashDumps\*

rem Uninstall commonly-installed bloatware
echo Uninstalling bloatware...
wmic product where "name like '%Bing Bar%'" call uninstall
wmic product where "name like '%WildTangent Games%'" call uninstall
wmc product where "name like '%Yahoo Toolbar%'" call uninstall
wmic product where "name like '%Windows Live Essentials%'" call uninstall
echo Done!
