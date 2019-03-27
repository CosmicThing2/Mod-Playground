/*

Minecraft Mod Playground Script - Created by Oliver Cox (CosmicThing2)
This script effectively functions as a simply 'mod and map manager' for Minecraft. It contains a large number of preset mods already setup for Minecraft 1.12.2. The script also has a number of other functions specifically for use at schools such as:
- Automatic registering of students/users when they launch this script
- Preventing students/users launching the game before a certain time (by default 2pm)
- Users can 'load' from each other to quickly and easily get the same mods.
- A backup manager that allows users to save their created maps

For this script to work, you MUST have:
- MultiMC. The entire script relies on MultiMC being installed and logged in, the script can and will try to install it automatically for you on first run.
- Java. Minecraft (and any mods) require Java to be installed to work. This can be found here: https://www.java.com/en/download/manual.jsp. Install 'Windows Offline' (and 'Windows Offline (64-bit)' if you've got a 64-bit system - STRONGLY RECOMMENDED!).
- A valid Minecraft Account. To download the game and any needed libraries, you will be asked to sign into MultiMC with a valid Minecraft account. For schools (and other businesses), you must legally own an account per device the game is running on. I will never support hacked or unlicensed clients.
- Internet Connection. For MultiMC to authenticate and for Mod Playground to download/update any mods, you need an Internet Connection. The faster the better!

Thanks for using this program! :)

Copyright 2019 Oliver Cox

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

*/
 
;---------------------Setup initial settings for the program

;These ensure the script can't accidently be run twice at the same time and that it always runs as fast as possible, don't need to be changed at all
#SingleInstance ignore
SetTitleMatchMode, 3
SetKeyDelay, 0

;Need the time/date
FormatTime, time,, Time

;---------------------Setup all needed variables for the program, most of the below can be changed if needed

;Changeable Static variables that depend on minecraft - change these as and when needed
version = ModMan ;Minecraft Version/Folder name. i.e. The full instance/game files should be in %mclocation%\%version%. Be careful about changing this, it changes a massive amount of the program! You must have an instance ready with the same name on the server!
spacetolerance = 0 ;If the install folder on the client PC is less than this (in mb), it will be wiped and reinstalled (in case it installs badly). I made this but I rarely use it, can be left as 0 unless you want to change it!
mcver = 1.12.2 ;Minecraft version that this instance uses, will need to be changed if minecraft is updated. Note that all mods only work with one minecraft version!! You'll need to download new mods! Be very careful changing this!
configloc = C:\Program Files (x86)\Mod Playground\cfg.ini ;Default location of the config file if not specified
configdir = C:\Program Files (x86)\Mod Playground ;Default config directory
customusername = %A_UserName% ;Username to use for the player (if forcing offline mode)

;Variable defaults used in the program, do not ever change these
newinstall = 0 ;Used to detect if minecraft has been installed recently or not. If it has, we don't need to bother wiping all mods/configs from a previous run
loadsave = 0 ;Used to detect if the user has already saved/loaded or not. If they haven't, we need to prompt them to ask if they want to save/load etc
legacymap = false ;Some maps only work with older versions of minecraft, if a map is one of these, this  will be true
legacymapver = 0 ;Some maps only work with older versions of minecraft, if a map is one of these, this variable will be set to the version that's needed

;#addmods1 - Add comma separated mods here
;These variables keep track of which mods are which type (basically just a list of all mods), MUST be comma separated with no spaces! Add a mod to these if you'd like! If you add a mod here, you MUST add it to the variable(s) below too.
modsTech = Advanced Generators,Bonsai Trees,Cyclic,Dark Utilities,Environmental Tech,Industrial Foregoing,Integrated Dynamics,XNet,Applied Energistics,Colossal Chests,Ender Storage,Extra Utilities 2,Extreme Reactors,Quark,Refined Storage,Tinkers Construct,Thermal Expansion,BuildCraft,IndustrialCraft,SecurityCraft,Immersive Engineering,Actually Additions,ProjectE,Storage Drawers,EnderIO,Iron Chests,RFTools,Forestry,Compact Machines,OpenBlocks,Mekanism,Simply Jetpacks,Ex Nihilo,Portal Gun,Simple Teleporters,Project Red,PneumaticCraft
modsMagic = Exotic Birds,Dimensional Doors,Millenaire,Minecraft Comes Alive,Aether 2,Electroblobs Wizardry,Vampirism,Serene Seasons,The Erebus,Thaumcraft,Botania,Blood Magic,JourneyMap,Recurrent Complex,Roguelike Dungeons,Roots 2,HarvestCraft,Twilight Forest,Astral Sorcery,Mystical Agriculture,Psi,AbyssalCraft,Betweenlands,Cooking for Blockheads,Biomes O' Plenty,NetherEx,Just a few fish,Totemic,Weeping Angels,Tardis,JurassiCraft,Animania,Chococraft
modsCreative = Mr Crayfish's Guns,Terrarium,Blockcraftery,Chisel 2,Xtones,BiblioCraft,Decocraft 2,Malisis Doors,Chisels and Bits,Better Builders Wands,WorldEdit,Earthworks,Fairy Lights,Mr Crayfish's Furniture,Secret Rooms,Mr Crayfish's Vehicles,CustomNPCs,Ferdinands Flowers,Streams
modsOther = Ore Excavation,LAN Server Extended,Heroic Armoury,Minewatch,Chance Cubes,Inventory Pets,Morph,Heroes Expansion,Speedster Heroes,Hats,Pokecube,Spartan Shields,Hardcore Darkness,Viescraft Airships,Lost Cities

;Have one list that contains all mods, used for randoming
modsAll := modsTech . "," . modsMagic . "," . modsCreative . "," . modsOther

;List of mods known to cause issues, these mods will come up with a warning when chosen. They can be selected but may cause crashes in some cases.
buggyMods = IronMan,Dalek Mod

;#addmods2 - Add pipe separated mods here, remember last item in list must be a pipe
;These variables keep track of everything which is in the left listbox and the right listbox (they need to start out the same as the variables above, but may change as and when the user presses '<' and '>'). Last character MUST be '|'. Add a mod to these if you'd like! If you add a mod here, you MUST add it to the variable(s) above too.
leftboxTech = Advanced Generators|Bonsai Trees|Cyclic|Dark Utilities|Environmental Tech|Industrial Foregoing|Integrated Dynamics|XNet|Applied Energistics|Colossal Chests|Ender Storage|Extra Utilities 2|Extreme Reactors|Quark|Refined Storage|Tinkers Construct|Thermal Expansion|BuildCraft|IndustrialCraft|SecurityCraft|Immersive Engineering|Actually Additions|ProjectE|Storage Drawers|EnderIO|Iron Chests|RFTools|Forestry|Compact Machines|OpenBlocks|Mekanism|Simply Jetpacks|Ex Nihilo|Portal Gun|Simple Teleporters|Project Red|PneumaticCraft|
leftboxMagic = Exotic Birds|Dimensional Doors|Millenaire|Minecraft Comes Alive|Aether 2|Electroblobs Wizardry|Vampirism|Serene Seasons|The Erebus|Thaumcraft|Botania|Blood Magic|JourneyMap|Recurrent Complex|Roguelike Dungeons|Roots 2|HarvestCraft|Twilight Forest|Astral Sorcery|Mystical Agriculture|Psi|AbyssalCraft|Betweenlands|Cooking for Blockheads|Biomes O' Plenty|NetherEx|Just a few fish|Totemic|Weeping Angels|Tardis|JurassiCraft|Animania|Chococraft|
leftboxCreative = Mr Crayfish's Guns|Terrarium|Blockcraftery|Chisel 2|Xtones|BiblioCraft|Decocraft 2|Malisis Doors|Chisels and Bits|Better Builders Wands|WorldEdit|Earthworks|Fairy Lights|Mr Crayfish's Furniture|Secret Rooms|Mr Crayfish's Vehicles|CustomNPCs|Ferdinands Flowers|Streams|
leftboxOther = Ore Excavation|LAN Server Extended|Heroic Armoury|Minewatch|Chance Cubes|Inventory Pets|Morph|Heroes Expansion|Speedster Heroes|Hats|Pokecube|Spartan Shields|Hardcore Darkness|Viescraft Airships|Lost Cities|
rightbox =
mapsList =

