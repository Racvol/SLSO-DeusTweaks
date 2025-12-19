Scriptname slac_Notify Extends Quest

; ------
; SexLab Aroused Creatures Notifications
;
; This feature is still experimental
; There may be changes in future updates that break any third-party modifications to the .
;
; Notification messages are typically triggered by events such as pursuits and animations. These events
; are pre-defined in the AC code using a simple string ID defined below. Each call is accompanied by the 
; primary actors, one victim and one creature, and flags to indicate if the engagement is consensual and if 
; it involves more then two participants. The actors are processed to determine the relevant information which 
; is then used to collect any applicable notification registered for that event ID. A notification is then 
; selected at random from the compiled list, the relevant data interpolated, and the result displayed via 
; Debug.Notification().
;
; Notifications are stored in Data/SKSE/Plugins/ArousedCreatures/slacNotifications.json
; This must be a valid JSON file formatted like this:
;
;	{
;		"ModVersion":40026,
;		"FileVersion":1001,
;		"Pronouns":{
;			"Subject":{"Male":"he","Female":"she","Neutral":"they"},
;			"Object":{"Male":"him","Female":"her","Neutral":"them"},
;			"Possessive":{"Male":"his","Female":"hers","Neutral":"theirs"},
;			"PossessiveAdj":{"Male":"his","Female":"her","Neutral":"their"},
;			"Reflexive":{"Male":"himself","Female":"herself","Neutral":"themself"}
;		},
;		"Events":{
;			"SexEnd":[
;				"IsPair,NonConsensual,NPCVictim,ActorPC|The {creaturerace} is finished with you",
;				"IsPair,NonConsensual,NPCVictim,ActorPC|The {creaturerace} is finally done with you"
;			]
;		}
;	}
;
; Notifications are defined using a set of comma-delimited tags indicating the disposition and relevance of 
; the text, followed by a pipe "|" and then the text of the message with tokens such as {npcname}, defined 
; below, which will be replaced with the relevant info before being displayed.
; 
; Tags are organised into groups for processing. Tags use a "Neutral" fallback if no tag from a group is
; included. For example, if there is no "IsMaleCreatureSex" or "IsFemaleCreatureSex" tag, then the system 
; will automatically add the "NeutralCreatureSex" tag. This means the notification can be used for creatures
; of either sex. While this neutral tag system increases the amount of data, it also improves performance as
; it is not necessary to test both IsMaleCreatureSex and IsFemaleCreatureSex tags to determine that neither 
; are present.
;
; EventIDs
; ArousalFail : Certain situations where arousal checks are tested at critical points such as direct invitation.
; PursuitStart : When a pursuit is successfully started.
; PursuitFail : A pursuer reached their victim but could not start an animation for some reason. This could be a change in circumstances such as the start of combat, or a technical failure preventing progression of the scene.
; PursuitScare : A pursuit was halted due to the player drawing their weapon.
; PursuitEscape : A pursuing creature was not able to reach the capture radius of their victim in the time available (30 secs by default).
; SexStart : A SexLab animation was started successfully by Aroused Creatures, either automatically or electively.
; SexStartFail : The function to start an SL animation was called but a technical issue prevented the operation.
; SexEnd : A SexLab animation started by Aroused Creatures has ended.
; QueueJoin : A creature has joined the queue waiting to use a victim.
; QueueNext : A queued creature is taking a turn with a victim.
; QueueNextFail : The queued creature could not start an animation with the victim.
; QueueLeave : One or more creatures have left a queue, usually due to a change in status, like entering combat.
; SuitorJoin : A creature that meets the creature dialogue arousal threshold has started following an aroused player.
; SuitorLeave : A suitor has abandoned the player because they are no longer suitable, perhaps because of changes in arousal level, configuration options, etc.
; SuitorQueue : The player has started an animation and their suitors have queued to take a turn with them.
; SuitorReject : The suitor has been scared away by the player drawing their weapon or by entering combat.
; TargetSelectPass : The player has used the target select key on an actor who has passed basic suitability checks.
; TargetSelectFail : The targeted actor has failed basic tests.
; HorseBuck : The player has been bucked from an aroused horse.
; StruggleSucceed : The player has successfully struggled free from a non-consensual engagement.
; StruggleFail : The player can no longer struggle against the creature.

