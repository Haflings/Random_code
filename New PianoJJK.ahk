#Requires AutoHotkey v2.0

g := Gui('AlwaysOnTop', 'Auto Piano')

g.AddText('+Center', '============Roblox Virtual Piano In-Game Styled Autoplayer (v 2.0)============')
g.AddText('+Center',"-----------------------------------------------PASTE SHEETS HERE------------------------------------------------")

Sheet := g.AddEdit("R10 w400")

g.AddText(,"Press the - = [ ] keybinds to start autoplaying. you'll need to play by rhythm.")
g.AddText(,"Click the `"Reset`" button after playing a song/changing a song. (IMPORTANT)")
g.AddText(,"Press \ to exit")
g.AddText(,"Press ' to auto play")
g.AddText(,"Based on the old AutoHotkey Virtual Piano Autoplayer (the one with F4 and F8)")
g.AddText(,"This also works in Virtual Pianos outside of Roblox.")
g.AddText(,"Modifications done by: Haflings")

g.AddText('+Center', '----------------------------------------------------------Edit Tempo---------------------------------------------------------')
g.Tempo := g.AddEdit('+Center')
g.AddUpDown("vMyUpDown Range1-1000", 5)

g.AddText('+Center',"------------------------------------------------------------Progress------------------------------------------------------------")

g.AutoPlayState := g.AddText(,"Auto play: Disabled")

Progress := g.AddEdit("ReadOnly w400")
Reset := g.AddButton(,"ResetProgress")

g.OnEvent("Close", (*) => ExitApp())

g.Show('AutoSize')

PianoMusic := ""
CurrentPos := 1
DisplayPos := 1
; KeyPressStartTime := 0
KeyDelay := 100

clamp := (n, low, hi) => Min(Max(n, low), hi)

PlayNextNote()
{
    global PianoMusic, CurrentPos, DisplayPos, KeyDelay ; , KeyPressStartTime
    g.Submit(0)

    PianoMusic := Sheet.Value
    DisplayMusic := PianoMusic

    ; Remove \n, \r, / and whitespace
    PianoMusic := RegExReplace(PianoMusic, "`n|`r|/| ")

    ; At end of script
    if (CurrentPos > StrLen(PianoMusic))
    {
        CurrentPos := 1
        DisplayPos := 1
    }

    ; If not yet complete
    ; And not afk for 30 seconds???
    if (CurrentPos <= StrLen(PianoMusic)) ; && A_TickCount - KeyPressStartTime < 3000)
    {   
        if (RegExMatch(PianoMusic, "U)(\[.*]|.)", &Keys, CurrentPos))
        {
            Keys := Keys[]
            CurrentPos += StrLen(Keys)

            while (DisplayPos <= StrLen(DisplayMusic) && InStr(" `n`r/", SubStr(DisplayMusic, DisplayPos, 1)))
            {
                DisplayPos++
            }
            DisplayPos += StrLen(Keys)

            Keys := Trim(Keys, "[]")
            SendInput('{Raw}' Keys)

            NextNotes := SubStr(DisplayMusic, DisplayPos, 90)
            Progress.Text := NextNotes
            
            Sleep(
                clamp(
                    (60000 / KeyDelay) - 1 ; BPM to ms, Also remove 1 ms due to SetTimer delay
                    , 0, 100000000 ; Clamp between 0 and 100000000 ms
                )
            ) 
        }
    }
}

-::
[::
]::
=::{
    ; KeyPressStartTime := A_TickCount
    PlayNextNote()
    ; KeyPressStartTime := 0
}

global autoplay
autoplay := false

AutoPlayFunction() 
{   
    global autoplay
    while autoplay
    {
        PlayNextNote()
    }
}

'::{
    global autoplay
    autoplay := not autoplay

    if autoplay
    {
        g.AutoPlayState.Text := "Auto play: Enabled"
    }
    else
    {
        g.AutoPlayState.Text := "Auto play: Disabled"
    }

    SetTimer(AutoPlayFunction, 1)
}

\::{
    ExitApp
}

default := 0

r(con, info) {
    global CurrentPos, DisplayPos, KeyDelay

    CurrentPos := 1
    DisplayPos := 1
    KeyDelay := (g.Tempo.Text or 0)    ; Fix later pls.
    Progress.Text := ''
}

Reset.OnEvent('Click', r)