;Firstly, lets check for arguments
;If the user enters exactly 2 arguments then they are specifying a config directory... lets analyse that!
if A_Args.Length() = 2
{
	code := A_Args[1]
	configloc := A_Args[2]
	filetype := SubStr(configloc, -3)
	
	;Find config directory
	lastslash := InStr(configloc, "\",, 0)
	lastslash--
	configdir := SubStr(configloc, 1, lastslash)
	
	;Few checks first, if the first argument isn't '-cfg', throw them out
	if code != -cfg
	{
		MsgBox, 16, Error!, Bad arguments detected!`n`nPlease run with no arguments to use default config location (C:\Program Files (x86)\Mod Playground\cfg.ini) or run with -cfg "<location>\<configfile>.ini" to run with a specified config file.
		ExitApp
	}
	
	;If the second argument isn't an ini file, throw them out
	if filetype != .ini
	{
		MsgBox, 16, Error!, Bad arguments detected!`n`nPlease run with no arguments to use default config location (C:\Program Files (x86)\Mod Playground\cfg.ini) or run with -cfg "<location>\<configfile>.ini" to run with a specified config file.
		ExitApp
	}
	
	;Prompt the user for first time setup if the cfg isn't found
	IfNotExist, %configloc%
	{
		;Firstly ensure they are logged in with an admin account! If they're not an admin, don't allow first time setup to run, just exit script.
		full_command_line := DllCall("GetCommandLine", "str")
		if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
		{
			MsgBox, 17, Configuration File not found!, Your configuration file was not found in: %configloc%`n`nTo run first time setup, you must be an Administrator!`n`nPlease press 'OK' and Mod Playground will reload.
			IfMsgBox, Cancel
				ExitApp
			try
			{
				if A_IsCompiled
					Run *RunAs "%A_ScriptFullPath%" /restart -cfg "%configloc%"
				else
					Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%" -cfg "%configloc%"
			}
			ExitApp
		}
		
		;Does the user want to launch first time setup method?
		MsgBox, 49, Config file not found!, Cannot find a config file in: %configloc%`n`nDoes it exist? Or maybe I don't have permission to access it?`n`nWould you like to run first time setup with this location?
		IfMsgBox Ok
			firstsetup(configloc)
		else
			ExitApp
	}

}

;If they only enter 1 argument... they need to get it sorted!
else if A_Args.Length() = 1
{
	MsgBox, 16, Error!, Bad arguments detected!`n`nPlease run with no arguments to use default config location (C:\Program Files (x86)\Mod Playground\cfg.ini) or run with -cfg "<location>\<configfile>.ini" to run with a specified config file.
	ExitApp
}

;No arguments = use default config location (C:\Program Files (x86)\Mod Playground\cfg.ini)
else
{
	;If the config doesn't exist, query to run first time setup
	IfNotExist, %configloc%
	{
		;Firstly ensure they are logged in with an admin account! If they're not an admin, don't allow first time setup to run, just exit script.
		full_command_line := DllCall("GetCommandLine", "str")
		if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
		{
			MsgBox, 17, Configuration File not found!, You didn't specify a configuration file directory and it wasn't found in the default location: %configloc%`n`nTo run first time setup, you must be an Administrator!`n`nPlease press 'OK' and Mod Playground will reload.
			IfMsgBox, Cancel
				ExitApp
			try
			{
				if A_IsCompiled
					Run *RunAs "%A_ScriptFullPath%" /restart
				else
					Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%"
			}
			ExitApp
		}
		
		;Does the user want to launch first time setup method?
		MsgBox, 49, Config file not found!, You didn't specify a configuration file directory and it wasn't found in the default location: %configloc%`n`nDoes it exist, or maybe I don't have permission to access it?`n`nRun first time setup with this location?
		IfMsgBox Ok
		{
			firstsetup(configloc)
		}
		else
			ExitApp
	}
}

;Setup needed variables, reading from the config file
setupVars(configloc, configdir)

;Is it 'minecraft' or '.minecraft'?
IfExist, %multimcfolderloc%\instances\%version%\minecraft
	minecraftdirtype = minecraft 
else
	minecraftdirtype = .minecraft

;Is it 'minecraft' or '.minecraft' on the server?
IfExist, %mclocation%\%version%\minecraft
	serverdirtype = minecraft
else
	serverdirtype = .minecraft

;Read the admin password from 'mppwd.txt'
FileReadLine, hash, %configdir%\mppwd.txt, 1

;Read CustomMods.txt and CustomMaps.txt
FileRead, custommodslist, %modfilesloc%\CustomMods.txt
FileRead, custommapslist, %mapsloc%\CustomMaps.txt

;Add any Custom Mods to the lists from CustomMods.txt
addCustomMods()

;Add any Custom Maps to the lists from CustomMaps.txt
addCustomMaps()

;MAIN PROGRAM START  -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;Everything in this section is 'Autorun' code. i.e. It's always run at the start of the program, most of it is GUI creation and setup.

writeagain = True

;Is timelock enabled?
if Timelock = 1
{
	;Get current time in HHMM form
	TimelockNow := A_Hour . A_Min
	
	;Check this against the timelock times from the config file. Ask the user the admin password if the time is bad!
	if ((TimelockNow < TimelockStart) || (TimelockNow > TimelockEnd))
	{
		;If registers are enabled, log the attempt to the register file
		if RegistersEnabled = 1
			Iniwrite, %version% on %A_ComputerName% (%time%) - Blocked, %registerloc%\%A_MM%-%A_YYYY%.ini, %A_DD%/%A_MM%, %A_UserName%
			
		;Ask the user for a password
		InputBox, datain, Not Allowed!, Mod Playground is not allowed at this time`, sorry!`n`nPlease enter administrator password., HIDE, 320, 160
		if ErrorLevel
			ExitApp
			
		;Hash the input data and compare with the stored hash
		datain := bcrypt_sha256(datain)
		if datain != %hash%
		{
			MsgBox, 16, Bad Password!, Bad password!
			ExitApp
		}
		else
		{
			if RegistersEnabled = 1
			{
				Iniwrite, %version% on %A_ComputerName% (%time%) - Allowed using administrator password, %registerloc%\%A_MM%-%A_YYYY%.ini, %A_DD%/%A_MM%, %A_UserName%
				writeagain = False
			}
		}
	}
}

;If they're allowed to play at this time also write this to the register file
if ((RegistersEnabled = 1) && (writeagain = True))
	Iniwrite, %version% on %A_ComputerName% (%time%) - Allowed, %registerloc%\%A_MM%-%A_YYYY%.ini, %A_DD%/%A_MM%, %A_UserName%

;Firstly ensure the MultiMC folder exists. If it doesn't, kick the user out straightaway UNLESS they enter the admin password
IfNotExist, %multimcfolderloc%
{
	InputBox, datain, Not Installed!, Minecraft hasn't been installed on this computer yet in %multimcfolderloc%`n`nPlease speak to an ICT Administrator or enter administrator password., HIDE
	if ErrorLevel
		ExitApp
		
	;Hash the input data and compare with the stored hash
	datain := bcrypt_sha256(datain)
	if datain != %hash%
	{
		MsgBox, 16, Bad Password!, Bad password!
		ExitApp
	}
	
	;Game will not work without MultiMC but an admin user is free to browse the program if they want to
	MsgBox, 48, No MultiMC!, Correct Admin Password Entered. Please not that Minecraft will not launch without MultiMC!`n`nThe directory has been set to: %multimcfolderloc%
}

;Show the progress bar
Progress, show
Progress, 1, Performing initial setup, Starting up launcher. Please Wait...,Mod Playground

;Now check to see if the ModMan instance exists. If it doesn't, we'll need to download it from %mclocation% and save it to the local machine
if (!exist(version, spacetolerance, multimcfolderloc))
{
	Progress, 5, Downloading Minecraft instance, Starting up launcher. Please Wait...,Mod Playground
	newinstall = 1
	
	;If it fails to install or can't for whatever reason, just exit the script. No point continuing!
	if(!install(version, mclocation, multimcfolderloc, libsloc))
		ExitApp
}

;Ensure user has the latest instance version, this is determined by 'modversion.ini' which should be in the instance folder. If it doesn't match it will redownload the instance and libraries from the server.
Progress, 10, Checking you have the latest version, Starting up launcher. Please Wait...,Mod Playground
update(version, mclocation, libsloc, multimcfolderloc)

Progress, 40, Creating GUI, Starting up launcher. Please Wait...,Mod Playground

;Main function for creating the main mod manager GUI:

;Create the different tabs ('CurrentTab' is a created variable which keeps track of what tab the user is current on - used later)
Gui, Add, Tab3, vCurrentTab gTabChange, Intro|Science and Technology|Magic and Exploration|Creative|Other|Maps

;Add stuff to the 'Intro' tab
Gui, Tab, Intro
Gui, Font, norm s16, Verdana
Gui, Add, Text, x30 y60 w400 h50, Welcome to Cosmic's epic...
Gui, Font, norm s30 w700, Verdana
Gui, Add, Text, x100 y90 w400 h200 +Center cRed, MINECRAFT MOD MANAGER!
Gui, Font, norm s12, Verdana
Gui, Add, Text, x30 y190 w400 h50, 1. Firstly choose from one of the tabs above:
Gui, Add, Picture, x30 y210, %modpicsloc%\tabs.jpg
Gui, Add, Text, x30 y250 w440 h50, 2. Click a mod to get some information about it and then hit the arrow to add it to your mod list!
Gui, Add, Picture, x30 y290, %modpicsloc%\modslist.jpg
Gui, Add, Picture, x235 y350, %modpicsloc%\arrow.jpg
Gui, Add, Text, x295 y335 w200 h60 +Center, 3. Finally`, just press Launch!
Gui, Add, Picture, x330 y380, %modpicsloc%\launch.jpg
Gui, Add, Button,x490 y50 w20 h20 gHelp vHelp, !

;Add stuff to the 'Science and Technology' tab
Gui, Tab, Science and Technology
Gui, Font, norm s14,Calibri Light
Gui, Add, ListBox, vModChoiceTech Sort x20 y60 w200 h415 gItemSelectL, %leftboxTech%
Gui, Font, norm s11,Calibri Light
Gui, Add, Edit, vdescTech ReadOnly x290 y140 w210 h260
Gui, Font, norm s20 w700,Calibri Light
Gui, Add, Button,x235 y200 w40 h40 gMover, >
Gui, Add, Picture, x305 y60 vdescpicTech,
Gui, Font, norm s12 w700,Calibri Light
Gui, Add, Text, x325 y410 w150 h25 vVideotexttech, Video of this mod:
Gui, Font, norm s11,Calibri Light
GuiControl, Hide, Videotexttech
Gui, Add, Link, x280 y435 w250 h25 vVideolinktech, 

;Add stuff to the 'Magic and Exploration' tab
Gui, Tab, Magic and Exploration
Gui, Font, norm s14,Calibri Light
Gui, Add, ListBox, vModChoiceMagic Sort x20 y60 w200 h415 gItemSelectL, %leftboxMagic%
Gui, Font, norm s11,Calibri Light
Gui, Add, Edit, vdescMagic ReadOnly x290 y140 w210 h260
Gui, Font, norm s20 w700,Calibri Light
Gui, Add, Button,x235 y200 w40 h40 gMover, >
Gui, Add, Picture, x305 y60 vdescpicMagic,
Gui, Font, norm s12 w700,Calibri Light
Gui, Add, Text, x325 y410 w150 h25 vVideotextmagic, Video of this mod:
Gui, Font, norm s11,Calibri Light
GuiControl, Hide, Videotextmagic
Gui, Add, Link, x280 y435 w250 h25 vVideolinkmagic,

;Add stuff to the 'Creative' tab
Gui, Tab, Creative
Gui, Font, norm s14,Calibri Light
Gui, Add, ListBox, vModChoiceCreative Sort x20 y60 w200 h415 gItemSelectL, %leftboxCreative%
Gui, Font, norm s11,Calibri Light
Gui, Add, Edit, vdescCreative ReadOnly x290 y140 w210 h260
Gui, Font, norm s20 w700,Calibri Light
Gui, Add, Button,x235 y200 w40 h40 gMover, >
Gui, Add, Picture, x305 y60 vdescpicCreative,
Gui, Font, norm s12 w700,Calibri Light
Gui, Add, Text, x325 y410 w150 h25 vVideotextcreative, Video of this mod:
Gui, Font, norm s11,Calibri Light
GuiControl, Hide, Videotextcreative
Gui, Add, Link, x280 y435 w250 h25 vVideolinkcreative,

;Add stuff to the 'Other' tab
Gui, Tab, Other
Gui, Font, norm s14,Calibri Light
Gui, Add, ListBox, vModChoiceOther Sort x20 y60 w200 h415 gItemSelectL, %leftboxOther%
Gui, Font, norm s11,Calibri Light
Gui, Add, Edit, vdescOther ReadOnly x290 y140 w210 h260
Gui, Font, norm s20 w700,Calibri Light
Gui, Add, Button,x235 y200 w40 h40 gMover, >
Gui, Add, Picture, x305 y60 vdescpicOther,
Gui, Font, norm s12 w700,Calibri Light
Gui, Add, Text, x325 y410 w150 h25 vVideotextother, Video of this mod:
Gui, Font, norm s11,Calibri Light
GuiControl, Hide, Videotextother
Gui, Add, Link, x280 y435 w250 h25 vVideolinkother,

;Add stuff to the 'Maps' tab
Gui, Tab, Maps
Gui, Font, norm s14,Calibri Light
Gui, Add, ListBox, vMapsList Sort x20 y60 w200 h355 gItemSelectMaps, %mapsList%
Gui, Add, Button,x20 y415 w200 h40 gMapDL vMapDL, Download this map
GuiControl, Disable, MapDL
Gui, Add, ListBox, vMapSavesList Sort x300 y265 w200 h150
Gui, Font, norm s12,Calibri Light
Gui, Font,norm s16 w700,Calibri Light
Gui, Add, Text, x300 y232 w200 h30 Center, Your Saves
Gui, Add, Picture, x305 y60 vdescpicMaps
Gui, Add, Picture, x225 y325, %modpicsloc%\maparrow.png
AddGraphicButton("cross", modpicsloc . "\cross.bmp", "x300 y415 w40 h40 gDeleteSave vDeleteSave", 32, 32)
AddGraphicButton("downmap", modpicsloc . "\dlmap.bmp", "x350 y415 w40 h40 gDownloadMap vDownloadMap", 32, 32)
AddGraphicButton("upmap", modpicsloc . "\ulmap.bmp", "x400 y415 w40 h40 gUploadMap vUploadMap", 32, 32)

;Add stuff to the other GUI (with the right hand box on it)
Gui, 2:Font,norm s14,Calibri Light
Gui, 2:Add, ListBox, vModChoiceFinal Sort x80 y20 w200 h380, %rightbox%
Gui, 2:Font,norm s20 w700,Calibri Light
Gui, 2:Add,Button,x25 y175 w40 h40 gMovel, <
Gui, 2:Font,norm s12 w700,Calibri Light
Gui, 2:Add,Button,x10 y303 w60 h40 gClear, Clear
Gui, 2:Add,Button,x10 y353 w60 h40 gSave, Save
Gui, 2:Add,Button,x10 y19 w60 h40 gLoad, Load
Gui, 2:Default
AddGraphicButton("randommods", modpicsloc . "\random.bmp", "x30 y400 w100 h60 gRandomMods vRandomMods", 52, 92)
Gui, 1:Default
Gui, 2:Add,Button,x140 y400 w140 h60 gLaunch vLaunch, Launch Minecraft!
Gui, 2:Font, norm s12,Calibri Light

;Add stuff to the backup/saves GUI
Gui, 3:Font,norm s20 w700,Calibri Light
Gui, 3:Add, Text, x60 y10 w280 h50, Backup Manager
Gui, 3:Font,norm s14,Calibri Light
Gui, 3:Add, Text, x20 y50 w260 h100 Center, Tick the worlds which you want backed up from the list below`, these worlds will be copied to every computer you go on!
Gui, 3:Add, ListView, Checked AltSubmit vworlds Sort x20 y150 w250 h200, Save
Gui, 3:Add,Button,x20 y365 w100 h60 gRefreshBackup, Refresh
Gui, 3:Add,Button,x130 y365 w140 h60 gBackup vBackup, Backup Now

Progress, 50, Downloading your saves, Starting up launcher. Please Wait...,Mod Playground

;Run function to add the users' worlds to the backup GUI, this GUI is only shown once the user launches minecraft. See the function for more details. Don't bother wiping local saves though if backups are disabled.
if BackupsEnabled = 1
	addBackupWorlds(savefilesloc, version, 1, multimcfolderloc, 1, 0, minecraftdirtype)
else
	addBackupWorlds(savefilesloc, version, 0, multimcfolderloc, 0, 0, minecraftdirtype)

Progress, 95, Loading last save and finishing up, Starting up launcher. Please Wait...,Mod Playground

;Load the most recent autosave automatically if it exists (remembers what mods were selected last time the manager was run).
if SavesEnabled = 1
{
	if FileExist(lastrunsave)
	{
		;Start reading from the selected file
		cnotice = Autogenerated save file!
		cblank =
		FileReadLine, notice, %lastrunsave%, 1
		FileReadLine, empty, %lastrunsave%, 2

		;Check the read file to ensure it's a valid save file and hasn't been modified in any way (will cause problems later if it has been edited). We only try to read/load from it as long as it hasn't been messed with!
		if ((notice = cnotice) && (empty = cblank))
		{
			;Read line by line
			FileReadLine, leftboxTech, %lastrunsave%, 3
			FileReadLine, leftboxMagic, %lastrunsave%, 4
			FileReadLine, leftboxCreative, %lastrunsave%, 5
			FileReadLine, leftboxOther, %lastrunsave%, 6
			FileReadLine, rightbox, %lastrunsave%, 7
			
			;Detect any new mods that have been added recently, add it to the save. These won't exist in the autosaves so we need a separate function to search and add them if needed.
			leftboxTech := detectNewMods(leftboxTech, rightbox, "Tech")
			leftboxMagic := detectNewMods(leftboxMagic, rightbox, "Magic")
			leftboxCreative := detectNewMods(leftboxCreative, rightbox, "Creative")
			leftboxOther := detectNewMods(leftboxOther, rightbox, "Other")
				
			;Update all the variables and GUI with the new data
			GuiControl, 1:, ModChoiceTech, |%leftboxTech%
			GuiControl, 1:, ModChoiceMagic, |%leftboxMagic%
			GuiControl, 1:, ModChoiceCreative, |%leftboxCreative%
			GuiControl, 1:, ModChoiceOther, |%leftboxOther%
			GuiControl, 2:, ModChoiceFinal, |%rightbox%
		}
		
	}
}

;Show all GUI's and leave it up to the user to decide what happens next!
Progress, off
Gui , Show, w520 h470, Mod Manager
WinGetPos, gui1x, gui1y,gui1w,,Mod Manager
gui2x := gui1x+gui1w+5
Gui,2:Show, x%gui2x% w300 h470, Selected Mods
return

;--------------------------------------------------------------------------------------END OF AUTORUN CODE-----------------------------------------------------------------------------------------------------------------------------------
;ALL CODE BELOW CONTAINS VARIOUS METHODS AND FUNCTIONS THAT ARE ONLY RUN WHEN NEEDED. (Usually when buttons are pressed)

;Enable the minecraft email box if user ticks the offline mode tickbox
OfflineMode:
Gui, 5:Submit, NoHide
if OfflineMode = 1
	GuiControl, 5:Enable, offlineemail
else
	GuiControl, 5:Disable, offlineemail
return

;Enable the timelock times if the user ticks the tickbox
Timelock:
Gui, 5:Submit, NoHide
if Timelock = 1
{
	GuiControl, 5:Enable, TimelockStart
	GuiControl, 5:Enable, TimelockEnd
}
else
{
	GuiControl, 5:Disable, TimelockStart
	GuiControl, 5:Disable, TimelockEnd
}
return

;Enable the 'saveloc' edit bar on GUI 5 if/when the tickboxes are clicked
ToggleSaveLoc:
Gui, 5:Submit, NoHide
TotalEnabled := SavesEnabled + BackupsEnabled + StatsEnabled
if TotalEnabled > 0
{
	GuiControl, 5:Enable, BrowseSav
	GuiControl, 5:Enable, saveloc
}
else
{
	GuiControl, 5:Disable, BrowseSav
	GuiControl, 5:Disable, saveloc
}
return

;Enable the 'regloc' edit bar on GUI 5 if/when the tickboxe is clicked
ToggleRegLoc:
Gui, 5:Submit, NoHide
if RegistersEnabled = 1
{
	GuiControl, 5:Enable, BrowseReg
	GuiControl, 5:Enable, regloc
}
else
{
	GuiControl, 5:Disable, BrowseReg
	GuiControl, 5:Disable, regloc
}
return

;Browse buttons on GUI 5
SelectFolder:
FileSelectFolder, selecteddir,, 3, Select a Folder
if selecteddir =
	return
if A_GuiControl = BrowseMMC
	GuiControl, 5:, mmloc, %selecteddir%
else if A_GuiControl = BrowseRes
	GuiControl, 5:, mploc, %selecteddir%
else if A_GuiControl = BrowseSav
	GuiControl, 5:, saveloc, %selecteddir%
else if A_GuiControl = BrowseReg
	GuiControl, 5:, regloc, %selecteddir%
return

;Run on first time setup, sets up all variables, folders and the password for the program to run
SaveConfig:
Gui, 5:Submit, NoHide

;Firstly, if they've enabled the 'prevent users accessing the program at 'x' and 'y' times thing... check they've entered the times correctly!
if Timelock = 1
{
	if TimelockEnd <= %TimelockStart%
	{
		MsgBox, 16, Error!, For allowing users access only at certain times, you have set the end time to be the same as (or earlier) than the start time!`n`nPlease set end time to be later than the start time!
		GuiControl, Focus, TimelockEnd
		return
	}
}

;Turn this complex times into 'hour' and 'minute' for easy writing to cfg.ini (we only care about hour and minute)
TimelockStart := SubStr(TimelockStart, 9, 4)
TimelockEnd := SubStr(TimelockEnd, 9, 4)

Gui, 5:Hide

;Create the config directory if it doesn't exist
IfNotExist, %configdir%
	FileCreateDir, %configdir%

;Write all needed variables to the config file
IniWrite, %mmloc%, %configloc%, Mod Playground Configuration File, MultiMC Location
IniWrite, %mploc%, %configloc%, Mod Playground Configuration File, Mod Playground Resource Location
IniWrite, %mploc%\Instances, %configloc%, Mod Playground Configuration File, Instances Location
IniWrite, %mploc%\Mods, %configloc%, Mod Playground Configuration File, Mods Location
IniWrite, %mploc%\Images, %configloc%, Mod Playground Configuration File, Images Location
IniWrite, %mploc%\Libs, %configloc%, Mod Playground Configuration File, Libraries Location
IniWrite, %mploc%\Maps, %configloc%, Mod Playground Configuration File, Custom Maps Location
IniWrite, %saveloc%, %configloc%, Mod Playground Configuration File, User Save Data Location
IniWrite, %regloc%, %configloc%, Mod Playground Configuration File, Register Location
IniWrite, %SavesEnabled%, %configloc%, Mod Playground Configuration File, AutoSaves
IniWrite, %BackupsEnabled%, %configloc%, Mod Playground Configuration File, Backup Manager
IniWrite, %StatsEnabled%, %configloc%, Mod Playground Configuration File, Stats
IniWrite, %RegistersEnabled%, %configloc%, Mod Playground Configuration File, Registers
IniWrite, %OfflineMode%, %configloc%, Mod Playground Configuration File, Offline
IniWrite, %offlineemail%, %configloc%, Mod Playground Configuration File, Email Addr
IniWrite, %Timelock%, %configloc%, Mod Playground Configuration File, Timelock
IniWrite, %TimelockStart%, %configloc%, Mod Playground Configuration File, Timelock Start
IniWrite, %TimelockEnd%, %configloc%, Mod Playground Configuration File, Timelock End

modfilesloc = %mploc%\Mods
skipEnc = False

;Ask user to create an admin password
IfNotExist, %configdir%\mppwd.txt
{
	adminpass =
	adminpass2 = test
	InputBox, adminpass, Administrator Password, Please create a strong administrator password for Mod Playground of at least 8 characters.`n`nThis is used to update mods and delete the MultiMC instances if needed., HIDE
	If ErrorLevel
	{
		FileDelete, %configloc%
		ExitApp
	}
	while ((adminpass != adminpass2) || (adminpass = ""))
	{
		;MsgBox, whileloop
		while (StrLen(adminpass) < 8)
		{
			InputBox, adminpass, Administrator Password, Please create a password of at least 8 characters!, HIDE
			If ErrorLevel
			{
				FileDelete, %configloc%
				ExitApp
			}
		}
		InputBox, adminpass2, Administrator Password, Please enter this password again to confirm., HIDE
		If ErrorLevel
		{
			FileDelete, %configloc%
			ExitApp
		}
		if adminpass != %adminpass2%
		{
			InputBox, adminpass, Administrator Password, Error`, passwords were not identical`, please try again!`n`nCreate a strong administrator password for Mod Playground of at least 8 characters.`n`nThis is used to update mods and delete the MultiMC instances if needed., HIDE,,240
			If ErrorLevel
			{
				FileDelete, %configloc%
				ExitApp
			}
		}
	}
}
else
{
	MsgBox, 49, Password File Found, A password file seems to already exist at: %configdir%\mppwd.txt`n`nIf you want to use this password, press Ok. Otherwise, please delete mppwd.txt and cfg.ini, then re-run first time setup.
	IfMsgBox, Cancel
		ExitApp
	skipEnc = True
}

; Hash this password
if skipEnc = False
{
	hash := bcrypt_sha256(adminpass)
	FileAppend, %hash%, %configdir%\mppwd.txt
}
MsgBox, Password set!

;If user has ticked the box to Install MMC, create the directory if needed and then copy it to the right dir
if InstallMMC = 1
{
	IfNotExist, %mmloc%\MultiMC.exe
	{
		IfNotExist, %mmloc%
		{
			FileCreateDir, %mmloc%
			FileCopyDir, MultiMC, %mmloc%, 1
		}
		else
		{
			MsgBox, 49, MultiMC, The directory %mmloc% already exists.`n`nMultiMC will be installed in this directory and any files will be overwritten. Continue?
			IfMsgBox, Ok
				FileCopyDir, MultiMC, %mmloc%, 1
		}
		
	}
	else
		MsgBox, 48, MultiMC, Found MultiMC.exe already exists inside %mmloc%\MultiMC.exe`n`nInstall will be skipped...
}

;Create other needed folders if they don't exist
IfNotExist, %mploc%\Instances
	FileCreateDir, %mploc%\Instances
	
IfNotExist, %mploc%\Instances\ModMan
	FileCopyDir, ModMan, %mploc%\Instances\ModMan, 1
else
	MsgBox, Mod Playground instance already found at: %mploc%\Instances\ModMan, instance will not be copied!`n`nPlease remove this existing instance (and re-run first time setup) if you would like Mod Playground install a fresh one.
	
IfNotExist, %mploc%\Maps
	FileCreateDir, %mploc%\Maps

;Only check the saves location exists if we're actually planning on using it
savesdirenabled := SavesEnabled + BackupsEnabled + StatsEnabled
if savesdirenabled > 0
{
	IfNotExist, %saveloc%
		FileCreateDir, %saveloc%
}	

;Only check the registers location exists if we're actually planning on using it
if RegistersEnabled = 1
{
	IfNotExist, %regloc%
		FileCreateDir, %regloc%
}

;Create the 'CustomMaps.txt' file if it doesn't exist
IfNotExist, %mploc%\Maps\CustomMaps.txt
{
	FileAppend,
	(
	#	Enter maps in the format: <name>, Survival/Creative/Adventure/Dropper/Parkour/Minigames, <img.filetype>, <minecraftversion>, <num of players>, <description>
#	Name must match up with the same folder name inside Maps\<name>. Img.filetype must also match up with an image inside Images\<img.filetype>. If the map is NOT for 1.12, a separate instance must exist inside Instances\<instance> with the name as the version - e.g. Instances\1.7.10
#	For example: Herobrine's Mansion, Adventure, mansion.jpg, 1.11.2, 2 - 4, Herobrine's Mansion is a large adventure map filled with bosses, quests, weapons and armour. It's a fantastic map created by Hypixel which has it's own story that you follow as a team. Spooky and quite difficult but great fun with friends, can you take down Herobrine? Can be done 1 player, but tricky!

	), %mploc%\Maps\CustomMaps.txt
}

IfNotExist, %mploc%\Mods
	FileCreateDir, %mploc%\Mods

;Create the 'CustomMods.txt' file if it doesn't exist
IfNotExist, %mploc%\Mods\CustomMods.txt
{
	FileAppend, 
	(
	#	Enter mods in the format: <name>, tech/magic/creative/other, <img.filetype>, <youtubeurl>, <description>
#	Name must match up with the same folder name inside Mods\<name>. Img.filetype must also match up with an image inside Images\<img.filetype>. PLEASE CHECK THAT ANY CUSTOM MODS YOU ADD ACTUALLY WORK WITH MINECRAFT VERSION 1.12.2!!
#	For example: Applied Energistics, tech, applied.png, https://www.youtube.com/watch?v=testvideocode, Applied Energistics is an awesome tech mod all about storage and autocrafting. It allows you to store massive amount of items on 'disks' in a digital form, you can then create your own 'network' of machines and autocrafters to automate nearly anything in your base. Sometimes tricky but very rewarding!

	), %mploc%\Mods\CustomMods.txt
}

;Now we need to download all the mods, this is up to the user if they want to run it or not now.
ftdownload = False	
MsgBox, 3, Download Mods?, Would you like to download/update all mods now? Any mods that are already downloaded and at the latest version will be ignored.`n`nThis process will take a few minutes depending on your Internet connection and any custom added mods, it can be done later via the '!' button on the main GUI if desired.`n`nContinue?
IfMsgBox, Yes
	ftdownload = True
IfMsgBox, Cancel
	ExitApp

;If they do, create all the directories and the needed web shortcut files in each one (for the mod downloader function to use in a minute)
;For every mod, check the folder exists along with the shortcuts. These shortcuts are needed for the mod downloader to download them if necessary
Loop, Parse, modsAll, `,,
{
	IfNotExist, %mploc%\Mods\%A_LoopField%
	{
		;Create Directory
		FileCreateDir, %mploc%\Mods\%A_LoopField%
		
		;Create Shortcuts
		if A_LoopField = AbyssalCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/abyssalcraft, %mploc%\Mods\%A_LoopField%\abyssalcraft.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/abyssalcraft-integration, %mploc%\Mods\%A_LoopField%\abyssalcraft-integration.url, InternetShortcut, URL
		}
		else if A_LoopField = Actually Additions
		{
			IniWrite, https://minecraft.curseforge.com/projects/actually-additions, %mploc%\Mods\%A_LoopField%\actually-additions.url, InternetShortcut, URL
		}
		else if A_LoopField = Advanced Generators
		{
			IniWrite, https://minecraft.curseforge.com/projects/advanced-generators, %mploc%\Mods\%A_LoopField%\advanced-generators.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/bdlib, %mploc%\Mods\%A_LoopField%\bdlib.url, InternetShortcut, URL
		}
		else if A_LoopField = Aether 2
		{
			IniWrite, https://minecraft.curseforge.com/projects/the-aether-ii, %mploc%\Mods\%A_LoopField%\the-aether-ii.url, InternetShortcut, URL
		}
		else if A_LoopField = Animania
		{
			IniWrite, https://minecraft.curseforge.com/projects/animania, %mploc%\Mods\%A_LoopField%\animania.url, InternetShortcut, URL
			IniWrite, https://www.curseforge.com/minecraft/mc-mods/craftstudio-api, %mploc%\Mods\%A_LoopField%\craftstudio-api.url, InternetShortcut, URL
		}
		else if A_LoopField = Applied Energistics
		{
			IniWrite, https://minecraft.curseforge.com/projects/applied-energistics-2, %mploc%\Mods\%A_LoopField%\applied-energistics-2.url, InternetShortcut, URL
		}
		else if A_LoopField = Astral Sorcery
		{
			IniWrite, https://minecraft.curseforge.com/projects/astral-sorcery, %mploc%\Mods\%A_LoopField%\astral-sorcery.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/baubles, %mploc%\Mods\%A_LoopField%\baubles.url, InternetShortcut, URL
		}
		else if A_LoopField = Better Builders Wands
		{
			IniWrite, https://minecraft.curseforge.com/projects/better-builders-wands, %mploc%\Mods\%A_LoopField%\better-builders-wands.url, InternetShortcut, URL
		}
		else if A_LoopField = Betweenlands
		{
			IniWrite, https://minecraft.curseforge.com/projects/angry-pixel-the-betweenlands-mod, %mploc%\Mods\%A_LoopField%\angry-pixel-the-betweenlands-mod.url, InternetShortcut, URL
		}
		else if A_LoopField = BiblioCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/bibliocraft, %mploc%\Mods\%A_LoopField%\bibliocraft.url, InternetShortcut, URL
		}
		else if A_LoopField = Biomes O' Plenty
		{
			IniWrite, https://minecraft.curseforge.com/projects/biomes-o-plenty, %mploc%\Mods\%A_LoopField%\biomes-o-plenty.url, InternetShortcut, URL
		}
		else if A_LoopField = Blockcraftery
		{
			IniWrite, https://minecraft.curseforge.com/projects/blockcraftery, %mploc%\Mods\%A_LoopField%\blockcraftery.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/mysticallib, %mploc%\Mods\%A_LoopField%\mysticallib.url, InternetShortcut, URL
		}
		else if A_LoopField = Blood Magic
		{
			IniWrite, https://minecraft.curseforge.com/projects/blood-magic, %mploc%\Mods\%A_LoopField%\blood-magic.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/guide-api, %mploc%\Mods\%A_LoopField%\guide-api.url, InternetShortcut, URL
		}
		else if A_LoopField = Bonsai Trees
		{
			IniWrite, https://minecraft.curseforge.com/projects/bonsai-trees, %mploc%\Mods\%A_LoopField%\bonsai-trees.url, InternetShortcut, URL
		}
		else if A_LoopField = Botania
		{
			IniWrite, https://minecraft.curseforge.com/projects/botania, %mploc%\Mods\%A_LoopField%\botania.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/baubles, %mploc%\Mods\%A_LoopField%\baubles.url, InternetShortcut, URL
		}
		else if A_LoopField = BuildCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/buildcraft, %mploc%\Mods\%A_LoopField%\buildcraft.url, InternetShortcut, URL
		}
		else if A_LoopField = Chance Cubes
		{
			IniWrite, https://minecraft.curseforge.com/projects/chance-cubes, %mploc%\Mods\%A_LoopField%\chance-cubes.url, InternetShortcut, URL
		}
		else if A_LoopField = Chisel 2
		{
			IniWrite, https://minecraft.curseforge.com/projects/chisel, %mploc%\Mods\%A_LoopField%\chisel.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/ctm, %mploc%\Mods\%A_LoopField%\ctm.url, InternetShortcut, URL
		}
		else if A_LoopField = Chisels and Bits
		{
			IniWrite, https://minecraft.curseforge.com/projects/chisels-bits, %mploc%\Mods\%A_LoopField%\chisels-bits.url, InternetShortcut, URL
		}
		else if A_LoopField = Chococraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/chococraft-3, %mploc%\Mods\%A_LoopField%\chococraft-3.url, InternetShortcut, URL
		}
		else if A_LoopField = Colossal Chests
		{
			IniWrite, https://minecraft.curseforge.com/projects/colossal-chests, %mploc%\Mods\%A_LoopField%\colossal-chests.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/cyclops-core, %mploc%\Mods\%A_LoopField%\cyclops-core.url, InternetShortcut, URL
		}
		else if A_LoopField = Compact Machines
		{
			IniWrite, https://minecraft.curseforge.com/projects/compact-machines, %mploc%\Mods\%A_LoopField%\compact-machines.url, InternetShortcut, URL
		}
		else if A_LoopField = Cooking for Blockheads
		{
			IniWrite, https://minecraft.curseforge.com/projects/cooking-for-blockheads, %mploc%\Mods\%A_LoopField%\cooking-for-blockheads.url, InternetShortcut, URL
		}
		else if A_LoopField = CustomNPCs
		{
			IniWrite, https://minecraft.curseforge.com/projects/custom-npcs, %mploc%\Mods\%A_LoopField%\custom-npcs.url, InternetShortcut, URL
		}
		else if A_LoopField = Cyclic
		{
			IniWrite, https://minecraft.curseforge.com/projects/cyclic, %mploc%\Mods\%A_LoopField%\cyclic.url, InternetShortcut, URL
		}
		else if A_LoopField = Dark Utilities
		{
			IniWrite, https://minecraft.curseforge.com/projects/dark-utilities, %mploc%\Mods\%A_LoopField%\dark-utilities.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/bookshelf, %mploc%\Mods\%A_LoopField%\bookshelf.url, InternetShortcut, URL
		}
		else if A_LoopField = Decocraft 2
		{
			IniWrite, https://minecraft.curseforge.com/projects/decocraft2, %mploc%\Mods\%A_LoopField%\decocraft2.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/ptrlib, %mploc%\Mods\%A_LoopField%\ptrlib.url, InternetShortcut, URL
		}
		else if A_LoopField = Dimensional Doors
		{
			IniWrite, https://minecraft.curseforge.com/projects/dimensionaldoors, %mploc%\Mods\%A_LoopField%\dimensionaldoors.url, InternetShortcut, URL
		}
		else if A_LoopField = Earthworks
		{
			IniWrite, https://minecraft.curseforge.com/projects/earthworks, %mploc%\Mods\%A_LoopField%\earthworks.url, InternetShortcut, URL
		}
		else if A_LoopField = Electroblobs Wizardry
		{
			IniWrite, https://minecraft.curseforge.com/projects/electroblobs-wizardry, %mploc%\Mods\%A_LoopField%\electroblobs-wizardry.url, InternetShortcut, URL
		}
		else if A_LoopField = Ender Storage
		{
			IniWrite, https://minecraft.curseforge.com/projects/ender-storage-1-8, %mploc%\Mods\%A_LoopField%\ender-storage-1-8.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/codechicken-lib-1-8, %mploc%\Mods\%A_LoopField%\codechicken-lib-1-8.url, InternetShortcut, URL
		}
		else if A_LoopField = EnderIO
		{
			IniWrite, https://minecraft.curseforge.com/projects/ender-io, %mploc%\Mods\%A_LoopField%\ender-io.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/endercore, %mploc%\Mods\%A_LoopField%\endercore.url, InternetShortcut, URL
		}
		else if A_LoopField = Environmental Tech
		{
			IniWrite, https://minecraft.curseforge.com/projects/environmental-tech, %mploc%\Mods\%A_LoopField%\environmental-tech.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/valkyrielib, %mploc%\Mods\%A_LoopField%\valkyrielib.url, InternetShortcut, URL
		}
		else if A_LoopField = Ex Nihilo
		{
			IniWrite, https://minecraft.curseforge.com/projects/ex-nihilo-creatio, %mploc%\Mods\%A_LoopField%\ex-nihilo-creatio.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/shadowfacts-forgelin, %mploc%\Mods\%A_LoopField%\shadowfacts-forgelin.url, InternetShortcut, URL
		}
		else if A_LoopField = Exotic Birds
		{
			IniWrite, https://minecraft.curseforge.com/projects/exotic-birds, %mploc%\Mods\%A_LoopField%\exotic-birds.url, InternetShortcut, URL
		}
		else if A_LoopField = Extra Utilities 2
		{
			IniWrite, https://minecraft.curseforge.com/projects/extra-utilities, %mploc%\Mods\%A_LoopField%\extra-utilities.url, InternetShortcut, URL
		}
		else if A_LoopField = Extreme Reactors
		{
			IniWrite, https://minecraft.curseforge.com/projects/extreme-reactors, %mploc%\Mods\%A_LoopField%\extreme-reactors.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/zerocore, %mploc%\Mods\%A_LoopField%\zerocore.url, InternetShortcut, URL
		}
		else if A_LoopField = Fairy Lights
		{
			IniWrite, https://minecraft.curseforge.com/projects/fairy-lights, %mploc%\Mods\%A_LoopField%\fairy-lights.url, InternetShortcut, URL
		}
		else if A_LoopField = Ferdinands Flowers
		{
			IniWrite, https://minecraft.curseforge.com/projects/ferdinands-flowers, %mploc%\Mods\%A_LoopField%\ferdinands-flowers.url, InternetShortcut, URL
		}
		else if A_LoopField = Forestry
		{
			IniWrite, https://minecraft.curseforge.com/projects/forestry, %mploc%\Mods\%A_LoopField%\forestry.url, InternetShortcut, URL
		}
		else if A_LoopField = Hardcore Darkness
		{
			IniWrite, https://minecraft.curseforge.com/projects/hardcore-darkness, %mploc%\Mods\%A_LoopField%\hardcore-darkness.url, InternetShortcut, URL
		}
		else if A_LoopField = HarvestCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/pams-harvestcraft, %mploc%\Mods\%A_LoopField%\pams-harvestcraft.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/just-enough-harvestcraft, %mploc%\Mods\%A_LoopField%\just-enough-harvestcraft.url, InternetShortcut, URL
		}
		else if A_LoopField = Hats
		{
			IniWrite, https://minecraft.curseforge.com/projects/hats, %mploc%\Mods\%A_LoopField%\hats.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/ichunutil, %mploc%\Mods\%A_LoopField%\ichunutil.url, InternetShortcut, URL
		}
		else if A_LoopField = Heroes Expansion
		{
			IniWrite, https://minecraft.curseforge.com/projects/heroesexpansion, %mploc%\Mods\%A_LoopField%\heroesexpansion.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/lucraft-core, %mploc%\Mods\%A_LoopField%\lucraft-core.url, InternetShortcut, URL
		}
		else if A_LoopField = Heroic Armoury
		{
			IniWrite, https://minecraft.curseforge.com/projects/heroic-armory, %mploc%\Mods\%A_LoopField%\heroic-armory.url, InternetShortcut, URL
		}
		else if A_LoopField = Immersive Engineering
		{
			IniWrite, https://minecraft.curseforge.com/projects/immersive-engineering, %mploc%\Mods\%A_LoopField%\immersive-engineering.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/immersive-petroleum, %mploc%\Mods\%A_LoopField%\immersive-petroleum.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/immersive-tech, %mploc%\Mods\%A_LoopField%\immersive-tech.url, InternetShortcut, URL
		}
		else if A_LoopField = IndustrialCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/industrial-craft, %mploc%\Mods\%A_LoopField%\industrial-craft.url, InternetShortcut, URL
		}
		else if A_LoopField = Integrated Dynamics
		{
			IniWrite, https://minecraft.curseforge.com/projects/integrated-dynamics, %mploc%\Mods\%A_LoopField%\integrated-dynamics.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/cyclops-core, %mploc%\Mods\%A_LoopField%\cyclops-core.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/common-capabilities, %mploc%\Mods\%A_LoopField%\common-capabilities.url, InternetShortcut, URL
		}
		else if A_LoopField = Industrial Foregoing
		{
			IniWrite, https://minecraft.curseforge.com/projects/industrial-foregoing, %mploc%\Mods\%A_LoopField%\industrial-foregoing.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/integration-foregoing, %mploc%\Mods\%A_LoopField%\integration-foregoing.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/tesla-core-lib, %mploc%\Mods\%A_LoopField%\tesla-core-lib.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/shadowfacts-forgelin, %mploc%\Mods\%A_LoopField%\shadowfacts-forgelin.url, InternetShortcut, URL
		}
		else if A_LoopField = Inventory Pets
		{
			IniWrite, https://minecraft.curseforge.com/projects/inventory-pets, %mploc%\Mods\%A_LoopField%\inventory-pets.url, InternetShortcut, URL
		}
		else if A_LoopField = Iron Chests
		{
			IniWrite, https://minecraft.curseforge.com/projects/iron-chests, %mploc%\Mods\%A_LoopField%\iron-chests.url, InternetShortcut, URL
		}
		else if A_LoopField = JourneyMap
		{
			IniWrite, https://minecraft.curseforge.com/projects/journeymap, %mploc%\Mods\%A_LoopField%\journeymap.url, InternetShortcut, URL
		}
		else if A_LoopField = JurassiCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/jurassicraft, %mploc%\Mods\%A_LoopField%\jurassicraft.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/llibrary, %mploc%\Mods\%A_LoopField%\llibrary.url, InternetShortcut, URL
		}
		else if A_LoopField = Just a few fish
		{
			IniWrite, https://minecraft.curseforge.com/projects/just-a-few-fish, %mploc%\Mods\%A_LoopField%\just-a-few-fish.url, InternetShortcut, URL
		}
		else if A_LoopField = LAN Server Extended
		{
			IniWrite, https://minecraft.curseforge.com/projects/lanserverextended, %mploc%\Mods\%A_LoopField%\lanserverextended.url, InternetShortcut, URL
		}
		else if A_LoopField = Lost Cities
		{
			IniWrite, https://minecraft.curseforge.com/projects/the-lost-cities, %mploc%\Mods\%A_LoopField%\the-lost-cities.url, InternetShortcut, URL
		}
		else if A_LoopField = Malisis Doors
		{
			IniWrite, https://minecraft.curseforge.com/projects/malisisdoors, %mploc%\Mods\%A_LoopField%\malisisdoors.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/malisiscore, %mploc%\Mods\%A_LoopField%\malisiscore.url, InternetShortcut, URL
		}
		else if A_LoopField = Mekanism
		{
			IniWrite, https://minecraft.curseforge.com/projects/mekanism, %mploc%\Mods\%A_LoopField%\mekanism.url, InternetShortcut, URL
		}
		else if A_LoopField = Millenaire
		{
			IniWrite, https://minecraft.curseforge.com/projects/millenaire, %mploc%\Mods\%A_LoopField%\millenaire.url, InternetShortcut, URL
		}
		else if A_LoopField = Minecraft Comes Alive
		{
			IniWrite, https://minecraft.curseforge.com/projects/minecraft-comes-alive-mca, %mploc%\Mods\%A_LoopField%\minecraft-comes-alive-mca.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/radixcore, %mploc%\Mods\%A_LoopField%\radixcore.url, InternetShortcut, URL
		}
		else if A_LoopField = Minewatch
		{
			IniWrite, https://minecraft.curseforge.com/projects/minewatch, %mploc%\Mods\%A_LoopField%\minewatch.url, InternetShortcut, URL
		}
		else if A_LoopField = Morph
		{
			IniWrite, https://minecraft.curseforge.com/projects/morph, %mploc%\Mods\%A_LoopField%\morph.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/ichunutil, %mploc%\Mods\%A_LoopField%\ichunutil.url, InternetShortcut, URL
		}
		else if A_LoopField = Mr Crayfish's Furniture
		{
			IniWrite, https://minecraft.curseforge.com/projects/mrcrayfish-furniture-mod, %mploc%\Mods\%A_LoopField%\mrcrayfish-furniture-mod.url, InternetShortcut, URL
		}
		else if A_LoopField = Mr Crayfish's Guns
		{
			IniWrite, https://minecraft.curseforge.com/projects/mrcrayfishs-gun-mod, %mploc%\Mods\%A_LoopField%\mrcrayfishs-gun-mod.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/obfuscate, %mploc%\Mods\%A_LoopField%\obfuscate.url, InternetShortcut, URL
		}
		else if A_LoopField = Mr Crayfish's Vehicles
		{
			IniWrite, https://minecraft.curseforge.com/projects/mrcrayfishs-vehicle-mod, %mploc%\Mods\%A_LoopField%\mrcrayfishs-vehicle-mod.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/obfuscate, %mploc%\Mods\%A_LoopField%\obfuscate.url, InternetShortcut, URL
		}
		else if A_LoopField = Mystical Agriculture
		{
			IniWrite, https://minecraft.curseforge.com/projects/mystical-agriculture, %mploc%\Mods\%A_LoopField%\mystical-agriculture.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/cucumber, %mploc%\Mods\%A_LoopField%\cucumber.url, InternetShortcut, URL
		}
		else if A_LoopField = NetherEx
		{
			IniWrite, https://minecraft.curseforge.com/projects/netherex, %mploc%\Mods\%A_LoopField%\netherex.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/libraryex, %mploc%\Mods\%A_LoopField%\libraryex.url, InternetShortcut, URL
		}
		else if A_LoopField = OpenBlocks
		{
			IniWrite, https://minecraft.curseforge.com/projects/openblocks, %mploc%\Mods\%A_LoopField%\openblocks.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/openmodslib, %mploc%\Mods\%A_LoopField%\openmodslib.url, InternetShortcut, URL
		}
		else if A_LoopField = Ore Excavation
		{
			IniWrite, https://minecraft.curseforge.com/projects/ore-excavation, %mploc%\Mods\%A_LoopField%\ore-excavation.url, InternetShortcut, URL
		}
		else if A_LoopField = PneumaticCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/pneumaticcraft-repressurized, %mploc%\Mods\%A_LoopField%\pneumaticcraft-repressurized.url, InternetShortcut, URL
		}
		else if A_LoopField = Pokecube
		{
			IniWrite, https://minecraft.curseforge.com/projects/pokecube-aoi, %mploc%\Mods\%A_LoopField%\pokecube-aoi.url, InternetShortcut, URL
		}
		else if A_LoopField = Portal Gun
		{
			IniWrite, https://minecraft.curseforge.com/projects/portal-gun, %mploc%\Mods\%A_LoopField%\portal-gun.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/ichunutil, %mploc%\Mods\%A_LoopField%\ichunutil.url, InternetShortcut, URL
		}
		else if A_LoopField = Project Red
		{
			IniWrite, https://minecraft.curseforge.com/projects/codechicken-lib-1-8, %mploc%\Mods\%A_LoopField%\codechicken-lib-1-8.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/forge-multipart-cbe, %mploc%\Mods\%A_LoopField%\forge-multipart-cbe.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/mrtjpcore, %mploc%\Mods\%A_LoopField%\mrtjpcore.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/project-red-base, %mploc%\Mods\%A_LoopField%\project-red-base.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/project-red-fabrication, %mploc%\Mods\%A_LoopField%\project-red-fabrication.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/project-red-integration, %mploc%\Mods\%A_LoopField%\project-red-integration.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/project-red-lighting, %mploc%\Mods\%A_LoopField%\project-red-lighting.url, InternetShortcut, URL
		}
		else if A_LoopField = ProjectE
		{
			IniWrite, https://minecraft.curseforge.com/projects/projecte, %mploc%\Mods\%A_LoopField%\projecte.url, InternetShortcut, URL
		}
		else if A_LoopField = Psi
		{
			IniWrite, https://minecraft.curseforge.com/projects/psi, %mploc%\Mods\%A_LoopField%\psi.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/autoreglib, %mploc%\Mods\%A_LoopField%\autoreglib.url, InternetShortcut, URL
		}
		else if A_LoopField = Quark
		{
			IniWrite, https://minecraft.curseforge.com/projects/quark, %mploc%\Mods\%A_LoopField%\quark.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/autoreglib, %mploc%\Mods\%A_LoopField%\autoreglib.url, InternetShortcut, URL
		}
		else if A_LoopField = Recurrent Complex
		{
			IniWrite, https://minecraft.curseforge.com/projects/recurrent-complex, %mploc%\Mods\%A_LoopField%\recurrent-complex.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/ivtoolkit, %mploc%\Mods\%A_LoopField%\ivtoolkit.url, InternetShortcut, URL
		}
		else if A_LoopField = Refined Storage
		{
			IniWrite, https://minecraft.curseforge.com/projects/refined-storage, %mploc%\Mods\%A_LoopField%\refined-storage.url, InternetShortcut, URL
		}
		else if A_LoopField = RFTools
		{
			IniWrite, https://minecraft.curseforge.com/projects/rftools, %mploc%\Mods\%A_LoopField%\rftools.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/rftools-dimensions, %mploc%\Mods\%A_LoopField%\rftools-dimensions.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/mcjtylib, %mploc%\Mods\%A_LoopField%\mcjtylib.url, InternetShortcut, URL
		}
		else if A_LoopField = Roguelike Dungeons
		{
			IniWrite, https://minecraft.curseforge.com/projects/roguelike-dungeons, %mploc%\Mods\%A_LoopField%\roguelike-dungeons.url, InternetShortcut, URL
		}
		else if A_LoopField = Roots 2
		{
			IniWrite, https://minecraft.curseforge.com/projects/roots, %mploc%\Mods\%A_LoopField%\roots.url, InternetShortcut, URL
		}
		else if A_LoopField = Secret Rooms
		{
			IniWrite, https://minecraft.curseforge.com/projects/secretroomsmod, %mploc%\Mods\%A_LoopField%\secretroomsmod.url, InternetShortcut, URL
		}
		else if A_LoopField = SecurityCraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/security-craft, %mploc%\Mods\%A_LoopField%\security-craft.url, InternetShortcut, URL
		}
		else if A_LoopField = Serene Seasons
		{
			IniWrite, https://minecraft.curseforge.com/projects/serene-seasons, %mploc%\Mods\%A_LoopField%\serene-seasons.url, InternetShortcut, URL
		}
		else if A_LoopField = Simple Teleporters
		{
			IniWrite, https://minecraft.curseforge.com/projects/simple-teleporters, %mploc%\Mods\%A_LoopField%\simple-teleporters.url, InternetShortcut, URL
		}
		else if A_LoopField = Simply Jetpacks
		{
			IniWrite, https://minecraft.curseforge.com/projects/simply-jetpacks-2, %mploc%\Mods\%A_LoopField%\simply-jetpacks-2.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/redstone-flux, %mploc%\Mods\%A_LoopField%\redstone-flux.url, InternetShortcut, URL
		}
		else if A_LoopField = Spartan Shields
		{
			IniWrite, https://minecraft.curseforge.com/projects/spartan-shields, %mploc%\Mods\%A_LoopField%\spartan-shields.url, InternetShortcut, URL
		}
		else if A_LoopField = Speedster Heroes
		{
			IniWrite, https://minecraft.curseforge.com/projects/speedster-heroes, %mploc%\Mods\%A_LoopField%\speedster-heroes.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/lucraft-core, %mploc%\Mods\%A_LoopField%\lucraft-core.url, InternetShortcut, URL
		}
		else if A_LoopField = Storage Drawers
		{
			IniWrite, https://minecraft.curseforge.com/projects/storage-drawers, %mploc%\Mods\%A_LoopField%\storage-drawers.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/chameleon, %mploc%\Mods\%A_LoopField%\chameleon.url, InternetShortcut, URL
		}
		else if A_LoopField = Streams
		{
			IniWrite, https://minecraft.curseforge.com/projects/streams, %mploc%\Mods\%A_LoopField%\streams.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/farseek, %mploc%\Mods\%A_LoopField%\farseek.url, InternetShortcut, URL
		}
		else if A_LoopField = Tardis
		{
			IniWrite, https://minecraft.curseforge.com/projects/new-tardis-mod, %mploc%\Mods\%A_LoopField%\new-tardis-mod.url, InternetShortcut, URL
		}
		else if A_LoopField = Terrarium
		{
			IniWrite, https://minecraft.curseforge.com/projects/terrarium, %mploc%\Mods\%A_LoopField%\terrarium.url, InternetShortcut, URL
		}
		else if A_LoopField = Thaumcraft
		{
			IniWrite, https://minecraft.curseforge.com/projects/thaumcraft, %mploc%\Mods\%A_LoopField%\thaumcraft.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/baubles, %mploc%\Mods\%A_LoopField%\baubles.url, InternetShortcut, URL
		}
		else if A_LoopField = The Erebus
		{
			IniWrite, https://minecraft.curseforge.com/projects/the-erebus, %mploc%\Mods\%A_LoopField%\the-erebus.url, InternetShortcut, URL
		}
		else if A_LoopField = Thermal Expansion
		{
			IniWrite, https://minecraft.curseforge.com/projects/codechicken-lib-1-8, %mploc%\Mods\%A_LoopField%\codechicken-lib-1-8.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/cofh-world, %mploc%\Mods\%A_LoopField%\cofh-world.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/cofhcore, %mploc%\Mods\%A_LoopField%\cofhcore.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/redstone-flux, %mploc%\Mods\%A_LoopField%\redstone-flux.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/thermal-foundation, %mploc%\Mods\%A_LoopField%\thermal-foundation.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/thermalexpansion, %mploc%\Mods\%A_LoopField%\thermalexpansion.url, InternetShortcut, URL
		}
		else if A_LoopField = Tinkers Construct
		{
			IniWrite, https://minecraft.curseforge.com/projects/tinkers-construct, %mploc%\Mods\%A_LoopField%\tinkers-construct.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/mantle, %mploc%\Mods\%A_LoopField%\mantle.url, InternetShortcut, URL
		}
		else if A_LoopField = Totemic
		{
			IniWrite, https://minecraft.curseforge.com/projects/totemic, %mploc%\Mods\%A_LoopField%\totemic.url, InternetShortcut, URL
		}
		else if A_LoopField = Twilight Forest
		{
			IniWrite, https://minecraft.curseforge.com/projects/the-twilight-forest, %mploc%\Mods\%A_LoopField%\the-twilight-forest.url, InternetShortcut, URL
		}
		else if A_LoopField = Vampirism
		{
			IniWrite, https://minecraft.curseforge.com/projects/vampirism-become-a-vampire, %mploc%\Mods\%A_LoopField%\vampirism-become-a-vampire.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/vampirism-integrations, %mploc%\Mods\%A_LoopField%\vampirism-integrations.url, InternetShortcut, URL
		}
		else if A_LoopField = Viescraft Airships
		{
			IniWrite, https://minecraft.curseforge.com/projects/viescraft-airships, %mploc%\Mods\%A_LoopField%\viescraft-airships.url, InternetShortcut, URL
		}
		else if A_LoopField = Weeping Angels
		{
			IniWrite, https://minecraft.curseforge.com/projects/weeping-angels-mod, %mploc%\Mods\%A_LoopField%\weeping-angels-mod.url, InternetShortcut, URL
		}
		else if A_LoopField = WorldEdit
		{
			IniWrite, https://minecraft.curseforge.com/projects/worldedit, %mploc%\Mods\%A_LoopField%\worldedit.url, InternetShortcut, URL
		}
		else if A_LoopField = XNet
		{
			IniWrite, https://minecraft.curseforge.com/projects/xnet, %mploc%\Mods\%A_LoopField%\xnet.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/ynot, %mploc%\Mods\%A_LoopField%\ynot.url, InternetShortcut, URL
			IniWrite, https://minecraft.curseforge.com/projects/mcjtylib, %mploc%\Mods\%A_LoopField%\mcjtylib.url, InternetShortcut, URL
		}
		else if A_LoopField = Xtones
		{
			IniWrite, https://minecraft.curseforge.com/projects/xtones, %mploc%\Mods\%A_LoopField%\xtones.url, InternetShortcut, URL
		}
	}
}