; Tags:
;	Participants:
;		NeutralNumber, IsSingle, IsPair, IsGroup
;	Consent:
;		NeutralConsent, IsConsensual, NonConsensual, RoughConsensual, NotConsent
;	Victim Selection (indicated "direction" of engagement):
;		NeutralVictimActor, NPCVictim, CreatureVictim, NotVictim
;	Victim Gender ("NPC" here applies to both PC and NPC):
;		NeutralNPCSex, IsMaleNPCSex, IsFemaleNPCSex, TransMaleNPCSex, TransFemaleNPCSex
;	Creature Gender:
;		NeutralCreatureSex, IsMaleCreatureSex, IsFemaleCreatureSex
;	Sexuality:
;		NeutralSexuality, Heterosexual, Homosexual, NotSexual
;	NPC Relationship (partial support - only followers for now):
;		NeutralRelationshipNPC,IsPlayerNPCFollower,NotPlayerNPCFollower,IsPlayerNPCSpouse,NotPlayerNPCSpouse,IsPlayerEnemyNPC,NotPlayerEnemyNPC
;	Creature Relationship (partial support - only player horse and creature followers for now):
;		NeutralRelationshipCreature,IsPlayerHorse,NotPlayerHorse,IsPlayerCreatureFollower,NotPlayerCreatureFollower,IsPlayerEnemyCreature,NotPlayerEnemyCreature
;	Oral:
;		NeutralOral, GiveBlowjob, GetBlowjob, GiveCunnilingus, GetCunnilingus, GiveAnilingus, GetAnilingus, NotOral, AnyOral
;	Anal:
;		NeutralAnal, GiveAnal, GetAnal, NotAnal
;	Masturbation (not currently implemented):
;		NeutralMasturbation, GiveMasturbation, GetMasturbation, NotMasturbation
;	Victim PC / NPC (ActorNPC, ActorUnique, and ActorNotUnique all exclude the PC):
;		NeutralActor, ActorPC, ActorNPC, ActorUnique, ActorNotUnique
;	Victim Race (multiple permitted, NPC race names may need to be in UPPERCASE - not tested):
;		VictimRace[Race Name]
;	Creature Race (multiple permitted):
;		CreatureRaceName[Race Name]
;	Creature Race Key (multiple permitted):
;		CreatureRaceKeyName[SexLab Race Key]

; Tokens:
; 	{npcname}
;	{creaturename}
;	{lastactorname} - Will be replaced the NPC name unless a creature is included, used for the target select notification
;
;	{npcarousal} - Not currently used
;	{creaturearousal} - Not currently used
;	{lastactorarousal} - Used for target select with {lastactorname}
;
;	{npcrace}
;	{creaturerace}
;	{creatureraceplural} - uses defined SL race key
;
;	{npcheshe}
;	{npchimher}
;	{npchishers}
;	{npchisher}
;	{npchimherself}
;	{creatureheshe}
;	{creaturehimher}
;	{creaturehishers}
;	{creaturehisher}
;	{creaturehimherself}
;
; Advanced
;   This system is built for English. Obviously, the tokens above may not be enough for other languages.
;   To extended the syntax options beyond this you should recompile this script to add the extra features, and 
;   distribute it with the slacNotifications.json.
;
; Notes
; 	Tags and notification text are separated by a pipe |.
; 	Tags are separated by commas ,.
; 	Spaces are not permitted in tags.
;	Spaces between tags and commas will be stripped.
;	Only one tag from each group defined above may be used save for those that indicate otherwise.
;	For VictimRace[Race Name], CreatureRaceName[Race Name], and CreatureRaceKeyName[SL Race Key]
;	    Multiple versions can be used such as "CreatureRaceNameDog,CreatureRaceNameWolf"
;	If no tags from a group are used the first tag in the group list, "Neutral*", is assumed.
;	Neutral tagging means that the tag group is ignored for selection purposes.
;	    For instance, a notification tagged as "NeutralConsent" or without a consent  
;	    tag may be used in both consensual and non-consensual engagement notifications.
;	There is currently an arbitrary 40 tag limit for each notification, including 15 fallback tags added for 
;       tag groups not represented in the defined tags.
;	ModVersion (Int) is the version of Aroused Creatures that the JSON was created for. ModVersion is advisory
;       only. The system will attempt to load the file regardless of this version.
;	FileVersion (Int) is the version of the JSON file itself. If this number is changed, it will force this 
;       script to reload and reprocess it when loading a save. Setting this to any value less then 1 will cause 
;       the files to be loaded every time.
;
; ------


slac_Config Property slacConfig Auto
slac_Utility Property slacUtility Auto
slac_Data Property slacData Auto
String noteFilePath = "../ArousedCreatures/slacNotifications"
String[] EventIDs
Int ModVersion = 0
Int FileVersion = 0

; Token lists
String[] GroupTags
String[] ConsentTags
String[] VictimTags
String[] GenderTags
String[] CreatureGenderTags
String[] SexualityTags
String[] RelationshipNPCTags
String[] RelationshipCreatureTags
String[] OralTags
String[] AnalTags
String[] MasturbationTags
String[] ActorTags

; Token pronouns
String[] PronounSubject
String[] PronounObject
String[] PronounPossessive
String[] PronounPossessiveAdj
String[] PronounReflexive

; Creature race name fallbacks
String[] CreatureRaceFallback


