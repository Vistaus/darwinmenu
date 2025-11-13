# Darwin Menu
Darwin menu is a Plasma applet that provides a menu system similar to that found on other operating systems. It allows users to access frequently used system settings and session controls.

Menu supports adding custom commands, which can be placed in separate sub-menu or in common list.

Applet also provides "Force Quit" app, which can be opened with global shortcut. (Default: "**⌘-⌥-⎋"**) 😊

Menu uses global theme, so will adapt to any Plasma style.
## Requirements
Plasma 6.5

## Installation 
1. Download latest release from [releases page](https://github.com/lasaczka/darwinmenu/releases)
2. Install with ```kpackagetool6 -i %release%```
3. ...or update with ```kpackagetool6 -u %release%```
   
You can also install it using Plasma GUI

1. Right Click Panel > Panel Options > Add Widgets
2. Get New Widgets > Install Widget From Local File

## Install via KDE

1. Right Click Panel > Panel Options > Add Widgets
2. Get New Widgets > Download New Widgets
3. Search: "Darwin Menu"
4. Install

## Install via GitHub
```
git clone https://github.com/lasaczka/darwinmenu.git darwinmenu
cd darwinmenu
sh ./install
```

To update, run `git pull` then `sh ./install -r`. Please note this script will restart `plasmashell` so you don't have to relog.

## Install Translations

Go to `~/.local/share/plasma/plasmoids/org.latgardi.darwinmenu/translate/` and run `chmod +x ./translation && ./translation build --restart`.

## Screenshots

<img src="https://github.com/lasaczka/darwinmenu/assets/85876063/319b82c0-1a60-472c-8265-6a050a581cab" alt="screenshot">

## Translating

See the [translation readme](package/translate/ReadMe.md) for instructions on translating.

