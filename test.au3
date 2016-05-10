#include <Array.au3>
#include <GUIConstantsEx.au3> 
#include <WindowsConstants.au3>
#include <ColorConstants.au3>

const $conf = "avrdude.ini"

Opt("GUIOnEventMode", 1)  ; Включает режим OnEvent 
$programmer = ""
$device = ""
$project = ""
$target = ""
$auto = ""
$hex = ""
$eep = ""

$i = 1

while ($i <= $CmdLine[0])
    switch (StringLeft($CmdLine[$i], 2))
        case "-p"
            $project = StringTrimLeft($CmdLine[$i], 2)
        case "-t"
            $target = StringTrimLeft($CmdLine[$i], 2)
        case "-a"
            $auto = StringTrimLeft($CmdLine[$i], 2)
    endswitch
    $i += 1
wend

if (FileExists($target & ".hex")) then
    $hex = $target & ".hex"
endif
if (FileExists($target & ".eep")) then
    $eep = $target & ".eep"
endif

ReadVars()

$mainWindow = GUICreate("Main", 700, 700) 
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked") 

$progCtrl = GUICtrlCreateInput($programmer, 20, 20, 100)
GUICtrlSetOnEvent($progCtrl, "UpdateVars")
$devCtrl = GUICtrlCreateInput($device, 140, 20, 100)
GUICtrlSetOnEvent($devCtrl, "UpdateVars")
$hexCtrl = GUICtrlCreateInput($hex, 20, 50, 600)
$eepCtrl = GUICtrlCreateInput($eep, 20, 80, 600)

$paramsEdit = GUICtrlCreateEdit("", 20, 380, 660, 300);
GUICtrlSetFont($paramsEdit, 10, 0, 0, "Consolas")
GUICtrlSetBkColor($paramsEdit, 0x040404)
GUICtrlSetColor($paramsEdit, 0x88FF88)
;GUICtrlSetData($paramsEdit, _ArrayToString($CmdLine, @CRLF), 1);
GUISetState(@SW_SHOW, $mainWindow) 

$pid = Run(@ScriptDir & "\avrdude.exe -c usbasp -p m328p", "", @SW_HIDE, $STDOUT_CHILD + $STDERR_CHILD)

while ProcessExists($pid)
    GUICtrlSetData($paramsEdit, StdoutRead($pid), 1)
    GUICtrlSetData($paramsEdit, StderrRead($pid), 1)
wend


While (1)
  Sleep(1000)
WEnd 

;---------------------------------------

func ReadVars()
    $confPath = $project & $conf
    $section = "conf"
    $programmer = IniRead($confPath, $section, "programmer", "")
    $device = IniRead($confPath, $section, "device", "")
endfunc

func WriteVars()
    $confPath = $project & $conf
    $section = "conf"
    IniWrite($confPath, $section, "programmer", $programmer)
    IniWrite($confPath, $section, "device", $device)
endfunc

func UpdateVars()
    switch (@GUI_CtrlId)
        case 0
    endswitch
    $programmer = GUICtrlRead($progCtrl)
    $device= GUICtrlRead($devCtrl)
    $hex= GUICtrlRead($hexCtrl)
    $eep= GUICtrlRead($eepCtrl)
endfunc

Func CLOSEClicked() 
    If @GUI_WinHandle = $mainwindow Then 
        UpdateVars()
        WriteVars()
        Exit 
    EndIf 
EndFunc