; Update token lists
Function UpdateTokens()
	EventIDs = PapyrusUtil.StringSplit("ArousalFail,PursuitStart,PursuitFail,PursuitScare,PursuitEscape,SexStart,SexStartFail,SexEnd,QueueNext,QueueNextFail,QueueJoin,QueueLeave,SuitorJoin,SuitorLeave,SuitorQueue,SuitorReject,TargetSelectPass,TargetSelectFail,HorseBuck,StruggleSucceed,StruggleFail",",")
	GroupTags = PapyrusUtil.StringSplit("NeutralNumber,IsSolo,IsPair,IsGroup",",")
	ConsentTags = PapyrusUtil.StringSplit("NeutralConsent,IsConsensual,NonConsensual,RoughConsensual,NotConsent",",")
	VictimTags = PapyrusUtil.StringSplit("NeutralVictimActor,NPCVictim,CreatureVictim,NotVictim",",")
	GenderTags = PapyrusUtil.StringSplit("NeutralNPCSex,IsMaleNPCSex,IsFemaleNPCSex,TransMaleNPCSex,TransFemaleNPCSex",",")
	CreatureGenderTags = PapyrusUtil.StringSplit("NeutralCreatureSex,IsMaleCreatureSex,IsFemaleCreatureSex",",")
	SexualityTags = PapyrusUtil.StringSplit("NeutralSexuality,Heterosexual,Homosexual,NotSexual",",")
	RelationshipNPCTags = PapyrusUtil.StringSplit("NeutralRelationshipNPC,IsPlayerNPCFollower,NotPlayerNPCFollower,IsPlayerNPCSpouse,NotPlayerNPCSpouse,IsPlayerEnemyNPC,NotPlayerEnemyNPC",",")
	RelationshipCreatureTags = PapyrusUtil.StringSplit("NeutralRelationshipCreature,IsPlayerHorse,NotPlayerHorse,IsPlayerCreatureFollower,NotPlayerCreatureFollower,IsPlayerEnemyCreature,NotPlayerEnemyCreature",",")
	OralTags = PapyrusUtil.StringSplit("NeutralOral,GiveBlowjob,GetBlowjob,GiveCunnilingus,GetCunnilingus,GiveAnilingus,GetAnilingus,NotOral,AnyOral",",")
	AnalTags = PapyrusUtil.StringSplit("NeutralAnal,GiveAnal,GetAnal,NotAnal",",")
	MasturbationTags = PapyrusUtil.StringSplit("NeutralMasturbation,GiveMasturbation,GetMasturbation,NotMasturbation",",")
	ActorTags = PapyrusUtil.StringSplit("NeutralActor,ActorPC,ActorNPC,ActorUnique,ActorNotUnique",",")
EndFunction


