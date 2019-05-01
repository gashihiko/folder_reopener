cf_stack := []
adressmarker := {0x0411: "アドレス", 0x0409: "Adress", 0x0809: "Adress", 0x0c09: "Adress", 0x1009: "Adress", 0x1409: "Adress"}[A_Language]

Loop {
	sleep, 1000
	folders := []
	WinGet, folder, List, ahk_exe explorer.exe, %adressmarker%

	Loop, %folder% {
		tmp := folder%A_Index%
		WinGetText, text, ahk_id %tmp%
		RegExMatch(text, adressmarker . ": (.+?)\r", text)
		If text contains \, :
		{
			folders.Insert(text1)
		}
	}

	closed_folder := lacked_value(folders, pastfolders)
	opened_folder := lacked_value(pastfolders, folders)

	Loop % closed_folder.MaxIndex() {
		for kcl, vcl in closed_folder {
			for kcr, vcr in opened_folder {
				If vcr contains %vcl%
					closed_folder.Remove(kcl) ; Parent folder before opening its inner folder is not closed folder.
				If vcl contains %vcr%
					closed_folder.Remove(kcl) ; Child folder before going back to its parent folder is not closed folder.
			}
		}
	}

	for _, v in closed_folder {
		cf_stack.Insert(v)
	}

	pastfolders := folders.Clone()

	if (cf_stack.MaxIndex() > 100) {
		cf_stack.Remove(1)
	}
}


lacked_value(obj, comp) {
	res := comp.Clone()
	
	Loop, % res.MaxIndex() {
		for kres, vres in res {
			for _, vobj in obj {
				if (vres == vobj) {
					res.Remove(kres)
				}
			}
		}
	}

	return res
}

^+w::
Try {
	Run, % cf_stack[cf_stack.MaxIndex()]
}
cf_stack.Remove()
Return

;hotkey to check the closed folder stack
^+F1::
closed := ""
for k, v in cf_stack {
	closed .= "`n" . v
}
	msgbox % closed
Return
