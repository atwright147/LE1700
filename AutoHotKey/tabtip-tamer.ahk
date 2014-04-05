#Persistent
FlashWinTitle = Flash, Alias, Mirage, Painter, Photoshop, Illustrator, Expression, ArtRage
SetTimer, WatchFlash, 2000 ;Checks the window every 2 seconds
WatchFlash:
WinGetActiveTitle, ActiveTitle
If ActiveTitle Not Contains %FlashWinTitle%
{
	Process, Priority, tabtip.exe, normal
}
Else ;it is the active window so make it high priority
{
	Process, Priority, tabtip.exe, high
}
Return