Scriptname MoreNastyCrittersVoices extends sslVoiceFactory  

function RegisterVoices()
	PrepareFactory()
	RegisterVoice("AshhopperMNC")
	RegisterVoice("BearMNC")
	RegisterVoice("BoarMNC")
	RegisterVoice("BoarMountedMNC")
	RegisterVoice("CaninesMNC")
	RegisterVoice("ChaurusBugsMNC")
	RegisterVoice("ChickenMNC")
	RegisterVoice("CowMNC")
	RegisterVoice("DeerElkMNC")
	RegisterVoice("DragonPriestMNC")
	RegisterVoice("DragonMNC")
	RegisterVoice("DraugrMNC")
	RegisterVoice("DwarvenHeavyMNC")
	RegisterVoice("DwarvenLightMNC")
	RegisterVoice("FalmerMNC")
	RegisterVoice("FlameAtronachMNC")
	RegisterVoice("FoxMNC")
	RegisterVoice("FrostAtronachMNC")
	RegisterVoice("GargoyleMNC")
	RegisterVoice("GiantMNC")
	RegisterVoice("GoatMNC")
	RegisterVoice("HagravenMNC")
	RegisterVoice("HorkerMNC")
	RegisterVoice("HorseMNC")
	RegisterVoice("IceWraithMNC")
	RegisterVoice("LurkerMNC")
	RegisterVoice("MammothMNC")
	RegisterVoice("MudcrabMNC")
	RegisterVoice("NetchMNC")
	;RegisterVoice("RabbitMNC")
	RegisterVoice("RieklingMNC")
	RegisterVoice("SabreCatMNC")
	RegisterVoice("SeekerMNC")
	RegisterVoice("SkeeverMNC")
	RegisterVoice("SlaughterfishMNC")
	RegisterVoice("StormAtronachMNC")
	RegisterVoice("SpiderMNC")
	RegisterVoice("SprigganMNC")
	RegisterVoice("TrollMNC")
	;RegisterVoice("VampireLordMNC")
	RegisterVoice("WerewolfMNC")
	RegisterVoice("WispMotherMNC")
	;RegisterVoice("WispMNC")
endFunction

function AshhopperMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Ashhopper (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB02, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB01, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB00, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Ashhoppers")
	Base.Save(id)
endFunction

function BearMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Bear (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB05, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB04, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB03, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Bears")
	Base.Save(id)
endFunction

function BoarMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Boar (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB08, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB07, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB06, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Boars")
	Base.AddRaceKey("BoarsAny")
	Base.Save(id)
endFunction

function BoarMountedMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Mounted Boars (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB0B, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB0A, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB09, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("BoarsMounted")
	Base.Save(id)
endFunction

function CaninesMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Canines (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB0E, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB0D, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB0C, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Canines")
	Base.AddRaceKey("Dogs")
	Base.AddRaceKey("Wolves")
	Base.Save(id)
endFunction

function ChaurusBugsMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Chaurus Bugs (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB11, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB10, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB0F, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Chaurus")
	Base.AddRaceKey("ChaurusHunters")
	Base.AddRaceKey("ChaurusReapers")
	Base.Save(id)
endFunction

function ChickenMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Chicken (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB12, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB12, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB12, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Chickens")
	Base.Save(id)
endFunction

function CowMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Cow (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB15, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB14, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB13, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Cows")
	Base.Save(id)
endFunction

function DeerElkMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Deer & Elk (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB18, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB17, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB16, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Deers")
	Base.Save(id)
endFunction

function DragonPriestMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Dragon Priest (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB1E, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB1D, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB1C, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("DragonPriests")
	Base.Save(id)
endFunction

function DragonMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Dragon (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB1B, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB1A, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB19, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Dragons")
	Base.Save(id)
endFunction

function DraugrMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Draugr (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB21, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB20, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB1F, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Draugrs")
	Base.Save(id)
endFunction

function DwarvenHeavyMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Heavy Dwarven Constructs (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB24, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB23, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB22, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("DwarvenBallistas")
	Base.AddRaceKey("DwarvenCenturions")
	Base.Save(id)
endFunction

function DwarvenLightMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Light Dwarven Constructs (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB27, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB26, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB25, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("DwarvenSpheres")
	Base.AddRaceKey("DwarvenSpiders")
	Base.Save(id)
endFunction

function FalmerMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Falmer (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB2A, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB29, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB28, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Falmers")
	Base.Save(id)
endFunction

function FlameAtronachMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "FlameAtronach (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB2D, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB2C, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB2B, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("FlameAtronach")
	Base.Save(id)
endFunction

function FoxMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Fox (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB30, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB2F, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB2E, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Foxes")
	Base.Save(id)
endFunction

function FrostAtronachMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "FrostAtronach (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB33, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB32, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB31, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("FrostAtronach")
	Base.Save(id)
endFunction

function GargoyleMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Gargoyle (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB36, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB35, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB34, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Gargoyles")
	Base.Save(id)
endFunction

function GiantMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Giant (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB39, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB38, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB37, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Giants")
	Base.Save(id)
endFunction

function GoatMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Goat (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB3C, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB3B, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB3A, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Goats")
	Base.Save(id)
endFunction

function HagravenMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Hagraven (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB3F, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB3E, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB3D, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Hagravens")
	Base.Save(id)
endFunction

function HorkerMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Horker (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB42, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB41, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB40, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Horkers")
	Base.Save(id)
endFunction

function HorseMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Horse (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB45, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB44, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB43, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Horses")
	Base.Save(id)
endFunction

function IceWraithMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "IceWraith (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB48, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB47, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB46, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("IceWraiths")
	Base.Save(id)
endFunction

function LurkerMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Lurker (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB4B, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB4A, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB49, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Lurkers")
	Base.Save(id)
endFunction

function MammothMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Mammoth (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB4E, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB4D, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB4C, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Mammoths")
	Base.Save(id)
endFunction

function MudcrabMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Mudcrab (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB51, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB50, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB4F, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Mudcrabs")
	Base.Save(id)
endFunction

function NetchMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Netch (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB54, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB53, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB52, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Netches")
	Base.Save(id)
endFunction

;function RabbitMNC(int id)
;	sslBaseVoice Base = Create(id)
;	Base.Name = "Rabbit (MNC)"
;	Base.Gender  = Creature
;	Base.Mild = Game.GetFormFromFile(0x----, "MoreNastyCritters.esp") as Sound
;	Base.Medium = Game.GetFormFromFile(0x----, "MoreNastyCritters.esp") as Sound
;	Base.Hot = Game.GetFormFromFile(0x----, "MoreNastyCritters.esp") as Sound
;	Base.AddRaceKey("Rabbits")
;	Base.Save(id)
;endFunction

function RieklingMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Riekling (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB57, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB56, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB55, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Rieklings")
	Base.Save(id)
endFunction

function SabreCatMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "SabreCat (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB5A, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB59, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB58, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("SabreCats")
	Base.Save(id)
endFunction

function SeekerMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Seeker (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB5D, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB5C, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB5B, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Seekers")
	Base.Save(id)
endFunction

function SkeeverMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Skeever (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB60, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB5F, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB5E, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Skeevers")
	Base.Save(id)
endFunction

function SlaughterfishMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Slaughterfish (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB63, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB62, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB61, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Slaughterfishes")
	Base.Save(id)
endFunction

function StormAtronachMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "StormAtronach (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB6C, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB6B, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB6A, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("StormAtronach")
	Base.Save(id)
endFunction

function SpiderMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Spider (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB66, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB65, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB64, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Spiders")
	Base.AddRaceKey("LargeSpiders")
	Base.AddRaceKey("GiantSpiders")
	Base.Save(id)
endFunction

function SprigganMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Spriggan (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB69, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB68, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB67, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Spriggans")
	Base.Save(id)
endFunction

function TrollMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Troll (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB6F, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB6E, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB6D, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Trolls")
	Base.Save(id)
endFunction

;function VampireLordMNC(int id)
;	sslBaseVoice Base = Create(id)
;	Base.Name = "VampireLord (MNC)"
;	Base.Gender  = Creature
;	Base.Mild = Game.GetFormFromFile(0x----, "MoreNastyCritters.esp") as Sound
;	Base.Medium = Game.GetFormFromFile(0x----, "MoreNastyCritters.esp") as Sound
;	Base.Hot = Game.GetFormFromFile(0x----, "MoreNastyCritters.esp") as Sound
;	Base.AddRaceKey("VampireLords")
;	Base.Save(id)
;endFunction

function WerewolfMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "Werewolf (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB72, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB71, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB70, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("Werewolves")
	Base.Save(id)
endFunction

function WispMotherMNC(int id)
	sslBaseVoice Base = Create(id)
	Base.Name = "WispMother (MNC)"
	Base.Gender  = Creature
	Base.Mild = Game.GetFormFromFile(0xAB75, "MoreNastyCritters.esp") as Sound
	Base.Medium = Game.GetFormFromFile(0xAB74, "MoreNastyCritters.esp") as Sound
	Base.Hot = Game.GetFormFromFile(0xAB73, "MoreNastyCritters.esp") as Sound
	Base.AddRaceKey("WispMothers")
	Base.Save(id)
endFunction

;function WispMNC(int id)
;	sslBaseVoice Base = Create(id)
;	Base.Name = "Wisp (MNC)"
;	Base.Gender  = Creature
;	Base.Mild = Game.GetFormFromFile(0x---, "MoreNastyCritters.esp") as Sound
;	Base.Medium = Game.GetFormFromFile(0x---, "MoreNastyCritters.esp") as Sound
;	Base.Hot = Game.GetFormFromFile(0x---, "MoreNastyCritters.esp") as Sound
;	Base.AddRaceKey("Wisps")
;	Base.Save(id)
;endFunction