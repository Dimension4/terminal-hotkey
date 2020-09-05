# terminal-hotkey

A simple AutoHotkey script to toggle the visibility of Windows Terminal. This script will always use its own terminal instance. This means toggling for the first time will start a new instance of the terminal, even if there is one running already. If the terminal is closed for whatever reason, toggling again will boot up a new instance.

I've written this script to be used with Windows Terminal, but in theory any application should work. Adjust the variables at the very top of the script to change the application:

```ahk
WindowHeight := 0.45
AppName := "Microsoft.WindowsTerminalPreview"
ProcName := "WindowsTerminal.exe"
```