; Show selected notification
Bool Function Show(String ID, Actor Victim, Actor Creature = None, Bool Consensual = False, Bool Group = False)
	Bool HasPlayer = Victim == slacUtility.PlayerRef
	If slacConfig.InMaintenance || (HasPlayer && !slacConfig.showNotifications) || (!HasPlayer && !slacConfig.showNotificationsNPC)
		; Notifications disabled
		Return False
	EndIf

	String VictimName = Victim.GetLeveledActorBase().GetName()
	Race VictimRace = Victim.GetRace()
	String VictimRaceName = VictimRace.GetName()
	Int VictimGender = slacUtility.TreatAsSex(Victim,Creature)
	Int VictimSLGender = slacUtility.SexLab.GetGender(Victim)
	Int VictimVanillaSex = Victim.GetLeveledActorBase().GetSex()
	Bool VictimIsTrans = VictimSLGender != VictimVanillaSex
	Int VictimArousal = slacUtility.GetActorArousal(Victim)
	String LastActorName = VictimName
	Int LastActorArousal = VictimArousal
	ActorBase VictimBase = Victim.GetBaseObject() as ActorBase
	Bool VictimUnique = VictimBase.IsUnique()
	
	String CreatureName = "[no name]"
	Race CreatureRace = None
	String CreatureRaceName = "[no race]"
	Bool MissingRaceName = False
	String CreatureRaceKey = "[no race key]"
	Int CreatureGender = 0
	Bool Hetero = True
	Bool CreatureVictim = False
	Bool IsFollowerCreature = False
	Bool IsPlayerHorse = False
	Int CreatureArousal = -1
	If Creature
		CreatureName = Creature.GetLeveledActorBase().GetName()
		LastActorName = CreatureName
		CreatureRace = Creature.GetRace()
		CreatureRaceName = CreatureRace.GetName()
		CreatureRaceKey = slacUtility.GetCreatureRaceKeyString(Creature)
		CreatureGender = slacUtility.GetSex(Creature)
		Hetero = (VictimGender == 1 && CreatureGender == 0) || (VictimGender == 0 && CreatureGender == 1)
		CreatureVictim = slacData.GetSignalBool(Victim, "NPCIsAggressor") || slacData.GetSignalBool(Victim, "CreatureVictim")
		IsFollowerCreature = Creature.IsPlayerTeammate()
		IsPlayerHorse = Creature.IsPlayersLastRiddenHorse()
		CreatureArousal = slacUtility.GetActorArousal(Creature)
		LastActorArousal = CreatureArousal

		; Creature race name fallbacks
		If CreatureRaceName == ""
			CreatureRace = Creature.GetLeveledActorBase().GetRace()
			CreatureRaceName = CreatureRace.GetName()
			slacConfig.debugSLAC && slacUtility.Log("Notify: missing race name (1), using fallback levelled creature race name " + CreatureRaceName + " for " + CreatureRace)
		EndIf
		;If CreatureRaceName == ""
		;	CreatureRace = Creature.GetRace()
		;	If StringUtil.Find(CreatureRace,"HorseRace") > -1
		;		CreatureRaceName = "horse"
		;	ElseIf StringUtil.Find(CreatureRace,"DogRace") > -1
		;		CreatureRaceName = "dog"
		;	ElseIf StringUtil.Find(CreatureRace,"WolfRace") > -1
		;		CreatureRaceName = "wolf"
		;	EndIf
		;	slacConfig.debugSLAC && slacUtility.Log("Notify: missing race name (2), using common name '" + CreatureRaceName + "'' for " + CreatureRace)
		;EndIf
		If CreatureRaceName == ""
			Int endindex = StringUtil.Find(CreatureRace,"Race (")
			If endindex > -1
				CreatureRaceName = StringUtil.SubString(CreatureRace, 7, endindex - 7)
				slacConfig.debugSLAC && slacUtility.Log("Notify: missing race name (3), using fallback race substring '" + CreatureRaceName + "' for " + CreatureRace)
			EndIf
		EndIf
		If CreatureRaceName == ""
			CreatureRaceName = CreatureName
			slacConfig.debugSLAC && slacUtility.Log("Notify: missing race name (4), using fallback creature name '" + CreatureRaceName + "' for " + CreatureRace)
			MissingRaceName = True
		EndIf
		If CreatureRaceName == "" && CreatureRaceFallback.Length > 0
			CreatureRaceName = CreatureRaceFallback[Utility.RandomInt(0,CreatureRaceFallback.Length - 1)]
			slacConfig.debugSLAC && slacUtility.Log("Notify: missing race name (5), using fallback creature name '" + CreatureRaceName + "' for " + CreatureRace)
			MissingRaceName = True
		EndIf
		If CreatureRaceName == ""
			CreatureRaceName = "animal"
			slacConfig.debugSLAC && slacUtility.Log("Notify: missing race name (6), complete failure. Using '" + CreatureRaceName + "' for " + CreatureRace)
			MissingRaceName = True
		EndIf
	EndIf
	
	Bool Testing = slacData.GetSignalBool(Victim, "NotifyTestSubject")
	Testing = Testing && slacConfig.debugSLAC

	Bool IsFollowerNPC = Victim.IsPlayerTeammate()
	Bool GivingBlowjob = slacData.GetSignalBool(Victim, "GivingBlowjob")
	Bool GettingBlowjob = slacData.GetSignalBool(Victim, "GettingBlowjob")
	Bool GivingCunnilingus = slacData.GetSignalBool(Victim, "GivingCunnilingus")
	Bool GettingCunnilingus = slacData.GetSignalBool(Victim, "GettingCunnilingus")
	Bool GivingAnilingus = slacData.GetSignalBool(Victim, "GivingAnilingus")
	Bool GettingAnilingus = slacData.GetSignalBool(Victim, "GettingAnilingus")
	Bool IsOral = GivingBlowjob || GivingCunnilingus || GettingCunnilingus || GettingBlowjob

	Bool GivingAnal = slacData.GetSignalBool(Victim, "GivingAnal")
	Bool GettingAnal = slacData.GetSignalBool(Victim, "GettingAnal")
	Bool IsAnal = GivingAnal || GettingAnal

	Bool GivingMasturbation = slacData.GetSignalBool(Victim, "GivingMasturbation")
	Bool GettingMasturbation = slacData.GetSignalBool(Victim, "GettingMasturbation")
	Bool IsMasturbation = GivingMasturbation || GettingMasturbation

	slacConfig.debugSLAC && slacUtility.Log("Notify: Event ID: " + ID + " IsOral:" + IsOral + " GivingBlowjob:" + GivingBlowjob + " GettingBlowjob:" + GettingBlowjob + " GivingCunnilingus:" + GivingCunnilingus + " GettingCunnilingus:" + GettingCunnilingus + " GivingMasturbation:" + GivingMasturbation + " GettingMasturbation:" + GettingMasturbation)

	String VictimHeShe = PronounSubject[VictimGender]
	String VictimHimHer = PronounObject[VictimGender]
	String VictimHisHer = PronounPossessiveAdj[VictimGender]
	String VictimHisHers = PronounPossessive[VictimGender]
	String VictimHimHerSelf = PronounReflexive[VictimGender]
	String CreatureHeShe = slacConfig.CondString(CreatureGender == 0, PronounSubject[0], PronounSubject[1])
	String CreatureHimHer = slacConfig.CondString(CreatureGender == 0, PronounObject[0], PronounObject[1])
	String CreatureHisHer = slacConfig.CondString(CreatureGender == 0, PronounPossessiveAdj[0], PronounPossessiveAdj[1])
	String CreatureHisHers = slacConfig.CondString(CreatureGender == 0, PronounPossessive[0], PronounPossessive[1])
	String CreatureHimHerself = slacConfig.CondString(CreatureGender == 0, PronounReflexive[0], PronounReflexive[1])

	; Compile selection
	Int[] selection = Utility.CreateIntArray(64, -1)
	Int selectionIndex = 0

	; Get all notifications for the event
	String[] eventNoteText = StorageUtil.StringListToArray(None, "SLArousedCreatures.Notifications." + ID + ".Text")
	String[] eventNoteTags = StorageUtil.StringListToArray(None, "SLArousedCreatures.Notifications." + ID + ".Tags")

	; Check tags
	Int i = 0
	While i < eventNoteText.Length
		String[] t = PapyrusUtil.StringSplit(eventNoteTags[i],",")
		Bool valid = True
		String report = ""
		; Positions
		If !HasTag(t, "NeutralNumber")
			If Group && !HasTag(t,"IsGroup")
				valid = False
			ElseIf !Group && !HasTag(t,"IsPair")
				valid = False
			EndIf
		EndIf
		report = report + " Positions:" + valid
		; Consent
		If valid && !HasTag(t,"NeutralConsent")
			If Consensual
				If slacData.GetSignalBool(Victim, "RoughConsensual")
					If !HasTag(t,"RoughConsensual")
						valid = False
					EndIf
				ElseIf HasTag(t,"NonConsensual") || HasTag(t,"RoughConsensual")
					valid = False
				EndIf
			ElseIf !HasTag(t,"NonConsensual")
				valid = False
			EndIf
		EndIf
		report = report + " Consent:" + valid
		; Creature victim
		If valid && Creature && !HasTag(t,"NeutralVictimActor")
			If !CreatureVictim && HasTag(t,"CreatureVictim")
				valid = False
			ElseIf CreatureVictim && HasTag(t,"NPCVictim")
				valid = False
			EndIf
		EndIf
		report = report + " Victim:" + valid
		; Victim sex
		If valid && !HasTag(t,"NeutralNPCSex")
			If VictimGender == 0 && !HasTag(t,"IsMaleNPCSex")
				valid = False
			ElseIf VictimGender == 1 && !HasTag(t,"IsFemaleNPCSex")
				valid = False
			EndIf
		EndIf
		report = report + " VictimSex:" + valid
		; Creature sex
		If valid && Creature && !HasTag(t,"NeutralCreatureSex")
			If CreatureGender == 0 && !HasTag(t,"IsMaleCreatureSex")
				valid = False
			ElseIf CreatureGender == 1 && !HasTag(t,"IsFemaleCreatureSex")
				valid = False
			EndIf
		EndIf
		report = report + " CreatureSex:" + valid
		; Sexuality
		If valid && Creature && !HasTag(t,"NeutralSexuality")
			If Hetero && !HasTag(t,"Heterosexual")
				valid = False
			ElseIf !Hetero && !HasTag(t,"Homosexual")
				valid = False
			EndIf
		EndIf
		report = report + " Sexuality:" + valid
		; NPC Relationship
		If valid && !HasTag(t,"NeutralRelationshipNPC")
			If !IsFollowerNPC && HasTag(t,"IsPlayerNPCFollower")
				valid = False
			ElseIf IsFollowerNPC && HasTag(t,"NotPlayerNPCFollower")
				valid = False
			EndIf
		EndIf
		report = report + " NPCRelationship:" + valid
		; Creature Relationship
		If valid && Creature && !HasTag(t,"NeutralRelationshipCreature")
			If !IsPlayerHorse && HasTag(t,"IsPlayerHorse")
				valid = False
			ElseIf IsPlayerHorse && HasTag(t,"NotPlayerHorse")
				valid = False
			ElseIf !IsFollowerCreature && HasTag(t,"IsPlayerCreatureFollower")
				valid = False
			ElseIf IsFollowerCreature && HasTag(t,"NotPlayerCreatureFollower")
				valid = False
			EndIf
		EndIf
		report = report + " CreatureRelationship:" + valid
		; Oral
		If valid && Creature && !HasTag(t,"NeutralOral")
			If IsOral && HasTag(t,"AnyOral")
				report = report + " AnyOral"
			ElseIf IsOral && HasTag(t,"NotOral")
				valid = False
				report = report + " NotOral"
			ElseIf (!GivingBlowjob && HasTag(t,"GiveBlowjob")) || (GivingBlowjob && !HasTag(t,"GiveBlowjob")) 
				valid = False
				report = report + " GiveBlowjob"
			ElseIf (!GettingBlowjob && HasTag(t,"GetBlowjob")) || (GettingBlowjob && !HasTag(t,"GetBlowjob"))
				valid = False
				report = report + " GetBlowjob"
			ElseIf (!GivingCunnilingus && HasTag(t,"GiveCunnilingus")) || (GivingCunnilingus && !HasTag(t,"GiveCunnilingus"))
				valid = False
				report = report + " GiveCunnilingus"
			ElseIf (!GettingCunnilingus && HasTag(t,"GetCunnilingus")) || (GettingCunnilingus && !HasTag(t,"GetCunnilingus"))
				valid = False
				report = report + " GetCunnilingus"
			ElseIf (!GivingAnilingus && HasTag(t,"GiveAnilingus")) || (GivingAnilingus && !HasTag(t,"GiveAnilingus"))
				valid = False
				report = report + " GiveAnilingus"
			ElseIf (!GettingAnilingus && HasTag(t,"GetAnilingus")) || (GettingAnilingus && !HasTag(t,"GetAnilingus"))
				valid = False
				report = report + " GetAnilingus"
			EndIf
		EndIf
		report = report + " Oral:" + valid
		; Anal
		If valid && Creature && !HasTag(t, "NeutralAnal")
			If GivingAnal && !HasTag(t,"GiveAnal")
				valid = False
			ElseIf GettingAnal && !HasTag(t,"GetAnal")
				valid = False
			ElseIf (GivingAnal || GettingAnal) && HasTag(t,"NotAnal")
				valid = False
			EndIf
		EndIf
		report = report + " Anal:" + valid
		; Masturbation
		If valid && !HasTag(t,"NeutralMasturbation")
			If GivingMasturbation && !HasTag(t,"GiveMasturbation")
				valid = False
			ElseIf GettingMasturbation && !HasTag(t,"GetMasturbation")
				valid = False
			ElseIf (GivingMasturbation || GettingMasturbation) && HasTag(t,"NotMasturbation")
				valid = False
			EndIf
		EndIf
		report = report + " Masturbation:" + valid
		; PC/NPC victim
		If valid && !HasTag(t,"NeutralActor")
			If HasPlayer && !HasTag(t,"ActorPC")
				valid = False
			ElseIf !HasPlayer
				If !VictimUnique && HasTag(t,"ActorUnique")
					valid = False
				ElseIf VictimUnique && HasTag(t,"ActorNotUnique")
					valid == False
				ElseIf !HasTag(t,"ActorNPC") && !HasTag(t,"ActorUnique")
					valid = False
				EndIf
			EndIf
		EndIf
		report = report + " PC/NPC:" + valid
		; Creature race
		If valid && Creature && !HasTag(t,"NeutralCreatureRaceName")
			If !HasTag(t, "CreatureRaceName" + CreatureRaceName)
				valid = False
			EndIf
		EndIf
		;If MissingRaceName && StringUtil.Find(eventNoteText,"{creaturerace}") > -1
		;	valid = False
		;EndIf
		If valid && Creature && !HasTag(t,"NeutralCreatureRaceKeyName")
			If !HasTag(t, "CreatureRaceKeyName" + CreatureRaceKey)
				valid = False
			EndIf
		EndIf
		report = report + " CreatureRace:" + valid
		; Victim race
		If valid && !HasTag(t,"NeutralVictimRace")
			If !HasTag(t, "VictimRace" + VictimRaceName)
				valid = False
			EndIf
		EndIf
		report = report + " VictimRace:" + valid

		; Record note index
		
		If valid
			selection[selectionIndex] = i
			selectionIndex += 1
			report = "Valid"
		Else
			report = "Invalid"
		EndIf
		;slacConfig.debugSLAC && slacUtility.Log("Notify (" + ID + ", " + i + ") " + report + " on " + eventNoteTags[i] + "|" + eventNoteText[i])

		i += 1
	EndWhile
	
	slacConfig.debugSLAC && slacUtility.Log("Notify Testing:" + Testing + " VictimRaceName:" + VictimRaceName + " VictimRace:" + VictimRaceName + " VictimUnique:" + VictimUnique + " CreatureName:" + CreatureName + " CreatureRaceName:" + CreatureRaceName + " CreatureRaceKey:" + CreatureRaceKey)

	; Select random result
	selection = PapyrusUtil.RemoveInt(selection,-1)

	If selection.Length > 0
		Int res = Utility.RandomInt(0,selection.Length - 1)
		If Testing
			res = 0
		EndIf
		
		While res < selection.Length
			; Interpolate tokens in result
			String displayNote = Replace(eventNoteText[selection[res]], "npcname", VictimName)
			displayNote = Replace(displayNote, "creaturename", CreatureName)
			displayNote = Replace(displayNote, "lastactorname", LastActorName)

			displayNote = Replace(displayNote, "npcrace", VictimRaceName)
			displayNote = Replace(displayNote, "creaturerace", CreatureRaceName)
			displayNote = Replace(displayNote, "creatureraceplural", CreatureRaceKey)

			displayNote = Replace(displayNote, "npcheshe", VictimHeShe)
			displayNote = Replace(displayNote, "creatureheshe", CreatureHeShe)
			displayNote = Replace(displayNote, "npchimher", VictimHimHer)
			displayNote = Replace(displayNote, "creaturehimher", CreatureHimHer)
			displayNote = Replace(displayNote, "npchishers", VictimHisHers)
			displayNote = Replace(displayNote, "creaturehishers", CreatureHisHers)
			displayNote = Replace(displayNote, "npchisher", VictimHisHer)
			displayNote = Replace(displayNote, "creaturehisher", CreatureHisHer)
			displayNote = Replace(displayNote, "npchimherself", VictimHimHerself)
			displayNote = Replace(displayNote, "creaturehimherself", CreatureHimHerself)

			displayNote = Replace(displayNote, "npcarousal", VictimArousal)
			displayNote = Replace(displayNote, "creaturearousal", CreatureArousal)
			displayNote = Replace(displayNote, "lastactorarousal", LastActorArousal)

			; Display result
			Debug.Notification(displayNote)

			; Debug
			;slacConfig.debugSLAC && slacUtility.Log("Notify (" + ID + "," + selection[res] + " from " + selection.Length + ") source: " + eventNoteTags[selection[res]] + "|" + eventNoteText[selection[res]])
			slacConfig.debugSLAC && slacUtility.Log("Notify (" + ID + ") (" + (res + 1) + "/" + selection.Length + ") result: " + displayNote + " - tags: " + eventNoteTags[selection[res]])
			
			If Testing
				; Show other results for testing
				res += 1
			Else
				; Show single result for normal operation.
				res = selection.Length + 1
			EndIf
		EndWhile
	Else
		; Debug
		slacConfig.debugSLAC && slacUtility.Log("Notify (" + ID + ") No Valid Result")
		Return False
	EndIf
	Return True
