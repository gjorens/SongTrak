# SongTrak: notes for Claude

SongTrak is a single-file web app for guitarists: chord charts and lyrics, setlists, sharing, a Play mode with auto-scroll and a drum backing track, a tuner, and library file saving. It is hosted on GitHub Pages from the `main` branch root and installed on iPad as a Home Screen app.

## Files
- `index.html`: the whole app (inline CSS and vanilla JS, no build step, no libraries).
- `sw.js`: offline helper (network first). Bump the cache name (`songtrak-vN`) on every release.
- `manifest.webmanifest`, `icon-*.png`: install on Home Screen.
- `songtrak-test-library.json`: test data (276 songs, 66 setlists) used by the Load test songs button. Original test songs only.
- `README.txt`: how to host it.

## Conventions
- Show the version beside the app name (`<small id="ver">` in the header, form `v1.4 · 24 Oct e1`). Bump it and the `sw.js` cache name on every change, so the user can tell which copy their iPad is running.
- Help guide: every feature change also updates the matching Help section (`<h4>` blocks in `index.html`), including its collapsed "More info…" part. Check this before opening the pull request.
- Edit `index.html` with small, exact string replacements and check that the script still parses before committing.
- Storage keys: `cc2` (library in localStorage), `songtrak-*` for newer keys. Prefix any new key with `songtrak-` (GitHub Pages sites under one username share storage).
- Device-local keys (not in the library file): `songtrak-nav` (navigation history, newest last, max 100 events `{t,s,l,v,ts}`), `songtrak-loops` (IndexedDB for recorded loops; each record `{sr,pcm,vol,mute,bpm}`, `bpm` is the drum tempo when the loop was recorded, 0 or absent for older loops), `songtrak-tnin`/`songtrak-tnsens` (tuner), `songtrak-pedal`, `songtrak-nolooper`, `songtrak-health` (Library health log, max 100), `songtrak-bak` (up to 3 library backups), `songtrak-corrupt` (damaged copies set aside, never auto-deleted), `songtrak-trash` (last 50 deleted songs with setlist positions), `songtrak-expmeta` (Select export checkbox "Include song data", 0 or 1), `songtrak-drumvol`, `songtrak-lw` (left panel width in px, 220 or more; absent means the default 270), `songtrak-lcl`/`songtrak-lcd`/`songtrak-ccl`/`songtrak-ccd` (lyric and chord colours for light and dark mode; absent means the scheme default, or the older `cc-lc`/`cc-cc` value if set), `songtrak-mgcols` (Manage setlist column widths, JSON `[column 1 px, column 2 px]`; absent means 230px and equal shares; column 3 takes the rest), `songtrak-mix` (Mixer, JSON `{ig:[4 input gains], mon:[4 monitor levels], master}`), `songtrak-fx` (Pedalboard, JSON `{c:[4 chains Guitar, Voice, Bass, Pass-through], p:[saved chains], si:pass-through input id}`; a pedal is `{t,on,p:{params}}`; chains are printed into loop recordings), `songtrak-tabs` (Play tabs hidden in Settings > Play mode, JSON array of tab ids `drums`, `mix`, `fx`, `tuner`, `key`; absent means all shown; the Loops tab uses `songtrak-nolooper`), `songtrak-ui` (App text size multiplier 1, 1.25, 1.5 or 1.75; absent means 1), `songtrak-inch` (input channel for Guitar, Voice, Bass and pass-through, JSON `["d","d","d","d"]`; `d` default (no channel request, as before v3.101), `1` Input 1 left, `2` Input 2 right, `m` both mixed; absent means all `d`), `songtrak-drumlv` (device default drum sound levels, JSON `{l:{row letter:0-200 percent},ks:0|1}`; absent means all 100 and the small-speaker kick off), `songtrak-tapin` (Tap in pad sounds), `songtrak-loopout` (stereo side for each sound, JSON `["b","b","b","b","b"]` for Guitar, Voice, Bass, the drum machine and the pass-through; `b` both sides, `l` left, `r` right; absent means all both).
- Left column has two views: Songs, and Setlists (list of setlists; tapping one opens it with its songs, same sort and A-Z rail). `slOpen` says whether a setlist is open; `mgrOn` is the 3-column setlist manager.
- Library file format: `{at, j}` where `j` is a JSON string `{songs, lists, hist, hp, uname, pats, fsets}`. `fsets` is the list of saved fill sets `{id,name,L,f}` (`L` steps per bar, `f` four row sets; 3 still loads); like `pats`, a file without it loads as none. `pats` is the list of saved drum patterns `{id,name,p,n,e}` (`p` base pattern, `n` bars 1 to 4, `e` row strings); a file without `pats` loads as no saved patterns. "Copy library text" wraps it as compressed, line-wrapped text starting `SONGTRAK-LIBRARY-GZ`.
- Song files are ChordPro-style: `{key: value}` directive header, then chords inline as `[G]word`, sections as `# Verse`.
- Key model: `key` is the original key; `mkey` is My Key (sounding key); `capo` and `mkr` (chords rewritten into My Key) are stored separately.
- Per-song extras: `tuning`, `drums` (`p`, `b` tempo, `w` swing, `h` human feel, `c` count-in, `s` scroll starts with the drums once the count-in ends (Start scroll then starts the drums if they are stopped; pausing the scroll never stops them), `n` bars 1 to 4 (always written; no `n` and no `e` shows the default 4 bars, `e` without `n` means 1 bar), `t` turnaround (from v3.92 a fill bar plays as an extra bar after every t bars of the beat, so the cycle is t+1 bars and the beat carries on where it left off; before v3.92 it replaced the last of every t bars; one of 1, 2, 3, 4, 6, 8, 11, 12, 16 (11 from v3.110, for a 12-bar blues: 11 bars plus the fill bar); every pattern bar is still played, e.g. a 4-bar beat with t=2 gives b1 b2 F1 b3 b4 F2 b1 b2 F3 b3 b4 F4; absent when off), `f` four one-bar fill row sets that the turnaround rotates through (a saved set of 3 loads with a default 4th fill added), kept even when the turnaround is off, `u` id of the saved pattern in use, `e` edited rows; row letters k s h o r c plus a crash, d ride, t tom high, u tom low, p clap, w cowbell, y shaker, b tambourine; the song keeps its own copy of the beat, so exports and deleted saved patterns never lose it), `speed`.

