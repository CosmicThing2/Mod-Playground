# Mod Playground

### Minecraft Mod Playground Script - Created by CosmicThing2
### Latest download: [MPG.exe](https://github.com/CosmicThing2/Mod-Playground/raw/master/Install/MPG.exe)

## Install
### First time
If running it for the first time, simply run the self-extracting package 'MPG.exe'. The Mod Playground will then ask you for a few different directories but the defaults will be fine for most people. In a LAN environment, you may wish to enable some of/more of the advanced features. See LAN section below!

On first launching a game, you will need to setup MultiMC, choose your RAM, Java installation and enter your account details. You may then need to reload the Mod Playground.

### Updating
If updating, simply overwrite 'Minecraft Mod Playground.exe'. Note, for major updates you may need to wipe your cfg.ini and/or mppwd.txt.

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

But but what if I want to add my own stuff to the GUI? I want to add my own mods and/or maps!

Yes I hear you, don't panic! I'd probably only recommend this inside a LAN based setup though as it can be a bit fiddly and there are easier ways to do it on a home setup!

In the resources folder that you setup previously, you'll find the 'Mods' and 'Maps' directory where all your downloaded mods are stored. You should also find 'CustomMods.txt' and 'CustomMaps.txt'. Mods and Maps can be added to these line by line. Please follow the example I've put in each file. 

Custom Mods need the following:
- a name
- a category (either tech, magic, creative or other)
- an image file located in the 'Images' directory
- a YouTube link
- a description of the mod

Mods also need a folder matching the name, containing the jar files inside the 'Mods' folder (obviously!). If it's available on curseforge, Mod Playground can also update it automatically for you. Just add a shortcut file that matches the name on CurseForge (e.g. https://minecraft.curseforge.com/projects/<NAME>).

Custom Maps need these:
- a name
- a category (either Survival, Creative, Adventure, Dropper, Parkour or Minigames)
- an image file located in the 'Images' directory
- version of minecraft that the map is for (if it's not 1.12.2, you must also have an instance available for it to use inside 'Instances' called the same name as the version - e.g. an instance called 1.11.2)
- number of players (e.g. 2 - 4, or 3+ etc)
- a description of the map

Maps also need a folder matching the name, containing the map files inside the 'Maps' folder (obviously!). Make sure you extract it, i.e. Maps\<mapname>\level.dat must exist!