EndFunction


; Load notifications from JSON
Bool Function UpdateNotes(Bool ForceUpdate = False)
	UpdateTokens()
	; Check JSON
	JsonUtil.Unload(noteFilePath, saveChanges = False)
	If !JsonUtil.Load(noteFilePath)
		; Error - Missing file / could not load
		slacConfig.debugSLAC && slacUtility.Log("Error parsing notifications: file could not be loaded or is not found at " + noteFilePath)
		Return False
	ElseIf !JsonUtil.IsGood(noteFilePath)
		; Error - JSON formatting
		slacConfig.debugSLAC && slacUtility.Log("Error parsing notifications: formatting error in " + noteFilePath)
		Return False
	EndIF
	
	Int TestFileVersion = JsonUtil.GetPathIntValue(noteFilePath, ".FileVersion", -1)
	If !ForceUpdate && TestFileVersion > 0 && TestFileVersion == FileVersion
		; JSON file should not be reloaded as it has not been updated.
		; Setting FileVersion in the JSON to any value less than 1 will cause it to always load.
		slacConfig.debugSLAC && slacUtility.Log("Stopped parsing notifications: the file version has not changed (" + TestFileVersion + ") " + noteFilePath)
		Return False
	ElseIf ForceUpdate || TestFileVersion < 1
		slacConfig.debugSLAC && slacUtility.Log("Parsing notifications: forced reloading (" + FileVersion + ") " + noteFilePath)
	Else
		slacConfig.debugSLAC && slacUtility.Log("Parsing notifications: updating to file version " + TestFileVersion + " (was " + FileVersion + ") " + noteFilePath)
	EndIf

	; Remove currently stored notifications
	StorageUtil.ClearAllPrefix("SLArousedCreatures.Notifications.")

	; Update mod and file versions
	ModVersion = JsonUtil.GetPathIntValue(noteFilePath, ".ModVersion", -1)
	FileVersion = JsonUtil.GetPathIntValue(noteFilePath, ".FileVersion", -1)

	; Collect creature race name fallbacks
	CreatureRaceFallback = JsonUtil.StringListToArray(noteFilePath, ".CreatureRaceFallback")
	If CreatureRaceFallback.Length < 1
		CreatureRaceFallback = PapyrusUtil.StringSplit("animal,beast,creature", ",")
	EndIf
	slacConfig.debugSLAC && slacUtility.Log("Parsing notifications: CreatureRaceFallback [" + PapyrusUtil.StringJoin(CreatureRaceFallback, ",") + "]")

	; Collect notification strings for each event
	Int i = 0
	While i < EventIDs.Length
		String[] notes = JsonUtil.PathStringElements(noteFilePath, ".Events." + EventIDs[i])
		If notes.Length < 1
			; Error - no event data
			slacConfig.debugSLAC && slacUtility.Log("Warning parsing notifications: no items for event ID " + EventIDs[i])
		
		Else
			; Process tags and store notification text
			Int j = 0
			While j < notes.Length
				; Split tags and notification text
				String[] parts = PapyrusUtil.StringSplit(notes[j], "|")
				String tags = ""
				String text = ""
				Bool ParseError = False
				If parts.Length == 0 || StringUtil.GetLength(parts[0]) < 2
					; Error - missing notification parts
					slacConfig.debugSLAC && slacUtility.Log("Error parsing notifications: malformed or missing item index " + j + " for event ID " + EventIDs[i])
					ParseError = True
				ElseIf parts.Length == 1
					; Assume notification text only with neutral tags
					text = parts[0]
				Else
					; Normal tags|text
					tags = parts[0]
					text = parts[1]
				EndIf

				If !ParseError
					String[] newTags = Utility.CreateStringArray(40,"")
					
					; Recompile tag strings to uniform values (adding assumed neutral* tags)
					String[] TagArray = PapyrusUtil.StringSplit(tags,",")
					newTags[0] = FindTags(TagArray,GroupTags)
					newTags[1] = FindTags(TagArray,ConsentTags)
					newTags[2] = FindTags(TagArray,VictimTags)
					newTags[3] = FindTags(TagArray,GenderTags)
					newTags[4] = FindTags(TagArray,CreatureGenderTags)
					newTags[5] = FindTags(TagArray,SexualityTags)
					newTags[6] = FindTags(TagArray,RelationshipNPCTags)
					newTags[7] = FindTags(TagArray,RelationshipCreatureTags)
					newTags[8] = FindTags(TagArray,AnalTags)
					newTags[9] = FindTags(TagArray,MasturbationTags)
					newTags[10] = FindTags(TagArray,ActorTags)
					newTags[11] = FindTags(TagArray,OralTags)
					
					Int nextindex = 12
					; Add HasOral meta tag
					If newTags[10] != "NeutralOral" && newTags[10] != "NotOral"
						newTags[nextindex] = "HasOral"
						nextindex += 1
					EndIf

					; Collect victim race tags
					Int raceMatchIndex = StringUtil.Find(tags, "VictimRace")
					If raceMatchIndex > -1
						newTags[nextindex] = "HasVictimRace"
						nextindex += 1
						While raceMatchIndex > -1 && nextindex < newTags.Length
							String[] tempTags = PapyrusUtil.StringSplit(StringUtil.SubString(tags, raceMatchIndex, 0), ",")
							newTags[nextindex] = tempTags[0]
							nextindex += 1
							raceMatchIndex = StringUtil.Find(tags, "VictimRace", raceMatchIndex + 1)
						EndWhile
					Else
						newTags[nextindex] = "NeutralVictimRace"
						nextindex += 1
					EndIf

					; Collect creature race tags
					raceMatchIndex = StringUtil.Find(tags, "CreatureRaceKeyName")
					If raceMatchIndex > -1
						newTags[nextindex] = "HasCreatureRaceKeyName"
						nextindex += 1
						While raceMatchIndex > -1 && nextindex < newTags.Length
							String[] tempTags = PapyrusUtil.StringSplit(StringUtil.SubString(tags, raceMatchIndex, 0), ",")
							newTags[nextindex] = tempTags[0]
							nextindex += 1
							raceMatchIndex = StringUtil.Find(tags, "CreatureRaceKeyName", raceMatchIndex + 1)
						EndWhile
					Else
						newTags[nextindex] = "NeutralCreatureRaceKeyName"
						nextindex += 1
					EndIf

					; Collect creature race key tags (from SexLab creature registration)
					raceMatchIndex = StringUtil.Find(tags, "CreatureRaceName")
					If raceMatchIndex > -1
						newTags[nextindex] = "HasCreatureRaceName"
						nextindex += 1
						While raceMatchIndex > -1 && nextindex < newTags.Length
							String[] tempTags = PapyrusUtil.StringSplit(StringUtil.SubString(tags, raceMatchIndex, 0), ",")
							newTags[nextindex] = tempTags[0]
							nextindex += 1
							raceMatchIndex = StringUtil.Find(tags, "CreatureRaceName", raceMatchIndex + 1)
						EndWhile
					Else
						newTags[nextindex] = "NeutralCreatureRaceName"
						nextindex += 1
					EndIf
					
					; Remove excess entries
					newTags = PapyrusUtil.ClearEmpty(newTags)

					; Record resulting tags and raw notification text
					StorageUtil.StringListAdd(None,"SLArousedCreatures.Notifications." + EventIDs[i] + ".Text", text)
					StorageUtil.StringListAdd(None,"SLArousedCreatures.Notifications." + EventIDs[i] + ".Tags", PapyrusUtil.StringJoin(newTags, ","))
					slacConfig.debugSLAC && slacUtility.Log("Added Notification: event: " + EventIDs[i] + " - note: " + text + " - tags: " + PapyrusUtil.StringJoin(newTags, ","))
				EndIf

				j += 1
			EndWhile
		EndIf
		i += 1
	EndWhile

	; Collect pronoun strings
	PronounSubject = Utility.CreateStringArray(3,"")
	PronounSubject[0] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Subject.Male", "he")
	PronounSubject[1] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Subject.Female", "she")
	PronounSubject[2] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Subject.Neutral", "they")
	PronounObject = Utility.CreateStringArray(3,"")
	PronounObject[0] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Object.Male", "him")
	PronounObject[1] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Object.Female", "her")
	PronounObject[2] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Object.Neutral", "them")
	PronounPossessive = Utility.CreateStringArray(3,"")
	PronounPossessive[0] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Possessive.Male", "his")
	PronounPossessive[1] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Possessive.Female", "hers")
	PronounPossessive[2] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Possessive.Neutral", "theirs")
	PronounPossessiveAdj = Utility.CreateStringArray(3,"")
	PronounPossessiveAdj[0] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.PossessiveAdj.Male", "his")
	PronounPossessiveAdj[1] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.PossessiveAdj.Female", "her")
	PronounPossessiveAdj[2] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.PossessiveAdj.Neutral", "their")
	PronounReflexive = Utility.CreateStringArray(3,"")
	PronounReflexive[0] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Reflexive.Male", "himself")
	PronounReflexive[1] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Reflexive.Female", "herself")
	PronounReflexive[2] = JsonUtil.GetPathStringValue(noteFilePath, ".Pronouns.Reflexive.Neutral", "themself")
	
	Return True
