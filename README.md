# FocusDex

> Catch creatures by focusing. The Animal Crossing of productivity.

Pokemon-style mechanics for real focus. Earn Pokeballs by focusing on real work. Catch creatures on your breaks. Different conditions spawn different creatures — time of day, app context, weather, sleep, streaks, even real astronomical events.

**Status**: design-complete, app skeleton scaffolded, v1.0 in progress.
**License**: MIT — free forever.
**Site**: [focusdex.pages.dev](https://focusdex.pages.dev)
**Tip jar**: [cash.app/$Dryeetsolutions](https://cash.app/$Dryeetsolutions)

---

## What's in this repo

```
FocusDex/
├── project.yml             ← xcodegen source of truth
├── App/
│   ├── FocusDexApp.swift   ← @main entry
│   ├── AppDelegate.swift   ← menubar setup (LSUIElement)
│   ├── ContentView.swift   ← popover root + tabs
│   ├── FocusDex.entitlements
│   └── Features/
│       ├── Focus/          ← timer + Pokeball earning
│       ├── Dex/            ← creature model + dex view
│       └── Balls/          ← stockpile view
├── scripts/
│   └── build.sh            ← xcodegen + xcodebuild
└── website/                ← Cloudflare Pages promo site
    ├── index.html
    ├── styles.css
    ├── app.js
    └── appcast.xml         ← Sparkle update feed
```

Design artifacts (147 creatures + 30 animation prompts + UI bundle + story bible) live in `../FocusDex-Designs/`.

---

## Build the Mac app

```bash
brew install xcodegen        # one-time
./scripts/build.sh           # generates project + builds Release
open build/DerivedData/Build/Products/Release/FocusDex.app
```

## Deploy the site

```bash
cd website
npx wrangler pages deploy . --project-name=focusdex --branch=main --commit-dirty=true
```

---

## Roadmap

- [x] Design every creature (147 total)
- [x] Build promo site
- [x] App skeleton (menubar shell, focus timer, ball stockpile)
- [ ] Spawn engine (time/app/weather/sleep)
- [ ] Catch mechanic (Safari Mode break view)
- [ ] Sparkle auto-updates wired up
- [ ] Battle system
- [ ] Sync via iCloud
- [ ] Trading via share codes
- [ ] Co-focusing
- [ ] Gym Leaders + Elite Four
- [ ] Champion Mode postgame
- [ ] NOTCH-PRIME ARG

---

## Made by

[@bendawg2010](https://github.com/bendawg2010) · part of the Notchyverse.
Tip jar: [$Dryeetsolutions](https://cash.app/$Dryeetsolutions).
