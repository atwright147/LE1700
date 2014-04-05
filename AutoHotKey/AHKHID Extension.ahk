#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\AHKHID.ahk
PenUsagePage = 13
PenUsage = 2 
ButtonsUsagePage = 1
ButtonsUsage = 9
Gui, +LastFound
GuiHandle := WinExist()
AHKHID_Register(PenUsagePage, PenUsage, GuiHandle, RIDEV_INPUTSINK)
AHKHID_Register(ButtonsUsagePage, ButtonsUsage, GuiHandle, RIDEV_INPUTSINK)

;Intercept WM_INPUT
OnMessage(0x00FF, "InputMsg")
InputMsg(wParam, lParam) {
	Local r, h
	Critical ;Or otherwise you could get ERROR_INVALID_HANDLE

	;Get device type
	r := AHKHID_GetInputInfo(lParam, II_DEVTYPE) 

	If (r = RIM_TYPEHID) {
		iInputNum += 1
		h := AHKHID_GetInputInfo(lParam, II_DEVHANDLE)
		r2 := AHKHID_GetInputData(lParam, uData)
		data := Bin2Hex(&uData, r2)
		data2 := "0x" . SubStr(data, 3, 2)
		data3 := "0x" . SubStr(data, 5, 8)
		SetFormat, integer, d
		data2 += 0
		data3 += 0
		ToolTip,data2=%data2% data3=%data3% r2=%r2%
		; ProcessKey(data2, data3, r2)
	}
	SendMessage, 0x018B, 0, 0,, ahk_id %hlbxInput%
	SendMessage, 0x0186, ErrorLevel - 1, 0,, ahk_id %hlbxInput%
	Critical, Off
}
;By Laszlo
;http://www.autohotkey.com/forum/viewtopic.php?p=135402#135402
Bin2Hex(addr,len) {
	Static fun
	If (fun = "") {
		h=8B4C2404578B7C241085FF7E30568B7424108A168AC2C0E8 04463C0976040437EB02043080E20F88
		018AC2413C0976040437EB0204308801414F75D65EC601005F C3
		VarSetCapacity(fun,StrLen(h)//2)
		Loop % StrLen(h)//2
		NumPut("0x" . SubStr(h,2*A_Index-1,2), fun, A_Index-1, "Char")
	}
	VarSetCapacity(hex,2*len+1)
	dllcall(&fun, "uint",&hex, "uint",addr, "uint",len, "cdecl")
	VarSetCapacity(hex,-1) ; update StrLen
	Return hex
}