EndFunction


; Find and return first matching tag from list in string, or return first (neutral) tag in list.
String Function FindTags(String[] tags, String[] tagList)
	Int i = 0

	; Find and return first matching tag
	While i < tagList.Length
		If tags.Find(tagList[i]) > -1
			Return tagList[i]
		EndIf
		i += 1
	EndWhile

	; Return default / neutral* tag
	Return tagList[0]
EndFunction


; Find matching tag in string
Bool Function HasTag(String[] tags, String SearchTag)
	Return tags.Find(SearchTag) > -1
EndFunction


; Replace token string if present
String Function Replace(String Subject, String Token, String Insert)
	; String[] Parts = StringUtil.Split(Subject, "{" + Token + "}") ; Can't split on more than one character
	; PapyrusUtil.StringSplit trims whitespace from the ends of the resultant elements. This is awkward in 
	; situations where a concatenation should be part of a word, such as "{creaturerace}'s".
	;String[] Parts = PapyrusUtil.StringSplit(Subject, "{" + Token + "}")
	;If Parts.Length > 1
	;	Return PapyrusUtil.StringJoin(Parts, " " + Insert + " ")
	;EndIf

	Int LastIndex = 0
	Token = "{" + Token + "}"
	Int Escape = 20

	While StringUtil.Find(Subject, Token, LastIndex) > -1 && Escape > 0
		Int NextIndex = StringUtil.Find(Subject,Token,LastIndex)
		String Part1 = ""

		If NextIndex > 0
			Part1 = StringUtil.SubString(Subject, LastIndex, NextIndex)
		EndIf

		String Part2 = StringUtil.SubString(Subject, NextIndex + StringUtil.GetLength(Token))

		; CTD string test. This may run afoul of some multi-byte language encodings.
		If StringUtil.GetLength(Part1) + StringUtil.GetLength(Insert) + StringUtil.GetLength(Part2) > 255
			slacConfig.DebugSLAC && slacUtility.Log("Notify Process Error: String too long - canceled to prevent CTD")
			; Not sure if more aggressive messaging to the user should be used here.
			Return Subject
		EndIf

		Subject = Part1 + Insert + Part2

		Escape -= 1
	EndWhile

	Return Subject
EndFunction


; Event IDs
String[] Function GetEventIDs()
	Return EventIDs
EndFunction


; JSON Versions
Int Function GetModVersion()
	Return ModVersion
EndFunction
Int Function GetFileVersion()
	Return FileVersion
EndFunction