## App text size
- CSS font sizes up to 34px, control heights (28 to 60px) and some min-widths are written as `calc(Npx*var(--ui,1))`; `--ui` is set on `:root` (early in `<head>` and from the settings select `#uisz`). When adding new CSS, write control font sizes and heights this way. The song chart keeps its own size settings (`--fs`, `--cs`).

## Beat editor layout
- Controls in `#dpanel` are 44px high. "Edit the beat" has rows by function: Beat length (bars select, bar tabs `#dbt`, pattern save buttons), Turnaround (select, fill tabs `#dft`, fill save buttons), a plain-language hint line `#dhint`, the grid, and More sounds. Opening it adds the `tall` class so the panel fills most of the screen.

## Select mode and export
- Select (Songs view) shows checkboxes; Delete is batch, with a backup first and Undo. Export writes ChordPro (`{title:}`, `{artist:}`, `{key:}`, `{capo:}`, sections as `{comment: Verse 1}`), as a zip (stored, one `.txt` per song) or one text file joined by `{new_song}`. Import splits `{new_song}` files and confirms multi-song imports.

## Testing
Use Playwright with a local server (`python3 -m http.server`). Cover: library load, save to Files (mock `navigator.share`), drums panel, tuner pitch detection, import and export round trips. The iPad file picker is unreliable for this user, so keep the paste, drag-and-drop and Load test songs routes working.

## Release flow
Work on a branch and open a pull request. The owner (Gerry) said on 29 Oct 2026 that Claude may merge routine pull requests itself, because the app is not in beta yet. Mention in the reply which pull requests were merged and the version that is now live.

Update 10 Nov 2026: Gerry said Claude may merge ALL pull requests itself from now on, including the risky kinds below, until he says otherwise. Still say plainly in the reply what a risky change touches (storage keys, file format, sw.js caching, removed features) and which pull request was merged. If he withdraws this, go back to asking first.

Previously: ask first, and do not merge until the owner says yes, for risky changes:
- anything that changes the library file format, the storage keys, or how data is saved, loaded, imported or deleted (risk of losing songs or loops);
- changes to `sw.js` caching logic (risk of the iPad app getting stuck on an old copy);
- anything that removes a feature or data.

Never push to `main` directly. Merge through the pull request, using a normal merge commit.

