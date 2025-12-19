Scriptname SOS_Maintenance extends Quest

SOS_SetupQuest_Script Property SOS Auto
SOS_PlayerAliasScript Property PlayerAliasScript Auto
Bool firstTime

Event OnInit()
	Init()
EndEvent

Function Init()
	If !CheckRequirements()
		Return
	EndIf
	
	int installedVersion = CheckUpdate()
	
	If firstTime
		SOS.Start()
	Else
		PlayerAliasScript.CheckAddons()
		PlayerAliasScript.CheckArmors()
	EndIf
	
	SOS.SOS_VersionInt = installedVersion
	
	SOS.Initialize(firstTime)
EndFunction

Int Function CheckUpdate()
	
	Int loadedVersion = SOS.SOS_VersionInt
	Int installedVersion = 300005 ; Current version
	Debug.Trace("SOS Maintenance: loaded version is " + loadedVersion)
	firstTime = False
	
	If loadedVersion < installedVersion
	
		If loadedVersion
		
			Debug.Trace("SOS Maintenance: updating to version 3.00.005") ; Current version

			If loadedVersion < 300000
				SOS_Data.ClearConcealingArmors()
				SOS_Data.ClearRevealingArmors()
			EndIf
			If loadedVersion < 300002
				SOS.config.PerformVersionUpdate(300002)
			EndIf

			; add switch for each subsequent release here
			SOS.Notify("$SOS update complete")

		ElseIf SOS.SOS_Version
			; in 2.04.012 (and 2.05.026) the version number was changed to int to avoid floating point issues
			; fix version
			SOS.SOS_VersionInt = (SOS.SOS_Version * 100000) as Int
			; re-run the update
			Return CheckUpdate()
		Else
			; no version saved
			firstTime = True
			
		Endif

	else
		Debug.Trace("SOS Maintenance: version " + SOS.SOS_VersionInt + " is updated and ready.")
	endIf
	
	Return installedVersion

EndFunction

Bool Function CheckRequirements()
	int minSkseVersion = 48 ; version 1.7.3
	String minSkseVersionStr = "1.7.3"
	int minPUVersion = 32

	Int installedSkseVersion = SKSE.GetScriptVersionRelease()
	If installedSkseVersion >= 66  ; version 2.1.2 or later for AE
		minSkseVersion = 66 ; version 2.1.2
		minSkseVersionStr = "2.1.2"
		minPUVersion = 41
		
	ElseIf installedSkseVersion >= 64 ; version 2.0.17
		minSkseVersion = 64 ; version 2.0.17
		minSkseVersionStr = "2.0.17"
		minPUVersion = 39
				
	ElseIf installedSkseVersion >= 58 ; version 2.0.12 VR
		minSkseVersion = 58 ; version 2.0.12
		minSkseVersionStr = "2.0.12"
		minPUVersion = 36
				
	EndIf


	bool ok = installedSkseVersion >= minSkseVersion
	Debug.Trace("SOS CheckRequirements: SKSE.GetScriptVersionRelease() = " + installedSkseVersion)
	If !ok
		Debug.TraceAndBox("SOS Warning!\n\nSKSE not found, or the installed version is too old.\n\nFound " + SKSE.GetVersion() + "." + SKSE.GetVersionMinor()+ "." + SKSE.GetVersionBeta() + ", expected " + minSkseVersionStr + " or higher.\n\nPlease exit the game without saving and install the last SKSE version")
		Return false
	EndIf

	int minSOSVersion = 300004 ; Same version since LE
	Int installedSOSVersion = SKSE.GetPluginVersion("SchlongsOfSkyrim")  ; optional SOS DLL support disabled for now
	
	If installedSOSVersion >= minSOSVersion
		Debug.Trace("SOS CheckRequirements: Optional SchlongsOfSkyrim.dll found (version " + installedSOSVersion + ")")
		If !SOS.useDLL
		;	SOS.InvalidateAllRacesCache(newDLL = True)  ; clean probability caches since they might cause trouble when the dll is uninstalled later
			SOS.useDLL = True
		EndIf
	;	Return True
	Else
		Debug.Trace("SOS CheckRequirements: No working SchlongsOfSkyrim.dll found. Functions will be emulated in Papyrus.")
		SOS.useDLL = False
	EndIf

	Int installedPUVersion = 0
	If SKSE.GetPluginVersion("papyrusutil") >= 1 || SKSE.GetPluginVersion("papyrusutil plugin") >= 1
		installedPUVersion = PapyrusUtil.GetVersion()
	EndIf
	ok = installedPUVersion >= minPUVersion
	Debug.Trace("SOS CheckRequirements: PapyrusUtil.GetVersion = " + installedPUVersion)
	If !ok
	;	Debug.TraceAndBox("SOS Warning!\n\nSchlongsOfSkyrim.dll not found, or the installed version is too old.\n\nFound " + SKSE.GetPluginVersion("SchlongsOfSkyrim") + ", expected " + minSOSVersion + ".\n\nPlease exit the game and reinstall SOS")
		Debug.TraceAndBox("SOS Warning!\n\nPapyrusUtil.dll not found, or the installed version is too old.\n\nFound " + installedPUVersion + ", expected " + minPUVersion + ".\n\nPlease exit the game and reinstall PapyrusUtil.")
		Return false
	EndIf

	Return true
EndFunction