;Download and update new mods if needed using the modsUpdate function (fi the user wants to)
if ftdownload = True
	modsUpdate(modfilesloc)

;Create Images dir, overwriting if needed (query the user)
IfNotExist, Images
{
	IfNotExist, %mploc%\Images
	{
		FileCreateDir, %mploc%\Images
		MsgBox, 48, Error!, 'Images' data folder for first time setup seems to be missing! Did you delete it or move it?`n`nAll images will be missing!
	}
	else
		MsgBox, 48, Error!, 'Images' data folder for first time setup seems to be missing! However existing images folder has already been detected at: %mploc%\Images`n`nNew images will NOT be installed
}
else
{
	IfNotExist, %mploc%\Images
	{
		FileCreateDir, %mploc%\Images
		FileCopyDir, Images, %mploc%\Images, 1
	}
	else
	{
		MsgBox, 52, Images Folder, Image data folder already exists in %mploc%\Images`n`nShould Mod Playground overwrite any existing files in this directory?
		IfMsgBox, Yes
			FileCopyDir, Images, %mploc%\Images, 1
		else
			FileCopyDir, Images, %mploc%\Images, 0
	}
}

;Libs dir
IfNotExist, %mploc%\Libs
{
	FileCreateDir, %mploc%\Libs
	FileCreateDir, %mploc%\Libs\libraries
	FileCreateDir, %mploc%\Libs\meta
	FileCreateDir, %mploc%\Libs\versions
}
else
{
	IfNotExist, %mploc%\Libs\libraries
		FileCreateDir, %mploc%\Libs\libraries
		
	IfNotExist, %mploc%\Libs\meta
		FileCreateDir, %mploc%\Libs\meta
		
	IfNotExist, %mploc%\Libs\versions
		FileCreateDir, %mploc%\Libs\versions
}
	
;Set configssaved to be true, so the script knows that the user actually pressed 'Save' and submitted the data
configsaved = True
return

;Run when the '!' button is pressed on the main intro tab. This functions as an 'admin' menu. It requires the administrator password to open it.
Help:

;Ask for admin password
InputBox, datain, Help!, Please enter administrator password to access advanced menu, HIDE, 260, 140
if ErrorLevel
	return

;Hash the input data and compare with the stored hash
datain := bcrypt_sha256(datain)
if datain != %hash%
{
	MsgBox, 16, Error!, Incorrect Password entered!
	return
}

;Create advanced settings GUI, this launches a few different functions as/when certain buttons are pressed (WipeInstance/UpdateMods/ChangePass etc)
Gui, 6:Font,norm s11,Calibri Light
Gui, 6:Add, Text, x160 y70 w430 h80, If Minecraft won't load even with no mods selected, this will redownload a fresh MultiMC instance from the server (or wherever your instances are stored). Requires a restart of Mod Playground.
Gui, 6:Add, Text, x160 y135 w430 h80, Runs the Mod Updater to update all mods on the server. This will take some time, especially with a large number of custom mods. Must be run as admin.
Gui, 6:Add, Text, x160 y205 w430 h80, Change the administrator password. You will be required to enter the current password first. Must be run as admin.
Gui, 6:Add, Edit, x10 y30 w550 h25 +ReadOnly vconfigedit Hwndconfigedit, %configloc%
Gui, 6:Font,norm s12 w700,Calibri Light
Gui, 6:Add, Text, x10 y10 w430 h20, Location of config file:
Gui, 6:Font,norm s14,Calibri Light
Gui, 6:Add, Button, x10 y70 w145 h45 gWipeInstance vWipeInstance, Wipe Instance
Gui, 6:Add, Button, x10 y135 w145 h45 gUpdateMods vUpdateMods, Update Mods
Gui, 6:Add, Button, x10 y200 w145 h45 gChangePass vChangePass, Change Password
Gui, 6:Show, w600 h500, Advanced Settings and Debug Menu
ControlSend,,{Home}, ahk_id %configedit%
return

;Run when the 'Change Password' button is pressed on GUI 6. Changes the administrator password.
ChangePass:

;Ensure they are logged in with an admin account
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
	MsgBox, 17, Not an admin!, You cannot change the administrator password without being an administrator!`n`nReload Mod Playground and run as admin?
	IfMsgBox, Cancel
		return
	try
	{
		if A_IsCompiled
			Run *RunAs "%A_ScriptFullPath%" /restart -cfg "%configloc%"
		else
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%" -cfg "%configloc%"
	}
	return
}

;Ask user to enter the correct current password
InputBox, datain, Confirm?, To change the administrator password`, please either delete the config file (cfg.ini) and the password file (mppwd.txt)`, or enter the current password, HIDE
if ErrorLevel
	return
	
;Hash the input data and compare with the stored hash
datain := bcrypt_sha256(datain)
if datain != %hash%
{
	MsgBox, 16, Bad Password!, Bad password!
	return
}

adminpass =
adminpass2 = test
InputBox, adminpass, Administrator Password, Please create a strong administrator password for Mod Playground of at least 8 characters.`n`nThis is used to update mods and delete the MultiMC instances if needed., HIDE
If ErrorLevel
	return
while ((adminpass != adminpass2) || (adminpass = ""))
{
	;MsgBox, whileloop
	while (StrLen(adminpass) < 8)
	{
		InputBox, adminpass, Administrator Password, Please create a password of at least 8 characters!, HIDE
		If ErrorLevel
			return
	}
	InputBox, adminpass2, Administrator Password, Please enter this password again to confirm., HIDE
	If ErrorLevel
		return
	if adminpass != %adminpass2%
	{
		InputBox, adminpass, Administrator Password, Error`, passwords were not identical`, please try again!`n`nCreate a strong administrator password for Mod Playground of at least 8 characters.`n`nThis is used to update mods and delete the MultiMC instances if needed., HIDE,,240
		If ErrorLevel
			return
	}
}

; Hash and write to file
hash := bcrypt_sha256(adminpass)
FileDelete, %configdir%\mppwd.txt
FileAppend, %hash%, %configdir%\mppwd.txt
MsgBox, New password set!
return

;Run when the 'Wipe Instance' button is pressed on GUI 6. Deletes the locally installed minecraft instance (and then relaunches the script so it can be downloaded again)
WipeInstance:
MsgBox, 1, Confirm?, Confirm wiping local instance? Mod Playground will restart if successful.
IfMsgBox, Cancel
	return
else
{
	FileRemoveDir, %multimcfolderloc%\instances\ModMan, 1
	If ErrorLevel,
		MsgBox, 16, Error!, Error! I couldn't delete the Minecraft instance at %multimcfolderloc%\instances\ModMan. Please see an IT Technician!
	else
		reload
}
return

;Run when the 'Update Mods' button is pressed on GUI 6. Runs the mod updater (after confirming that user is an admin).
UpdateMods:

;Ensure they are logged in with an admin account
full_command_line := DllCall("GetCommandLine", "str")
if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
	MsgBox, 17, Not an admin!, You cannot update any mods without being an administrator!`n`nReload Mod Playground and run as admin?
	IfMsgBox, Cancel
		return
	try
	{
		if A_IsCompiled
			Run *RunAs "%A_ScriptFullPath%" /restart -cfg "%configloc%"
		else
			Run *RunAs "%A_AhkPath%" /restart "%A_ScriptFullPath%" -cfg "%configloc%"
	}
	return
}

;Confirm with user
MsgBox, 1, Confirm?, Confirm updating all mods in: %modfilesloc%
IfMsgBox, Cancel
	return

;Disable certain buttons to prevent the user running it twice at the same time etc. Then launch the mod updater.	
GuiControl, 6:Disable, UpdateMods
GuiControl, 6:Disable, WipeInstance
GuiControl, 1:Disable, Help
modsUpdate(modfilesloc)

;Enable buttons again
GuiControl, 6:Enable, UpdateMods
GuiControl, 6:Enable, WipeInstance
GuiControl, 1:Enable, Help
return

;Function that's run when the user clicks the 'Clear' button. It resets all mods and lists using 'resetvars()'.
Clear:
;Query user if they already have mods selected
if rightbox !=
{
	MsgBox, 1, Loose load order?, You've got mods selected, you will loose them if you clear. Continue?
	IfMsgBox Cancel
		return
}

;If they haven't got anything in the right hand box, don't bother clearing - just a waste of time!
else
	return

;Reset all lists and then return to GUI
resetvars()
return

;Function that's run when the user clicks the 'Random Mods' button. This incorporates a random function which generates 15 random numbers. It then matches those to certain mods in a list (and then picks those out).
RandomMods:
;Query user if they already have mods selected
if rightbox !=
{
	MsgBox, 1, Loose load order?, If you random`, you will loose the mods you have selected. Continue?
	IfMsgBox Cancel
		return
}

;Quick reset the lists, to re-add mods if need be from a previous random run
resetvars()

;Parse through modsAll, count total number of mods. This is stored in 'totalnummods'. So we know the total number of all mods in all lists.
totalnummods = 0
Loop, Parse, modsAll, `,,
	totalnummods++
	
;This loop purely exists to make the random function look cool! It could be disabled or removed without issue.
Loop 50
{
	;If we randomed a dodgy mod, go back and try again from this point (start of loop). This is to stop the script randoming mods that maybe don't work very well!
	retryrandom:
	
	;Have to sleep a little bit otherwise the GUI updates so fast that we can't actually see the effect!
	Sleep 1

	;Clear rightbox each time, otherwise it fills up with garbage
	rightbox :=
	GuiControl, 2:, ModChoiceFinal, |%rightbox%

	;Generate 15 UNIQUE random numbers between 1 and the number of items (NOT MY CODE)
	Loop 15
	{
	  i := A_Index
	  loop
	  {
		Random R, 1, %totalnummods%     ; R = random number
		j := Index_%R%             ; get value from Indexes
		If j is number
		  If j between 1 and % i - 1
			If (R_%j% = R)
			  continue             ; repetition found, try again
		Index_%R% := i             ; store index
		R_%i% := R                 ; store in R_1, R_2...
		break                      ; different number
	  }
	}

	;All the random numbers are now stored in this variable
	allrannumbers := R_1 . "," . R_2 . "," . R_3 . "," . R_4 . "," . R_5 . "," . R_6 . "," . R_7 . "," . R_8 . "," . R_9 . "," . R_10 . "," . R_11 . "," . R_12 . "," . R_13 . "," . R_14 . "," . R_15

	;Now match these numbers to mods via the 'modsAll' list. I.e. First mod in 'modsAll' = 1, second mod = 2. Select the mods that correspond to the numbers in the random variable above. Add them to the GUI.
	currentmodnum = 0
	
	;Loop through 'modsAll'
	Loop, Parse, modsAll, `,,
	{
		currentmod = %A_LoopField%
		addthismod = False
		i := A_Index
		
		;If the modnumber matches one we randomed in 'allrannumbers', mark this mod 'addthismod'
		Loop, Parse, allrannumbers, `,,
		{
			if i = %A_LoopField%
				addthismod = True
		}
		
		;If the mod is marked, add it to the GUI and rightbox UNLESS ITS A BUGGY MOD (THEN RETRY)
		if addthismod = True
		{
			;Never random buggy mods. If we've randomed one, retry the whole randomisation
			if currentmod in %buggyMods%
				goto, retryrandom
			GuiControl, 2:, ModChoiceFinal, %currentmod%
			rightbox := rightbox . currentmod . "|"
		}
	}
}

;Debug output random numbers
;MsgBox, % R_1 . "," . R_2 . "," . R_3 . "," . R_4 . "," . R_5 . "," . R_6 . "," . R_7 . "," . R_8 . "," . R_9 . "," . R_10 . "," . R_11 . "," . R_12 . "," . R_13 . "," . R_14 . "," . R_15

;We now need to remove said mods from the other lists (otherwise we'll end up with duplicates!), loop through all the mods we just randomly chose and remove each one from the other lists
TabModifier =
Loop, Parse, rightbox, |
{
	currentmod = %A_LoopField%
	
	;If it's on the last one and it's blank, just ignore it, (we need a '|' to be the last item or the list doesn't work). This is to prevent a bug.
	if currentmod =
		continue
	
	;For each mod in the rightbox, find out what tab it should be on/what tab it originated from
	if currentmod in %modsTech%
		TabModifier = Tech
	else if currentmod in %modsMagic%
		TabModifier = Magic
	else if currentmod in %modsCreative%
		TabModifier = Creative
	else if currentmod in %modsOther%
		TabModifier = Other
		
	;Search the leftbox variable on the appropriate tab for this mod and remove it
	currentmod := currentmod . "|"
	leftbox%TabModifier% := StrReplace(leftbox%TabModifier%, currentmod)

}

;Update the GUI to all the lists and then return
leftboxfinalTech := leftboxTech
leftboxfinalMagic := leftboxMagic
leftboxfinalCreative := leftboxCreative
leftboxfinalOther := leftboxOther

GuiControl, 1:, ModChoiceTech, |%leftboxfinalTech%
GuiControl, 1:, ModChoiceMagic, |%leftboxfinalMagic% 
GuiControl, 1:, ModChoiceCreative, |%leftboxfinalCreative% 
GuiControl, 1:, ModChoiceOther, |%leftboxfinalOther% 
return

;Simple tiny function to close Gui 4 (the maps information GUI thing) if tab isn't the maps tab. This is run everytime the user changes tabs.
TabChange:
Gui, Submit, NoHide
if CurrentTab != Maps
	Gui, 4:Destroy
return

;Function for when a user clicks '>' to move a mod to the right hand box	
Mover: 
;Reset Variables
selectmore = False
selectedlindex = 1
TabModifier =
TabClass =

;Firstly submit everything on the GUI. Then need to find out what current tab the user is on.
Gui, Submit, NoHide
if CurrentTab = Science and Technology
{
	TabModifier = Tech
	TabClass = 1
}
else if CurrentTab = Magic and Exploration
{
	TabModifier = Magic
	TabClass = 2
}
else if CurrentTab = Creative
{
	TabModifier = Creative
	TabClass = 3
}
else if CurrentTab = Other
{
	TabModifier = Other
	TabClass = 4
}

;If they haven't selected anything, just stop here. I.e. they pressed the button but didn't click a mod... what a plank!!
GuiControlGet, selectedl, 1:, ModChoice%TabModifier%
if selectedl =
	return

;If they selected a buggy mod, warn the user. Give them the option to cancel this mod and back out now.
if selectedl in %buggyMods%
{
	MsgBox, 49, Buggy Mod Detected, %selectedl% is known to cause crashes and freezes. You can use it if you want, but if you have any problems try reducing your number of mods or removing this mod entirely. Continue?
	IfMsgBox, Cancel
		return
}
	
;Add the selected item to the right box and to the end of the rightbox variable
GuiControl, 2:, ModChoiceFinal, %selectedl% 
rightbox = %rightbox%%selectedl%|

;Retrieve all items from the current (old) leftside list and count how many there are. We'll need to do slightly different things for different numbers of items.
ControlGet, cc1rows, List, Count, ListBox%TabClass%, Mod Manager
cc1rowscount = 0
Loop, Parse, cc1rows, `n
{
	if selectedl = %A_LoopField%
		selectedlindex = %A_Index%
	cc1rowscount += 1
}

;If there's more than one item, we will need to run the selection code (to automatically select the next item for convenience). Mark this as 'true' for now, we'll come back to it in a second.
;(This is just a function that many people assume about lists, that they automatically select the next item if an item disappears. Sadly, this isn't true here and I had to code it manually.)
if cc1rowscount > 1
	selectmore = True
	;If the item they selected is at the bottom, it's a special case because the selection code will then need to select the previous item (instead of the next one)
	if selectedlindex = %cc1rowscount%
			selectedlindex -= 1

;Search the leftbox variable for this selected item and remove it
selectedl = %selectedl%|
leftbox%TabModifier% := StrReplace(leftbox%TabModifier%, selectedl)

;Update the GUI to the leftbox variable
leftboxfinal := leftbox%TabModifier% 
GuiControl, 1:, ModChoice%TabModifier%, |%leftboxfinal% 

;If we do need to select more items (because there's more than one, run this code). This selects the next item automatically, this is nice for convenience's sake.
if selectmore = True
{
	;Find the new item where the old one was
	ControlGet, cc1rows, List, Count, ListBox%TabClass%, Mod Manager
	Loop, Parse, cc1rows, `n
	{
		if selectedlindex = %A_Index%
			selectl = %A_LoopField%
	}
	;Select that item
	ControlFocus, ListBox%TabClass%, Mod Manager
	ControlSend, ListBox%TabClass%, %selectl%, Mod Manager
}
return

;Function for when a user clicks '<' to move a mod back to the left hand boxes
Movel: 
;Reset Variables
selectmore = False
selectedrindex = 1
TabModifier =

;Submit everything on GUI
Gui, Submit, NoHide

;If they haven't actually selected anything, just stop here. I.e. they pressed the button but didn't click a mod. What a plank...
GuiControlGet, selectedr, 2:, ModChoiceFinal
if selectedr =
	return

;Determine where the mod should return to (which tab). Remember that each mod must go on a specific tab!
if selectedr in %modsTech%
	TabModifier = Tech
else if selectedr in %modsMagic%
	TabModifier = Magic
else if selectedr in %modsCreative%
	TabModifier = Creative
else if selectedr in %modsOther%
	TabModifier = Other

;Add the mod to the appropriate tab and it's appropriate variable
GuiControl, 1:, ModChoice%TabModifier%, %selectedr%
leftboxfinal := leftbox%TabModifier%  
leftbox%TabModifier% = %leftboxfinal%%selectedr%|

;Determine if there's more than one item in the list
ControlGet, cc2rows, List, Count, ListBox1, Selected Mods
cc2rowscount = 0
Loop, Parse, cc2rows, `n
{
	if selectedr = %A_LoopField%
		selectedrindex = %A_Index%
	cc2rowscount += 1
}

;If there is more than one item, we need to auto select the next one for convenience
if cc2rowscount > 1
	selectmore = True
	if selectedrindex = %cc2rowscount%
			selectedrindex -= 1

;Remove the old item from the right box
selectedr = %selectedr%|
rightbox := StrReplace(rightbox, selectedr)
GuiControl, 2:, ModChoiceFinal, |%rightbox% 

;If we need to select more, auto type the next appropriate item
if selectmore = True
{
	;Find the new item in the position where the old one was
	ControlGet, cc2rows, List, Count, ListBox1, Selected Mods
	Loop, Parse, cc2rows, `n
	{
		if selectedrindex = %A_Index%
			selectr = %A_LoopField%
	}
	;Select that item
	ControlFocus, ListBox1, Selected Mods
	ControlSend, ListBox1, %selectr%, Selected Mods
}
return

;Function that runs when a user left-clicks any map on the 'maps' tab. This displays information and a picture of the map, along with a YouTube link.
ItemSelectMaps:
;Submit everything on the GUI and enable the 'Download button'
Gui, Submit, NoHide
GuiControl, Enable, MapDL

;By default, every map is set to work with minecraft 1.12.2, be careful about changing this, you risk breaking a lot of maps!
legacymapver = 1.12.2

;Firstly blank/remove any previous picture
GuiControl, 1:, descpicMaps,

;Find out what map has been selected
GuiControlGet, selecteditem, 1:, MapsList

;Types of map are: Survival (Green), Creative (Blue), Adventure (Red), Dropper (Orange), Parkour (Purple), Minigames (Pink)
maptype =

;If they press download but don't select a map, do nothing
if selecteditem =
	return
	
