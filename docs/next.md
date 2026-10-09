# Next

Scratch notes from `os-notes.txt` land here after triage.
Dump obstacles in that file, then hand it over. This page is the working
list. Done items move into `goals.md` / `binds.md` and come off this page.

| Want | Who | Status |
|------|-----|--------|
| Messages links open a logged-in Chrome | you confirm | waiting: click a link in Messages |
| Bitwarden: try the desktop app | you (login); agent can `pkg add` | you |
| Super+F maximize (match Novalis) | you confirm (`hyprctl reload`) | applied 2026-09-08 |
| Focus follows mouse into Grok Bot | explained | 2026-09-26, see below |
| Clock plate instead of a type outline | applied | 2026-09-26 |
| Obsidian vault in Projects | done | moved 2026-09-26 |
| Keybinds to match Novalis | you confirm (`hyprctl reload` done) | applied 2026-10-04 |
| Dwindle tiling again | applied | 2026-10-08 |
| VLC, Inkscape, GIMP (+ web-dev extras) | you pick | review 2026-10-04 |
| Lazygit, Yazi, image TUIs in kitty | applied | 2026-10-15 |
| GNU Stow for the overlay | applied | 2026-10-15 |
| Tidal Cycles | applied | 2026-10-15 |

## Messages links open a logged-in Chrome

Applied: the webapp Chrome dir is now a single signed-in `Default`
profile (`scripts/collapse-webapp-profile.sh`, launchers pass
`--profile-directory=Default`). Confirm by clicking a link in Messages.

If the window is still the "wrong Chrome", that is a second browser, not
Super+W. Real PWAs from the main profile would share it, but we already
avoided `--app-id` because those draw a CSD title bar.

## Bitwarden: try the desktop app

The Chrome extension is a separate install in every Chrome profile. The
webapp Chrome is not the Super+W Chrome, so the extension there is a
second copy and a common source of "it is buggy."

Official desktop app is `extra/bitwarden`. Enable **Settings → App
settings → Enable browser integration**, then the extension unlocks
through the native host instead of living on its own.

Agent can `omarchy pkg add bitwarden`. You install/login, turn on
browser integration, and see if the extension stops being weird.

More "OS-shaped" and optional: `rbw` (CLI). Skip unless the desktop app
is also annoying. Omarchy's 1Password installer is unrelated.

## Focus follows mouse into Grok Bot

Hyprland is not skipping Grok Bot. `input:follow_mouse` is 1 for every
window except JetBrains (`no_follow_mouse`). The live window is a normal
tiled Wayland client: class `grok-bot`, `acceptsInput` true, no focus rule.

Two things make it feel different from a Chrome web app:

- Grok Bot 0.29.0 is Electron 42, frameless on Linux (`frame: false`) with
  Wayland window decorations turned on. Chrome web apps are ordinary
  Chrome windows. Hover moves Hyprland's focus to either of them. Electron
  often does not put the caret in the page until a click, so the border
  can change while typing still goes to the window you left.
- While the default was scrolling, a column would not slide into view on
  hover unless at least 40% of it was on screen
  (`scrolling:follow_min_visible`, stock 0.4). Grok Bot opened at about a
  quarter of this 3840-wide panel, so hovering it focused the sliver and
  left the web app column where it was. A click, or Super+Left/Right,
  pulled it in. The default is dwindle again, so this only applies after
  Super+Ctrl+L.

## Clock plate instead of a type outline

Applied 2026-09-26. The date/time sits on a solid `#161C22` plate, white,
normal weight. The demibold outline is gone. The bar plugin hot-reloads;
`omarchy-shell shell rescanPlugins` if the old outline is still up.

## Obsidian vault in Projects

Moved 2026-09-26 from `~/Documents/Obsidian Vault` to
`~/Projects/obsidian`. Obsidian's vault list points at the new path.
The git remote is unchanged.

## Super+F maximize (match Novalis)

Applied 2026-09-08. Super+F is
`hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })`.
Novalis Super+F is `maximize-column`. Super+Ctrl+F stays windowed
fullscreen; Super+Alt+F stays full width; Super+Shift+F stays files.
Run `hyprctl reload` on this machine to pick it up.

