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
- Edit `index.html` with small, exact string replacements and check that the script still parses before committing.
- Storage keys: `cc2` (library in localStorage), `songtrak-*` for newer keys. Prefix any new key with `songtrak-` (GitHub Pages sites under one username share storage).
- Library file format: `{at, j}` where `j` is a JSON string `{songs, lists, hist, hp, uname}`. "Copy library text" wraps it as compressed, line-wrapped text starting `SONGTRAK-LIBRARY-GZ`.
- Song files are ChordPro-style: `{key: value}` directive header, then chords inline as `[G]word`, sections as `# Verse`.
- Key model: `key` is the original key; `mkey` is My Key (sounding key); `capo` and `mkr` (chords rewritten into My Key) are stored separately.
- Per-song extras: `tuning`, `drums` (`p`, `b` tempo, `w` swing, `h` human feel, `c` count-in, `s` sync with scroll, `e` edited rows), `speed`.

## Testing
Use Playwright with a local server (`python3 -m http.server`). Cover: library load, save to Files (mock `navigator.share`), drums panel, tuner pitch detection, import and export round trips. The iPad file picker is unreliable for this user, so keep the paste, drag-and-drop and Load test songs routes working.

## Release flow
Work on a branch, open a pull request, and let the owner merge. Do not push to `main` directly.
