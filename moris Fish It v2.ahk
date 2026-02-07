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

ResizeRobloxWindow() {
    titles := ["Roblox", "ahk_exe RobloxPlayerBeta.exe", "ahk_exe RobloxPlayer.exe"]
    targetTitle := ""
    
    for title in titles {
        if WinExist(title) {
            targetTitle := title
            break
        }
    }
    
    if (targetTitle = "") {
        MsgBox("Roblox window not found!")
        return
    }
    
    try {
        WinActivate(targetTitle)
        Sleep(500)
        
        style := WinGetStyle(targetTitle)
        WS_CAPTION := 0xC00000
        WS_THICKFRAME := 0x40000
        
        hasWindowBorders := (style & WS_CAPTION) || (style & WS_THICKFRAME)
        
        if (!hasWindowBorders) {
            Send("{F11}")
            Sleep(500)
        }
        
        WinMove(-7, 0, 974, 630, targetTitle)
    } catch Error as e {
        MsgBox("Error resizing window: " . e.Message)
    }
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
