#Requires AutoHotkey v2.0
#SingleInstance Force

running := false
speedPercent := 0
castWait := 300
myGui := ""
speedEdit := ""
castEdit := ""

LoadSettings()
CreateGUI()
ResizeRobloxWindow()
Sleep(1000)

LoadSettings()
{
    global speedPercent, castWait
    try {
        speedPercent := IniRead("settings.ini", "Settings", "SpeedPercent", 0)
        castWait := IniRead("settings.ini", "Settings", "CastWait", 300)
    } catch {
        speedPercent := 0
        castWait := 300
        SaveSettings()
    }
}

SaveSettings()
{
    global speedPercent, castWait
    try {
        IniWrite(speedPercent, "settings.ini", "Settings", "SpeedPercent")
        IniWrite(castWait, "settings.ini", "Settings", "CastWait")
    } catch as e {
        MsgBox("Error saving settings: " . e.message)
    }
}

UpdateSpeed()
{
    global speedPercent, speedEdit
    try {
        speedPercent := Integer(speedEdit.Text)
        SaveSettings()
    } catch {
        speedEdit.Text := speedPercent
    }
}

UpdateCast()
{
    global castWait, castEdit
    try {
        castWait := Integer(castEdit.Text)
        SaveSettings()
    } catch {
        castEdit.Text := castWait
    }
}

F1::
{
    global running

    MouseMove 479, 299

    if (!running) {
        running := true
        StartMacro()
    } else {
        running := false
    }
}

F2::
{
    Reload
}



StartMacro()
{
    global running, speedPercent
    
    while (running) {
        holdDuration := 400 - (speedPercent * 4)
        if (holdDuration < 1) {
            holdDuration := 1
        }
        
        Click("Down")
        Sleep(holdDuration)
        Click("Up")
        
        Sleep(500)
        
        SpamClickUntilWhite()
        
        Sleep(500)
    }
}

SpamClickUntilWhite()
{
    global running, castWait
    whiteWasDetected := false
    
    while (running) {
        Click()
        Sleep(10)
        
        pixelColor := PixelGetColor(505, 553)
        
        if (pixelColor == 0xFFFFFF) {
            if (!whiteWasDetected) {
                whiteWasDetected := true
            }
        } else {
            if (whiteWasDetected) {
                Sleep(castWait)
                break
            }
        }
    }
}

CreateGUI()
{
    global speedPercent, castWait, myGui, speedEdit, castEdit
    
    if (myGui) {
        try {
            myGui.Destroy()
        }
    }
    
    myGui := Gui("+Resize -MinimizeBox -MaximizeBox", "moris Fish It Macro v1.0")
    myGui.SetFont("s10")
    
    myGui.Add("Text", "x10 y10", "Speed % :")
    speedEdit := myGui.Add("Edit", "x75 y8 w40 vSpeedPercent Center", speedPercent)
    speedEdit.OnEvent("Change", (*) => UpdateSpeed())
    
    myGui.Add("Text", "x140 y10", "Cast Wait :")
    castEdit := myGui.Add("Edit", "x205 y8 w40 vCastWait Center", castWait)
    castEdit.OnEvent("Change", (*) => UpdateCast())
    
    myGui.Add("Text", "x10 y40 w340", "F1: Start/Stop Macro | F2: Reload Script")
    
    myGui.OnEvent("Close", (*) => myGui.Hide())
    
    myGui.Show("x-7 y630 w260 h70")
}

ResizeRobloxWindow() {
    robloxWindow := ""
    robloxTitles := ["Roblox", "ahk_exe RobloxPlayerBeta.exe", "ahk_exe RobloxPlayer.exe"]
    
    for title in robloxTitles {
        try {
            if WinExist(title) {
                robloxWindow := title
                break
            }
        }
    }
    
    if (robloxWindow = "") {
        return false
    }
    
    try {
        WinActivate(robloxWindow)
        Sleep(100)
    } catch as e {
        return false
    }
    try {
        currentStyle := WinGetStyle(robloxWindow)
    } catch as e {
        return false
    }
    
    if (!(currentStyle & 0x00C00000)) {
        SendInput("{F11}")
        Sleep(300)
    }
    
    try {
        WinRestore(robloxWindow)
        WinSetStyle("+0x00C40000", robloxWindow)
        WinMove(-7, 0, 974, 630, robloxWindow)
    } catch as e {
        return false
    }

    return true
}