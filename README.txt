SongTrak standalone web app
===========================
Files: index.html, manifest.webmanifest, sw.js, icon-180.png, icon-192.png, icon-512.png
Upload ALL files together to the same folder of any HTTPS web host (GitHub Pages, Netlify, Cloudflare Pages, your own site).
Open the address in Safari on iPad, tap Share > Add to Home Screen, then launch SongTrak from the new icon. It runs full screen and works offline after the first visit.

Differences from the Claude-hosted version:
- Each person's library is stored in that browser on that device.
- Cloud database sync and "Write with AI" are not available.
- Save as text downloads a file; use Share > Include all song data and the library file buttons (in cloud sync settings) to move songs between devices.
- To publish an update, replace the files; users get the new version on their next online visit (change "songtrak-v2" in sw.js to force it).
