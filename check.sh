#!/bin/sh
# Release check: run before every commit (a git pre-commit hook calls it too).
# Fails if sw.js is empty/damaged, the cache name was not bumped, the version
# string is missing, or the script in index.html does not parse.
cd "$(dirname "$0")" || exit 1
fail(){ echo "CHECK FAILED: $1"; exit 1; }
[ -s sw.js ] || fail "sw.js is empty"
[ "$(wc -c < sw.js)" -gt 300 ] || fail "sw.js is suspiciously small"
grep -q 'const C="songtrak-v[0-9]*"' sw.js || fail "sw.js has no songtrak-vN cache name"
grep -q 'addEventListener("fetch"' sw.js || fail "sw.js has no fetch handler"
grep -q 'id="ver"[^>]*>v[0-9][0-9.]* ' index.html || fail "version string missing in index.html"
node --check sw.js || fail "sw.js does not parse"
node -e '
const s=require("fs").readFileSync("index.html","utf8");
const m=[...s.matchAll(/<script>([\s\S]*?)<\/script>/g)].map(x=>x[1]).sort((a,b)=>b.length-a.length)[0];
if(!m){console.error("no script");process.exit(1)}
new Function(m);' || fail "index.html script does not parse"
# On a pull request or commit that changes index.html, sw.js must change too.
base=$(git merge-base HEAD origin/main 2>/dev/null)
if [ -n "$base" ] && ! git diff --quiet "$base" -- index.html 2>/dev/null; then
  git diff --quiet "$base" -- sw.js 2>/dev/null && [ -z "$(git diff --cached --name-only -- sw.js)" ] && fail "index.html changed but the sw.js cache name was not bumped"
fi
echo "check ok"
