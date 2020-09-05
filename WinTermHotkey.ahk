#NoEnv
#SingleInstance, Force
#NoTrayIcon

WindowHeight := 0.45
AppName := "Microsoft.WindowsTerminalPreview"
ProcName := "WindowsTerminal.exe"

SendMode Input
DetectHiddenWindows, On


#^::
    ToggleApp()



StartApp(appName, procName)
{
    prevPIDs := GetPIDs(procName)
    Run shell:AppsFolder\%appName%_8wekyb3d8bbwe!App,,, pid

    if (pid)
    {
        return pid
    }

    newPIDs := GetPIDs(procName)
    Sort, prevPIDs
    Sort, newPIDs

    for idx, newPID in newPIDs
        if (newPID != prevPIDs[idx])
            return newPID
}

GetPIDs(procName)
{
	static wmi := ComObjGet("winmgmts:root\cimv2")

    pids := []
	for proc in wmi.ExecQuery("SELECT * FROM Win32_Process WHERE Name = '" procName "'")
        pids.Push(proc.processId)

    return pids
}

ProcessExists(pid)
{
    Process, Exist, %pid%
    return (ErrorLevel == pid)
}

GetActiveDisplay()
{
    CoordMode, Mouse, Screen
    MouseGetPos, x, y
    SysGet, count, MonitorCount
    loop %count%
    {
        SysGet, screen, Monitor, %A_Index%
        if (x >= screenLeft and x <= screenRight and y >= screenTop and y <= screenBottom)
        {
            return {x: screenLeft, y: screenTop, width: screenRight - screenLeft, height: screenBottom - screenTop}
        }
    }
}

Activate(window, heightRatio)
{
    screen := GetActiveDisplay()
    WinRestore, ahk_id %window%
    WinActivate, ahk_id %window%
    WinMove, ahk_id %window%,, % screen.x, screen.y, screen.width, screen.height * heightRatio
}

Hide(window)
{
    WinMinimize, ahk_id %window%
    WinHide, ahk_id %window%
}

IsActive(window)
{
    IfWinActive, ahk_id %window%
        return true

    return false
}

GetWindow(pid)
{
    WinGet, windows, List, ahk_pid %pid%
    return windows ? windows1 : 0
}

ToggleApp()
{
    global AppName, ProcName, WindowHeight
    static pid := ""
    justStarted := false

    if (!ProcessExists(pid))
    {
        pid := StartApp(AppName, ProcName)
        WinWait, ahk_pid %pid%
        Sleep, 400
        justStarted := true
    }

    window := GetWindow(pid)
    if (window)
    {
        if (IsActive(window) && !justStarted)
        {
            Hide(window)
        }
        else
        {
            Activate(window, WindowHeight)
        }
    }
    else
    {
        MsgBox, 0x10, "Bad window", % "The process " ProcName " (" pid ") doesn't have any windows."
        pid := ""
    }
}
