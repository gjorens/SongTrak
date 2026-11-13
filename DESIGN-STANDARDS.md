# SongTrak design standards

Agreed with Gerry on 11 Nov 2026 (v3.124). Give this file to any new Claude conversation working on SongTrak, together with `CLAUDE.md`. Every screen should follow it. The values live in one CSS block at the end of the `<style>` in `index.html` (search for `v3.124 design standards`) and in the CSS variables below, so change a value in one place.

## The standards

| # | Standard | Value | Defined as |
|---|----------|-------|------------|
| 1 | Icon family | One family only: Lucide (outline, 24 px grid, 2 px round stroke). Never mix in emoji, text glyphs (▲ ▾ ⏮ ✕ and similar) or other sets. | `<symbol id="i-NAME">` sprite right after `<body>`; use `<svg class="ic"><use href="#i-NAME"/></svg>`; in JavaScript use `ic("NAME")` |
| 2 | Button height | Every button is 44 px high (scales with app text size). Length is only as wide as needed: icon-only buttons are 44 x 44, text buttons have 12 px side padding. Buttons are not stretched to fill a row unless they are a series that shares the row (for example the four header buttons, Songs and Setlists). | `--ch: calc(44px*var(--ui,1))`, `min-height` on `.btn`, `.gear`, `.tabs button`, `#pbar button` |
| 3 | Button colour | All functional buttons share one background. Importance is shown by the colour of the icon or text (accent for primary actions such as Play and Add song), never by a different fill. Selected state is a 2 px accent ring, not a new fill. | `--ctl-bg` (light `#f1f3fa`, dark `#202849`) |
| 4 | Text box colour | All text boxes, search boxes, selects and text areas share one background. | `--fld-bg` (light `#ffffff`, dark `#0d1121`) |
| 5 | Corner radius | One radius for every rectangle: buttons, boxes, windows, menus, cards, text boxes, list rows. Round shapes (rings, switches, sliders, dots) are the only exception. | `--r: 10px` |
| 6 | Outline | Every control has a 1 px outline slightly darker than its fill. | `--ctl-line` (light `#a9b1cd`, dark `#090c1b`) |
| 7 | Spacing between controls | 8 px everywhere. | `--gap: 8px` |
| 8 | Spacing from controls to a window or panel edge | 12 px everywhere. | `--pad: 12px` |
| 9 | Exit buttons | Red fill, white "✕ Exit" text, top right, same height and radius as other buttons. This is the one deliberate exception to standard 3. | `#pexit` and the shared close-button rule |
| 10 | Hidden elements | `[hidden]` must always win over a button's `display` rule. | `button[hidden],.pill[hidden],select[hidden],input[hidden],.btn[hidden]{display:none!important}` |
| 11 | Main page buttons | Add song = plus. Import = arrow into a box (tray). Play = right-pointing triangle, placed between previous and next (like a video recorder: arrow-left-from-line, play, arrow-right-from-line; the skip buttons show only when a setlist is open). Share = box with an arrow going up. Edit = slanted pencil. Back = left arrow. Listen and find = the word Find with the list-music icon. Tune stays as it is (guitar emoji, agreed). There is one Play button only (the floating one was removed). | markup in `index.html` |
| 12 | Sliders | Use the class `rng` on every `<input type="range">`: 44 px high touch area (`--ch`), a thin 8 px track with a visible outline, and a large 32 px round thumb in the accent colour (`--chord`) with a 3 px outline in the text colour (`--ink`) and a soft shadow, so it is easy to see and grab in light and dark mode. Never leave the browser's default thin slider. Dialogs must not block touch drags on sliders (the touchmove guard skips `input[type=range]`). Sliders are the one round shape allowed by standard 5. | `input.rng` rules in the `v3.149` block at the end of the `<style>` |
| 13 | Drop-down lists (selects) | Every `<select>` shows a chevron-down arrow (so it reads as a choice) and opens the app's own chooser dialog (`chooseDlg`: 44px buttons, current choice outlined with a tick, Cancel at the bottom) instead of the grey iPad/system picker. Done globally in the v3.151 block and script; new selects need no extra code. Add `data-native` to a select to keep the system picker. | `select`, `chooseDlg`, `--chev` |

## Icons in use (all Lucide, ISC licence)

plus, minus, import, share, pencil, play, arrow-left-from-line, arrow-right-from-line, arrow-left, arrow-up, arrow-down, maximize, circle-question-mark (help), settings, list-music, chevron-down, chevrons-right-left, x.

To add an icon: copy its `<path>` elements from the Lucide `icons/NAME.svg` file into a new `<symbol id="i-NAME" viewBox="0 0 24 24">` in the sprite. Lucide names change over time, so check the file exists. Credit: the ISC licence notice for Lucide is kept in `README.txt`.

- v3.142: Play bar converted (icons for skip, A-, A+, speed, drums Start/Stop, Loops, Tap in; 44px buttons, `--r`). Key drawer banner is fixed-height and grey until a change.

## Not yet converted (next passes)

- The song editor and its menus (text glyphs such as ▾, the search emoji).
- The Play bar glyph buttons (skip, A−, A+, speed −/+) and the Play drawers' special controls.
- Setlist manager, Settings, Backup and restore, Help headings.
- Existing sliders other than the tuner (Mixer, Loops, Pedals, drum sound levels, tempo) still use older looks and should get `class="rng"` in a later pass. Specialty controls that keep their own look on purpose: drum grid cells, the coloured Play tabs, tuner string buttons, list rows (green songs, purple setlists).
- The Tune button still uses an emoji.

## How to apply to a new screen

1. Use the existing classes (`.btn`, `.btn.ico`, `.pill`, `.tabs`, `.tools`, `.krow`, `.frow`) rather than new one-off rules.
2. Take colours, radius, gap and padding from the variables; do not write new hard-coded values.
3. Replace text glyphs and emoji with an `ic()` icon; give icon-only buttons an `aria-label` and a `title`.
4. Check the screen at iPad width, iPhone width (390 px), and in light and dark mode.


## v3.125 additions
- History button (`#hnav`) uses a custom pocket-watch icon (`pocket-watch`, drawn in Lucide style: circle, crown, ring, hands; not part of Lucide). Sort arrows `#sup`/`#sdn` icons are 26px (x ui scale).
- Previous/next song buttons (`#pv`/`#nx`) always show beside Play: they step through the open setlist, or the songs listed on screen.
- An icon catalogue page (all Lucide icons, in-use ones marked) can be rebuilt from the Lucide `icons` folder.

- v3.131: header row is back (chevron-left), history (pocket-watch), forward (chevron-right), then full screen, help, settings: all `.gear`, equal width and height.