## Play drawers (v3.91)
- Right-edge coloured tabs `#dtabs` (Drums, Loops, Mixer, Pedals, Tuner, Key) open one drawer at a time; the bottom bar `#pbar` holds only action buttons. The old Play-bar buttons `pdr`, `plp`, `ptn`, `pkey` are hidden and clicked by the tabs. `#mixp` and `#fxp` are the Mixer and Pedalboard drawers; the status rings sit bottom-left.
- Play drawers have no Close buttons (hidden by CSS in Play mode); a tab closes its own drawer. `.phead` (title, artist/key line, style/mood) is `position:sticky` at the top of the chart in Play mode.
- The key/capo "changed, Save or Discard" note `#vd` moves into the Key drawer (`#pkfb`) while Playing (`window.__placeVd`), and the Key tab shows a yellow dot (`.alert`) while it is showing. The "Not backed up yet" bar `#fbanner` stays hidden in Play.
- v3.97: Mute buttons (Mixer and Loops panel) are speaker icons (`spk()`), red with a line through when muted. Output side options read BOTH SIDES, LEFT, RIGHT. `#dhint` is hidden (`hintText` returns ""), `#dedit` is always open, and drawer width is `--dw` (up to 760px; Key drawer up to 460px).

- v3.98: Help has a "Sample connection to iPad" section (inline SVG, classes prefixed `sc-`) before Mixer and Pedalboard.
- v3.101: input streams ask for 2 channels (`channelCount:{ideal:2}`); `wireIn` picks the channel from `songtrak-inch`, falling back to channel 1 with a message if the device gives only one.
- v3.100: `--dw` never exceeds the screen: `min(760px, 100vw - rail - 6px, max(440px, ...))`, so drawers fit an iPhone.
- v3.102: the Settings, Help, Tuner, Mixer, Pedalboard, Loops and Backup close buttons share the red "✕ Exit" style of `#pexit` (one CSS rule after it).
- v3.103: Exit buttons are `white-space:nowrap` and slimmer under 520px wide, so "✕ Exit" stays on one line on an iPhone.
- v3.104: channel choice defaults to `d` (Default): the stream is requested exactly as before, with no `channelCount`. Only `1`, `2` or `m` ask for 2 channels (iPhone recording failed with the 2-channel request).
- v3.105: Select mode shows a red "✕ Exit select" button (`#seldone`, same look as Exit) and an explanation line `#selhint` while everything else is switched off.
- v3.106: under 520px wide the Play bar is two rows (nav, A−/A+, Speed; then drums Start and Start scroll; `.pright`/`.pgrp` use `display:contents` and `order`), and the Play tabs are narrower (`--rail` 32px).
- v3.107: the Backup and restore status line `#cst` is a highlighted box (accent border and tint, bold) with a short flash, and scrolls into view when its text changes.
- v3.108: "Copy songs as text" explains how the clipboard reaches another device (note or message to yourself; Universal Clipboard) on the button, in the status message and in Help.
- v3.109: "Tap in…" (`#dtapin`; `#dtap` is the older Tap tempo button, overlay `#tapin`, code block "Tap in" after `#dgo` onclick): four pads record taps into `rd` at the nearest step while a loop plays; the pad sounds are chosen per pad and kept in the device-local key `songtrak-tapin` (JSON array of 4 row letters, default `["k","s","h","o"]`). Writes the existing beat rows only; no file format change.
- v3.110: built-in patterns Blues shuffle (`bluesh`), Slow blues (`blueslow`), Texas shuffle (`blueshuf`) and a turnaround of "After 11 bars" (12-bar form with the fill as bar 12). The song format only gains the value `t:11`; older app versions treat it as off.
- v3.111: Sound levels panel (`#dlv`) with a slider per drum sound, a Small-speaker kick switch, built-in boosts for ride, hats and percussion (`DEF`), applied in `hit()` through `lvg()`; the beat grid is `max-content` wide with the sound names column sticky on the left.
- v3.112: optional per-song pedals and drum levels. A song may carry `fx` (array of 4 cleaned chains, same shape as `songtrak-fx` `c`) and `dl` (`{l:{row:0-200},ks:0|1}`); absent means the device defaults (`songtrak-fx` / `songtrak-drumlv`, which only change while a song has no own copy). Applied from `renderChart()` via `window.__songFx` / `window.__songDl`; toggled by `[data-f=song]` in the Pedals drawer and `#dlsong` in Sound levels. Library file: songs gain optional `fx` and `dl` (older apps ignore them). Song text files carry `{fx: base64 JSON}` and `{dl: base64 JSON}`. `drumsIn` now accepts the blues pattern ids.
- v3.113: the input channel choice array is `CHS` (it was also named `CHN` from v3.101, which overwrote the Guitar/Voice/Bass/Pass-through names and showed "d"); `CHN` is only the four track names.
