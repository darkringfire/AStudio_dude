Command line options

-p"project"     path to save .conf
-t"target"      path to binaries
-d"avrdudde"    path to avrdude.exe (default: path to astudiodude.exe)
-a[f][e][c]     automatic flash, eeprom, close

Atmel Studio External tools:

Title:      AStudioDude
Command:    D:\Programs\avrdude\astudiodude.exe
Arguments:  -t$(TargetDir)$(TargetName) -p$(ProjectDir)

Title:      Burn!
Command:    D:\Programs\avrdude\astudiodude.exe
Arguments:  -afc -t$(TargetDir)$(TargetName) -p$(ProjectDir)


