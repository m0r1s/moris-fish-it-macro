#Requires AutoHotkey v2.0
#SingleInstance Force

running := false

ResizeRobloxWindow()

F1::{
    global running
    running := true
    StartFishing()
}

F2:: Reload

ResizeRobloxWindow(){
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

StartFishing() {
    global running
    if (!running)
        return
        
    Send(1)
    Sleep(200)
    Click("Left Down")
    Sleep(300)
    Click("Left Up")
    
    SetTimer(CheckWhite, 10)
}

CheckWhite() {
    global running
    if (!running)
        return
        
    color := PixelGetColor(505, 551, "RGB")
    
    red := (color >> 16) & 0xFF
    green := (color >> 8) & 0xFF
    blue := color & 0xFF
    
    isWhite := (red > 200 && green > 200 && blue > 200)
    
    static wasWhite := false
    
    if (isWhite) {
        wasWhite := true
        Click("Left Down")
        Sleep(5)
        Click("Left Up")
        Sleep(5)
    } else if (wasWhite) {
        wasWhite := false
        SetTimer(CheckWhite, 0)
        Sleep(300)
        StartFishing()
    }
}