## Keybinds to match Novalis

Applied 2026-10-04. Program start/focus is Super+Shift+letter, same
chords as Novalis. Super-letter is window management again (float,
pop-out, scratchpad). Confirm with Super+Shift+W / T / D / M / L / Y.

| Key | Job |
|-----|-----|
| Super+Shift+W | Chrome (focus or launch) |
| Super+Shift+T | VS Code |
| Super+Shift+D | Discord |
| Super+Shift+E / Super+Shift+Alt+E | Thunderbird / compose |
| Super+Shift+G | Gmail |
| Super+Shift+C | Google Calendar |
| Super+Shift+B | Board Game Arena |
| Super+Shift+M | Google Messages |
| Super+Shift+L | Google Maps |
| Super+Shift+O | LibreOffice |
| Super+Shift+Y | YouTube Music, then YouTube |
| Super+Shift+I | Inkscape |
| Super+Shift+P | GIMP |
| Super+Shift+Alt+A | Grok |
| Super+Shift+Alt+D | Docker TUI |
| Super+Shift+Alt+W | Omawrite |

Vacated Super-letter: Super+T float, Super+O pop-out, Super+W unbound
(not close — old browser muscle memory), Super+D / Super+M unbound.
Scratchpad stays Super+S / Super+Shift+S. Super+period stays clickpad.
Steam / Heroic / Noctalia Super+A I N W stay on Novalis.

Inkscape and GIMP binds need `omarchy pkg add inkscape gimp` (sudo in a
real terminal). Arrow grammar stays split.

## Dwindle tiling again

Applied 2026-10-08. `config/hypr/looknfeel.lua` sets `general.layout` back
to stock dwindle. Super+Ctrl+L still toggles the current desk to
scrolling. Saved scrolling rules for workspaces 2 and 3 were removed so
they follow the default.

## VLC, Inkscape, GIMP (+ web-dev extras)

Inbox 2026-10-04. None of the three is installed. Novalis already has
Inkscape and GIMP (`cachyos/packages/extra.txt`). Omarchy already plays
video with `mpv`.

Named, ready:

```
omarchy pkg add vlc inkscape gimp
```

| Package | Repo | Why |
|---------|------|-----|
| `vlc` 3.0.23 | extra | "open this file" player. `mpv` stays the Omarchy default |
| `inkscape` 1.4.4 | extra | vector editor. Same pick as Novalis |
| `gimp` 3.2.4 | extra | Photoshop-type editor. Same pick as Novalis. `pinta` stays for quick raster |

Already here for web work: VS Code, Chrome, git, lazygit, Docker /
Compose / lazydocker, Node (mise 26.7.0 plus distro `nodejs-lts-jod` 22),
Python, Ruby, ImageMagick, ffmpeg, libvips, OBS, Kdenlive, Bitwarden,
Obsidian, Thunderbird, LibreOffice.

The gap for Willy Fresh IT / WordPress:

| Extra | How | Why |
|-------|-----|-----|
| PHP + Composer | `omarchy install dev-env php` | WordPress builds. Not installed |
| FileZilla | `omarchy pkg add filezilla` | DreamHost FTP/SFTP |
| DBeaver | `omarchy pkg add dbeaver` | local/remote SQL if you want a GUI. Skip if Docker + CLI is enough |

Skip unless you ask: Krita (Novalis picked GIMP), Steam / Heroic
(Novalis), bun / Go / Rust (`omarchy install dev-env` when a project
needs them).

Inkscape / GIMP chords are live (Super+Shift+I / P). They no-op until
the packages are in.

## Lazygit, Yazi, image TUIs in kitty

Applied 2026-10-15. Lazygit 0.65.0 was already installed. It has no
pictures, so the launcher uses the default terminal (Foot):
`Lazygit` in the app menu, `lazygit` in a shell.

Yazi 26.9.1 was the terminal file manager not installed yet. Image
previews use Kitty's graphics protocol, so its launcher runs
`kitty --class yazi yazi`. Superfile was already that way.

Kitty, because they draw images:

