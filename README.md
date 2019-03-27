# Mod Playground

### Minecraft Mod Playground Script - Created by CosmicThing2
### Latest download: [MPG.exe](https://github.com/CosmicThing2/Mod-Playground/raw/master/Install/MPG.exe)

## Install
### First time
If running it for the first time, simply run the self-extracting package 'MPG.exe'. The Mod Playground will then ask you for a few different directories but the defaults will be fine for most people (for more information on these settings, see below). In a LAN environment, you may wish to enable some of/more of the advanced features.

On first launching a game, you will need to setup MultiMC, choose your RAM, Java installation and enter your account details. You may then need to reload the Mod Playground.

### Updating
If updating, simply overwrite 'Minecraft Mod Playground.exe'. Note, for major updates you may need to wipe your cfg.ini and/or mppwd.txt.

## First Time Setup

If you haven't run Mod Playground before or have specified a new location for the config file, it will ask you to run first time setup, this must be run as an administrator. The following directories and settings are available:
- MultiMC location. Where should MultiMC be installed? I'd probably recommend C:\MultiMC in most cases. Mod Playground can copy this in for you automatically if the folder is available.
- Resources for Mod Playground. Where should all the resources for the program be installed? This includes Mods, Maps, Images, Instances, the Configs and any Libraries. (For a home setup, this can just be your documents, but in a LAN you'd want to set this to some shared location that all clients can access). 

The settings below all use the same location. For a home setup, this could just be your documents, but in a LAN you'd want to set this to some shared location that all clients can access, CLIENTS/MOD PLAYGROUND NEEDS WRITE ACCESS TO THIS DIRECTORY!).

- Enable autosaving mod lists. Mod Playground can remember what mods you selected last time you played and 'auto save' this to a file. It will then load this on every launch. Very helpful and recommended.
- Enable backup manager. The Backup Manager loads after you've started the game. It allows your saves to also be copied to the location specified when you press the 'Backup' button on the manager. These saves will then be automatically downloaded on every launch, allowing for users to move around and have their saves follow them to any computer.
- Enable usage stats. If enabled, will log what mods users select and save this data to 'modstats.ini' inside each users' folder. Allows the administrator to see what mods are popular!

Registers can optionally use a different location.
- Enable registers. This will log every user that launches Mod Playground including their username, the time and date, the computer they launched it on and whether they were allowed to play, bypassed with the admin password or were blocked. Only recommended for LAN environments.

Other settings:
- Allows access only at certain times. Only recommended in LAN environments, allows controlling when users can launch the program. If outside of the allowed time, the administrator password will be requested.
- Force offline mode. This will edit the accounts file in MultiMC to force it to launch in Offline mode. This means that users will be unable to play Minecraft online and/or join any online servers. Useful in schools where students may not be allowed to play online for safeguarding reasons. See below for more information as this requires some other setup!

## Offline Mode

Offline mode is a feature that blocks all online content by deliberately forcing MultiMC (and therefore Minecraft) into Offline Mode. To do this however, you must ensure the following url is BLOCKED (via a firewall e.g.) for all users/students: https://authserver.mojang.com. 

I'd also recommend ALLLOWING the following URLs to prevent issues later (as the game may need to download resources at certain points):
- https://libraries.minecraft.net
- https://files.minecraftforge.net
- https://launcher.mojang.com
- https://launchermeta.mojang.com
- https://resources.download.minecraft.net

You will then need to login to MultiMC once on each computer that you want users/students to play Minecraft on, this could be done on an administrator account that has https://authserver.mojang.com unblocked. Once MultiMC and Minecraft has been authenticated at least once, users can then launch the game in offline mode on their own accounts.

## Introduction

Mod Playground effectively functions as a Mod and Map Manager for Minecraft that works alongside MultiMC. It's primarily designed for children and those who aren't so familiar with downloading and installing Minecraft mods. It provides a number of useful features to work via a LAN configuration but can also be used at home.

Mod Playground provides the following features:
- Over 100 of the most popular Minecraft mods already setup in 4 different categories which can be added to Minecraft in one click. Each mod has a short description, picture and a YouTube link to a Mod Spotlight (if one exists!)
- Mod Updater that can update all your mods to their latest versions (via CurseForge)
- Save and load your mod lists. These can either be send to friends online, or if on the same LAN you can simply enter a username to load a mod list instantly from that player
- Custom Mods and Maps. Any custom mods and maps can be added to the launcher via adding them into 'CustomMods.txt' and 'CustomMaps.txt'. Any custom mods can also be updated so long as they exist on CurseForge.
- Random Mods button. Because why not.

For school (or other LANs) environments, the following features are also provided:
- Users can be automatically registered/logged when they start Mod Playground. The username, time and computer are logged to an ini file allowing you to see who's attended/launched the program.
- Prevent users launching the program at certain times. Mod Playground can be locked to a start and end time, a password will be asked otherwise (which is setup by the original administrator).
- Backup Manager which can copy a users' worlds up to a server or shared directory. These worlds are then automatically downloaded when the student uses a different computer, allowing them to keep their worlds whichever computer they use.

## Basic Requirements

For Mod Playground to work, you MUST have:
- MultiMC. This is provided in the download and the launcher can automatically install it for you. In a LAN environment, this would have to be copied/deployed to all PCs that are going to play the game.
- Java. Minecraft (and any mods) require Java to be installed to work. I recommend having the latest 32-bit and 64-bit versions installed (unless you've got a 32-bit PC). Java can be found [here](https://www.java.com/en/download/manual.jsp).
- Valid Minecraft Account(s). To download the game and any needed libraries, you will be asked to sign into MultiMC with a valid Minecraft account. For schools (and other businesses), you must legally own an account per device the game is running on. I will never support hacked or unlicensed clients.
- Internet Connection. For MultiMC to authenticate and for Mod Playground to download/update any mods, you need an Internet Connection. The faster the better!

## Using the Mod Playground - A simple rundown!

Mod Playground is designed to be simple and easy to use. Just choose one of the tabs at the top to see all mods in this category. Clicking on a mod will give you some information about the mod, a picture and a link to a Mod Spotlight on it. If you'd like to play this mod, click the '>' arrow to add it to the right hand side GUI. You can add any number of mods (but do take your RAM into account!). Alternatively, hit 'Random Mods' to get a new selection everytime!

Once you've chosen your mods, you can optionally save this modlist to a file (this could then be sent to a friend for them to have the same mods e.g.), then press 'Launch Minecraft'. All mods you selected will be copied into the MultiMC instance and then the game will be launched.

Depending on whether you've enabled the backup manager (not needed for personal/home installations), this will either appear or the Mod Playground will exit.

## Adding Custom Mods and Custom Maps

But what if I want to add my own stuff to the GUI? I want to add my own mods and/or maps!

Yes I hear you, don't panic! I'd probably only recommend this inside a LAN based setup though as it can be a bit fiddly and there are easier ways to do it on a home setup!

In the resources folder that you setup previously, you'll find the 'Mods' and 'Maps' directory where all your downloaded mods are stored. You should also find 'CustomMods.txt' and 'CustomMaps.txt'. Mods and Maps can be added to these line by line. Please follow the example I've put in each file. 

Custom Mods need the following:
- a name
- a category (either tech, magic, creative or other)
- an image file located in the 'Images' directory
- a YouTube link
- a description of the mod

Mods also need a folder (matching the name you just added to CustomMods.txt), containing the jar files inside the 'Mods' folder (obviously!). If it's available on curseforge, Mod Playground can also update it automatically for you. Just add a shortcut file that matches the name on CurseForge (e.g. https://minecraft.curseforge.com/projects/NAME).

Custom Maps need these:
- a name
- a category (either Survival, Creative, Adventure, Dropper, Parkour or Minigames)
- an image file located in the 'Images' directory
- version of minecraft that the map is for (if it's not 1.12.2, you must also have an instance available for it to use inside 'Instances' called the same name as the version - e.g. an instance called 1.11.2)
- number of players (e.g. 2 - 4, or 3+ etc)
- a description of the map

Maps also need a folder (matching the name you just added to CustomMaps.txt), containing the map files inside the 'Maps' folder (obviously!). Make sure you extract it, i.e. Maps\MAPNAME\level.dat must exist!