;For each map, show the correct picture, description and information.
else
{
	;Parse through the data, adding mods as we go
	Loop, Parse, custommapslist, `n
	{
		;If first character in a line is a hash (or nothing), ignore that whole line (it's a comment!)
		if(SubStr(A_LoopField, 1, 1)) = "#"
			continue
		
		if(SubStr(A_LoopField, 1, 1)) = "`r"
			continue
			
		if(SubStr(A_LoopField, 1, 1)) = "`n"
			continue
			
		if(SubStr(A_LoopField, 1, 1)) = ""
			continue
			
		if(SubStr(A_LoopField, 1, 1)) =
			continue
		
		;Split the line into 5 parts - the name, category, imgsrc, url and description
		custommodarray := StrSplit(A_LoopField, ",", " `t", 6)
		customname := custommodarray[1]
		
		;If the name matches something in CustomMods.txt, grab all the information from the text file and put it on the GUI
		if selecteditem = %customname%
		{
			maptype := custommodarray[2]
			customimg := custommodarray[3]
			legacymapver := custommodarray[4]
			mapplayers := custommodarray[5]
			mapdesc := custommodarray[6]
			
			GuiControl, 1:, descpicMaps, *w190 *h-1 %modpicsloc%\%customimg%
			legacymap = false
			if legacymapver != 1.12.2
				legacymap = true
		}
	}
}

;Create Map Information GUI (GUI 4)
Gui, 4:Destroy
WinGetPos, modmanx, modmany,,,Mod Manager
modmanx -= 290
Gui, 4:Font,norm s18 bold,Calibri Light
Gui, 4:Add,Text, vmapnametext x10 y5 w260 h40 +center, %selecteditem%
Gui, 4:Font,norm s14,Calibri Light

;Different categories are different colours
Gui, 4:Add,Text,x10 y40 w80 h50, Map Type:
if maptype = Survival
	Gui, 4:Add,Text,x95 y40 w220 h50 cGreen, Survival
else if maptype = Creative
	Gui, 4:Add,Text,x95 y40 w220 h50 cBlue, Creative
else if maptype = Adventure
	Gui, 4:Add,Text,x95 y40 w220 h50 cRed, Adventure
else if maptype = Dropper
	Gui, 4:Add,Text,x95 y40 w220 h50 cFF8000, Dropper
else if maptype = Parkour
	Gui, 4:Add,Text,x95 y40 w220 h50 cPurple, Parkour
else if maptype = Minigames
	Gui, 4:Add,Text,x95 y40 w220 h50 cFF33FF, Minigames
Gui, 4:Add,Text,x10 y65 w100 h50, Players: %mapplayers%

;If they're using a map for an older version of Minecraft, highlight this in RED. These maps cannot have mods or backups as it wouldn't work!
Gui, 4:Add,Text,x10 y90 w140 h50, Minecraft Version:
if legacymap = true
	Gui, 4:Add,Text,x155 y90 w100 h50 cRed, %legacymapver%
else
	Gui, 4:Add,Text,x155 y90 w100 h50, 1.12.2
Gui, 4:Add, Edit, ReadOnly x10 y120 w260 h335 vmapdescbox
Gui, 4:Show, x%modmanx% y%modmany% w280 h470,Information 
GuiControl, 4:, mapdescbox, %mapdesc%
return

;This function runs when the user presses the 'Download' button to download a map to their saves
MapDL:
;Submit everything on GUI and find out what map was selected
Gui, Submit, NoHide
GuiControlGet, selecteditem, 1:, MapsList

;Is it a legacy map? (i.e. Meant to work for an older version of Minecraft). This is run if 'legacymap' is set to TRUE via the function above, it should be set for all minecraft versions that are NOT 1.12.2.
if legacymap = true
{
	neededmcver := legacymapver
	
	;Warn the user, stop if they press cancel
	MsgBox, 49, Legacy Version Required!, This map needs an older version of Minecraft than what you're using. You need Minecraft Version %neededmcver%. Would you like to launch this version now?`n`nYOU CANNOT HAVE ANY MODS OR BACKUPS IN OLD VERSIONS!
	IfMsgBox, Cancel
		return
	

	
	;If they're happy with it, disable buttons to prevent the user launching minecraft while it's still trying to download their map. Yep, this was a problem....
	GuiControl, Disable, MapDL
	GuiControl, 2:, Launch, Launching Minecraft...
	GuiControl, 2:Disable, Launch
	
	;Remove old instance folder if it exists, this is to remove any old rubbish left over by the last user that ran that instance. (i.e. download a nice new fresh one each time)
	IfExist, %multimcfolderloc%\instances\%neededmcver%
		FileRemoveDir, %multimcfolderloc%\instances\%neededmcver%, 1
		
	;Copy in the instance, and then copy in the map inside this instance
	FileCopyDir, %mclocation%\%neededmcver%, %multimcfolderloc%\instances\%neededmcver%
	
	;If the instance hasn't previously been initialised/run by the user, the folder we need to copy the world into won't actually exist yet. So make it.
	IfNotExist, %multimcfolderloc%\instances\%neededmcver%\.minecraft\saves
	{
		IfNotExist, %multimcfolderloc%\instances\%neededmcver%\minecraft\saves
			FileCreateDir, %multimcfolderloc%\instances\%neededmcver%\.minecraft\saves
	}
	
	IfExist, %multimcfolderloc%\instances\%neededmcver%\.minecraft
		FileCopyDir, %mapsloc%\%selecteditem%, %multimcfolderloc%\instances\%neededmcver%\.minecraft\saves\%selecteditem%
	
	IfExist, %multimcfolderloc%\instances\%neededmcver%\minecraft
		FileCopyDir, %mapsloc%\%selecteditem%, %multimcfolderloc%\instances\%neededmcver%\minecraft\saves\%selecteditem%
	
	;Resource packs in 1.7.10 worked a bit differently, make sure we handle that!
	if neededmcver = 1.7.10
	{	
		;To make resource packs work, we need this inside the options.txt file
		defaultoptionsfile =
		(
		resourcePacks:["resources.zip"]
		)
	
		;Some maps come with a 'resources.zip' pack inside the map folder. If they do, and it's minecraft version 1.7.10, copy that zip folder to the separate 'resourcepacks' folder.
		IfExist, %multimcfolderloc%\instances\%neededmcver%\.minecraft\saves\%selecteditem%\resources.zip
		{
			FileCreateDir, %multimcfolderloc%\instances\%neededmcver%\.minecraft\resourcepacks
			FileCopy, %multimcfolderloc%\instances\%neededmcver%\.minecraft\saves\%selecteditem%\resources.zip, %multimcfolderloc%\instances\%neededmcver%\.minecraft\resourcepacks
			
			;To use this resource pack, we need to update the options.txt. But lets only update it if it doesn't already exist (allows user to add their own options.txt if they want to)
			IfNotExist, %multimcfolderloc%\instances\%neededmcver%\.minecraft\options.txt
				FileAppend, %defaultoptionsfile%, %multimcfolderloc%\instances\%neededmcver%\.minecraft\options.txt
		}
		IfExist, %multimcfolderloc%\instances\%neededmcver%\minecraft\saves\%selecteditem%\resources.zip
		{
			FileCreateDir, %multimcfolderloc%\instances\%neededmcver%\minecraft\resourcepacks
			FileCopy, %multimcfolderloc%\instances\%neededmcver%\minecraft\saves\%selecteditem%\resources.zip, %multimcfolderloc%\instances\%neededmcver%\minecraft\resourcepacks
			
			;To use this resource pack, we need to update the options.txt. But lets only update it if it doesn't already exist (allows user to add their own options.txt if they want to)
			IfNotExist, %multimcfolderloc%\instances\%neededmcver%\minecraft\options.txt
				FileAppend, %defaultoptionsfile%, %multimcfolderloc%\instances\%neededmcver%\minecraft\options.txt
		}
	}
	
	;Run the game... and then exit the script WITHOUT running backups or mods. Mods and Backups will NOT work properly here as it's a completely different minecraft version. (Could work on this in future but might be impossible to fix).
	rungame(neededmcver, neededmcver, multimcfolderloc, offlineemail, OfflineMode)
	ExitApp
}