| Launcher | Command |
|----------|---------|
| Concord | `kitty --class concord concord` |
| Superfile | `kitty --class superfile spf` |
| Yazi | `kitty --class yazi yazi` |
| NeoMutt | `kitty --class neomutt neomutt` |
| LazyVim | `kitty --class lazyvim nvim` |

NeoMutt image attachments go through `scripts/neomutt-icat.sh`. The
picture stays until Enter. Other attachment types still use
`/etc/mailcap`.

Lynx, caligula, valvefm, steam-tui, lazydocker, btop, dua, and
cliamp do not draw images. They stay on the default terminal.
Foot stays the default. Super+Return is unchanged.

Not installed: `impala` (wifi) and `wiremix` (PipeWire mixer). Say
if you want those.

## GNU Stow for the overlay

Applied 2026-10-15. `scripts/apply.sh` restows the `config` package
into `~/.config`. Stow folds into the real `hypr` and `omarchy`
directories and symlinks only our files. `config/applications` is
ignored (`.stow-local-ignore`) and still copied onto the Chrome
launcher names.

Zeibytes' repos (`MangoWM`, `most-racist-rice-V2`) put one package
per app at the repo root and run `stow -t ~/.config hypr kitty`,
because those repos are only dotfiles. This repo also has scripts
and docs, so the overlay stays one package whose tree matches
`~/.config`.

Needs the `stow` package. Absolute links from the old `ln -sfn`
list are replaced with Stow's relative links on the first apply.

## Tidal Cycles

Applied 2026-10-15, from the Arch steps at
https://tidalcycles.org/docs/getting-started/linux_install

Installed: SuperCollider 3.14.1, sc3-plugins 3.14.0, GHC 9.6.6,
haskell-tidal 1.9.5 (and the Haskell libraries that package lists),
qjackctl 1.0.6. SuperDirt v1.7.4, Dirt-Samples, and Vowel are
quarks under `~/.local/share/SuperCollider/downloaded-quarks`.
`~/.local/share/SuperCollider/startup.scd` is SuperDirt's startup
script, so opening SuperCollider boots SuperDirt with enough
buffers for the default samples. The VS Code extension is
`tidalcycles.vscode-tidalcycles` 2.0.2.

This machine already had PipeWire's JACK (`pipewire-jack`). The
page's `jack2` package conflicts with that, so it was not
installed. qjackctl uses the JACK library that is already here.
`mesa-demos` was not installed, so there was nothing to remove.
The full `pacman -Syu` in the page was not run.

`willyfresh` is in the `audio` group. That applies at the next
login. Log out and back in before the first session.

Start: open SuperCollider and wait for
`SuperDirt: listening to Tidal on port 57120`. In VS Code, save a
file as `something.tidal`, run TidalCycles: Boot Tidal Cycles, then
Shift+Enter on `d1 $ sound "bd sn"`.
## Terminal apps, leave the mouse

Copied from the Novalis inbox 2026-10-07. Installed on Novalis
2026-10-08. Nothing from this list is installed on Delorean. No key
until you name one or two. Nautilus, Chrome, Thunderbird, Discord,
and Steam stay until one of these replaces it.

| App | Job | Package |
|-----|-----|---------|
| superfile (`spf`) | file manager | `superfile` |
| concord | Discord | AUR `concord-bin` |
| lynx | text web | `lynx` |
| neovim | editor | `neovim` |
| caligula | write a disk image | `caligula` |
| neomutt | mail | `neomutt` |
| valvefm | FM radio | not packaged; GitHub Zorig/valveFM |
| steam-tui | Steam library via steamcmd | AUR `steam-tui` |

Super+Shift+D stays the Electron Discord client until you say otherwise.
steam-tui still starts the real Steam client for games that need it.
Novalis also has kitty for Concord images. It is not installed here.

## Super alone does nothing

Backlog. Stock Omarchy leaves Super alone unbound. This overlay binds
Super release to `omarchy-menu toggle` in `config/hypr/bindings.lua`.
`docs/goals.md` still lists that as a KDE habit.

A bare press should do nothing. Super+Space still opens the menu.
Novalis already does this (2026-10-07). The other Super chords stay.
