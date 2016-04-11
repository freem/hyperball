# code name HYPER BALL
yes.

<img src="screenshot.png?raw=true" alt="HYPER BALL Screenshot" width="608" height="448">


## Notes
- **Initial Platform**: Neo-Geo (Other platforms possible in the future)
- **Number of Players**: 1-2 (ideally 1-4 for the 2v2 mode)
- **Game Modes**: Arcade (1v1, 2v2), Versus (1v1, 2v2)

## Building from Source Code
(This is based off of freem's environment; Kannagi is using a slightly different setup)

### Requirements
Building the game from the source code requires the following:
- GNU Make
- vasm (68K with mot syntax, Z80 with oldstyle syntax)
 - freem's environment has `vasmm68k` renamed to `vasm68k`; please edit the `Makefile` if you need to call `vasmm68k` instead.
- Various other tools that haven't been decided yet (we'll cross that bridge when we get there)

This list is subject to change, of course.

### How to Build
- `make all` to create the `cart`, `cd`, and `chd` targets.
- `make cart` to create the cartridge (MVS, home/AES versions) target.
- `make cd` to create the Neo-Geo CD target.
- `make chd` to create a CHD file for use with MAME. (Implies `make cd`, so you don't have to run that first.)

Please read the `Makefile` if you require more information.