;If it's NOT a legacy map, then it works with the latest version of minecraft and should be fine for mods/backups etc
else
{
	if BackupsEnabled = 1
	{
		;Count how many worlds the user has currently, (if we're using the backup manager). By default, limited to 5 each. No limit if they're not using the manager.
		countserversaves = 0
		Loop, Files, %savefilesloc%\%A_UserName%\*.*, D
			countserversaves++

		;If they have 5 or more, warn them and stop here
		if countserversaves >= 5
		{
			MsgBox, 16, Too many worlds!, Error, you've got too many worlds! Either remove some until you have 5 or less, or use the green download button to save them in your documents.
			return
		}
	}
	
	;Otherwise, keep asking them what they want to save the world as until script is happy! Check it doesn't already exist and they've actually typed something in etc..
	Loop {
		mapname =
		InputBox, mapname, Name your world!, You are currently downloading '%selecteditem%' to your saves. What would you like to call the world?,, 350, 160,,,,, %selecteditem%
		If ErrorLevel
			return
			
		if mapname =
			return
		
		if BackupsEnabled = 1
		{
			IfExist, %savefilesloc%\%A_UserName%\%mapname%
				MsgBox, 16, World already exists!, Error, you've already got a save called %mapname%! Please delete this one or use a different name!
			else
				break
		}
		else
		{
			IfExist, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\saves\%mapname%
				MsgBox, 16, World already exists!, Error, you've already got a save called %mapname%! Please delete this one or use a different name!
			else
				break
		}
	}

	;Disable the various launch buttons to prevent multiple downloads at the same time or them launching minecraft while it's still downloading!
	GuiControl, Disable, MapDL
	GuiControl, 2:, Launch, Downloading Map...
	GuiControl, 2:Disable, Launch

	;Now copy in the save to the local machine (and the users saves' folder if we're using backups)
	FileCopyDir, %mapsloc%\%selecteditem%, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\saves\%mapname%

	;Also copy to the server and then run a refresh for the backup GUI (if the backups are enabled)
	if BackupsEnabled = 1
	{
		FileCopyDir, %mapsloc%\%selecteditem%, %savefilesloc%\%A_UserName%\%mapname%
		addBackupWorlds(savefilesloc, version, 0, multimcfolderloc, 1, 0, minecraftdirtype)
	}
	else
		addBackupWorlds(savefilesloc, version, 0, multimcfolderloc, 0, 0, minecraftdirtype)

	;Let the user know the task has done
	MsgBox, 0, Map Download Successful!, Successfully downloaded %selecteditem%, copied to save folder as %mapname%.

	;Enable the buttons again. User can now download more maps or launch minecraft
	GuiControl, Enable, MapDL
	GuiControl, 2:, Launch, Launch Minecraft!
	GuiControl, 2:Enable, Launch
}
return

;This function runs when the red 'X' delete button is pressed, it deletes a world that the user selected (after confirming with them)
DeleteSave:
;Submit everything on GUI and find out what map was selected
Gui, Submit, NoHide
GuiControlGet, selecteditem, 1:, MapSavesList

if selecteditem =
{
	MsgBox, 16, Select a map!, Please select one of your saves to delete!
	return
}

;Confirm with the user
InputBox, confirm, Are you sure?, Delete the world '%selecteditem%' from your saves?`n`nPlease type 'okay' to confirm!,,,160

;If user is happy, disable all buttons temporarily and then remove the world directory from their saves
if confirm = okay
{
	GuiControl, Disable, DeleteSave
	GuiControl, Disable, DownloadMap
	GuiControl, Disable, UploadMap
	GuiControl, Disable, MapDL
	GuiControl, 2:, Launch, Deleting Map...
	GuiControl, 2:Disable, Launch
	
	if BackupsEnabled = 1
		FileRemoveDir, %savefilesloc%\%A_UserName%\%selecteditem%, 1
	else
		FileRemoveDir, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\saves\%selecteditem%, 1
		
	GuiControl, Enable, DeleteSave
	GuiControl, Enable, DownloadMap
	GuiControl, Enable, UploadMap
	GuiControl, Enable, MapDL
	GuiControl, 2:, Launch, Launch Minecraft!
	GuiControl, 2:Enable, Launch
	MsgBox, The world '%selecteditem%' has been removed from your saves.
}

;If user is not happy, just return
else
	return
	
;Run a refresh of backup GUI
addBackupWorlds(savefilesloc, version, 0, multimcfolderloc, BackupsEnabled, 0, minecraftdirtype)
return

;This function is run when the user presses the green 'down arrow' to download a map to their documents. Rarely used but exists in-case.
DownloadMap:
;Submit everything on GUI and find out what map was selected
Gui, Submit, NoHide
GuiControlGet, selecteditem, 1:, MapSavesList

if selecteditem =
{
	MsgBox, 16, Select a map!, Please select one of your saves to download!
	return
}

;Query and confirm with the user
MsgBox, 1, Download Map, This button allows you to download one of your saves to your documents. You could then put it on your OneDrive to take it home with you.`n`nYou will need space in your documents! Download '%selecteditem%'?
IfMsgBox Cancel
	return

;If ok, ask the user where they want to save the world. Return if they press cancel or type nothing in
mapdldir =
FileSelectFolder, mapdldir, H:\, 3, Choose a folder to save your world
if mapdldir =
	return

;Don't overwrite, ask the user if unsure
IfExist, %mapdldir%\%selecteditem%
{
	MsgBox, 16, Error!, Error`, a world already exists in %mapdldir% with the same name! Maybe delete or rename that one first?
	return
}

;Now disable the buttons temporarily and then (try to) download the world
GuiControl, Disable, DeleteSave
GuiControl, Disable, DownloadMap
GuiControl, Disable, UploadMap
GuiControl, Disable, MapDL

;Download from the server if backups are enabled, or the local machine if not
if BackupsEnabled = 1
	FileCopyDir, %savefilesloc%\%A_UserName%\%selecteditem%, %mapdldir%\%selecteditem%
else
	FileCopyDir, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\saves\%selecteditem%, %mapdldir%\%selecteditem%

;Enable all buttons once done (or not)
If ErrorLevel
{
	GuiControl, Enable, DeleteSave
	GuiControl, Enable, DownloadMap
	GuiControl, Enable, UploadMap
	GuiControl, Enable, MapDL
	MsgBox, 16, Error!, Error downloading %selecteditem%! Maybe you don't have enough space or maybe Mod Playground doesn't have permission?
	return
}
else
{
	GuiControl, Enable, DeleteSave
	GuiControl, Enable, DownloadMap
	GuiControl, Enable, UploadMap
	GuiControl, Enable, MapDL
	MsgBox, 0, Success!, Successfully downloaded '%selecteditem%' to %mapdldir%
}
return

;This functions runs when the user presses the blue 'upload' button to upload a world to the Server (from their documents). Rarely used but why not...!
UploadMap:
Gui, Submit, NoHide

;Query and confirm with the user
MsgBox, 1, Upload Map, This button allows you to upload a save/map from your computer, to your saves. Please extract the save first, it must also contain a 'level.dat' file.`n`nContinue?
IfMsgBox Cancel
	return
	
if BackupsEnabled = 1
{
	;Count how many worlds the user has currently (if the backup manager is enabled)
	countserversaves = 0
	Loop, Files, %savefilesloc%\%A_UserName%\*.*, D
		countserversaves++

	;If they have 5 or more, stop them here
	if countserversaves >= 5
	{
		MsgBox, 16, Too many worlds!, Error, you've got too many worlds! Try removing some until you've got less than 5!
		return
	}
}

;Ask the user for a folder
FileSelectFolder, mapupdir, H:\, 0, Choose a world to upload

;Check that the level.dat exists, minecraft worlds will not work at all if the level.dat doesn't exist
IfNotExist, %mapupdir%\level.dat
{
	MsgBox, 16, Error!, Error uploading '%selecteditem%'! This looks like a bad world folder as no 'level.dat' file was found, are you sure you selected the right folder? Or maybe it's corrupted?
	return
}

;Ask for save name
mapupnamepos := InStr(mapupdir, "\",,0)
mapupnamepos += 1
mapupname := SubStr(mapupdir, mapupnamepos)
InputBox, mapupnamedone, World Name, What would you like to call the world? It must be different to your other worlds!,,,,,,,,%mapupname%
if ErrorLevel
	return
	
if mapupnamedone =
{
	MsgBox, 16, Error!, Cannot name world a blank name!
	return
}

;If backups are enabled, we are uploading to the SERVER. If backups are disabled, we are 'uploading' to the LOCAL MACHINE.
if BackupsEnabled = 1
	serverorlocaldir = %savefilesloc%\%A_UserName%
else
	serverorlocaldir = %multimcfolderloc%\instances\%version%\%minecraftdirtype%\saves

;Check that name doesn't exist already
IfExist, %serverorlocaldir%\%mapupnamedone%
{
	MsgBox, 16, Error!, Error, you've already got a world called '%mapupnamedone%' as one of your saves! Please call it something different!
	return
}

;If all happy, copy the folder
FileCopyDir, %mapupdir%, %serverorlocaldir%\%mapupnamedone%
If ErrorLevel
{
	MsgBox, 16, Error!, Error uploading %mapupdir% to %serverorlocaldir%\%mapupnamedone%!
	return
}

;Copy the new world to the local machine as well as the users saves. Then let the user know. DON'T SHOW THE PROGRESS BAR! :)
addBackupWorlds(savefilesloc, version, 1, multimcfolderloc, backupsEnabled, 1, minecraftdirtype)
MsgBox, 0, Success!, Successfully uploaded '%mapupdir%' to your saves under the name '%mapupnamedone%'
return

;Function for when a user clicks on any mod in the left hand boxes. ADD NEW MODS BELOW! (Copy the style and just fill in the blanks! Mods will be blank until you do this!)
ItemSelectL: 
Gui, Submit, NoHide

;Firstly we need to determine which tab the user is on, then we know where to add appropriate pictures/text etc
TabModifier =
if CurrentTab = Science and Technology
	TabModifier = Tech
else if CurrentTab = Magic and Exploration
	TabModifier = Magic
else if CurrentTab = Creative
	TabModifier = Creative
else if CurrentTab = Other
	TabModifier = Other

;Firstly blank/remove any previous pictures
GuiControl, 1:, desc%TabModifier%,
GuiControl, 1:, descpic%TabModifier%,

;Find out what item has been selected
GuiControlGet, selecteditem, 1:, ModChoice%TabModifier%

;#addmods3 - Add an entry for the mod under here, you can copy the entire 'else if...' clause, then just change the description/picture file/youtube link. Note that different mods have a different 'videotexttech/videotextmagic' etc, depending on tab
;Show different pictures and information depending on what mod has been selected. Each mod has a description, picture and a youtube link. Note that the correct tab needs to be used 'Videotextmagic'/'Videolinkmagic' if it's a mod on the magic tab e.g.
if selecteditem = AbyssalCraft
{
	GuiControl, 1:, desc%TabModifier%, AbyssalCraft is a large exploration focused magic mod. Craft a Necronomicon and explore various demonic dimensions, perform evil rituals and fight tonnes of new scary looking mobs. This mod adds new tools, armour, weapons, food, ores, machines and even explosives. How deep can you go?
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\abyssal.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=PrzQ53LsDt8">youtube.com/watch?v=PrzQ53LsDt8</a>
}
else if selecteditem = Actually Additions
{
	GuiControl, 1:, desc%TabModifier%, Actually Additions (or 'AA') is a fairly new, powerful machine and tech mod. It adds in lasers, item and liquid placing, ore doubling machines, new tools such as drills and AIO tools, magnets, new food and an awesome oily way of generating power. This mod is a must have if you're creating a tech pack and has a lot of things to make your life easier!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\actually.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=vjX_7509_x4">youtube.com/watch?v=vjX_7509_x4</a>
}
else if selecteditem = Advanced Generators
{
	GuiControl, 1:, desc%TabModifier%, Advanced Generators is a fairly simple tech mod that adds in a variety of multiblock power generators such as the gas turbine generator, the steam turbine generator and the syngas producer. It also comes with lots of upgrades, power storage and sensors. A neat little tech mod!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\advgen.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=XcBIvnzoUnI">youtube.com/watch?v=XcBIvnzoUnI</a>
}
else if selecteditem = Aether 2
{
	GuiControl, 1:, desc%TabModifier%, Aether 2 is a massive minecraft dimension expansion similar to the Twilight Forest. What started out as a 'heaven' world (opposite the the 'hell' of the nether), has become one of the largest minecraft mods in existence! Make a portal out of glowstone and water and travel to the Aether realm where you'll find tonnes of new mobs, weapons, armour, magical items and bosses to defeat. Awesome with friends!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\aether2.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=E0Ab1nMWZ5Y">youtube.com/watch?v=E0Ab1nMWZ5Y</a>
}
else if selecteditem = Animania
{
	GuiControl, 1:, desc%TabModifier%, Animania is an awesome animal overhaul mod. It does NOT focus on adding loads of new mobs but instead tries to overhaul and improve animals that already exist. Animals such as cows, pigs and chickens now have improved models, textures and behaviours. There are different breeds in different biomes, and animals have a 'happiness' factor. The mod also adds ferrets, hedgehogs, peacocks and hamsters!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\animania.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=7P7_guM0DWY">youtube.com/watch?v=7P7_guM0DWY</a>
}
else if selecteditem = Applied Energistics
{
	GuiControl, 1:, desc%TabModifier%, Applied Energistics is an awesome tech mod all about storage and autocrafting. It allows you to store massive amount of items on 'disks' in a digital form, you can then create your own 'network' of machines and autocrafters to automate nearly anything in your base. Sometimes tricky but very rewarding!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\applied.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=IzstD3eV2FI">youtube.com/watch?v=IzstD3eV2FI</a>
}
else if selecteditem = Astral Sorcery
{
	GuiControl, 1:, desc%TabModifier%, Want to control the power of the starts? Astral Sorcery is a large magical mod all to do with stars and starlight. Use marble to create fancy altars and then attune yourself to a constellation to gain powerful buffs and perks. Astral adds in tonnes of awesome magical items and devices, it's also incredibly stylish...!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\astral.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=nNzujxmVsPo">youtube.com/watch?v=nNzujxmVsPo</a>
}
else if selecteditem = Better Builders Wands
{
	GuiControl, 1:, desc%TabModifier%, A small and simple mod that adds in several different builders wands. These can be used to quickly build things such as houses and walls. There are also different wands with different durabilities - stone/iron/diamond and the unbreakable wand... be careful with that one!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\bbwands.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=BsC_zjmZBus">youtube.com/watch?v=BsC_zjmZBus</a>
}
else if selecteditem = Betweenlands
{
	GuiControl, 1:, desc%TabModifier%, If you enjoy the Twilight Forest`, the Betweenlands will feel familiar. It adds in a huge dark swampy dimension full of new monsters`, bosses`, blocks`, items and tonnes more`, the mod even adds its own awesome music! A large but tricky mod full of fun things to explore and do!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\betweenlands.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=n-BeNshalPY">youtube.com/watch?v=n-BeNshalPY</a>
}
else if selecteditem = BiblioCraft
{
	GuiControl, 1:, desc%TabModifier%, Bibliocraft is a fancy popular mod which adds lots of pretty bookcases, signs, shelves, chairs and desks. It's perfect for spicing up any minecraft home. The mod also allows you to add custom formatting to books and signs for making your own really cool looking novels!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\biblio.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=0VTKVuUdaDs">youtube.com/watch?v=0VTKVuUdaDs</a>
}
else if selecteditem = Biomes O' Plenty
{
	GuiControl, 1:, desc%TabModifier%, BoP is one of the most popular biome mods, it adds in tonnes of new biomes from magical forests to cherry groves to large pine forests. A fantastic, but quite demanding on your PC, exploration based mod that also adds in a bunch of new items and blocks, great for an adventure style pack.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\bop.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=Qnl7MaSCiRg">youtube.com/watch?v=Qnl7MaSCiRg</a>
}
else if selecteditem = Blockcraftery
{
	GuiControl, 1:, desc%TabModifier%, Blockcraftery is an attempt to resurrect 'Carpenters Blocks', it adds in different shapes of 'frames' which you can then put blocks onto. This allows you to get slopes, slants, corners, stairs etc. of nearly any block in minecraft! This is a really helpful mod if you're planning a creative pack.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\blockcraft.jpg
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://youtu.be/SNsIt8bVypg?t=193">youtube.com/watch?v=SNsIt8bVypg</a>
}
else if selecteditem = Blood Magic
{
	GuiControl, 1:, desc%TabModifier%, Blood Magic is a large evil-y magical mod all to do with sacrifice and blood. Use the blood orbs to sacrifice your own health and gain 'Life Points' (LP), this LP can then be spent to create powerful weapons, armour and rituals. Alternatively, build a well of suffering above your friends base and suck out their very lifeforce for your own gain!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\blood.jpeg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=iYVVsE1thsk">youtube.com/watch?v=iYVVsE1thsk</a>
}
else if selecteditem = Bonsai Trees
{
	GuiControl, 1:, desc%TabModifier%, Bonsai Trees is an interesting tech addon mod that allows you to grow trees incredibly quickly in a special 'bonsai' plant pot. These pots can then output to chests and/or piping systems allowing you to set up neat and compact tree farms. Looks and works great in any tech pack!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\bonsai.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=iEOakYAjqfo">youtube.com/watch?v=iEOakYAjqfo</a>
}
else if selecteditem = Botania
{
	GuiControl, 1:, desc%TabModifier%, Botania is a large magic mod all to do with nature. Use plants to generate mana`, store it in mana pools and then use it to create powerful magical items and devices. Botania is one of the biggest magic mods available and it's recommended you either read the 'Botania Lexica' carefully in-game, or you watch a video to get you started.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\botania.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=x_UfV8g9Rlo">youtube.com/watch?v=x_UfV8g9Rlo</a>
}
else if selecteditem = Buildcraft
{
	GuiControl, 1:, desc%TabModifier%, As one of the oldest Minecraft mods, Buildcraft hasn't changed too much. It adds in pipes to move items around automatically along with redstone control so you can control exactly which item goes where. It also adds a pump to suck up liquids and the infamous quarry to automatically mine materials for power. This mod is the baseline for tech mods and is simple and easy to use.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\buildcraft.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=bIXxZ77KhRg">youtube.com/watch?v=bIXxZ77KhRg</a>
}
else if selecteditem = Chance Cubes
{
	GuiControl, 1:, desc%TabModifier%, Chance cubes is a small but crazy mod that adds in blocks to your world that when broken, will perform a random effect. Effects can range from free diamond blocks to a massive rainbow appearing out the ground, to just blowing up your face. Good for a quick laugh with friends!
	GuiControl, 1:, descpic%TabModifier%, *w160 *h-1 %modpicsloc%\chance.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=5thr3eGmh6k">youtube.com/watch?v=5thr3eGmh6k</a>
}
else if selecteditem = Chisel 2
{
	GuiControl, 1:, desc%TabModifier%, Chisel is a very large decorative style mod that adds in one tool, the chisel... and hundreds of new awesome looking blocks. Simple right click the chisel and put any building block such as stone, dirt, sand, bricks or even some of the new blocks such as factory blocks inside it. You can then choose from tonnes of different styles. If you want to build fancy things, this is your mod!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\chisel.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=SCuBQs3NThw">youtube.com/watch?v=SCuBQs3NThw</a>
}
else if selecteditem = Chisels and Bits
{
	GuiControl, 1:, desc%TabModifier%, The ultimate creative mod! Chisels and Bits lets you break many nearly any block down into much smaller parts which you can place wherever you like, this gives you a tonne more freedom when building. You can now actually write words with these bits or add detail to your buildings. There's so much you can do with this mod. If you like building, give it a try!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\chiselbits.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=jRY0AZgHP1g">youtube.com/watch?v=jRY0AZgHP1g</a>
}
else if selecteditem = Chococraft
{
	GuiControl, 1:, desc%TabModifier%, One of the oldest but best mob mods available, Chococraft adds in tameable and breedable Chocobos! There are many different ranks of chocobos and you'll need to keep breeding using the new crop - gysals, to get better ones with new abilities. Are you able to get a golden Chocobo? Fun mod for all worlds!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\chococraft.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=BmxaZniQZDs">youtube.com/watch?v=BmxaZniQZDs</a>
}
else if selecteditem = Colossal Chests
{
	GuiControl, 1:, desc%TabModifier%, Colossal Chests adds in huge (in physical size and storage size...) multiblock chests of different materials. Chests are made up of chest walls and a chest core, they can be made of wood, iron, gold, diamond etc and can also interact with hoppers too.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\colossalchests.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=q6EWfSN5ZZ0">youtube.com/watch?v=q6EWfSN5ZZ0</a>
}
else if selecteditem = Compact Machines
{
	GuiControl, 1:, desc%TabModifier%, Compact Machines is a small mod that can potentially revolutionise the way you play. It adds in a few blocks that allow you to 'shrink' yourself to go inside blocks, you could then build a huge machine or house inside this single block. This lets you massively save on space, these blocks can also input or output power/items/liquid etc for automation.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\compactmach.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=cDUIR8Zv5xw">youtube.com/watch?v=cDUIR8Zv5xw</a>
}
else if selecteditem = Cooking for Blockheads
{
	GuiControl, 1:, desc%TabModifier%, Cooking for Blockheads is primarily designed to work with HarvestCraft or another mod which adds lots of food. It adds in a buildable kitchen that you can add food to, and it will then calculate everything you can make with that food. Really smart and a great mod, especially if you're using HarvestCraft!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\cookingforblock.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=XzxvyJA4OVU">youtube.com/watch?v=XzxvyJA4OVU</a>
}
else if selecteditem = CustomNPCs
{
	GuiControl, 1:, desc%TabModifier%, CustomNPCs is a mod which allows you to create your own NPCs and place them in your world. You can customise their health, skin, strength, weapons, what they say and you can even set them up with movement behaviours and jobs! It can be a little bit fiddly but is really impressive when you have your own custom city with actual people in it!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\customnpcs.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=gsU1g6LiERQ">youtube.com/watch?v=gsU1g6LiERQ</a>
}
else if selecteditem = Cyclic
{
	GuiControl, 1:, desc%TabModifier%, Cyclic is a mod similar to Quark, OpenBlocks or Extra Utilities in that it adds loads of really useful random blocks and items but without a consistent theme. From extra potions, to wireless redstone, Ender Orbs and Wings, Magic Beans and the awesome Cyclic Scepter, you won't run out of cool tools in this mod!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\cyclic.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=kiizU1NQux0">youtube.com/watch?v=kiizU1NQux0</a>
}
else if selecteditem = Dark Utilities
{
	GuiControl, 1:, desc%TabModifier%, Dark Utilities is a tech addon mod that adds a variety of useful items and blocks (again, similar to Quark, OpenBlocks or Extra Utilities). It adds some really handy conveyors of different speeds, ender hoppers which are great for automating picking up items and sneaky blocks for disguising blocks as well as many other things. Works great in tech packs!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\darkutils.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=5w-yOag_sew">youtube.com/watch?v=5w-yOag_sew</a>
}
else if selecteditem = Decocraft 2
{
	GuiControl, 1:, desc%TabModifier%, Decocraft adds a large number of prebuilt objects and structures. Things that you couldn't normally build in minecraft such as detailed furniture, toys and games and kitchen equipment as well as loads of other cool things. Simply create a Decobench and put clay and dye inside it to make any object. Essential for most creative setups!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\deco.jpg
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=X1JcTOfXGTQ">youtube.com/watch?v=X1JcTOfXGTQ</a>
}
else if selecteditem = Dimensional Doors
{
	GuiControl, 1:, desc%TabModifier%, Dimensional Doors is a really wacky mod which adds in magical doors that you can either craft or find around the landscape. You can go through these doors and they will teleport you to various dimensions, from puzzles and treasure rooms, to hidden bases and traps. You could build your base inside a pocket dimension or create your own treasure room. Really cool!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\dimdoors.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=BL5eillMQi8">youtube.com/watch?v=BL5eillMQi8</a>
}
else if selecteditem = Earthworks
{
	GuiControl, 1:, desc%TabModifier%, Earthworks is a small but focused decorative mod that adds in some awesome looking natural blocks that are missing from other creative-style mods. Timber frames for houses and various types of pretty looking stoney blocks, great for stylish looking houses!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\earthworks.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=AmVI7-nKyd8">youtube.com/watch?v=AmVI7-nKyd8</a>
}
else if selecteditem = Electroblobs Wizardry
{
	GuiControl, 1:, desc%TabModifier%, Electroblob's Wizardry is a newish magical mod focused on casting and throwing awesome spells at each other! Unlike other magical mods, you don't craft or make things but instead will find spells, wands and scrolls through combat and exploration. You can also find master wizards which might sell you powerful spells. To get started, find a 'magic crystal' and then craft this with a book.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\electroblob.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=NoKUWKQO6UM">youtube.com/watch?v=NoKUWKQO6UM</a>
}
else if selecteditem = Ender Storage
{
	GuiControl, 1:, desc%TabModifier%, Ender Storage adds in three really useful items - EnderChests, which are a much improved version of the Vanilla Minecraft ones - you can have many different chests each with their own colour code. EnderPouches, which are an EnderChest that you can carry around with you, and EnderTanks which are an EnderChest for liquids.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\enderstorage.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=0R6mlJWtvb0">youtube.com/watch?v=0R6mlJWtvb0</a>
}
else if selecteditem = EnderIO
{
	GuiControl, 1:, desc%TabModifier%, EnderIO is one of the top tech mods available, if you want automation and machines you can't go wrong with EnderIO. Unlike other tech mods, it adds in a wacky teleportation system and a way to access anything in your base from nearly anywhere. The mod also has arguably the best pipes, allowing you to transport items, liquid and power all in the same block.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\enderio.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=Sv0Q4It4bD8">youtube.com/watch?v=Sv0Q4It4bD8</a>
}
else if selecteditem = Environmental Tech
{
	GuiControl, 1:, desc%TabModifier%, Environmental Tech is a fairly large tech mod about building multiblock machines. These machines are mostly 'afk' based machines which require a lot of resources to build but generally don't require much 'maintenance' once they're going. Huge solar panels, void miners and lightning rods are the main features of this mod. The mod also has it's own tier tree with increasingly expensive machines that produce more and more power and/or resources. 
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\ettech.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=7m8QY9so11A">youtube.com/watch?v=7m8QY9so11A</a>
}
else if selecteditem = Ex Nihilo
{
	GuiControl, 1:, desc%TabModifier%, Ex Nihilo is a small mod purely designed for SkyBlock based maps. It adds in ways to obtain ores and materials that make a full SkyBlock playthrough possible, things such as iron, coal, goal, diamond and various other generating items can now be obtained via assorted gadgets and devices. Perfect mod for any SkyBlock map, completely pointless for a normal map though!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\exnihilo.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=pbgVh5mXctQ">youtube.com/watch?v=pbgVh5mXctQ</a>
}
else if selecteditem = Exotic Birds
{
	GuiControl, 1:, desc%TabModifier%, Fairly self explanatory, Exotic Birds adds in... exotic birds! There's currently over 30 birds, from Magpies, to Owls, to Penguins and you'll find all the different birds in various biomes. Each bird also has several species allowing for over 100 different animals! The mod also adds in nests and an encyclopedia for you to log your finds!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\exbirds.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=RnqqRu6WdlQ">youtube.com/watch?v=RnqqRu6WdlQ</a>
}
else if selecteditem = Extra Utilities 2
{
	GuiControl, 1:, desc%TabModifier%, Extra Utilities adds in a tonne of handy blocks and items. From Angel blocks that you can place in mid air, to the large golden bag, to power generators, solar panels, pipes to move items and liquids around, Angel Rings to fly and a powerful quarry machine... it adds it all.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\extrautils.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=jWkJVJqeOmk">youtube.com/watch?v=jWkJVJqeOmk</a>
}
else if selecteditem = Extreme Reactors
{
	GuiControl, 1:, desc%TabModifier%, Extreme Reactors is a nuclear reactor mod which allows you to build your own reactors to generate power. Reactors take a lot of resources but the bigger they are and the better materials you use... the more power you'll generate! These reactors do NOT explode, unlike the IndustrialCraft ones! Note that this mod used to be called 'Big Reactors'.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\reactors.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=uIlBuguul5k">youtube.com/watch?v=uIlBuguul5k</a>
}
else if selecteditem = Fairy Lights
{
	GuiControl, 1:, desc%TabModifier%, A small but pretty mod that allows you to add various types of hangable fairy lights to your base. The lights can be all sorts of different colours, shapes and lengths. This mod looks fantastic around Halloween or Christmas time!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\fairylights.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=8slj3itCVDQ">youtube.com/watch?v=8slj3itCVDQ</a>
}
else if selecteditem = Ferdinands Flowers
{
	GuiControl, 1:, desc%TabModifier%, Another small but very pretty mod, this focuses on adding loads of really awesome looking flowers of assorted colours. It adds a total of 108 flowers as well as 32 new dyes and 16 glass colours. These flowers generate depending on the biome they're in, so you'll constantly be finding new ones as you explore. Perfect for any adventure or creative world!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\fflowers.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=FxQSVC3TS70&t=311">youtube.com/watch?v=FxQSVC3TS70</a>
}
else if selecteditem = Forestry
{
	GuiControl, 1:, desc%TabModifier%, Forestry is an older mod that works directly with (but doesn't necessarily need) Buildcraft, it has since expanded massively. The mod is based around setting up automatic farms for your base as well as adding tonnes of new discoverable tree species and the infamous bee and butterfly breeding. It also adds in new ways to generate power as well as some foods.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\forestry.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=hWy0WnZxPIk">youtube.com/watch?v=hWy0WnZxPIk</a>
}
else if selecteditem = Hardcore Darkness
{
	GuiControl, 1:, desc%TabModifier%, Hardcore Darkness is a spooky mod designed for upping the 'tension' of the game! It removes the minimum level of darkness for nights meaning that it can now actually get properly dark...! Great for Halloween events or worlds, are you afraid of the dark?
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\hardcoredark.png
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=ST3ljXBPBiw">youtube.com/watch?v=ST3ljXBPBiw</a>
}
else if selecteditem = HarvestCraft
{
	GuiControl, 1:, desc%TabModifier%, HarvestCraft is primarily a food and farming based mod. It adds around 40 new different fruit and vegetables to grow and combine to make tonnes of new food, as well as new flowers, new cooking utensils such as knives and mixing bowls as well as some pretty decorative blocks. This mod works very well with 'Cooking for Blockheads'!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\harvest.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=7umXiy3bPQY">youtube.com/watch?v=7umXiy3bPQY</a>
}
else if selecteditem = Hats
{
	GuiControl, 1:, desc%TabModifier%, If you can't guess what this mod does, you need to have a word with Gabe Newell. Hats adds loads of... wait for it... hats! These hats are collected by finding mobs or animals throughout the world wearing them, and then killing them to obtain their hat. There's hundreds of hats from the bog standard to the insanely crazy. A silly but fun addition to a pack.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\hats.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=o7EDBlQZsjg">youtube.com/watch?v=o7EDBlQZsjg</a>
}
else if selecteditem = Heroes Expansion
{
	GuiControl, 1:, desc%TabModifier%, Heroes Expansion is THE mod for superheroes in minecraft 1.12. It adds various items, blocks and machines that allow you to become Superman, Thor, Black Panther, Captain America, Green Arrow etc... You have to do different things to become various heroes, see the video for more details.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\heroesex.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=2d7Q5bJFhLc">youtube.com/watch?v=2d7Q5bJFhLc</a>
}
else if selecteditem = Heroic Armoury
{
	GuiControl, 1:, desc%TabModifier%, Heroic Armoury is a large weapon expansion that adds in a tonne of swords from other games. This includes the Legend of Zelda, Skyrim, RuneScape, Lord of the Rings, Soul Calibur and many others. The weapons have various stats and you can find them in loot treasure chests in Mineshafts/Pyramids/Dungeons/Jungle Temples. A great improvement for when your treasure hunting!
	GuiControl, 1:, descpic%TabModifier%, *w160 *h-1 %modpicsloc%\heroicarm.png
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://youtu.be/xsfsYojs_9E?t=170">youtube.com/watch?v=xsfsYojs_9E</a>
}
else if selecteditem = Immersive Engineering
{
	GuiControl, 1:, desc%TabModifier%, Immersive Engineering is a large tech mod focused on adding realistic awesome looking multiblock machines and power generation. A massive moving bucket mining drill, a large ore (and people) crusher, windmills and water wheels, a huge superfast furnace and also a really cool freeform power cable system. Note that you'll need plenty of iron! This mod, like Botania, comes with it's own guide book so it's easy to learn!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\immersive.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=FFwvmU5sqTY">youtube.com/watch?v=FFwvmU5sqTY</a>
}
else if selecteditem = Inventory Pets
{
	GuiControl, 1:, desc%TabModifier%, Tired of pets that 'just' follow you? You wanted a pet in your inventory right? Inventory pets does just that, it adds over 50 different pets that sit in your inventory and give you various bonuses when right clicked. Each one has different food that they eat and some are incredibly rare and hard to find. Can you get you them all?
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\ipets2.gif
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=gauUe00SUs8">youtube.com/watch?v=gauUe00SUs8</a>
}
else if selecteditem = IndustrialCraft
{
	GuiControl, 1:, desc%TabModifier%, IndustrialCraft, like BuildCraft, is one of the oldest mods available. Despite this, it's still going strong and is very popular. It's a large tech mod all about generating power via wind, sun, lava or even nuclear, and then using that power in tonnes of different machines. Unlike other mods, IC2 is absolutely merciless and you can easily get fried by cables or blow up your entire base with an overheated nucleur reactor. It's awesome fun.. if you're careful!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\ic2.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=QIZZQyS7SoU">youtube.com/watch?v=QIZZQyS7SoU</a>
}
else if selecteditem = Industrial Foregoing
{
	GuiControl, 1:, desc%TabModifier%, Industrial Foregoing is a large tech mod that effectively replaced MineFactory Reloaded, it adds in a variety of machines focused on (mostly) automating animals, mobs and farms. Collect rubber from trees, automate all your farms and then produce infinite xp, drops and/or liquid meat! The mod has a great manual and is easy to use, it's perfect for tech packs!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\indusfore.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=IlN00bAF7yQ">youtube.com/watch?v=IlN00bAF7yQ</a>
}
else if selecteditem = Integrated Dynamics
{
	GuiControl, 1:, desc%TabModifier%, Integrated Dynamics is quite an advanced tech mod similar to Applied Energistics and the Buildcraft Gates system. It allows you to build pipes for transporting items, fluids and energy around your base and then use these to build a network and automate everything around your base. It also focuses heavily on mod interaction and works well with other tech mods. It's very clever and although complex, is great fun once you get the hang of it
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\intdynamics.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=b9nk-uBr_4w">youtube.com/watch?v=b9nk-uBr_4w</a>
}
else if selecteditem = Iron Chests
{
	GuiControl, 1:, desc%TabModifier%, Iron Chests is a small but useful mod that allows you to upgrade chests to different materials which hold more and more. You've got wooden chests, iron chests, gold chests, diamond chests and obsidian chests. Handy mod that's easy to use for any modpack.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\ironchests.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=_l-Y3buIH18">youtube.com/watch?v=_l-Y3buIH18</a>
}
else if selecteditem = JourneyMap
{
	GuiControl, 1:, desc%TabModifier%, JourneyMap is an absolutely essential mod, it is the king of all minimap mods. JourneyMap has tonnes of customizable options as well as map markers and a full screen map mode. Whatever setup you're running... you want this mod.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\jmap.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=cSzFpfzFFmA">youtube.com/watch?v=cSzFpfzFFmA</a>
}
else if selecteditem = JurassiCraft
{
	GuiControl, 1:, desc%TabModifier%, JurassiCraft is quite a big mod which adds many features all based on Jurassic Park. This includes dinosaurs, fossils, amber, prehistoric plants, DNA Extraction machines and lab equipment. A pretty cool mod which is regularly updated, great for an adventure style pack!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\jurassicraft.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=PIBtjIR4Os0">youtube.com/watch?v=PIBtjIR4Os0</a>
}
else if selecteditem = Just a few fish
{
	GuiControl, 1:, desc%TabModifier%, Just a few fish is a small but aesthetic mod that looks really nice in pretty much any pack. The mod makes different fish actually appear in rivers so you can see them swimming around, rather than having them appear out of nowhere when you go fishing. You can also set up your own fish tank, as well as breed your fish.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\jaff.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=KLXL2wmHTm0">youtube.com/watch?v=KLXL2wmHTm0</a>
}
else if selecteditem = LAN Server Extended
{
	GuiControl, 1:, desc%TabModifier%, LAN Server Extended is a small mod that adds dedicated server commands to LAN servers. Yes, this means you can now use /ban, /kick, /whitelist and /pardon on your server! Note however that this mod seems to sometimes cause crashes with other mods, use at your own risk.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\lanserver.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href=""></a>
}
else if selecteditem = Lost Cities
{
	GuiControl, 1:, desc%TabModifier%, The Lost Cities mod is a world generation mod that adds in an infinite customizable city as a world type. This allows you to create endless massive cities to explore and play around with at your whim. To use it, simply select the 'Lost Cities' world type when you create your world.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\lostcities.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=imVfUIfkZ28">youtube.com/watch?v=imVfUIfkZ28</a>
}
else if selecteditem = Malisis Doors
{
	GuiControl, 1:, desc%TabModifier%, Malisis Doors is a small and simple mod that significantly improves doors in Minecraft. With this mod, you can now customize doors to have nearly any texture and shape. The mod also adds in some nice custom animations for doors too, to really spice up your builds!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\malisis.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=ndNAE5gEgVM">youtube.com/watch?v=ndNAE5gEgVM</a>
}
else if selecteditem = Mekanism
{
	GuiControl, 1:, desc%TabModifier%, Mekanism is a large beefy tech mod similar to IndustrialCraft. It adds in tonnes of machines for doubling and later even quadrupling your ore output. You'll also find new armour, new weapons, cute little controllable robots, jetpacks and scuba gear! Mekanism is the core of a tech pack.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\mekanism.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=GLNXGKZnFBs">youtube.com/watch?v=GLNXGKZnFBs</a>
}
else if selecteditem = Millenaire
{
	GuiControl, 1:, desc%TabModifier%, Millenaire is a massive Minecraft village expansion, it's one of the largest mods available and has a crazy amount of content. While exploring you'll find villages of various cultures from British, to Japanese, to Indians. Each village has it's own look, and each villager has their own job in the village. Villages will trade with you, build new buildings, craft weapons and give you quests. You have to work your way up the ranks and may even be built a house of your own. Incredible mod!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\millenaire.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=bHYKpr1oEDk">youtube.com/watch?v=bHYKpr1oEDk</a>
}
else if selecteditem = Minecraft Comes Alive
{
	GuiControl, 1:, desc%TabModifier%, Minecraft Comes Alive is another massive village expansion similar to Millenaire. This mod focuses on adding 'sims-like' villagers which you can interact with and build relationships with. Once you've developed enough of a relationship, you can then marry a villager and have a family. Villagers can do work for you and will chat to you, follow you etc. Really cool mod, but don't use it with Millenaire unless you like a broken Minecraft!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\mca.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=NlcjeJyCVzs">youtube.com/watch?v=NlcjeJyCVzs</a>
}
else if selecteditem = Minewatch
{
	GuiControl, 1:, desc%TabModifier%, Yep this is it! Overwatch in Minecraft! This is fantastic, but unfinished, version of Overwatch entirely re-created in Minecraft. Choose your class and destroy your friends with those sick Genji plays....! Note that this mod has been abandoned sadly and not all abilities are finished.
	GuiControl, 1:, descpic%TabModifier%, *w160 *h-1 %modpicsloc%\minewatch.png
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=STrkeEPBHmQ">youtube.com/watch?v=STrkeEPBHmQ</a>
}
else if selecteditem = Morph
{
	GuiControl, 1:, desc%TabModifier%, Morph is a simple mod that allows you to turn into animals and mobs that you've killed, different creatures have different abilities. Surprise (and annoy) your friends by turning into what they fear the most! Can you unlock all the morphs?
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\morph.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=LvmOZZBZVJ4">youtube.com/watch?v=LvmOZZBZVJ4</a>
}
else if selecteditem = Mr Crayfish's Furniture
{
	GuiControl, 1:, desc%TabModifier%, Mr Crayfish's Furniture mod is a decorative mod similar to Decocraft. It adds in about 40 different types of new furniture from kitchen appliances, to chairs and tables, to toilets and baths. Most items can be interacted with in some way or another. If you're a builder, get this mod.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\mrcrayfish.jpg
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=Mg3KSWPqiiA">youtube.com/watch?v=Mg3KSWPqiiA</a>
}
else if selecteditem = Mr Crayfish's Guns
{
	GuiControl, 1:, desc%TabModifier%, Sigh... Do you really need guns in Minecraft? This mod adds in a few different guns including a pistol, shotgun, rifles, grenade launcher, bazooka and a minigun. Yeah.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\gunmod.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=MV5WkZI2zjU">youtube.com/watch?v=MV5WkZI2zjU</a>
}
else if selecteditem = Mr Crayfish's Vehicles
{
	GuiControl, 1:, desc%TabModifier%, Mr Crayfish's Vehicles mod adds in a large host of new vehicles to minecraft, from ATV's and Go Karts, to shopping carts and a rideable couch! You may need to use commands to obtain them however - find '/summon vehicle' in the command list. Works well in creative packs.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\mrcrayvehicles.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=NYdsKzEMK3E">youtube.com/watch?v=NYdsKzEMK3E</a>
}
else if selecteditem = Mystical Agriculture
{
	GuiControl, 1:, desc%TabModifier%, Mystical Agriculture, or 'Magical Crops' as it was previously known, allows you to grow nearly any resource you need. From dirt plants to cow plants all the way up to diamond plants and wither plants, you can grow it! Note that the better plants require quite a lot of resources and time to get, so don't go thinking this is easy mode!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\mysticalagri.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=Xnq6rtfVPRc">youtube.com/watch?v=Xnq6rtfVPRc</a>
}
else if selecteditem = NetherEx
{
	GuiControl, 1:, desc%TabModifier%, NetherEx is a large Nether Overhaul, it adds new nether biomes, new mobs, blocks, items, armour, weapons and even food. It integrates well with Vanilla minecraft and improves the nether very significantly, you can guarantee that it'll feel completely new and scary once again!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\netherex.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=6gsFGzq7J94">youtube.com/watch?v=6gsFGzq7J94</a>
}
else if selecteditem = OpenBlocks
{
	GuiControl, 1:, desc%TabModifier%, OpenBlocks is a medium sized mod that adds in a chunk of useful blocks and items. Things such as the rope ladder for getting down from heights, the xp drain and xp shower for saving your XP, the item cannon... to launch items at your friends base... and the super useful elevator for getting around your base! It adds about 20 blocks and 25 different items.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\openblocks.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=0PJ70T612cw">youtube.com/watch?v=0PJ70T612cw</a>
}
else if selecteditem = Ore Excavation
{
	GuiControl, 1:, desc%TabModifier%, Ore Excavation (or Ore Excavator) is a very simple mod that adds one hotkey (defaults to the button below the 'Esc' key) that allows you to mine an entire ore vein at once. This isn't limited to just ore veins and can mine all of any type of block in a large radius. This will use up the appropriate durability of your tool and also uses hunger too.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\oreex.png
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=uUnGkCFdLMk&t=202">youtube.com/watch?v=uUnGkCFdLMk</a>
}
else if selecteditem = PneumaticCraft
{
	GuiControl, 1:, desc%TabModifier%, PneumaticCraft is quite a large tech mod that tries to set itself apart from the crowd with a very different power system. Instead of electricity, you'll be creating air pressure, this can then be used in compression chambers and assembly lines to create lots of new machines, generators, weapons and armour. Can be difficult but fanastic if you're a bit tired of standard tech mods.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\pneumaticcraft.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=7wlV65fYssc">youtube.com/watch?v=7wlV65fYssc</a>
}
else if selecteditem = Pokecube
{
	GuiControl, 1:, desc%TabModifier%, Since Pixelmon has now been taken down by Nintendo, Pokecube has taken the reins as leading Pokemon mod! It features hundreds of different pokemon that you throw out of 'pokecubes', these can then battle and fight with other pokemon. It can be helpful to familiarise yourself with the controls before you catch em' all though!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\pokecube.png
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=zbc9OxIzpA4">youtube.com/watch?v=zbc9OxIzpA4</a>
}
else if selecteditem = Portal Gun
{
	GuiControl, 1:, desc%TabModifier%, A classic mod! Portal Gun is a mod that implements the main device from the game 'Portal' straight into minecraft! This allows you to shoot portals on walls and then teleport between the portals whenever you want to. Note that this mod can be quite overpowered on a survival world, it can also cause lag if you've got loads of people all with guns... you've been warned!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\portalgun.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=_jNGiCsOtOs">youtube.com/watch?v=_jNGiCsOtOs</a>
}
else if selecteditem = ProjectE
{
	GuiControl, 1:, desc%TabModifier%, Aaaah ProjectE.... The most overpowered mod in existence! ProjectE allows you to turn your items into energy as well as generate energy from the sun, you can then use this energy to create any item you want, from blocks to diamonds to blocks of diamond..! Note that this mod does NOT work well with other mods that require any kind of balance... it's silly and crazy, but it's good fun!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\projecte.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=qmGQxtA7vng">youtube.com/watch?v=qmGQxtA7vng</a>
}
else if selecteditem = Project Red
{
	GuiControl, 1:, desc%TabModifier%, Project Red is a large mod which massively expands redstone. It adds in many different colours of redstone 'wiring' which is a lot more flexible than standard redstone and can go up walls, the mod also adds loads of different logic gates which saves you tonnes of space compared to making them in vanilla minecraft. Project Red is the perfect mod for any redstone enthusiast!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\projectred.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=2tQJR3uTUks">youtube.com/watch?v=2tQJR3uTUks</a>
}
else if selecteditem = Psi
{
	GuiControl, 1:, desc%TabModifier%, Psi is a magical mod crossed with a tech mod. If you enjoy any sort of programming, Psi is the mod for you! Combine blocks together to create spells and then put these spells inside your 'spell gun'. You can easily share spells with friends and the limit of spells you can make is nearly unending. A really clever and different mod, nothing like what you've played before!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\psi.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=GblATAoPWH4">youtube.com/watch?v=GblATAoPWH4</a>
}
else if selecteditem = Quark
{
	GuiControl, 1:, desc%TabModifier%, Quark adds loads of different small tweaks and improvements to Minecraft. New blocks such as the weather sensor, the ender watcher, loads of new cosmetic blocks, new world generation. It also improves your UI with chest searching and sorting, food tooltips, new animal textures, emotes and easy to see stats for weapons and armour. The list is huge, recommended you watch a video or see their website!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\quark.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=KuPRdLCC0Bw">youtube.com/watch?v=KuPRdLCC0Bw</a>
}
else if selecteditem = Recurrent Complex
{
	GuiControl, 1:, desc%TabModifier%, Recurrent Complex is a massive structure and world generation mod. If you want a fancy adventure-like world, this mod is the one you need. It adds over 200 new structures such as forts, mazes, pirate hideouts, inns, pyramids, graveyards... the list is unending and is very impressive. These structures will all randomly generate throughout your world and really help to spice it up!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\rc.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=efJ2NRvdpTw">youtube.com/watch?v=efJ2NRvdpTw</a>
}
else if selecteditem = Refined Storage
{
	GuiControl, 1:, desc%TabModifier%, Refined Storage is a massive Storage System mod, similar to Applied Energistics. Store all your items on digital disks and then use the autocrafting to make your items for you. Hook your system up to machines and automate everything. You're using chests!? Pfff.. Meet the ultimate storage mod!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\refinedstorage.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=n0oLJKT-InU">youtube.com/watch?v=n0oLJKT-InU</a>
}
else if selecteditem = RFTools
{
	GuiControl, 1:, desc%TabModifier%, RFTools is a huge tech mod, it's also one of the most functional as it gives you a massive number of new blocks and tools not found in any other mod. RFTools also lets you create your own custom dimensions and the beam yourself around using the dimensional teleporters. It's quite a tricky but an extremely rewarding mod if you know how to use it properly!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\rftools.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=mb-2OEt03fE">youtube.com/watch?v=mb-2OEt03fE</a>
}
else if selecteditem = Roguelike Dungeons
{
	GuiControl, 1:, desc%TabModifier%, Roguelike dungeons is a small but pretty awesome world generation mod that adds dungeons to your world. These are found in towers and houses on the surface, and can be really deep. The deeper you go, the better loot you can get! Really cool for an exploration or adventure-like world.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\rogued.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=aQJUwflb_8M">youtube.com/watch?v=aQJUwflb_8M</a>
}
else if selecteditem = Roots 2
{
	GuiControl, 1:, desc%TabModifier%, Roots is a medium sized magical mod with a nature theme, not too dissimilar to Botania. Combine plants and herbs to perform spells and rituals as well as creating magical staves to shoot fire or poison, or even teleporting. It adds a few new plants and also adds deer to your world.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\roots.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=3EiiMwVJz6o">youtube.com/watch?v=3EiiMwVJz6o</a>
}
else if selecteditem = Secret Rooms
{
	GuiControl, 1:, desc%TabModifier%, Secret Rooms is a small mod that adds in secret camoflaged 'ghost' blocks. These can be used to create secret doors and trapdoors in your base, or simply use them in your friends base as a trap! You can make the helmet provided by the mod to see all ghost blocks highlighted.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\secretrooms.jpg
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=96dfFBlYyFI">youtube.com/watch?v=96dfFBlYyFI</a>
}
else if selecteditem = SecurityCraft
{
	GuiControl, 1:, desc%TabModifier%, Securitycraft does exactly what you think it does! It adds loads of different ways to protect your base or area from other players or mobs. From lasers to unbreakable doors, to keypads and retinal scanners, you can be sure that not even a silverfish will get into your house!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\security.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=zaQp6O-CWWA">youtube.com/watch?v=zaQp6O-CWWA</a>
}
else if selecteditem = Simple Teleporters
{
	GuiControl, 1:, desc%TabModifier%, Simple Teleporters is a small minimalist mod that adds in a couple of items to build your own teleporters. To do this, you'll need to make an 'Ender Shard' and then shift-right click it to link it to your current position. Then just make a teleporter and right click your crystal in to make your teleporter! Other mods can do the same thing but if you just want teleporters without anything else, this is your mod.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\simpletele.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=HhhgMEzXR_M">youtube.com/watch?v=HhhgMEzXR_M</a>
}
else if selecteditem = Simply Jetpacks
{
	GuiControl, 1:, desc%TabModifier%, Simply Jetpacks is a small mod designed to work with either Thermal Expansion or EnderIO. It adds in a number of different upgradeable jetpacks that take RF power to use. The mod is easy to use and understand, it also adds fluxpacks for carrying electricity with you on the go.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\simplyjet.jpg
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=8JyKB0cXEqU">youtube.com/watch?v=8JyKB0cXEqU</a>
}
else if selecteditem = Serene Seasons
{
	GuiControl, 1:, desc%TabModifier%, Serene Seasons is a cool immersive aethetic mod which makes the entire world change with the seasons throughout the year. The weather and brightness will change, snow will fall in biomes in the winter and crops will grow more during spring/summer. Grass colour, tree colour and sky colours all change too, making you really feel like the seasons are taking place in Minecraft. Very cool!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\serene.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=knljaygWa_0">youtube.com/watch?v=knljaygWa_0</a>
}
else if selecteditem = Spartan Shields
{
	GuiControl, 1:, desc%TabModifier%, Hate the vanilla minecraft shield? Wish there were more awesome shields? This is your mod! Spartan Shields adds in a variety of new shields made of different materials including wooden, stone, iron, gold, diamond, obsidian and more if you've got other ores installed. Some shields can also be charged with energy if you've got a tech mod installed. An awesome mod for spicing up any combat situation!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\sshields.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=5oPSVuqbgYY">youtube.com/watch?v=5oPSVuqbgYY</a>
}
else if selecteditem = Speedster Heroes
{
	GuiControl, 1:, desc%TabModifier%, Speedster heroes is a small-ish mod that adds in various 'Speedster' suits. Each one has different speed levels, trails and abilities. If you're looking to become the Flash, this is your mod. Works well with Heroes Expansion. Create a particle accelerator to get started!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\speed.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=B86GIY7TdFc">youtube.com/watch?v=B86GIY7TdFc</a>
}
else if selecteditem = Storage Drawers
{
	GuiControl, 1:, desc%TabModifier%, Storage drawers is a very popular storage mod which adds... wait for it... loads of drawers to the game! These are really handy blocks that can hold up to 16 stacks of one item or 4 stacks of 4 different items. Perfect for when you've had enough of chests, the drawers can also all be linked together via a Drawer Controller to make it even easier to put your materials in. They look pretty too!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\sdrawers.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=uGqh8UFxxxo">youtube.com/watch?v=uGqh8UFxxxo</a>
}
else if selecteditem = Streams
{
	GuiControl, 1:, desc%TabModifier%, Streams is a small aesthetic mod which can add a lot to a pretty world. The mod adds actual real flowing rivers to the game, these originate in multiple places and then flow down the terrain through slopes and waterfalls towards the sea. Works really well in nearly any world, especially creative ones!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\streams.jpg
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=abOWMprP9wM">youtube.com/watch?v=abOWMprP9wM</a>
}
else if selecteditem = Tardis
{
	GuiControl, 1:, desc%TabModifier%, Keen on Doctor Who? This is the mod for you! The Tardis mod adds in a controllable Tardis which can teleport to various dimensions. Make a Tardis Coral to get started and it'll grow into a Tardis after a few days! The mod has been completely rebuilt for 1.12 and is currently very much in ALPHA, therefore you may encounter bugs or issues with it.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\tardis.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=05sn025_3O0">youtube.com/watch?v=05sn025_3O0</a>
}
else if selecteditem = Terrarium
{
	GuiControl, 1:, desc%TabModifier%, Terrarium is a really simple mod that adds a new world type for when you make a world... 'Earth'! This will generate a replica of the entire planet, you can then control the scale when generating, by default it's 1:35. You can also choose where you want to land when the world is generated. Note that this mod is meant for creative worlds and therefore has no ore or villages etc.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\terrarium.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href=""></a>
	;No videos of terrarium :(
}
else if selecteditem = Thaumcraft
{
	GuiControl, 1:, desc%TabModifier%, Thaumcraft has long been one of the most popular magic mods. It's a huge crazy expansion that adds so much to the game it's nearly impossible to mention it all. Remade for Minecraft 1.12, it adds wands, spells, golems, a new research system, tonnes of magical items, devices and blocks... and of course, plenty of things to mess with your friends! An absolutely incredible mod.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\thaumcraft.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=pDQZRhQq584">youtube.com/watch?v=pDQZRhQq584</a>
}
else if selecteditem = The Erebus
{
	GuiControl, 1:, desc%TabModifier%, The Erebus is a large dimension expansion mod similar to the Twilight Forest. It adds a desert based, deadly insect infested world with dungeons, bosses and lots of new items. To get there, make an offering altar and use obsidian, an emerald and a diamond on it. Then right click on it with a Staff of Gaea, and enjoy! Good mod with friends!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\erebus.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=tusEftrLNzk">youtube.com/watch?v=tusEftrLNzk</a>
}
else if selecteditem = Thermal Expansion
{
	GuiControl, 1:, desc%TabModifier%, Thermal Expansion is a large machine and tech based mod. Make generators to create power from lava, redstone and fuel then use that power to double your ores, increase your crop yield, get different materials and blocks, and even teleport items, liquids, power or yourself between dimensions. Create your own assembly line to process all the things!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\thermalex.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=yDd3y7v7kGQ">youtube.com/watch?v=yDd3y7v7kGQ</a>
}
else if selecteditem = Tinkers Construct
{
	GuiControl, 1:, desc%TabModifier%, Tinkers is a large and popular mod which allows you to make tools out of parts. A pickaxe is made up of a handle, binding and the head for example. Each part can have it's own material and different materials give different bonuses. Make a smeltery to make better parts and add modifiers to your tools to further improve them.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\tico.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=o03KGqbgv7U">youtube.com/watch?v=o03KGqbgv7U</a>
}
else if selecteditem = Totemic
{
	GuiControl, 1:, desc%TabModifier%, Totemic is a very different magic mod focused around totem poles, nature and music. Dance around totem poles while using your instruments to do rituals and ceremonies, these will unlock new powerful items, buffs or bosses. This mod is best done with a friend or two!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\totemic.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=d9S4U9qWT7A">youtube.com/watch?v=d9S4U9qWT7A</a>
}
else if selecteditem = Twilight Forest
{
	GuiControl, 1:, desc%TabModifier%, Twilight Forest adds a new dimension which contains loads of new monsters, creatures, items and most of all, bosses. The bosses each have their own structures and strategies, and start easy but quickly ramp up in difficulty. Can you beat the Twilight Lich? The Urr-ghast? Or even the Ice Queen?
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\twforest.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=1NRbCj6bn4M">youtube.com/watch?v=1NRbCj6bn4M</a>
}
else if selecteditem = Vampirism
{
	GuiControl, 1:, desc%TabModifier%, Guess what this mod is about...! Vampirism allows you to become a vampire (if you get bitten) with lots of benefits, but also drawbacks. You can then suck blood from animals or villagers and perform vampiric rituals to level up and gain new dark powers. Note however that the stronger you get, the more threatening the sun becomes! Or instead, become a vampire hunter and take down your evil vampire friends!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\vampirism.png
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=SQUbl6DENiE">youtube.com/watch?v=SQUbl6DENiE</a>
}
else if selecteditem = Viescraft Airships
{
	GuiControl, 1:, desc%TabModifier%, Ever wanted to build a flying machine? Now you can! Viescraft allows you to contruct and upgrade your own customizable flying machine, each machine can have it's own modules and colours and models. A really fun way to explore minecraft in style, the sky is the limit!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\viescraft.jpg
	GuiControl, Show, Videotextother
	GuiControl, 1:, Videolinkother, <a href="https://www.youtube.com/watch?v=qgnZj_UYu-c">youtube.com/watch?v=qgnZj_UYu-c</a>
}
else if selecteditem = Weeping Angels
{
	GuiControl, 1:, desc%TabModifier%, Any fans of Doctor Who will instantly recognise this mod! It adds in a new mod - the weeping angel. This is a dangerous mob which is extremely fast but can only move when you aren't looking at it! Angels will also attempt to remove light sources including torches and redstone lamps. If you can make two Angels look at each other, you might just stand a chance at dealing with them!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\weepingangels.jpg
	GuiControl, Show, Videotextmagic
	GuiControl, 1:, Videolinkmagic, <a href="https://www.youtube.com/watch?v=LnEGqv1TYaQ">youtube.com/watch?v=LnEGqv1TYaQ</a>
}
else if selecteditem = WorldEdit
{
	GuiControl, 1:, desc%TabModifier%, WorldEdit is a command based mod primarily for creative based servers. It allows you to quickly change/add/remove huge amounts of blocks in any area you specify. Sculpt your world in an way you wish, and without spending 2 hours placing down individual blocks!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\worldedit.jpg
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=SOOvommDpUA">youtube.com/watch?v=SOOvommDpUA</a>
}
else if selecteditem = XNet
{
	GuiControl, 1:, desc%TabModifier%, XNet is a small tech addon mod that adds a single cable  - the networking cable. This can instantly transport items, fluid, energy or information over massive distances and at the same time. It works well with other tech mods such as Mekanism or RFTools, and pretty much anything that you need automated.
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\xnet.png
	GuiControl, Show, Videotexttech
	GuiControl, 1:, Videolinktech, <a href="https://www.youtube.com/watch?v=ksaJgiipaOg">youtube.com/watch?v=ksaJgiipaOg</a>
}
else if selecteditem = Xtones
{
	GuiControl, 1:, desc%TabModifier%, Xtones, a remake of Ztones, is purely a cosmetic decorative mod. It adds tonnes of different coloured and awesome looking blocks. Xtones also works really well with Chisel and Bits, allowing you to break all of the blocks down into smaller parts. Perfect for a creative pack!
	GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\xtones.png
	GuiControl, Show, Videotextcreative
	GuiControl, 1:, Videolinkcreative, <a href="https://www.youtube.com/watch?v=RyeEl9oS0Lg">youtube.com/watch?v=RyeEl9oS0Lg</a>
}

;If it's not a predefined mod, lets search CustomMods.txt for it. This could be slow with a lot of mods as it's a parsing loop, we'll see...
else
{
	;Parse through the data, adding mods as we go
	Loop, Parse, custommodslist, `n
	{
		;If first character in a line is a hash (or nothing), ignore that whole line (it's a comment!)
		if(SubStr(A_LoopField, 1, 1)) = "#"
			continue
		
		if(SubStr(A_LoopField, 1, 1)) = "`r"
			continue
			
		if(SubStr(A_LoopField, 1, 1)) = "`n"
			continue
			
		if(SubStr(A_LoopField, 1, 1)) = ""
			continue
			
		if(SubStr(A_LoopField, 1, 1)) =
			continue
		
		;Split the line into 5 parts - the name, category, imgsrc, url and description
		custommodarray := StrSplit(A_LoopField, ",", " `t", 5)
		
		customname := custommodarray[1]
		currentmod := A_LoopField
		
		;If the name matches something in CustomMods.txt, grab all the information from the text file and put it on the GUI
		if selecteditem = %customname%
		{
			TabModifier := custommodarray[2]
			customimg := custommodarray[3]
			customyturl := custommodarray[4]
			customdesc := custommodarray[5]
			
			GuiControl, 1:, desc%TabModifier%, %customdesc%
			GuiControl, 1:, descpic%TabModifier%, *w180 *h-1 %modpicsloc%\%customimg%
			GuiControl, Show, Videotext%TabModifier%
			
			;To get the short url (without http://www.), split by the first '.' found, and then grab the second half
			splityturl := StrSplit(customyturl, ".", " `t", 2)
			shorturl := splityturl[2]
			
			GuiControl, 1:, Videolink%TabModifier%, <a href="%customyturl%">%shorturl%</a>
		}
	}
	
}
return

;Function for when a user clicks 'Load'
Load: 
{

/*

Note, this function gives the user two choices:

1. They can either load directly from a player, in this case they can type in another username... the script will then search the server for the latest autosave file for this user and attempt to load from it.

2. They can load from a file that they may have saved in their documents or any other location

*/

;Query user if mods have already been chosen
if rightbox !=
{
	MsgBox, 1, Loose load order?, If you load now`, you will loose the mods you have selected. Continue?
	IfMsgBox Cancel
		return
}

;The user is given a choice to either load from a saved file, or they can load directly from another player. I don't like this and ideally it needs a proper GUI... but that's a lot of work!!
MsgBox, 35, Player or File?, Would you like to load directly from a player (YES)? Or load from a file instead (NO)?

;If they press Yes, they are loading directly from a player and need to enter the username of the player to load from
IfMsgBox Yes
{
	InputBox, loadplayer, Load from Player, Please type the username of the player you want to load from
	if ErrorLevel
		return
	otherlastsave = %savefilesloc%\%loadplayer%\lastrun.txt
	
	;Load the lastsave/autosave from this user automatically, if it exists. Search the server for an autosave file for the username entered.
	if FileExist(otherlastsave)
	{
		;Start reading from the selected file
		cnotice = Autogenerated save file!
		cblank =
		FileReadLine, notice, %otherlastsave%, 1
		FileReadLine, empty, %otherlastsave%, 2

		;Check the read file to ensure it's a valid save file and hasn't been modified in any way (will cause problems later if it has been edited)
		if ((notice = cnotice) && (empty = cblank))
		{
			;Read line by line
			FileReadLine, leftboxTech, %otherlastsave%, 3
			FileReadLine, leftboxMagic, %otherlastsave%, 4
			FileReadLine, leftboxCreative, %otherlastsave%, 5
			FileReadLine, leftboxOther, %otherlastsave%, 6
			FileReadLine, rightbox, %otherlastsave%, 7
		}
		else
		{
			;This will only trigger if the user has corrupted their autosave file somehow or the script can't access it for some reason. I.e. it's found a file but it can't read it/can't open it.
			MsgBox, 16, Error!, Bad save file detected! Maybe get that player to reload their game? Or try loading from a file instead.
			return
		}
	
	}
	else
	{
		;Will run if a bad/invalid username is entered and the script can't find it
		MsgBox, 16, Error!, Error - can't load from %loadplayer%! Are you sure you spelt their username correctly? Remember that they must have launched minecraft before you can load their mods! 
	}
}

;If they prss No, they are instead loading from a file (from their documents e.g.). The user needs to choose which file to load from
IfMsgBox No
{
	;Display file selection GUI. Exit back to GUI if they select nothing.
	FileSelectFile, loadfile, 3, H:\, Load your load order
	if ErrorLevel
		return
		
	;Start reading from the selected file
	cnotice = Do NOT edit this file, your save will break!
	cblank =
	FileReadLine, notice, %loadfile%, 1
	FileReadLine, empty, %loadfile%, 2

	;Check the read file to ensure it's a valid save file and hasn't been modified in any way (will cause problems later if it has been edited).
	if ((notice != cnotice) || (empty != cblank))
	{
		MsgBox, ERROR - Cannot load this file`, maybe this isn't a save file or someone edited it?
		return
	}
	
	;Check all mods one by one to ensure they actually exist. This is in-case the user has manually edited their save file, the script won't load a nonexisting mod.
	FileReadLine, leftboxTech, %loadfile%, 3
	if (!checkmods(leftboxTech))
		return
	FileReadLine, leftboxMagic, %loadfile%, 4
	if (!checkmods(leftboxMagic))
		return
	FileReadLine, leftboxCreative, %loadfile%, 5
	if (!checkmods(leftboxCreative))
		return
	FileReadLine, leftboxOther, %loadfile%, 6
	if (!checkmods(leftboxOther))
		return
	FileReadLine, rightbox, %loadfile%, 7
	if (!checkmods(rightbox))
		return
			
	;Detect any new mods that have been added recently, add them to the GUI. This is the case if a mod has been added to the script but doesn't yet exist in a users' save file.
	leftboxTech := detectNewMods(leftboxTech, rightbox, "Tech")
	leftboxMagic := detectNewMods(leftboxMagic, rightbox, "Magic")
	leftboxCreative := detectNewMods(leftboxCreative, rightbox, "Creative")
	leftboxOther := detectNewMods(leftboxOther, rightbox, "Other")
}

;If they press Cancel, just do nothing and return to the GUI
IfMsgBox Cancel
	return
	
;If the user chose to load AND it's a happy save file, update all the variables and GUI with the new data. Then return to the GUI
GuiControl, 1:, ModChoiceTech, |%leftboxTech%
GuiControl, 1:, ModChoiceMagic, |%leftboxMagic%
GuiControl, 1:, ModChoiceCreative, |%leftboxCreative%
GuiControl, 1:, ModChoiceOther, |%leftboxOther%
GuiControl, 2:, ModChoiceFinal, |%rightbox%
loadsave = 1
return
}

;Function for when a user clicks 'Save', this saves their mods to a txt file in a location of their choice
Save: 
{
;Firstly blank all variables
saverows =

;Find out what mods have been chosen in the rightbox
ControlGet, saverows, List, Count, ListBox1, Selected Mods

;If no mods have been selected, the user is being an idiot by trying to save a blank file... moan at them and then return
if saverows =
{
	Msgbox, You haven't selected any mods yet! Select at least one mod before you press Save.
	return
}

;Prompt the user for save location, if they cancel just return. Default is H:\mymods.txt
FileSelectFile, savefile, S24, H:\mymods.txt, Save your load order, Text Documents (*.txt)
if savefile =
	return
	
;If they choose to overwrite an existing save file, delete the old one first
if FileExist(savefile)
	FileDelete, %savefile%
	
;Write all data to the file, creating it first if needed. Then return to the GUI
FileAppend, Do NOT edit this file`, your save will break!`n`n, %savefile%
FileAppend, %leftboxTech%`n, %savefile%
FileAppend, %leftboxMagic%`n, %savefile%
FileAppend, %leftboxCreative%`n, %savefile%
FileAppend, %leftboxOther%`n, %savefile%
FileAppend, %rightbox%, %savefile%
loadsave = 1
return
}

;Function for when a user clicks 'Launch Minecraft'. This is a big function that actually launches the game!
Launch: 

;Query the user to check a few things if needed (no mods selected, too many mods selected, haven't saved etc)
ControlGet, chosenmods, List,, ListBox1, Selected Mods
ControlGet, chosenmodscount, List, Count, ListBox1, Selected Mods

;This variable is set to 1 if the user loads or saves. If it's still 0, then the user hasn't loaded or saved yet.
if loadsave = 0 
{
	MsgBox, 49, Save?, You haven't saved your mods yet! Launch minecraft anyway?
	IfMsgBox Cancel
		return
}

;If the user hasn't selected any mods, 'chosenmods' will be blank. Are they sure they want to launch with no mods?
if chosenmods =
{
	MsgBox, 1, No Mods Selected, You haven't selected any mods! If you launch the game now`, you will be playing %mcver% Vanilla Minecraft. Continue?
	IfMsgBox Cancel
		return
}

;If it's not blank, count the mods and tell the user off if they have selected too many! This is necessary as more mods take up a significant amount of RAM! More than 30 mods will very quickly crash the school PCs (and more than 20 can be unstable)
;Note that each instance is setup with a certain amount of RAM. Minecraft never just takes as much RAM as it can, it has to be told (usually by MultiMC) how much it can have, this is in the MultiMC settings for that instance.
else
{
	modsnumber = 0
	Loop, Parse, chosenmods, `n
	{
		modsnumber += 1
	}
	if modsnumber > 30
	{
		MsgBox, 16, Error!, You've selected too many mods`, your PC will crash if you continue! Please select fewer mods.
		return
	}
	else if modsnumber > 20
	{
		MsgBox, 49, Warning!, You've selected a large number of mods`, your PC may run slowly or freeze. Continue?
		IfMsgBox Cancel
			return
	}
	else
	{
		MsgBox, 1, %modsnumber% mods selected, You selected %modsnumber% mod(s). Confirm launching Minecraft?
		IfMsgBox Cancel
			return
	}
}

;If we're now happy, disable the launch button to prevent them launching it twice, then lets get underway....!
GuiControl,, Launch, Launching...
GuiControl, Disable, Launch

;If Minecraft was previously run/installed, delete and renew the mods and configs folder (removing any old rubbish left over from the last user that ran the game)
if newinstall = 0
{
	;Delete already existing mods and configs, in case the last user has modified them
	FileRemoveDir, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\mods, 1
	FileRemoveDir, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\config, 1
	FileDelete, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\options.txt
	
	FileCreateDir, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\mods
	FileCreateDir, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\config

	;Wait half a second, otherwise it sometimes fails to copy in the mods when the folder doesn't yet exist
	Sleep 500
	
	;Copy in the default mods that every modman game has	
	FileCopy, %mclocation%\%version%\%serverdirtype%\mods\*.*, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\mods\*.*
}

;Loop through every mod selected and copy it from %modfilesloc% on the server, to the mods directory on the local PC
Loop, Parse, chosenmods, `n
{
	if A_LoopField = LAN Server Extended
		MsgBox, 48, LAN Server Extended, IMPORTANT! You have selected LAN Server Extended. For this mod to work`, you must:`n`n1. ENABLE Cheat mode when first creating the world`n2. DISABLE Cheat mode when opening to LAN.`n`nContinue?, 15

	FileCopy, %modfilesloc%\%A_LoopField%\*.jar, %multimcfolderloc%\instances\%version%\%minecraftdirtype%\mods, 1
	
	;Usage stats and logging. This allows you to log how many times each mod is used, allows you to easy see which mods are popular!
	if StatsEnabled = 1
	{
		globalmodusedtimes = 0
		mymodusedtimes = 0
		
		;Global mods used (How often ALL users use each mod)
		ifExist %savefilesloc%\modstats.ini
			IniRead, globalmodusedtimes, %savefilesloc%\modstats.ini, Mods, %A_LoopField%
		globalmodusedtimes += 1
		if A_UserName != coxo
			IniWrite, %globalmodusedtimes%, %savefilesloc%\modstats.ini, Mods, %A_LoopField%
		
		;Personal mods used (How often 'x' user uses each mod)
		ifExist %savefilesloc%\%A_UserName%\modstats.ini
			IniRead, mymodusedtimes, %savefilesloc%\%A_UserName%\modstats.ini, Mods, %A_LoopField%
		mymodusedtimes += 1
		IniWrite, %mymodusedtimes%, %savefilesloc%\%A_UserName%\modstats.ini, Mods, %A_LoopField%
	}
}

;Do an autosave if they are enabled
if SavesEnabled = 1
{
	;Write lastrun save file to %savesfileloc% so we can auto-load it upon next run (so it remembers what mods were used last time)
	if FileExist(lastrunsave)
		FileDelete, %lastrunsave%

	IfNotExist, %savefilesloc%\%A_UserName%
		FileCreateDir, %savefilesloc%\%A_UserName%

	FileAppend, Autogenerated save file!`n`n, %lastrunsave%
	FileAppend, %leftboxTech%`n, %lastrunsave%
	FileAppend, %leftboxMagic%`n, %lastrunsave%
	FileAppend, %leftboxCreative%`n, %lastrunsave%
	FileAppend, %leftboxOther%`n, %lastrunsave%
	FileAppend, %rightbox%, %lastrunsave%
}

;Finally, try to launch minecraft. If there's an issue, inform the user then reinstall minecraft
try
{
	rungame(version, mcver, multimcfolderloc, offlineemail, OfflineMode)
}
catch error
{
	Msgbox, 0, ERROR!, Couldn't find the minecraft launcher, corrupt install! Minecraft will be reinstalled...
	FileRemoveDir, C:\minecraft%version%, 1
	install(version, mclocation, multimcfolderloc, libsloc)
	reload
}

;Kill all GUIs and then show the backup GUI
WinGetPos, mcx, mcy, mcw,,Minecraft %mcver%
if mcx =
{
	MsgBox, 16, Error!, Error - I can't find Minecraft! Did it crash? Maybe try removing bad mods or delete the instance?
	GuiControl,, Launch, Launch
	GuiControl, Enable, Launch
	return
}

;Run the backup manager if it's enabled, otherwise just exit
if BackupsEnabled = 1
{
	Gui, 1:destroy
	Gui, 2:destroy
	Gui, 4:destroy
	mcx := mcx + mcw - 100
	mcy += 15
	Gui, 3:Show, w300 h450 x%mcx% y%mcy%, World Backups
	return
}
else
	ExitApp

;When the 'refresh' button is pressed, run the 'addbackupworlds' function. See below for more detail
RefreshBackup:
AddBackupWorlds(savefilesloc, version, 0, multimcfolderloc, 1, 0, minecraftdirtype)
return

;When the 'backup' button is pressed, run the 'backup' function. See below for more detail
Backup:
backup(savefilesloc, version, multimcfolderloc)
return

;When any GUI is closed (except GUI 4), kill the whole program	
GuiClose:
ExitApp

2GuiClose:
ExitApp

3GuiClose:
exitcode =
InputBox, exitcode, Have you backed up?, If you exit the backup launcher`, any progress you make from now on will NOT be saved! Are you sure you want to exit?`n`nPlease type 'okay' in the box if you are sure!,,300,200
if exitcode = okay
	ExitApp
else
	return

6GuiClose:
Gui, 6:Destroy
return

;MORE FUNCTIONS BELOW HERE ---------------------------------------------------------------------------------------------------------------------------------------
;These aren't run from certain buttons, but instead only run when needed by other functions.

;Checks all mods in a savefile to ensure they actually exist before trying to load them. This stops users editing their files and typing in random garbage (to have the script then panic when it can't find that mod!)
checkmods(inputread) 
{
global modsTech
global modsMagic
global modsCreative
global modsOther

;Read through a file, one mod at a time. Check every mod to see if it already exists as a mod at the top of this program
Loop, parse, inputread, |
{
	if A_LoopField not in %modsTech%
	{
		if A_LoopField not in %modsMagic%
		{
			if A_LoopField not in %modsCreative%
			{
				if A_LoopField not in %modsOther%
				{
					if A_LoopField != 
					{
						;If the mod doesn't exist in any of the modlists, it must either have been edited or the mod has been removed. Don't allow the user to load this file
						MsgBox, 16, Error, Error - Bad file or someone has edited this save file! Load cancelled. Bad Mod = %A_LoopField%. Maybe try removing this mod from the save file?
						resetvars()
						return false
					}
				}
			}
		}
	}
}
return true
}

;#addmods4 - Update the pipe separated items to include any new mods, remember last item in the list must be a pipe!
;Resets all variables back to defaults, in the case of a bad load or something else (THIS FUNCTION NEEDS TO BE UPDATED IF/WHEN NEW MODS ARE ADDED!)
resetvars() 
{
	global 

	;This just sets everything back to default, exactly as it is when you first launch the program
	leftboxTech = Advanced Generators|Bonsai Trees|Cyclic|Dark Utilities|Environmental Tech|Industrial Foregoing|Integrated Dynamics|XNet|Applied Energistics|Colossal Chests|Ender Storage|Extra Utilities 2|Extreme Reactors|Quark|Refined Storage|Tinkers Construct|Thermal Expansion|BuildCraft|IndustrialCraft|SecurityCraft|Immersive Engineering|Actually Additions|ProjectE|Storage Drawers|EnderIO|Iron Chests|RFTools|Forestry|Compact Machines|OpenBlocks|Mekanism|Simply Jetpacks|Ex Nihilo|Portal Gun|Simple Teleporters|Project Red|PneumaticCraft|
	leftboxMagic = Exotic Birds|Dimensional Doors|Millenaire|Minecraft Comes Alive|Aether 2|Electroblobs Wizardry|Vampirism|Serene Seasons|The Erebus|Thaumcraft|Botania|Blood Magic|JourneyMap|Recurrent Complex|Roguelike Dungeons|Roots 2|HarvestCraft|Twilight Forest|Astral Sorcery|Mystical Agriculture|Psi|AbyssalCraft|Betweenlands|Cooking for Blockheads|Biomes O' Plenty|NetherEx|Just a few fish|Totemic|Weeping Angels|Tardis|JurassiCraft|Animania|Chococraft|
	leftboxCreative = Mr Crayfish's Guns|Terrarium|Blockcraftery|Chisel 2|Xtones|BiblioCraft|Decocraft 2|Malisis Doors|Chisels and Bits|Better Builders Wands|WorldEdit|Earthworks|Fairy Lights|Mr Crayfish's Furniture|Secret Rooms|Mr Crayfish's Vehicles|CustomNPCs|Ferdinands Flowers|Streams|
	leftboxOther = Ore Excavation|LAN Server Extended|Heroic Armoury|Minewatch|Chance Cubes|Inventory Pets|Morph|Heroes Expansion|Speedster Heroes|Hats|Pokecube|Spartan Shields|Hardcore Darkness|Viescraft Airships|Lost Cities|
	rightbox =
	
	modsTech = Advanced Generators,Bonsai Trees,Cyclic,Dark Utilities,Environmental Tech,Industrial Foregoing,Integrated Dynamics,XNet,Applied Energistics,Colossal Chests,Ender Storage,Extra Utilities 2,Extreme Reactors,Quark,Refined Storage,Tinkers Construct,Thermal Expansion,BuildCraft,IndustrialCraft,SecurityCraft,Immersive Engineering,Actually Additions,ProjectE,Storage Drawers,EnderIO,Iron Chests,RFTools,Forestry,Compact Machines,OpenBlocks,Mekanism,Simply Jetpacks,Ex Nihilo,Portal Gun,Simple Teleporters,Project Red,PneumaticCraft
	modsMagic = Exotic Birds,Dimensional Doors,Millenaire,Minecraft Comes Alive,Aether 2,Electroblobs Wizardry,Vampirism,Serene Seasons,The Erebus,Thaumcraft,Botania,Blood Magic,JourneyMap,Recurrent Complex,Roguelike Dungeons,Roots 2,HarvestCraft,Twilight Forest,Astral Sorcery,Mystical Agriculture,Psi,AbyssalCraft,Betweenlands,Cooking for Blockheads,Biomes O' Plenty,NetherEx,Just a few fish,Totemic,Weeping Angels,Tardis,JurassiCraft,Animania,Chococraft
	modsCreative = Mr Crayfish's Guns,Terrarium,Blockcraftery,Chisel 2,Xtones,BiblioCraft,Decocraft 2,Malisis Doors,Chisels and Bits,Better Builders Wands,WorldEdit,Earthworks,Fairy Lights,Mr Crayfish's Furniture,Secret Rooms,Mr Crayfish's Vehicles,CustomNPCs,Ferdinands Flowers,Streams
	modsOther = Ore Excavation,LAN Server Extended,Heroic Armoury,Minewatch,Chance Cubes,Inventory Pets,Morph,Heroes Expansion,Speedster Heroes,Hats,Pokecube,Spartan Shields,Hardcore Darkness,Viescraft Airships,Lost Cities
	
	modsAll := modsTech . "," . modsMagic . "," . modsCreative . "," . modsOther
	
	;Now add any custom mods to these lists from the text files
	addCustomMods()
	
	;Update the GUI with the variables
	GuiControl, 1:, ModChoiceTech, |%leftboxTech%
	GuiControl, 1:, ModChoiceMagic, |%leftboxMagic%
	GuiControl, 1:, ModChoiceCreative, |%leftboxCreative%
	GuiControl, 1:, ModChoiceOther, |%leftboxOther%
	GuiControl, 2:, ModChoiceFinal, |%rightbox%
}

;Launches MultiMC and then the minecraft instance
rungame(version, mcver, multimcfolderloc, offlineemail, OfflineMode) 
{	
	/*
	;Allow the user to pick a name, and then update it in MultiMC (BREAKING ONLINE FUNCTIONALITY IN THE PROCESS)
	InputBox, customusername, Enter Username, What name would you like for your character?,, 240, 140,,,, 30, %A_UserName%
	while StrLen(customusername) > 15
	{
		InputBox, customusername, Error!, Names longer than 15 letters can cause problems with Minecraft!`n`nPlease enter a shorter name.,, 240, 180,,,, 30, %A_UserName%
	}
	
	;Don't allow them to enter a blank name, or the name of the actual account
	if customusername =
		customusername = %A_UserName%
	else if customusername = SeaMinecraft
		customusername = %A_UserName%
	*/
	
	;If user has set Offline Mode, run the username method to edit the accounts file in MultiMC (to force offline mode and break online functionality)
	if OfflineMode = 1
		username(multimcfolderloc, offlineemail)
		
	;Partial matching to allow MultiMC versions to be changed
	SetTitleMatchMode, 2
	
	;Firstly run the correct MultiMC instance. MultiMC accepts the '-l' switch to run any created instance
	Run, %multimcfolderloc%\MultiMC.exe -l "%version%", %multimcfolderloc%

	;Wait for Minecraft to appear (time out after 2 minutes)
	WinWait, Minecraft %mcver%,,120
	if ErrorLevel
	{
		Run, taskkill /im MultiMC.exe /f,,Hide
		MsgBox, Minecraft failed to load! Press OK then try launching the game again. Error 3.
		ExitApp
	}
	Sleep 3000
	RunWait, taskkill /im MultiMC.exe /f,,Hide
}

;Updates the 'accounts' file for MultiMC to the users username. Note that this will (deliberately) break online functionality, since the username is no longer valid. (Only run if the user selects offlinemode)
username(multimcfolderloc, offlineemail) 
{
	;Note, this code is a little bit hacky and could break if MultiMC updates their accounts.json file drastically!! But that's probably unlikely and it does the job for now!

	;If the accounts file exists, copy all the data but change the name to the users' username
	IfExist, %multimcfolderloc%\accounts.json
	{
		;Read the data out
		FileRead, account, %multimcfolderloc%\accounts.json
	
		;Find the location of the string 'name' in the file
		playnamestart := InStr(account, "name")
		
		;Find where the SECOND AND THIRD speech mark is after the 'name' string
		spmark = `"
		;" For my own sanity, this line is actually a comment and ends the previous speech mark (otherwise notepad is confused!)
		playnamefirstmark := InStr(account, spmark,, playnamestart, 2)
		playnameendmark := InStr(account, spmark,, playnamestart, 3)
		
		;Copy everything UP TO the second speech mark and everything FROM the second speech mark
		playnamefirstgroup := SubStr(account, 1, playnamefirstmark)
		playnamesecondgroup := SubStr(account, playnameendmark)
		
		;Concatenate the two along with the new username
		totalgroup := playnamefirstgroup . A_UserName . playnamesecondgroup
		
		;Delete the accounts file and make a new one with the new data
		FileDelete, %multimcfolderloc%\accounts.json
		FileAppend, %totalgroup%, %multimcfolderloc%\accounts.json
	
	}
	
	;If the accounts file doesn't get exist, we can't do very much. Just write a bunch of dummy data to a new file. MultiMC will then ask the user to login (and the data can then be obtained in future)
	else
	{
		json=
		(
		{
		"accounts": [
			{
				"accessToken": "%key%",
				"activeProfile": "%profile%",
				"clientToken": "%token%",
				"profiles": [
					{
						"id": "%profile%",
						"legacy": false,
						"name": "%A_UserName%"
					}
				],
				"user": {
					"id": "%user%"
				},
				"username": "%offlineemail%"
			}
		],
		"activeAccount": "%offlineemail%",
		"formatVersion": 2
	}
		)
		FileAppend, %json%, %multimcfolderloc%\accounts.json
	}
}

;Installs a minecraft version on the PC, returns true if successful
install(version, mclocation, multimcfolderloc, libsloc) 
{
	;Query the user first
	MsgBox, 4100, Version Not Installed!, This version of Minecraft is not installed on this computer, download from the server? (PLEASE BE PATIENT!)
	
	;If they press yes, copy the instance from the server to the local machine
	IfMsgBox, Yes
	{
		FileRemoveDir,  %multimcfolderloc%\libraries, 1
		FileRemoveDir,  %multimcfolderloc%\meta, 1
		Sleep, 1000
		FileCopyDir, %mclocation%\%version%, %multimcfolderloc%\instances\%version%
		FileCopyDir, %libsloc%\libraries, %multimcfolderloc%\libraries
		FileCopyDir, %libsloc%\meta, %multimcfolderloc%\meta
		
		return true
	}
	
	;If they press no, just stop here and exit
	IfMsgBox, No
		ExitApp
}

;Ensures the user has the same instance version as the server. This allows you to update the launcher/instance without having to go round every PC! It will simply redownload if it detects a different version
update(version, mclocation, libsloc, multimcfolderloc) 
{
	mcdirtype = minecraft
	svrdirtype = minecraft
	
	;Firstly check if it's '.minecraft' or just 'minecraft' on client and server
	IfExist, %multimcfolderloc%\instances\%version%\.minecraft
		mcdirtype = .minecraft
		
	IfExist, %mclocation%\%version%\.minecraft
		svrdirtype = .minecraft

	;This method can be used to force all client PC's to download a new version from the server. Simply change 'modversion.ini' at %mclocation%\%version%\minecraft\modversion.ini to a new number and watch the magic happen!
	IfExist, %multimcfolderloc%\instances\%version%\%mcdirtype%\modversion.ini
	{
		;Firstly read the version number on the PC and the Server
		IniRead, pcver, %multimcfolderloc%\instances\%version%\%mcdirtype%\modversion.ini, ModlistVersion, version
		IniRead, currentver, %mclocation%\%version%\%svrdirtype%\modversion.ini, ModlistVersion, version
		
		;If they don't match, wipe the client install and redownload it
		if (currentver!=pcver)
		{
			Progress, 20, Installing new updated version, Starting up launcher. Please Wait...,Mod Playground
			FileRemoveDir,  %multimcfolderloc%\instances\%version%, 1
			FileRemoveDir,  %multimcfolderloc%\libraries, 1
			FileRemoveDir,  %multimcfolderloc%\meta, 1
			FileRemoveDir,  %multimcfolderloc%\versions, 1
			FileCopyDir, %mclocation%\%version%, %multimcfolderloc%\instances\%version%
			FileCopyDir, %libsloc%\libraries, %multimcfolderloc%\libraries
			FileCopyDir, %libsloc%\meta, %multimcfolderloc%\meta
			FileCopyDir, %libsloc%\versions, %multimcfolderloc%\versions
		}
		else
			Progress, 20, Latest version found, Starting up launcher. Please Wait...,Mod Playground
	}
	;Or if the version file doesn't exist at all, also wipe and redownload
	else
	{
		Progress, 20, Installing new updated version, Starting up launcher. Please Wait...,Mod Playground
		FileRemoveDir,  %multimcfolderloc%\instances\%version%, 1
		FileRemoveDir,  %multimcfolderloc%\libraries, 1
		FileRemoveDir,  %multimcfolderloc%\meta, 1
		FileRemoveDir,  %multimcfolderloc%\versions, 1
		FileCopyDir, %mclocation%\%version%, %multimcfolderloc%\instances\%version%
		FileCopyDir, %libsloc%\libraries, %multimcfolderloc%\libraries
		FileCopyDir, %libsloc%\meta, %multimcfolderloc%\meta
		FileCopyDir, %libsloc%\versions, %multimcfolderloc%\versions
	}
}

;Returns true if a minecraft instance is installed correctly, false otherwise
exist(version, spacetolerance, multimcfolderloc) 
{
	;Check Instance exists
	IfExist, %multimcfolderloc%\instances\%version%
	{
		;Check minecraft is the estimated right size for the instance, which it always should be
		space = 0
		Loop, %multimcfolderloc%\instances\%version%\*.*, , 1
			space += %A_LoopFileSize%
		space /= 1048576 ;Find Space in MB
		if (space < spacetolerance)
		{
			;If it isn't the right size, wipe the directory and start again
			MsgBox, Space wrong size - Removing dir
			FileRemoveDir, %multimcfolderloc%\instances\%version%, 1
			return false
		}
		else
			return true ;If all these conditions are met...(try to) launch minecraft!
	}
	else
		return false
}

;addBackupWorlds(savefilesloc, version, 1, multimcfolderloc, 1, 0, minecraftdirtype)
;This function adds the users' worlds to the backup GUI and/or maps GUI, however it can also wipe the local saves if needed (e.g when the script is initially run e.g.)
addBackupWorlds(savefilesloc, version, removedir, multimcfolderloc, backupsEnabled, uploadbutton, mcdirtype)
{

	;Delete anything in the list from a previous run on the backup GUI (if it's enabled), also set the backup GUI as the default, this is necessary to make 'LV_Add' work correctly
	if backupsEnabled = 1
	{
		Gui, 3:Default
		LV_Delete()
	}
	
	;If launched at the start of the program, wipe the local save dir. This is to stop tonnes of worlds all taking up space on the client PCs!
	if removedir = 1
	{
		;Remove all local saves and junk
		FileRemoveDir, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves, 1
	
		FileCreateDir, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves
		Sleep 500
		
	}
	;If launched via the refresh button, DON'T DELETE local saves. Instead search the local folder and see what we can find!
	else
	{
		;Find all worlds on the local machine, count them and add to a variable 'localsaves'
		localsaves =
		countlocalsaves = 0
		Loop, Files, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\*.*, D
		{
			if localsaves =
			{
				localsaves := A_LoopFileName
				countlocalsaves++
			}
			else
			{
				localsaves := localsaves . "|" . A_LoopFileName
				countlocalsaves++
			}
		}
	}
	
	;If Backups are enabled, we'll look to have a look at the server too for saves
	if backupsEnabled = 1
	{
		;Find all worlds on the server, add all to a variable 'serversaves'
		serversaves =
		countserversaves = 0
		progressval = 60
		Loop, Files, %savefilesloc%\%A_UserName%\*.*, D
		{
			if serversaves =
			{
				serversaves := A_LoopFileName
				countserversaves++
			}
			else
			{
				serversaves := serversaves . "|" . A_LoopFileName
				countserversaves++
			}
			
			;If launched at the start of the script, copy all worlds down from the server, to the local machine. This is ignored if the refresh button is pressed!
			if removedir = 1
			{
				;Download each one to the local machine if it doesn't exist yet (it shouldn't exist since we deleted it earlier, but this is just a precaution)
				IfNotExist, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%A_LoopFileName% 
				{
					FileCopyDir, %savefilesloc%\%A_UserName%\%A_LoopFileName%, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%A_LoopFileName%
					
					;Don't show the progress bar if we're just using the upload button
					if uploadbutton = 0
						Progress, %progressval%, Downloading %A_LoopFileName%, Starting up launcher. Please Wait...,Mod Playground
				}
				;If it does exist, check if there's a newer version on the server. If a newer version is found, delete the local copy and download the server copy.
				else
				{
					;If for some reason the server copy doesn't have a 'level.dat', don't copy it!
					FileGetTime, servermodtime, %savefilesloc%\%A_UserName%\%A_LoopFileName%\level.dat
					if Errorlevel = 0
					{
						FileGetTime, localmodtime, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%A_LoopFileName%\level.dat
						if servermodtime > %localmodtime%
						{
							FileRemoveDir, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%A_LoopFileName%, 1
							FileCopyDir, %savefilesloc%\%A_UserName%\%A_LoopFileName%, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%A_LoopFileName%
							
							;Don't show the progress bar if we're just using the upload button
							if uploadbutton = 0
								Progress, %progressval%, Downloading %A_LoopFileName%, Starting up launcher. Please Wait...,Mod Playground
						}
					}
				}
			}
			;Increment the counter for the progress bar each time, so it keeps moving!
			progressval += 6
		}

		;Loop through worlds on the server, add them to the listview GUI with a check to show that they're already backed up
		if countserversaves > 0
		{
			if countserversaves = 1
			{
				LV_Add("Check", serversaves)
			}
			else
			{
				Loop, Parse, serversaves, |
					LV_Add("Check", A_LoopField)
			}
		}
		
		;If the refresh button is pressed, we'll need to search the local machine too for new worlds
		if removedir = 0
		{
			/*
		
			This section below is a bit of a monster! Basically, we've already got the users' server worlds in the backup GUI list, however we also need to add saves on the local machine... but we don't want to add the same world twice! A world could be on both the local machine and the server.
			
			Therefore we have to go through a few different situations to ensure that every world appears correctly and only ONCE in the list.
			
			We know how many SERVER saves there are, and we know how many LOCAL saves there are, so we can easy eliminate a few situations such as when there are 0 server saves or 0 local saves.
			
			We could have some kind of double loop, (and I have added this for the case where there is more than 1 local and more than 1 server save)... but this isn't necessary most of the time.
		
			*/
			if countlocalsaves > 0
			{
				;Cases where there is only 1 local save
				if countlocalsaves = 1
				{
					;1 local save, 0 server saves. Just add the local save since it won't conflict
					if countserversaves = 0
						LV_Add(, localsaves)
					;1 local save, 1 server save. Check they're not the same, if they aren't, add them both.
					if countserversaves = 1
					{
						if serversaves != %localsaves%
							LV_Add(, localsaves)
					}
					;1 local save, >1 server saves, need to loop through every server save to check it's not the same as the local save. If all are different, add the local save
					if countserversaves > 1
					{
						i = 0
						Loop, Parse, serversaves, |
						{
							if A_LoopField = %localsaves%
								i++
						}	
						if i = 0
							LV_Add(, localsaves)
					}
				}
				
				;Cases where there is more than 1 local save
				else
				{
					;>1 local save, 0 server saves. Add all local saves as they won't conflict
					if countserversaves = 0
					{
						Loop, Parse, localsaves, |
							LV_Add(, A_LoopField)
					}
					;>1 local save, 1 server save. Loop through local saves and check they aren't the same as the server save
					if countserversaves = 1
					{
						Loop, Parse, localsaves, |
						{
							if A_LoopField != %serversaves%
								LV_Add(, A_LoopField)
						}
					}
					;>1 local save, >1 server save. This is more complex! It is a double loop that loops through both server and local saves at the same time and checks every local world against every server world to ensure they are different!
					if countserversaves > 1
					{
						currentlocal =
						Loop, Parse, localsaves, |
						{
							i = 0
							currentlocal := A_LoopField
							Loop, Parse, serversaves, |
							{
								if A_LoopField = %currentlocal%
									i++
							}
							if i = 0
								LV_Add(, currentlocal)
						}
						
					}
				}
			}
		}
	}
	
	;Set main GUI back to default and then also add all server or local worlds to the 'maps' tab
	Gui, 1:Default
	if backupsEnabled = 1
		GuiControl, 1:, MapSavesList, |%serversaves%|
	else
		GuiControl, 1:, MapSavesList, |%localsaves%|
	return
}

;This is the main backup function that's run when the user presses the 'backup' button
backup(savefilesloc, version, multimcfolderloc)
{

	mcdirtype = minecraft
	svrdirtype = minecraft
	
	;Firstly check if it's '.minecraft' or just 'minecraft' on client and server
	IfExist, %multimcfolderloc%\instances\%version%\.minecraft
		mcdirtype = .minecraft
		
	IfExist, %mclocation%\%version%\.minecraft
		svrdirtype = .minecraft
		
	;Reset variables
	rownum = 0  
	checkedworldscount = 0
	backupworlds =
	
	;Go through the backup GUI worlds list and find all worlds that have been ticked (either by default, or by the user)
	Loop
	{
		rownum := LV_GetNext(rownum, "C")  ; Resume the search at the row after that found by the previous iteration.
		if not rownum  ; The above returned zero, so there are no more selected rows.
			break
		LV_GetText(checkedworld, rownum)
		if checkedworldscount = 0
			backupworlds := checkedworld
		else
			backupworlds := backupworlds . "|" . checkedworld
		checkedworldscount += 1
	}
	
	;If they haven't ticked anything, confirm with the user
	if checkedworldscount = 0
	{
		MsgBox, 49, No worlds selected!, No worlds have been selected for backup! If you continue, any backups will be removed. (Your worlds will still be on this computer).
		IfMsgBox, Cancel
			return
		else
		{
			Loop, Files, %savefilesloc%\%A_UserName%\*.*, D
				FileRemoveDir, %savefilesloc%\%A_UserName%\%A_LoopFileName%, 1
			MsgBox, Backups removed.
			return
		}
	}
	
	;Can't backup more than 5 worlds, sorry!
	if checkedworldscount > 5
	{
		MsgBox, 16, Too many worlds!, You can only backup up to 5 different worlds! Please remove some worlds first.
		return
	}
	
	;Check with user
	MsgBox, 33, Confirm Backup, Backup %checkedworldscount% world(s)?
	IfMsgBox, Ok
	{
		GuiControl, 3:, Backup, Backing up...
		GuiControl, 3:Disable, Backup
		
		;First delete all worlds from the server, unless that world has been deleted manually by the user
		Loop, Files, %savefilesloc%\%A_UserName%\*.*, D
		{
			IfExist, %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%A_LoopFileName%
				FileRemoveDir, %savefilesloc%\%A_UserName%\%A_LoopFileName%, 1
			else
				MsgBox, 16, Error!, Can't find the world '%A_LoopFileName%' on the local machine to back it up. Maybe you deleted it? This world has NOT been backed up but still exists in your saves.
		}
		
		;Now copy worlds back that the user selected
		if checkedworldscount = 1
			FileCopyDir,  %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%backupworlds%, %savefilesloc%\%A_UserName%\%backupworlds%
		else
		{
			Loop, Parse, backupworlds, |
				FileCopyDir,  %multimcfolderloc%\instances\%version%\%mcdirtype%\saves\%A_LoopField%, %savefilesloc%\%A_UserName%\%A_LoopField%
		}
	}
	else
		return
	
	MsgBox, Backup complete!
	GuiControl, 3:Enable, Backup
	GuiControl, 3:, Backup, Backup Now
	return
}

;This function searches the global modsLists and tries to find new recently added mods. If it finds them, it'll add them to the input list (so they don't get missed when the script auto-loads the last save)
detectNewMods(modsin, modsin2, modtype)
{
	;Need the global mods lists
	global modsTech
	global modsCreative
	global modsMagic
	global modsOther
	
	;Convert both inputs to comma separated items, so they are searchable
	comlist := StrReplace(modsin, "|", ",")
	comlist2 := StrReplace(modsin2, "|", ",")
	
	;Remove last character (the comma), to prevent issues
	comlist := SubStr(comlist, 1, -1)
	comlist2 := SubStr(comlist2, 1, -1)
	
	modsAdd =
	modsAddNum = 0
	
	;Loop through them
	Loop, Parse, mods%modtype%, `,
	{
		if A_LoopField not in %comlist%
		{
			if A_LoopField not in %comlist2%
			{
				if modsAddNum = 0
					modsAdd := A_LoopField
				else
					modsAdd := modsAdd . "|" . A_LoopField
					
				modsAddNum++
			}

		}
	}
	
	;Now turn it back into pipe separated items
	comlist := StrReplace(comlist, ",", "|")
	
	if modsAddNum > 0
		finallist := comlist . "|" . modsAdd . "|"
	else
		finallist := comlist . "|"
	
	;If the input is/was blank, return nothing, this is to fix a small bug
	if finallist =|
		finallist =
	
	;Finally, return the amended list
	return finallist
}

;This function below is someone's elses, it's used to make fancy picture based buttons. Yep it looks mega complicated in comparison to my code, shows how mediocre I am at coding! All I know is that it works!!
; ******************************************************************* 
; AddGraphicButton.ahk 
; ******************************************************************* 
; Version: 2.2 Updated: May 20, 2007 
; by corrupt 
; ******************************************************************* 
; VariableName = variable name for the button 
; ImgPath = Path to the image to be displayed 
; Options = AutoHotkey button options (g label, button size, etc...) 
; bHeight = Image height (default = 32) 
; bWidth = Image width (default = 32) 
; ******************************************************************* 
; note: 
; - calling the function again with the same variable name will 
; modify the image on the button 
; ******************************************************************* 
AddGraphicButton(VariableName, ImgPath, Options="", bHeight=32, bWidth=32) 
{ 
	Global 
	Local ImgType, ImgType1, ImgPath0, ImgPath1, ImgPath2, hwndmode 
	; BS_BITMAP := 128, IMAGE_BITMAP := 0, BS_ICON := 64, IMAGE_ICON := 1 
	Static LR_LOADFROMFILE := 16 
	Static BM_SETIMAGE := 247 
	Static NULL 
	SplitPath, ImgPath,,, ImgType1 
	If ImgPath is float 
	{ 
	  ImgType1 := (SubStr(ImgPath, 1, 1)  = "0") ? "bmp" : "ico" 
	  StringSplit, ImgPath, ImgPath,`. 
	  %VariableName%_img := ImgPath2 
	  hwndmode := true 
	} 
	ImgTYpe := (ImgType1 = "bmp") ? 128 : 64 
	If (%VariableName%_img != "") AND !(hwndmode) 
	  DllCall("DeleteObject", "UInt", %VariableName%_img) 
	If (%VariableName%_hwnd = "") 
	  Gui, Add, Button,  v%VariableName% hwnd%VariableName%_hwnd +%ImgTYpe% %Options% 
	ImgType := (ImgType1 = "bmp") ? 0 : 1 
	If !(hwndmode) 
	  %VariableName%_img := DllCall("LoadImage", "UInt", NULL, "Str", ImgPath, "UInt", ImgType, "Int", bWidth, "Int", bHeight, "UInt", LR_LOADFROMFILE, "UInt") 
	DllCall("SendMessage", "UInt", %VariableName%_hwnd, "UInt", BM_SETIMAGE, "UInt", ImgType,  "UInt", %VariableName%_img) 
	Return, %VariableName%_img ; Return the handle to the image 
}

;Runs first time setup GUI, allows the user to enter needed fields. Works alongside 'SaveConfig' method above.
firstsetup(configloc)
{
	global
	
	;Test for Java
	progfiles86 := A_ProgramFiles . " (x86)"
	IfNotExist %A_ProgramFiles%\Java
	{
		IfNotExist, %progfiles86%\Java
		{
			MsgBox, 17, No Java Detected!, Java was not detected on this machine in either '%A_ProgramFiles%\Java' or '%progfiles86%\Java'`n`nMinecraft will not run without Java! Please download and install this from the Java website (both 32-bit and 64-bit versions recommended).`n`nContinue anyway?
			IfMsgBox, Cancel
				ExitApp
		}
	}
	
	configsaved = False
	
	;Is the PC on a domain? If it is, setup the default GUI slightly differently. (Code belongs to 'Learning one' - https://autohotkey.com/board/topic/77940-detect-current-windows-domain/)
	objWMIService := ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" A_ComputerName "\root\cimv2")
	For objComputer in objWMIService.ExecQuery("Select * from Win32_ComputerSystem") {
	   Domain := objComputer.Domain, Workgroup := objComputer.Workgroup
	}

	;Msgbox %  Domain "`n"  Workgroup
	
	domainpc = False
	;This should work in all situations unless the actual name of the domain is 'WORKGROUP'. Lets hope that doesn't happen....!!
	if Domain != WORKGROUP
		domainpc = True

	;Create first setup GUI
	Gui, 5:Font,norm s30 w700,Calibri Light
	Gui, 5:Add, Text, x10 y5 w600 h60 cGreen Center, Minecraft Mod Playground!
	Gui, 5:Font,norm s14 w700,Calibri Light
	Gui, 5:Add, Text, x10 y60 w580 h80, Please fill in the locations for all the fields below. 
	Gui, 5:Font,norm s12,Calibri Light
	Gui, 5:Add, Text, x10 y90 w580 h80, If you're running this program over a LAN for multiple users, please ensure you put the program and any resources it needs in a directory that all clients can read from!
	Gui, 5:Add, Text, x10 y140 w580 h80, MultiMC is located in:
	Gui, 5:Add, Edit, x10 y160 w500 h25 vmmloc +Left, C:\MultiMC
	Gui, 5:Add, Checkbox, x10 y185 w500 h30 vInstallMMC Checked, Install MultiMC automatically in this location (if it doesn't exist)
	Gui, 5:Add, Text, x10 y220 w580 h80, Resources for Mod Playground (Mods/Resources/Libraries/Instances) are in:
	Gui, 5:Add, Checkbox, x10 y285 w220 h25 vSavesEnabled Checked gTogglesaveloc, Enable autosaving mod lists
	Gui, 5:Add, Text, x10 y310 w580 h80, Client autosaves, world backup data and stats is saved in:
	Gui, 5:Add, Text, x10 y330 w580 h80 cRed, (Users/Script must have read AND write access to this location)
	Gui, 5:Add, Checkbox, x10 y395 w220 h25 vRegistersEnabled gToggleregloc, Enable registers
	Gui, 5:Add, Text, x10 y420 w580 h80, Register data is saved in:
	Gui, 5:Add, Text, x10 y440 w580 h80 cRed, (Users/Script must have read AND write access to this location)
	Gui, 5:Add, Checkbox, x10 y500 w250 h25 vTimelock gTimelock, Allow access only at certain times
	Gui, 5:Add, Text, x10 y525 w300 h25, Users can launch Mod Playground between
	Gui, 5:Add, DateTime, x298 y520 w60 h25 vTimelockStart 1 Choose20000101120000, HH:mm
	Gui, 5:Add, Text, x364 y525 w300 h25, and
	Gui, 5:Add, DateTime, x394 y520 w60 h25 vTimelockEnd 1 Choose20000101140000, HH:mm
	Gui, 5:Add, Checkbox, x10 y560 w250 h25 vOfflineMode gOfflineMode, Force offline mode
	Gui, 5:Add, Text, x10 y585 w580 h80, Valid Minecraft login email address to use for all users:
	Gui, 5:Add, Edit, x10 y605 w500 h25 vofflineemail +Left, minecraftemailaddress@test.com
	Gui, 5:Font,norm s10,Calibri Light
	Gui, 5:Add, Button, x515 y160 w60 h25 vBrowseMMC gSelectFolder, Browse...
	Gui, 5:Add, Button, x515 y240 w60 h25 vBrowseRes gSelectFolder, Browse...
	Gui, 5:Add, Button, x515 y350 w60 h25 vBrowseSav gSelectFolder, Browse...
	Gui, 5:Add, Button, x515 y460 w60 h25 vBrowseReg gSelectFolder, Browse...
	Gui, 5:Font,norm s14,Calibri Light
	Gui, 5:Add, Button, x10 y650 w100 h50 gSaveConfig, Save
	Gui, 5:Font,norm s12,Calibri Light
	
	;If it's a PC on a specific domain, users will probably want to use a shared folder and some of the more advanced features. Set this to be the default.
	if domainpc = True
	{
		Gui, 5:Add, Edit, x10 y240 w500 h25 vmploc +Left, SharedFolder\Mod Playground
		Gui, 5:Add, Edit, x10 y350 w500 h25 vsaveloc +Left, SharedFolder\Mod Playground Saves
		Gui, 5:Add, Edit, x10 y460 w500 h25 vregloc +Left, SharedFolder\Mod Playground Registers
		Gui, 5:Add, Checkbox, x230 y285 w190 h25 vBackupsEnabled gTogglesaveloc Checked, Enable backup manager
		Gui, 5:Add, Checkbox, x420 y285 w220 h25 vStatsEnabled gTogglesaveloc Checked, Enable usage stats
	}
	
	;Otherwise, just use the 'My Documents' folder (and disable the advanced features), unless the user wants to change it
	else
	{
		Gui, 5:Add, Edit, x10 y240 w500 h25 vmploc +Left, %A_MyDocuments%\Mod Playground
		Gui, 5:Add, Edit, x10 y350 w500 h25 vsaveloc +Left, %A_MyDocuments%\Mod Playground\Saves
		Gui, 5:Add, Edit, x10 y460 w500 h25 vregloc +Left, %A_MyDocuments%\Mod Playground\Registers
		Gui, 5:Add, Checkbox, x230 y285 w190 h25 vBackupsEnabled gTogglesaveloc, Enable backup manager
		Gui, 5:Add, Checkbox, x420 y285 w220 h25 vStatsEnabled gTogglesaveloc, Enable usage stats
	}
	
	GuiControl, 5:Disable, regloc
	GuiControl, 5:Disable, BrowseReg
	GuiControl, 5:Disable, TimelockStart
	GuiControl, 5:Disable, TimelockEnd
	GuiControl, 5:Disable, offlineemail
	
	;If the user has removed the MultiMC folder/executable for whatever reason, we can't install it. Warn the user.
	IfNotExist, MultiMC/MultiMC.exe
	{
		GuiControl, 5:, InstallMMC, Error`, MultiMC.exe not found. Please install manually!
		GuiControl, 5:, InstallMMC, 0
		GuiControl, 5:Disable, InstallMMC
	}
	
	Gui, 5:Show, w600 h710,First Time Setup
	
	WinWaitClose, First Time Setup
	
	;If the user exited but didn't press 'Save', exit the program
	if configsaved = False
		ExitApp
	
	return
}

;Reads needed variables from the config file for use in the program
setupVars(configloc, configdir)
{
	global
	
	;Read all data from the found config file
	IniRead, multimcfolderloc, %configloc%, Mod Playground Configuration File, MultiMC Location
	IniRead, mploc, %configloc%, Mod Playground Configuration File, Mod Playground Resource Location
	IniRead, mclocation, %configloc%, Mod Playground Configuration File, Instances Location
	IniRead, modfilesloc, %configloc%, Mod Playground Configuration File, Mods Location
	IniRead, modpicsloc, %configloc%, Mod Playground Configuration File, Images Location
	IniRead, libsloc, %configloc%, Mod Playground Configuration File, Libraries Location
	IniRead, mapsloc, %configloc%, Mod Playground Configuration File, Custom Maps Location
	IniRead, savefilesloc, %configloc%, Mod Playground Configuration File, User Save Data Location
	lastrunsave = %savefilesloc%\%A_UserName%\lastrun.txt
	IniRead, registerloc, %configloc%, Mod Playground Configuration File, Register Location
	
	;Read checkboxes
	IniRead, SavesEnabled, %configloc%, Mod Playground Configuration File, AutoSaves
	IniRead, BackupsEnabled, %configloc%, Mod Playground Configuration File, Backup Manager
	IniRead, StatsEnabled, %configloc%, Mod Playground Configuration File, Stats
	IniRead, RegistersEnabled, %configloc%, Mod Playground Configuration File, Registers
	IniRead, OfflineMode, %configloc%, Mod Playground Configuration File, Offline
	IniRead, offlineemail, %configloc%, Mod Playground Configuration File, Email Addr
	IniRead, Timelock, %configloc%, Mod Playground Configuration File, Timelock
	IniRead, TimelockStart, %configloc%, Mod Playground Configuration File, Timelock Start
	IniRead, TimelockEnd, %configloc%, Mod Playground Configuration File, Timelock End

	;Check the config file is readable
	if multimcfolderloc = ERROR
	{
		MsgBox, 16, Error!, Bad or non-existent config file at %configloc%`n`nPlease delete it and re-run the Mod Playground.
		ExitApp
	}
	
	;Lets check each folder actually exists before we start the main program!
	IfNotExist, %multimcfolderloc%\MultiMC.exe
		MsgBox, 16, Error!, MultiMC.exe cannot be found inside %multimcfolderloc%.`n`nIs your config file correct or did you forget to install it? Minecraft will not run until MultiMC is installed!`n`nIf you want to re-run first time setup, please delete the config file.
		
	IfNotExist, %mploc%
	{
		MsgBox, 16, Error!, Resource directory not found at: %mploc%.`n`nIs your config file correct? Try deleting it to force first time setup again.
		ExitApp
	}
	IfNotExist, %mclocation%
	{
		MsgBox, 16, Error!, Instances directory not found at: %mclocation%.`n`nIs your config file correct? Try deleting it to force first time setup again.
		ExitApp
	}
	IfNotExist, %modfilesloc%
	{
		MsgBox, 16, Error!, Mod Jar Files directory not found at: %modfilesloc%.`n`nIs your config file correct? Try deleting it to force first time setup again.
		ExitApp
	}
	IfNotExist, %modpicsloc%
	{
		MsgBox, 16, Error!, Images directory not found at: %modpicsloc%.`n`nIs your config file correct? Try deleting it to force first time setup again.
		ExitApp
	}
	IfNotExist, %libsloc%
	{
		MsgBox, 16, Error!, Libraries directory not found at: %libsloc%.`n`nIs your config file correct? Try deleting it to force first time setup again.
		ExitApp
	}
	IfNotExist, %mapsloc%
	{
		MsgBox, 16, Error!, Custom Maps directory not found at: %mapsloc%.`n`nIs your config file correct? Try deleting it to force first time setup again.
		ExitApp
	}
	
	if Timelock = 1
	{
		if TimelockEnd <= %TimelockStart%
		{
			Timelock = 0
			MsgBox, 17, Error!, Timelock is enabled but end time is set to the same as (or earlier than) the start time!`n`nPlease fix this in the config file or re-run first time setup. Timelock has been disabled.`n`nContinue anyway?
			IfMsgBox, Cancel
				ExitApp
		}
	}
	
	totalbackssaves := SavesEnabled + BackupsEnabled + StatsEnabled
	if totalbackssaves > 0
	{
		IfNotExist, %savefilesloc%
		{
			MsgBox, 17, Error!, User Save Data directory not found at: %savefilesloc%.`n`nIs the config file correct? Or maybe this user doesn't have permission to access this folder?`n`nContinue anyway? (Saves, Backups and Usage Stats will not work!)
			IfMsgBox, Cancel
				ExitApp
		}
	}
	if RegistersEnabled = 1
	{
		IfNotExist, %registerloc%
		{
			MsgBox, 17, Error!, Register Data directory not found at: %registerloc%.`n`nIs the config file correct? Or maybe this user doesn't have permission to access this folder?`n`nContinue anyway? (Registers will not work!)
			IfMsgBox, Cancel
				ExitApp
		}
	}
	IfNotExist, %configdir%\mppwd.txt
	{
		MsgBox, 16, Error!, Password file not found at: %configdir%\mppwd.txt.`n`nPlease delete the cfg.ini file and then run first time setup again.
		ExitApp
	}
	
	return
}

; Just because we're not a bank doesn't mean we should compromise on security
; https://github.com/jNizM/AHK_CNG/blob/master/src/hash/func/bcrypt_sha256.ahk
bcrypt_sha256(string, encoding := "utf-8")
{
    static BCRYPT_SHA256_ALGORITHM := "SHA256"
    static BCRYPT_OBJECT_LENGTH    := "ObjectLength"
    static BCRYPT_HASH_LENGTH      := "HashDigestLength"

	try
	{
		; loads the specified module into the address space of the calling process
		if !(hBCRYPT := DllCall("LoadLibrary", "str", "bcrypt.dll", "ptr"))
			throw Exception("Failed to load bcrypt.dll", -1)

		; open an algorithm handle
		if (NT_STATUS := DllCall("bcrypt\BCryptOpenAlgorithmProvider", "ptr*", hAlg, "ptr", &BCRYPT_SHA256_ALGORITHM, "ptr", 0, "uint", 0) != 0)
			throw Exception("BCryptOpenAlgorithmProvider: " NT_STATUS, -1)

		; calculate the size of the buffer to hold the hash object
		if (NT_STATUS := DllCall("bcrypt\BCryptGetProperty", "ptr", hAlg, "ptr", &BCRYPT_OBJECT_LENGTH, "uint*", cbHashObject, "uint", 4, "uint*", cbData, "uint", 0) != 0)
			throw Exception("BCryptGetProperty: " NT_STATUS, -1)

		; allocate the hash object
		VarSetCapacity(pbHashObject, cbHashObject, 0)
		;	throw Exception("Memory allocation failed", -1)

		; calculate the length of the hash
		if (NT_STATUS := DllCall("bcrypt\BCryptGetProperty", "ptr", hAlg, "ptr", &BCRYPT_HASH_LENGTH, "uint*", cbHash, "uint", 4, "uint*", cbData, "uint", 0) != 0)
			throw Exception("BCryptGetProperty: " NT_STATUS, -1)

		; allocate the hash buffer
		VarSetCapacity(pbHash, cbHash, 0)
		;	throw Exception("Memory allocation failed", -1)

		; create a hash
		if (NT_STATUS := DllCall("bcrypt\BCryptCreateHash", "ptr", hAlg, "ptr*", hHash, "ptr", &pbHashObject, "uint", cbHashObject, "ptr", 0, "uint", 0, "uint", 0) != 0)
			throw Exception("BCryptCreateHash: " NT_STATUS, -1)

		; hash some data
		VarSetCapacity(pbInput, (StrPut(string, encoding) - 1) * ((encoding = "utf-16" || encoding = "cp1200") ? 2 : 1), 0) && cbInput := StrPut(string, &pbInput, encoding) - 1
		if (NT_STATUS := DllCall("bcrypt\BCryptHashData", "ptr", hHash, "ptr", &pbInput, "uint", cbInput, "uint", 0) != 0)
			throw Exception("BCryptHashData: " NT_STATUS, -1)

		; close the hash
		if (NT_STATUS := DllCall("bcrypt\BCryptFinishHash", "ptr", hHash, "ptr", &pbHash, "uint", cbHash, "uint", 0) != 0)
			throw Exception("BCryptFinishHash: " NT_STATUS, -1)

		loop % cbHash
			hash .= Format("{:02x}", NumGet(pbHash, A_Index - 1, "uchar"))
	}
	catch exception
	{
		; represents errors that occur during application execution
		throw Exception
	}
	finally
	{
		; cleaning up resources
		if (pbInput)
			VarSetCapacity(pbInput, 0)
		if (hHash)
			DllCall("bcrypt\BCryptDestroyHash", "ptr", hHash)
		if (pbHash)
			VarSetCapacity(pbHash, 0)
		if (pbHashObject)
			VarSetCapacity(pbHashObject, 0)
		if (hAlg)
			DllCall("bcrypt\BCryptCloseAlgorithmProvider", "ptr", hAlg, "uint", 0)
		if (hBCRYPT)
			DllCall("FreeLibrary", "ptr", hBCRYPT)
	}

	return hash
}
;My mod update function. This works alongside 'cfwidget.com' to find new versions and mods and then download them to the appropriate directory, ready for the main program to copy them into the instance later/when needed.
modsUpdate(modfilesloc)
{
	;Variable that contains all data to write to the 'UpdateLog.txt' at the end of the program
	writetext =
	
	;Firstly, quickly count the number of directories, so we can have a nice progress bar!
	totaldircount = 0
	Loop, Files, %modfilesloc%\*.*, D
	{
		totaldircount++
		percprog := 100/totaldircount
		;percprog := Round(percprog)
	}
	
	currentprogress = 0
	Progress, w400 h80 m a t, Updating Mods, Updating your Minecraft Mods. Please Wait...,Mod Playground
	Progress, %currentprogress%, Updating Mods, Updating your Minecraft Mods. Please Wait...,Mod Playground
	
	;Loop through every directory where the script is located
	Loop, Files, %modfilesloc%\*.*, D
	{
		outsidedir = %A_LoopFileName%
		updatemod = false
		modcounter = 0
		dontupdatemod = false
		modnotupdated =
		skipdelete = false
		modnamearray := []
		idarray := []
		
		countjar = 0
		
		currentprogress := percprog + currentprogress
		Progress, %currentprogress%, Checking %outsidedir% for updates, Updating your Minecraft Mods. Please Wait...,Mod Playground
		
		;Quickly loop through and check for any manual mods, need to warn the user if so
		Loop, Files, %modfilesloc%\%outsidedir%\*.url, F
		{
			modname := SubStr(A_LoopFileName, 1, -4)
			firstchars := SubStr(modname, 1, 13)
			if firstchars = MANUAL UPDATE
				skipdelete = true
		}
		
		;Count how many .jar files there are in each mods' directory. If there's none, ALWAYS force an update without even questioning the user.
		Loop, Files, %modfilesloc%\%outsidedir%\*.jar, F
		{
			countjar++
		}
		
		;In each directory, look for the '.url' shortcut files, get the name of each one and put it in 'modname'
		Loop, Files, %modfilesloc%\%outsidedir%\*.url, F
		{
			modname := SubStr(A_LoopFileName, 1, -4)
			
			;If we've previously selected NOT to update a file in a mod (set below), skip all the other files in this mod too, to prevent issues
			if dontupdatemod = false
			{
				;Increment counter per mod, so we know how many mods each folder is *meant* to have inside it
				modcounter++
				oldmod = false
				
				;Check for manual update mods
				firstchars := SubStr(modname, 1, 13)
				
				;If the shortcut file has 'MANUAL UPDATE' at the start, ignore this mod entirely. These can be renamed as and when required. Some mods do not use CurseForge and therefore cannot be updated automatically :(
				if firstchars != MANUAL UPDATE
				{
					;Replace all spaces in the modname with dashes, CurseForge does this automatically so we need to also, otherwise script won't find the mod
					modname := StrReplace(modname, A_Space, "-")

					
					
					;Needed variables, don't change if possible!
					searchver = "1.12.2"
					searchver2 = "1.12.1"
					urlver = "url":
					jarname = "name":
					fullurl = https://api.cfwidget.com/minecraft/mc-mods/%modname%
					speechmark = "
					;"
					
					;Used to count the number of attempts we've had to find the mod online. The script will give up if it tries 5 times and is still getting an 'error' response from the website API
					i = 0
					
					
					RetryGet:
					
					;Look online and download the text found at 'https://api.cfwidget.com/mc-mods/minecraft/%modname%' to a variable 'cursedata'
					whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
					whr.Open("GET", fullurl, true)
					whr.Send()
					whr.WaitForResponse()
					cursedata := whr.ResponseText
					
					errortest := SubStr(cursedata, 3, 5)
					if errortest = error
					{
						if i < 5
						{
							Sleep 3000
							if i = 3
								fullurl = https://api.cfwidget.com/mc-mods/minecraft/%modname%
							i++
							Goto, RetryGet
						}
						
						;If we've tried 4 times and still are getting 'error' from the website, give up on this mod, break out the loop
						else
						{
							writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". ERROR, I can't find this file after 5 attempts, maybe check the name of the .url file? If this error is persistent for this mod, maybe change it to manual update and update the mod yourself."
							break
						}
					}

					
					;BELOW IS A LOT OF FORMATTING TO TRY AND FIND THE CORRECT DOWNLOAD ID!

					;Search all the text (from left to right) for the most recent 1.12.2 file
					verpos := InStr(cursedata, searchver)
					
					;If there's no 1.12.2 file, try to search for a 1.12.1 file instead
					if verpos = 0
					{
						verpos := InStr(cursedata, searchver2)
						
						;If we find a 1.12.1 file, mark this mod as 'old'. It *might* work!
						if verpos != 0
							oldmod = true
						
						;If we still can't find a 1.12.1 file, give up. This mod won't be compatible!
						else
						{
							writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". ERROR, I can't find this file, maybe there's no 1.12.2 version? If this error is persistent for this mod, maybe change it to manual update."
							break
						}
					}

					;Cut the text from that point
					cursedata := SubStr(cursedata, 1, verpos)

					;Now search from right to left, for the closest URL
					urlpos := (InStr(cursedata, urlver,,0) + 7)

					;Cut backwards from that point
					cursedata := SubStr(cursedata, urlpos)

					;Quickly grab the name of the download jar before it disappears!
					namepos := (InStr(cursedata, jarname) + 8)
					namedata := SubStr(cursedata, namepos)

					speechpos := (InStr(namedata, speechmark) - 1)
					namedata := SubStr(namedata, 1, speechpos)
					
					;If for whatever reason we haven't found the name of the mod, give up and move on. This should never trigger, i.e. it should always be caught earlier. Left in purely for test purposes
					if namedata =
					{
						writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". ERROR, I can't find this file, misc error, maybe check the name?"
						break
					}

					;Replace all spaces with pluses in the jar name, CurseForge does this automatically so we need to also. Not sure if required.
					downloadedmodname := StrReplace(namedata, A_Space, "+")
					
					;We've now found the full filename of the latest '.jar' file. Put this in the array for looking at later (if user wants to update).
					modnamearray[modcounter] := downloadedmodname
					
					;Now cut forwards all the remaining junk by searching for a '"', to get the ID
					speechpos := (InStr(cursedata, speechmark) - 1)
					cursedata := SubStr(cursedata, 1, speechpos)

					;Now we've just got the basic URL which will be in the form: https:\/\/www.curseforge.com\/minecraft\/mc-mods\/rustic\/download\/2620608
					;Find the last slash and remove everything up to it, to get the ID
					slashpos := (InStr(cursedata, "/",,0) + 1)
					cursedata := SubStr(cursedata, slashpos)
					
					idarray[modcounter] := cursedata
					
					;If this jar does NOT already exist in the mod directory (for whatever reason), ask if the user wants to update
					IfNotExist, %modfilesloc%\%outsidedir%\%downloadedmodname%
					{
						;Check to see if the mod is for 1.12.1 (an old mod)
						if oldmod = true
						{
							MsgBox, 49, 1.12.1 Found, Mod: %outsidedir% and File: %modname% has a mod file but it's for Minecraft version 1.12.1 rather than 1.12.2. This should be fine as most 1.12.1 mods work also with 1.12.2, but if you experience issues with this mod maybe remove it or stop using it. Do you want to update it anyway?
							IfMsgBox, Cancel
							{
								writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". This mod has a new version but it's for 1.12.1 rather than 1.12.2. You chose not to update it."
								dontupdatemod = true
							}
						}
						
						;Else, the mod must be a new mod for 1.12.2
						else
						{
							;Ask the first time but if we've already updated one file for a mod, automatically update all the other files for that mod too - to prevent issues
							if updatemod = false
							{
								if countjar > 0
								{
									MsgBox, 4353, New file version for %outsidedir%!, Newer version for file %modname% found: %downloadedmodname%. Download?
									IfMsgBox, Cancel
									{
										writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". New updated file found but you chose NOT to download it: " downloadedmodname
										modnotupdated = %modname%
										dontupdatemod = true
									}
								}
							}

							;If the user doesn't want to update a file, don't update any files for that mod at all (skip without even prompting).
							if dontupdatemod = false
							{
								updatemod = true
								writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". New updated file downloaded: " downloadedmodname
							}
						}
									
					}
					else
					{
						;If latest version already found, add to UpdateLog.txt
						writetext := writetext . "`n" . "Mod: " outsidedir ". File: " modname ". Latest version of mod already found: " downloadedmodname
					}
				}
				else
				{
					;If manual update mod found, add to UpdateLog.txt
					modname := SubStr(modname, 17)
					writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". Mod set to manual download only, please update this yourself!"
				}
			}
			else
			{
				;If user chooses not to update first file in a mod, don't update any others, write this to UpdateLog.txt
				writetext := writetext . "`n" . "-Mod: " outsidedir ". File: " modname ". Ignored since you chose not to update another file necessary for this mod, file: " modnotupdated
			}
		}
		
		;If we need to update a mod, delete all the jars and then redownload updated ones
		if updatemod = true
		{
			Progress, %currentprogress%, Updating %outsidedir%, Updating your Minecraft Mods. Please Wait...,Mod Playground
			DeleteDir(modfilesloc, outsidedir, skipdelete)
			UpdateDir(modfilesloc, outsidedir, idarray, modnamearray, skipdelete)
		}
		
	}

	;Finally, delete the UpdateLog.txt if it already exists... and then write all the data to a new one
	IfExist, %modfilesloc%\UpdateLog.txt
		FileDelete, %modfilesloc%\UpdateLog.txt
	FileAppend, %writetext%, %modfilesloc%\UpdateLog.txt
	If ErrorLevel
	{
		MsgBox, 4112, Error 3, I can't seem to write to the 'UpdateLog.txt' file. Did you run me as an administrator?
		ExitApp
	}
	MsgBox, 4096, Update Finished!, Update Finished! Please check the UpdateLog.txt in Mod Directory for details.
	Progress, OFF
	return
}

;Deletes all jars in a mods directory, works with modsUpdate function
DeleteDir(modfilesloc, outsidedir, skipdelete)
{
	if skipdelete = false
		FileDelete, %modfilesloc%\%outsidedir%\*.jar
}

;Updates everything in a mods directory, works with modsUpdate function
UpdateDir(modfilesloc, outsidedir, idarray, modnamearray, skipdelete)
{
	loopcount = 1
	Loop, Files, %modfilesloc%\%outsidedir%\*.url, F
	{
		modname := SubStr(A_LoopFileName, 1, -4)
		modname := StrReplace(modname, A_Space, "-")
		currentid := idarray[loopcount]
		currentname := modnamearray[loopcount]
		
		;UNCOMMENT THE TWO LINES BELOW FOR DEBUG PURPOSES!
		;MsgBox, Downloading. outsidedir is %outsidedir%, modname is %modname%, loopcount is %loopcount%, currentid is %currentid% and currentname is %currentname%
		;MsgBox, Therefore I am downloading from: https://minecraft.curseforge.com/projects/%modname%/files/%currentid%/download and to: %outsidedir%\%currentname%
		IfNotExist, %modfilesloc%\%outsidedir%\%currentname%
		{
			UrlDownloadToFile, https://minecraft.curseforge.com/projects/%modname%/files/%currentid%/download, %modfilesloc%\%outsidedir%\%currentname%
			If ErrorLevel
				MsgBox, 4112, Error 2, I'm having trouble downloading this file: %modname% for mod %outsidedir%. Is this mod still available? Or did you forget to run me as an administrator? Skipping mod...
		}
		loopcount++
	}
	if skipdelete = true
		MsgBox, 4144, MANUAL MODS, Note that %outsidedir% has at least 1 manually updated mod and at least 1 automatically updated mod (that you have chosen to update). Automatically updated mods have been updated, but you will need to check the folder for this mod and remove any old versions yourself.`n`nIf you don't do this, you risk the entire mod causing issues or not working at all!
}

addCustomMods()
{
	;Need the global mods' lists, this function needs access to all global vars
	global
	
	;Parse through the data, adding mods as we go
	Loop, Parse, custommodslist, `n
	{
		;If first character in a line is a hash (or nothing), ignore that whole line (it's a comment!)
		if(SubStr(A_LoopField, 1, 1)) = "#"
			continue
		
		if(SubStr(A_LoopField, 1, 1)) = "`r"
			continue
			
		if(SubStr(A_LoopField, 1, 1)) = "`n"
			continue
			
		if(SubStr(A_LoopField, 1, 1)) = ""
			continue
		
		;Split the line into 5 parts - the name, category, imgsrc, url and description
		custommodarray := StrSplit(A_LoopField, ",", " `t", 5)
		
		customname := custommodarray[1]
		customcat := custommodarray[2]
		StringLower, customcat, customcat
		customimg := custommodarray[3]
		
		;Few checks for the name
		IfNotExist, %modfilesloc%\%customname%
		{
			MsgBox, 48, Missing Custom Mod, Error! Mod '%customname%' has been added to CustomMods.txt but it doesn't have it's own folder at: %modfilesloc%`n`nCustom Mod will be skipped...
			continue
		}
		else
		{
			IfNotExist, %modfilesloc%\%customname%\*.jar
			{
				MsgBox, 48, Missing Custom Mod Files, Error! Mod '%customname%' has been added to CustomMods.txt but it doesn't have any .jar mod files inside %modfilesloc%\%customname%`n`nCustom Mod will be skipped...
				continue
			}
		}
		
		;Check category
		if customcat != tech
		{
			if customcat != magic
			{
				if customcat != creative
				{
					if customcat != other
					{
						MsgBox, 48, Bad Custom Mod Category, Error! Mod '%customname%' has been added to CustomMods.txt but the category is not recognised, it is currently: %customcat%. Please set it to 'tech', 'magic', 'creative' or 'other'`n`nCustom Mod will be skipped...	
						continue
					}
					else
					{
						modsOther := modsOther . "," . customname
						leftboxOther := leftboxOther . customname . "|"
					}
				}
				else
				{
					modsCreative := modsCreative . "," . customname
					leftboxCreative := leftboxCreative . customname . "|"
				}
			}
			else
			{
				modsMagic := modsMagic . "," . customname
				leftboxMagic := leftboxMagic . customname . "|"
			}
		}
		else
		{
			modsTech := modsTech . "," . customname
			leftboxTech := leftboxTech . customname . "|"
			
		}
		
		modsAll := modsTech . "," . modsMagic . "," . modsCreative . "," . modsOther
		
		;Check image
		IfNotExist, %modpicsloc%\%customimg%
			MsgBox, 48, Missing Custom Mod Image, Error! Mod '%customname%' has been added to CustomMods.txt but the image '%customimg%' seems to be missing inside %modpicsloc%`n`nCustom Mod will have no image!
		
	}
	
	return
}

