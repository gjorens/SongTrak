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
- Device-local keys (not in the library file): `songtrak-nav` (navigation history, newest last, max 100 events `{t,s,l,v,ts}`), `songtrak-loops` (IndexedDB for recorded loops), `songtrak-tnin`/`songtrak-tnsens` (tuner), `songtrak-pedal`, `songtrak-nolooper`, `songtrak-health` (Library health log, max 100), `songtrak-bak` (up to 3 library backups), `songtrak-corrupt` (damaged copies set aside, never auto-deleted), `songtrak-trash` (last 50 deleted songs with setlist positions), `songtrak-expmeta` (Select export checkbox "Include song data", 0 or 1), `songtrak-drumvol`, `songtrak-lw` (left panel width in px, 220 or more; absent means the default 270), `songtrak-lcl`/`songtrak-lcd`/`songtrak-ccl`/`songtrak-ccd` (lyric and chord colours for light and dark mode; absent means the scheme default, or the older `cc-lc`/`cc-cc` value if set), `songtrak-ui` (App text size multiplier 1, 1.25, 1.5 or 1.75; absent means 1).
- Left column has two views: Songs, and Setlists (list of setlists; tapping one opens it with its songs, same sort and A-Z rail). `slOpen` says whether a setlist is open; `mgrOn` is the 3-column setlist manager.
- Library file format: `{at, j}` where `j` is a JSON string `{songs, lists, hist, hp, uname, pats, fsets}`. `fsets` is the list of saved fill sets `{id,name,L,f}` (`L` steps per bar, `f` three row sets); like `pats`, a file without it loads as none. `pats` is the list of saved drum patterns `{id,name,p,n,e}` (`p` base pattern, `n` bars 1 to 4, `e` row strings); a file without `pats` loads as no saved patterns. "Copy library text" wraps it as compressed, line-wrapped text starting `SONGTRAK-LIBRARY-GZ`.
- Song files are ChordPro-style: `{key: value}` directive header, then chords inline as `[G]word`, sections as `# Verse`.
- Key model: `key` is the original key; `mkey` is My Key (sounding key); `capo` and `mkr` (chords rewritten into My Key) are stored separately.
- Per-song extras: `tuning`, `drums` (`p`, `b` tempo, `w` swing, `h` human feel, `c` count-in, `s` sync with scroll, `n` bars 1 to 4, `t` turnaround (a fill bar replaces the last bar of every t bars; one of 2, 3, 4, 6, 8, 12, 16; absent when off), `f` three one-bar fill row sets that the turnaround rotates through, kept even when the turnaround is off, `u` id of the saved pattern in use, `e` edited rows; row letters k s h o r c plus a crash, d ride, t tom high, u tom low, p clap, w cowbell, y shaker, b tambourine; the song keeps its own copy of the beat, so exports and deleted saved patterns never lose it), `speed`.

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

Ask first, and do not merge until the owner says yes, for risky changes:
- anything that changes the library file format, the storage keys, or how data is saved, loaded, imported or deleted (risk of losing songs or loops);
- changes to `sw.js` caching logic (risk of the iPad app getting stuck on an old copy);
- anything that removes a feature or data.

Never push to `main` directly. Merge through the pull request, using a normal merge commit.

## Open items to raise with Gerry
- At the start of the next session, remind Gerry about the USB audio interface test (tuner input from a DI box and the looper). He had no results as of 7 Nov 2026. Keep reminding each session until he reports back, then delete this item.
