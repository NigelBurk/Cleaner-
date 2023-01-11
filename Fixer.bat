@echo off
echo Running advanced troubleshooter...

rem Reset Windows settings to default
dism.exe /Online /Cleanup-image /Restorehealth

rem Reset network adapter settings
netsh int ip reset
netsh winsock reset

rem Reset Windows Update components
net stop wuauserv
net stop cryptsvc
ren %systemroot%\SoftwareDistribution SoftwareDistribution.old
ren %systemroot%\system32\catroot2 catroot2.old
net start wuauserv
net start cryptsvc

rem Run the System File Checker and repair any corrupted files
sfc /scannow

rem Run the Deployment Image Servicing and Management (DISM) tool
dism.exe /Online /Cleanup-image /Scanhealth
dism.exe /Online /Cleanup-image /Checkhealth
dism.exe /Online /Cleanup-image /Restorehealth

rem Re-register important DLL files and fix common issues with Windows apps
FOR /F "tokens=*" %1 IN ('dir /s /b %windir%\System32\*.dll') DO regsvr32 /s %1
FOR /F "tokens=*" %1 IN ('dir /s /b %windir%\SysWOW64\*.dll') DO regsvr32 /s %1
start ms-settings:
start ms-settings:appsfeatures

echo Advanced troubleshooter complete. Please check the results for any issues that need to be fixed.

@echo off
echo Running service troubleshooter...

FOR /F "tokens=*" %i in ('sc query type= service state= all ^| findstr /B "SERVICE_NAME"') DO (
   rem Get the service name
   set service_name=%i
   set service_name=%service_name:~18%

   rem Stop the service
   net stop %service_name%

   rem Repair the service
   sc.exe config %service_name% obj= ".\LocalSystem" password= ""
   sc.exe failure %service_name% reset= 86400 actions= restart/10000/restart/10000/restart/10000

   rem Start the service
   net start %service_name%
   echo %service_name% troubleshooter complete.
)

@echo off
echo Running service troubleshooter...

rem Stop the service
net stop "ServiceName"

rem Repair the service
sc.exe config "ServiceName" obj= ".\LocalSystem" password= ""
sc.exe failure "ServiceName" reset= 86400 actions= restart/10000/restart/10000/restart/10000

rem Start the service
net start "ServiceName"

echo Service troubleshooter complete. 