addCustomMaps()
{
	;Need the global variables
	global
	
	;Parse through the data, adding maps as we go
	Loop, Parse, custommapslist, `n
	{
		;If first character in a line is a hash (or nothing), ignore that whole line (it's a comment!)
		if(SubStr(A_LoopField, 1, 1)) = "#"
			continue
		
		if(SubStr(A_LoopField, 1, 1)) = "`r"
			continue
		
		if(SubStr(A_LoopField, 1, 1)) = "`n"
			continue
			
		if(SubStr(A_LoopField, 1, 1)) = ""
			continue
		
		;Split the line into 6 parts - the name, category, imgsrc, minecraftver, numplayers and description
		custommaparray := StrSplit(A_LoopField, ",", " `t", 6)
		
		customname := custommaparray[1]
		customimg := custommaparray[3]
		custommcver := custommaparray[4]
		
		;Few checks for the name
		IfNotExist, %mapsloc%\%customname%
		{
			MsgBox, 48, Missing Custom Map, Error! Map '%customname%' has been added to CustomMaps.txt but there's no directory for it in: %mapsloc%\%customname%`n`nCustom Map will be skipped...
			continue
		}
		else
		{
			IfNotExist, %mapsloc%\%customname%\level.dat
			{
				MsgBox, 48, Missing Custom Map Files, Error! Map '%customname%' has been added to CustomMaps.txt but it doesn't have a 'level.dat' file inside %mapsloc%\%customname%`n`nDid you extract it properly or is the map broken? Custom Map will be skipped...
				continue
			}
		}
		
		;Not so fussed about category since it's not too important, however, do still need to check the image and minecraft version!
		
		
		;Check minecraft instance exists for legacy maps
		if custommcver != 1.12.2
		{
			IfNotExist, %mclocation%\%custommcver%
			{
				MsgBox, 48, Missing Custom Map Instance, Error! Map '%customname%' has been added to CustomMaps.txt but no instance exists inside %mclocation% for it to use!`n`nPlease create an instance called %custommcver% and put it inside this folder. Custom Map will be skipped...
				continue
			}
		}
		
		mapsList := mapsList . customname . "|"
		
		;Check image
		IfNotExist, %modpicsloc%\%customimg%
			MsgBox, 48, Missing Custom Map Image, Error! Map '%customname%' has been added to CustomMaps.txt but the image '%customimg%' seems to be missing inside %modpicsloc%`n`nCustom Map will have no image!
	}
	
	return
}