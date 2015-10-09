@echo off
::
set version=2015.10.06
::
:: astudio_dude.cmd <prodect_dir> [-c] [-f] [-e] [-F] [target_name]
::
::      -c      Edit conf file
::      -f      Write Flash memory
::      -e      Write EEPROM memory
::      -F      Write FUSEs
::
:: Atmel Studio external tools:
::
:: Title:              AVRdude : Flash
:: Command:            <path>\astudio_dude.cmd
:: Arguments:          $(ProjectDir) -f $(TargetName)
:: Initial directory:  $(TargetDir)
:: [X] Use output window
:: [ ] Prompt for arguments
:: [ ] Treat output as Unicode
::
:: Title:              AVRdude : EEPROM
:: Command:            <path>\astudio_dude.cmd
:: Arguments:          $(ProjectDir) -e $(TargetName)
:: Initial directory:  $(TargetDir)
:: [X] Use output window
:: [ ] Prompt for arguments
:: [ ] Treat output as Unicode
::
:: Title:              AVRdude : FUSEs
:: Command:            <path>\astudio_dude.cmd
:: Arguments:          $(ProjectDir) -F
:: Initial directory:  $(TargetDir)
:: [X] Use output window
:: [ ] Prompt for arguments
:: [ ] Treat output as Unicode
::
:: Title:              AVRdude : Reset
:: Description         Just access to microcontroller and reset it. Without programming
:: Command:            <path>\astudio_dude.cmd
:: Arguments:          $(ProjectDir)
:: Initial directory:  $(TargetDir)
:: [X] Use output window
:: [ ] Prompt for arguments
:: [ ] Treat output as Unicode
::
:: Title:              AVRdude : Conf
:: Command:            <path>\astudio_dude.cmd
:: Arguments:          $(ProjectDir) -c
:: Initial directory:  $(TargetDir)
:: [X] Use output window
:: [ ] Prompt for arguments
:: [ ] Treat output as Unicode
::

chcp 1251 > nul

echo AVRdude for Atmel Studio (%version%)
echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
::date /t
::time /t
::echo ~~~~~~~~~~~~~~~~~~~~~~~~

set editor=C:\Program Files (x86)\Notepad++\notepad++.exe
set dudepath=%~dp0
set projpath=%~dp1
set conf=%projpath%astudio_dude.conf
shift

:flags
if x%1==x-f (
    set Aflash=1
    shift
    goto flags
)
if x%1==x-e (
    set Aeeprom=1
    shift
    goto flags
)
if x%1==x-F (
    set Afuses=1
    shift
    goto flags
)
if x%1==x-c (
    set Aconf=1
    shift
    goto flags
)

if exist "%conf%" (
    for /f "eol=# tokens=1,2" %%i in (%conf%) do (
        set c_%%i=%%j
    )
) else (
    echo !!: File %conf% not exist
)

if x%Aconf%==x ( 
    set edit=1
    goto conf
)


if x%c_device%==x (
    echo EE: Device not specified.
    set edit=1
    goto conf
)
if x%c_programmer%==x (
    echo EE: Programmer not specified.
    set edit=1
    goto conf
)

set target=%1.
set target=%target:"=%
if not x%Aflash%%Aeeprom%==x (
    if x%target%==x (
        echo EE: Target not specified
        exit
    )
)

set params=

if x%Afuses%==x goto skipfuse
if not x%c_writefuse%==xYES (
    echo ii: Getting FUSEs
    for /F "tokens=*" %%i in ('"%dudepath%avrdude.exe" -p %c_device% -c %c_programmer% -B 4 -U efuse:r:-:b -qq') do set c_efuse=%%i
    for /F "tokens=*" %%i in ('"%dudepath%avrdude.exe" -p %c_device% -c %c_programmer% -B 4 -U hfuse:r:-:b -qq') do set c_hfuse=%%i
    for /F "tokens=*" %%i in ('"%dudepath%avrdude.exe" -p %c_device% -c %c_programmer% -B 4 -U lfuse:r:-:b -qq') do set c_lfuse=%%i
    echo !!: Change efuse, lfuse, hfuse and uncomment "writefuse YES" to write FUSEs
    set edit=1
    goto conf
)
if not x%c_efuse%==x set params=%params% -U efuse:w:%c_efuse%:m
if not x%c_hfuse%==x set params=%params% -U hfuse:w:%c_hfuse%:m
if not x%c_lfuse%==x set params=%params% -U lfuse:w:%c_lfuse%:m
set c_efuse=
set c_lfuse=
set c_hfuse=
:skipfuse

if x%Aflash%==x1 (
    if not exist "%target%hex" (
        echo EE: "%target%hex" not found!
        exit
    )
    set params=%params% -U flash:w:"%target%hex"
)
if x%Aeeprom%==x1 (
    if not exist "%target%eep" (
        echo EE: "%target%eep" not found!
        exit
    )
    set params=%params% -U eeprom:w:"%target%eep"
)


if not x%c_port%==x set params=%params% -P %c_port%
if not x%c_baudrate%==x set params=%params% -b %c_baudrate%
if not x%c_bitclock%==x set params=%params% -B %c_bitclock%

echo "%dudepath%avrdude.exe" -p %c_device% -c %c_programmer% %params%

:: =============================
:: == conf ==
:conf

echo # Configuration for AStudioDude> %conf%
if not x%c_device%==x       (echo device %c_device% >> %conf%)           else echo device >> %conf%
if not x%c_programmer%==x   (echo programmer %c_programmer% >> %conf%)   else echo programmer usbasp >> %conf%
if not x%c_port%==x         (echo port %c_port% >> %conf%)               else echo #port >> %conf%
if not x%c_baudrate%==x     (echo baudrate %c_baudrate% >> %conf%)       else echo #baudrate >> %conf%
if not x%c_bitclock%==x     (echo bitclock %c_bitclock% >> %conf%)       else echo #bitclock >> %conf%
if not x%c_efuse%==x        (echo #efuse %c_efuse% >> %conf%)
if not x%c_hfuse%==x        (echo #hfuse %c_hfuse% >> %conf%)
if not x%c_lfuse%==x        (echo #lfuse %c_lfuse% >> %conf%)
echo #writefuse NO >> %conf%

if x%edit%==x1 (
    echo ii: Edit config
    if not exist "%editor%" set editor="notepad.exe"
    start "" "%editor%" "%conf%"
)