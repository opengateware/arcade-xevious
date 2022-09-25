[![Xevious Logo](xevious-logo.png)](#)

---

[![Active Development](https://img.shields.io/badge/Maintenance%20Level-Actively%20Developed-brightgreen.svg)](#status-of-features)
[![Build](https://github.com/opengateware/arcade-xevious/actions/workflows/build-pocket.yml/badge.svg)](https://github.com/opengateware/arcade-xevious/actions/workflows/build-pocket.yml)
[![release](https://img.shields.io/github/release/opengateware/arcade-xevious.svg)](https://github.com/opengateware/arcade-xevious/releases)
[![license](https://img.shields.io/github/license/opengateware/arcade-xevious.svg?label=License&color=yellow)](#legal-notices)
[![issues](https://img.shields.io/github/issues/opengateware/arcade-xevious.svg?label=Issues&color=red)](https://github.com/opengateware/arcade-xevious/issues)
[![stars](https://img.shields.io/github/stars/opengateware/arcade-xevious.svg?label=Project%20Stars)](https://github.com/opengateware/arcade-xevious/stargazers)
[![discord](https://img.shields.io/discord/676418475635507210.svg?logo=discord&logoColor=white&label=Discord&color=5865F2)](https://chat.raetro.org)
[![Twitter Follow](https://img.shields.io/twitter/follow/marcusjordan?style=social)](https://twitter.com/marcusjordan)

## Namco [Xevious] Compatible Gateware IP Core

This Implementation of a compatible Xavious/Super Xavious arcade hardware in HDL is the work of [Dar](https://sourceforge.net/projects/darfpga/).

## Overview

Xevious (pronounced 'zeevious') is a vertically-scrolling shoot-em-up in which the player pilots the heavily-armed 'Solvalou' combat ship and must destroy the evil Xevious forces trying to take over the planet. The Solvalou is equipped with two weapon systems; the forwards-firing "air zapper" for shooting air-based enemies and 'blaster bombs', for destroying ground-based enemies. To enable accurate targetting of the air-to-ground blaster bombs, a white and blue targeting indicator is situated in front of the Solvalou. This flashes when an enemy is in its sights.

## Technical specifications

- **Main CPU:**     Zilog Z80 @ 3.72 MHz
- **Graphics CPU:** Zilog Z80 @ 3.72 MHz
- **Sound CPU:**    Zilog Z80 @ 3.72 MHz
- **Sound Chip:**   Fujitsu MB8842, MB8843 and MB8844 @ 1.536 MHz
- **Resolution:**   288×224, 4096 colors
- **Display Box:**  384×264 @ 6.144 MHz
- **Aspect Ratio:** 9:7
- **Orientation:**  Vertical (90º)

## Compatible Platforms

- Analogue Pocket

## Compatible Games

> **ROMs NOT INCLUDED:** By using this gateware you agree to provide your own roms.

| Officials                  | Status |
| :------------------------- | :----: |
| Xevious                    |   ✅   |
| Super Xevious              |   ✅   |
| **HBMAME (HomeBrew MAME)** |        |
| Gaous                      |   ✅   |
| Xevious 2002               |   ✅   |
| Xevious 2003               |   ✅   |
| Xevious 2004               |   ✅   |
| Xevious 2005               |   ✅   |
| Xevious Black              |   ✅   |
| **Bootlegs**               |        |
| Battles (set 2)            |   ✅   |
| Xevios                     |   ✅   |

### ROM Instructions

1. Download and Install [ORCA](https://github.com/opengateware/tools-orca/releases/latest) (Open ROM Conversion Assistant)
2. Download the [ROM Recipes](https://github.com/opengateware/arcade-xevious/releases/latest) and extract to your computer.
3. Copy the required MAME `.zip` file(s) into the `roms` folder.
4. Inside the `tools` folder execute the script related to your system.
   1. **Windows:** right click `make_roms.ps1` and select `Run with Powershell`.
   2. **Linux and MacOS:** run script `make_roms.sh`.
5. After the conversion is completed, copy the `Assets` folder to the Root of your SD Card.
6. **Optional:** an `.md5` file is included to verify if the hash of the ROMs are valid. (eg: `md5sum -c checklist.md5`)

> **Note:** Make sure your `.rom` files are in the `Assets/xevious/common` directory.

## Status of Features

> **WARNING**: This repository is in active development. There are no guarantees about stability. Breaking changes might occur until a stable release is made and announced.

- [ ] Add Second Player
- [ ] Dip Switches
- [ ] Pause
- [ ] Hi-Score Save

## Known Issues

- A completely random bug seems to occur where you insert a coin and the game starts as 2 players, the ship will also get stuck to the bottom left of the screen. Pressing start gets back to normal.

## Credits and acknowledgment

- [Alan Steremberg](https://github.com/alanswx)
- [Alexey Melnikov](https://github.com/sorgelig)
- [Daniel Wallner](https://opencores.org/projects/t80)
- [Dar](https://github.com/darfpga)
- [Kuba Winnicki](https://github.com/blackwine)
- [Peter Wendrich](https://github.com/pwsoft)

## Powered by Open-Source Software

This project borrowed and use code from several other projects. A great thanks to their efforts!

| Modules                        | Copyright/Developer     |
| :----------------------------- | :---------------------- |
| [Data Loader]                  | 2022 (c) Adam Gastineau |
| [T80]                          | 2001 (c) Daniel Wallner |
| [Xevious RTL]                  | 2017 (c) Dar            |

## Legal Notices

Xevious/Super Xevious © 1983-1984 NAMCO LTD. All rights reserved. Xevious is a trademark of BANDAI NAMCO ENTERTAINMENT INC.
All other trademarks, logos, and copyrights are property of their respective owners.

The authors and contributors or any of its maintainers are in no way associated with or endorsed by Bandai Namco Entertainment Inc.

[Data Loader]: https://github.com/agg23/analogue-pocket-utils
[T80]: https://opencores.org/projects/t80
[Xevious RTL]: https://github.com/MiSTer-devel/Arcade-Xevious_MiSTer/tree/master/rtl

[Xevious]: https://en.wikipedia.org/wiki/Xevious
