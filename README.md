# Discworld Noir in ScummVM

A fork of ScummVM's Tinsel engine that makes **Discworld Noir** (English, Windows, 3 CDs) playable from the title screen to the ending.

Upstream ScummVM detects Discworld Noir but marks it unstable. This fork adds the 3D actor movement and corrects the notebook, conversations, movie audio and speech, music fades, lighting and saves (58 engine files). It is a patch on ScummVM, not a separate program, and it reads your own copy of the game. No game data is included.

## State

- Two automated playthroughs reached the ending with normal mouse input.
- A human playthrough is under way. Bugs found so far are fixed; see [Known issues](#known-issues).
- Tested on Windows. Linux builds: see [Releases](../../releases).

## What you need

- Discworld Noir, English Windows version, all three CDs. Other languages and the demo are not tested.
- This build (from Releases) or ScummVM built from source with [the patch](noir.patch).

## Install on Linux or Steam Deck

1. Download `discworld-noir-scummvm-linux-x86_64.tar.gz` from Releases and extract it, for example to `~/Games/noir-scummvm`.
2. Make a folder for the game, for example `~/Games/discworld-noir`.
3. Copy the files from the CDs into that one folder: the contents of `cd1` from CD 1, `cd2` from CD 2 and `cd3` from CD 3. Many files are on more than one CD; the copies are identical, so skipping or replacing them are both fine. Put the files directly in the game folder, not in subfolders. The result is 317 files, about 1.2 GB.
4. Start `./noir-scummvm` from the extracted folder.
5. Click **Add Game...**, choose the game folder, and confirm "Discworld Noir".
6. Click **Start**. ScummVM warns that the game is unstable; click to start anyway.

On a Steam Deck, do steps 1 to 5 in Desktop Mode. To play in Game Mode, add `noir-scummvm` to Steam as a non-Steam game.

## Build from source

The patch applies to ScummVM commit `e8623090f959870ce5c39b01a2698a3653158653` (5 May 2026).

```bash
git clone https://github.com/scummvm/scummvm.git
cd scummvm
git checkout e8623090f959870ce5c39b01a2698a3653158653
git apply ../discworld-noir-scummvm/noir.patch
./configure --disable-all-engines --enable-engine=tinsel --enable-release
make -j$(nproc)
```

Music and speech need libmad (`--with-mad-prefix` if it is not in a standard place). [scripts/](scripts/) has the scripts that make the Linux release.

## Known issues

| Issue | State |
| --- | --- |
| Lewton looks very small on the Wharf | Cause not found. |
| Café singer: a seam between head or mouth and body | Cause not found. |
| Some actors look dark; captions dim; feet cut off in some places | No original to compare with yet. |
| Walking takes odd routes, or Lewton refuses a spot | The path solver is not the original one. Please report the place. |
| ScummVM's own volume sliders do nothing | Use the game's options screen. |
| Autosave | Off in testing. Save by hand. |

Please report bugs as GitHub issues. Include a save from just before the fault, a screenshot and where in the game it happened.

## About this project

This is a hobby project by a DevSecOps engineer, not a game programmer, made with substantial AI assistance. AI wrote most of the code. Every change was tested before it was kept: automated playthroughs with normal input, checks against the original game's behaviour, and a human playtest of the build.

ScummVM's [contribution rules](https://github.com/scummvm/scummvm/blob/master/AI-GUIDELINES.md) do not accept code written by an AI agent. For that reason this patch is not offered as a pull request to ScummVM. If you are a ScummVM developer and want Discworld Noir supported upstream, you are welcome to use this fork as a working reference for your own implementation. Open an issue here to get in touch.

## Licence

GPL version 3 or later, the same as ScummVM. See [COPYING](COPYING).

Discworld Noir is © Perfect Entertainment and GT Interactive. Discworld is a trademark of the Terry Pratchett estate. This project is not affiliated with them or with the ScummVM team.
