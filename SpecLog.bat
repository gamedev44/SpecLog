@echo off
cls
goto setup

:setup

:: Create the "SpecLogs" folder on the desktop
set "desktop=%userprofile%\Desktop"
set "log_folder=%desktop%\SpecLogs"
if not exist "%log_folder%" mkdir "%log_folder%"

:: Create a timestamp for the log file
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set "timestamp=%%a"
set "timestamp=%timestamp:~0,14%"
set "log_file=%log_folder%\log_%timestamp%.txt"

:menu
cls
echo ------------ -----------  ------------ ------------ ----           --------   ------------ 
echo ************ ************ ************ ************ ****          **********  ************ 
echo ----         ---      --- ----         ---          ----         ----    ---- ----         
echo ************ ************ ************ ***          ****         ***      *** ****  ****** 
echo ------------ -----------  ------------ ---          ----         ---      --- ----  ------ 
echo        ***** ****         ****         ***          ************ ****    **** ****    **** 
echo ------------ ----         ------------ ------------ ------------  ----------  ------------ 
echo ************ ****         ************ ************ ************   ********   ************ 
echo.
echo ****************** Menu *********************************
echo 1. Check Full System Specs and Scan (Generate Log)
echo 2. Check Network Specifications (Generate Log)
echo 3. Check Computer Specifications (System Info) (Generate Log)
echo 4. Check Computer Specifications (Detailed) (Generate Log)
echo 5. Check Graphics Card (Generate Log)
echo 6. Check Motherboard Type (Generate Log)
echo 7. Check CPU Information (Generate Log)
echo 8. Check Available RAM (Generate Log)
echo 9. Check VRAM (Generate Log)
echo A. Scan for PC Problems (SFC Scan) (Generate Log)
echo B. Repair PC Issues (SFC Repair) (Generate Log)
echo C. Scan Available Networks (Generate Log)
echo D. Exit Tool
set /p ans=Enter your choice: 

if "%ans%"=="1" call :check_specs_and_scan
if "%ans%"=="2" call :check_network
if "%ans%"=="3" call :check_computer_systeminfo
if "%ans%"=="4" call :check_computer_detailed
if "%ans%"=="5" call :check_graphics_card
if "%ans%"=="6" call :check_motherboard
if "%ans%"=="7" call :check_cpu
if "%ans%"=="8" call :check_ram
if "%ans%"=="9" call :check_vram
if /i "%ans%"=="A" call :sfc_scan_menu
if /i "%ans%"=="B" call :sfc_repair_menu
if /i "%ans%"=="C" call :scan_networks
if /i "%ans%"=="D" exit
echo Invalid choice, please try again.
pause
goto menu

:check_specs_and_scan
cls
echo Checking Full System Specs...
systeminfo > "%log_folder%\system_specs.txt"
echo Full System Specs saved to "system_specs.txt"
echo.
echo Scanning for PC Problems (SFC Scan)...
sfc /scannow >> "%log_folder%\sfc_scan.log"
echo SFC Scan results saved to "sfc_scan.log"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_network
cls
echo Checking Network Specifications...
netsh wlan show interfaces > "%log_folder%\network_specs.txt"
echo Network Specifications saved to "network_specs.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_computer_systeminfo
cls
echo Checking Computer Specifications (System Info)...
systeminfo > "%log_folder%\computer_specs_systeminfo.txt"
echo Computer Specifications saved to "computer_specs_systeminfo.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_computer_detailed
cls
echo Checking Computer Specifications (Detailed)...
msinfo32 /report "%log_folder%\computer_specs_msinfo32.txt"
echo Computer Specifications saved to "computer_specs_msinfo32.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_graphics_card
cls
echo Checking Graphics Card...
wmic path win32_videocontroller get caption > "%log_folder%\graphics_card.txt"
echo Graphics Card information saved to "graphics_card.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_motherboard
cls
echo Checking Motherboard Type...
wmic baseboard get product > "%log_folder%\motherboard.txt"
echo Motherboard information saved to "motherboard.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_cpu
cls
echo Checking CPU Information...
wmic cpu get caption > "%log_folder%\cpu_info.txt"
echo CPU information saved to "cpu_info.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_ram
cls
echo Checking Available RAM...
wmic memorychip get capacity > "%log_folder%\ram_info.txt"
echo RAM information saved to "ram_info.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:check_vram
cls
echo Checking VRAM...
wmic path win32_videocontroller get AdapterRAM > "%log_folder%\vram_info.txt"
echo VRAM information saved to "vram_info.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:sfc_scan_menu
cls
echo SFC Scan Options:
echo 1. Scan Whole System
echo 2. Specify Single File Directory
echo 3. Back to Main Menu
set /p sfc_choice=Enter your choice: 

if "%sfc_choice%"=="1" (
    echo Scanning for PC Problems (SFC Scan)...
    sfc /scannow >> "%log_folder%\sfc_scan.log"
    echo SFC Scan results saved to "sfc_scan.log"
) else if "%sfc_choice%"=="2" (
    set /p sfc_directory=Enter the single file directory (e.g., C:\Windows): 
    echo Scanning for PC Problems (SFC Scan) in specified directory...
    sfc /scannow /offwindir=!sfc_directory! >> "%log_folder%\sfc_scan.log"
    echo SFC Scan results saved to "sfc_scan.log"
)

echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:sfc_repair_menu
cls
echo Repairing PC Issues (SFC Repair)...
sfc /scannow /offbootdir=C:\ /offwindir=C:\Windows >> "%log_folder%\sfc_repair.log"
echo SFC Repair results saved to "sfc_repair.log"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:scan_networks
cls
echo Scanning Available Networks...
netsh wlan show networks mode=bssid > "%log_folder%\network_scan.txt"
echo Network scan results saved to "network_scan.txt"
echo.
echo Log files have been generated in the "SpecLogs" folder on the desktop.
pause
goto menu

:close
exit

:log_message
if "%*"=="" goto :eof
echo %* >> "%log_file%"
goto :eof
