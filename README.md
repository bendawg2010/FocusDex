<div align="center">

# FocusDex

### *Catch your year of work.*

[![License: MIT](https://img.shields.io/badge/License-MIT-FFD960.svg?style=for-the-badge)](LICENSE)
[![Made with Swift](https://img.shields.io/badge/Made%20with-Swift-FF6B6B.svg?style=for-the-badge&logo=swift&logoColor=white)](https://swift.org)
[![Platform: macOS](https://img.shields.io/badge/Platform-macOS-47A0FF.svg?style=for-the-badge&logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Status: v1.0 in progress](https://img.shields.io/badge/Status-v1.0%20in%20progress-2EE6A0.svg?style=for-the-badge)](https://focusdex.pages.dev)

</div>

---

## What is FocusDex?

**FocusDex is a pixel-art, Pokemon-style productivity app for macOS.**

Live in your menubar. Set a timer. Focus on real work. Earn Pokeballs in real time
based on the length of your session. When the timer ends, **Safari Mode** opens —
a screen full of creatures that spawned during your session. Throw your balls.
Catch them. Fill your Dex.

Different conditions spawn different creatures: time of day, app context, weather,
sleep, streaks, even real astronomical events. **147 creatures designed.** Your
Pokedex becomes the receipt of your year of work.

> Pokemon mechanics for real focus. The Animal Crossing of productivity.

---

## Quick demo

Try the in-browser playable demo:

**[focusdex.pages.dev/demo](https://focusdex.pages.dev/demo)**

No install required. Throws, catches, confetti, all of it.

---

## Screenshots

> Screenshots are coming. The full Claude Design package — 147 creature sprite
> sheets, UI mockups, and the brand style guide — has been fetched and integrated
> into `FocusDex-Designs/`. Sprite art is being generated next and will drop in
> here. Until then, the [live demo](https://focusdex.pages.dev/demo) is the best
> look at the vibe.

<div align="center">

*Coming soon:*

| Menubar | Focus Mode | Safari Catch | Trainer Card |
|---------|------------|--------------|--------------|
| _placeholder_ | _placeholder_ | _placeholder_ | _placeholder_ |

</div>

---

## Features

What's done and shipping in the v1.0 build:

- [x] **Menubar app** with live countdown — always visible, never in your way
- [x] **Focus timer with full persistence** — pokeballs, streak, and Dex all
      survive quits, reboots, and updates
- [x] **Catch minigame in Safari Mode** — playable on its own without a focus
      session, for testing or just relaxing
- [x] **4 Pokeball tiers** earned by session length:
  - Pokeball — 5 min sessions
  - Greatball — 25 min sessions
  - Ultraball — 90 min sessions
  - Masterball — 8 hr deep work sessions
- [x] **Onboarding starter selection** — choose between **Codesprite**,
      **Inkling**, or **Pixibrush** on first launch
- [x] **Confetti on catch** — particle physics, color cycles, the whole bit
- [x] **Sound effects + haptics** — full audio + trackpad feedback on throws,
      catches, and tier-ups
- [x] **Right-click context menu** — quick actions from the menubar icon
- [x] **Keyboard shortcuts**:
  - `⌘N` — new focus session
  - `⌘.` — cancel current session
  - `⌘G` — go to / open Safari Mode

---

## Build it

Two commands. You need [Homebrew](https://brew.sh) and Xcode.

```bash
brew install xcodegen
./scripts/build.sh
```

The build script runs `xcodegen` against `project.yml`, then builds Release with
`xcodebuild`. The final app lands at:

```
build/DerivedData/Build/Products/Release/FocusDex.app
```

Drag it to `/Applications`, launch, accept the menubar permission, and you're in.

---

## Project layout

```
FocusDex/
├── App/                          ← SwiftUI source
│   ├── FocusDexApp.swift         ← @main entry
│   ├── AppDelegate.swift         ← menubar setup (LSUIElement)
│   ├── ContentView.swift         ← popover root + tabs
│   ├── Theme.swift               ← brand palette + view modifiers
│   ├── Pixels.swift              ← string-grid sprite renderer
│   ├── Onboarding.swift          ← starter selection flow
│   ├── Persistence.swift         ← UserDefaults + JSON model save
│   ├── SoundFX.swift             ← AVAudioEngine playback
│   ├── Confetti.swift            ← particle physics on catch
│   ├── Data/                     ← all 147 creatures, by spawn category
│   │   ├── Creatures_Starters.swift
│   │   ├── Creatures_TimeOfDay.swift
│   │   ├── Creatures_Weather.swift
│   │   └── … (10 more)
│   └── Features/
│       ├── Focus/                ← timer + Pokeball earning
│       ├── Dex/                  ← creature model + dex view
│       ├── Balls/                ← stockpile view
│       ├── Battle/               ← battle scene (planned)
│       ├── History/              ← session log
│       ├── Trainer/              ← trainer card (planned)
│       └── About/                ← credits + tip jar
│
├── scripts/
│   ├── build.sh                  ← xcodegen + xcodebuild
│   ├── build-dmg.sh              ← codesign + notarize + DMG
│   ├── release.sh                ← Sparkle release cut
│   └── sparkle/                  ← Sparkle helper binaries
│
├── website/                      ← Cloudflare Pages promo site
│   ├── index.html
│   ├── styles.css
│   ├── app.js
│   ├── pixel-art.js              ← in-browser sprite renderer
│   ├── demo/                     ← playable web demo
│   └── appcast.xml               ← Sparkle update feed
│
├── project.yml                   ← xcodegen source of truth
└── LICENSE                       ← MIT
```

Design artifacts (147 creatures, 30 animation prompts, full UI bundle, story
bible) live next door in **`../FocusDex-Designs/`**.

---

## Design system

FocusDex has a real brand. See `App/Theme.swift` and `website/00-STYLE-GUIDE.md`.

**Palette:**

| Token       | Hex       | Use                                |
|-------------|-----------|------------------------------------|
| Pink        | `#FF6B6B` | Hero gradient start, accents       |
| Magenta     | `#C147FF` | Primary buttons, glow              |
| Blue        | `#47A0FF` | Focus mode gradient                |
| Mint        | `#2EE6A0` | Success states, "session active"   |
| Yellow      | `#FFD960` | Catch sparkle, MIT badge           |
| Deep BG     | `#06010F` | Popover background top             |
| Card BG     | `#0C0420` | Popover background bottom          |

**Type:** Apple system stack — `-apple-system, "SF Pro Text", "Helvetica Neue"`
for UI, with pixel-rendered display headers.

**Sprite renderer:** `App/Pixels.swift` parses character-grid sprite definitions
("k" = black, "p" = pink, etc.) and renders them at any scale in SwiftUI. Every
creature sprite is plain text in a `.swift` file — diff-friendly, version-able,
no asset catalogs.

---

## Roadmap

What's next:

- [ ] **Sparkle auto-updates** wired up (helper binaries already in `scripts/sparkle/`)
- [ ] **Battle system** — turn-based creature vs creature on long-session bonus rounds
- [ ] **Trainer Card window** — standalone window showing badges, stats, and your top creatures
- [ ] **Trade via share codes** — encode + decode creatures as 6-char strings
- [ ] **Full 147 creatures wired up** — sprite data is in `Data/`, art generation in flight
- [ ] iCloud sync across Macs
- [ ] Co-focusing with friends
- [ ] Gym Leaders + Elite Four (boss focus challenges)
- [ ] Champion Mode postgame
- [ ] NOTCH-PRIME ARG

---

## Contributing

PRs welcome. See **[CONTRIBUTING.md](CONTRIBUTING.md)** for the dev loop, code
style, and how to claim a sprite to draw.

Quick start: file an issue, fork, branch, run `./scripts/build.sh`, ship.

---

## Tip jar

FocusDex is **free forever** under MIT. If it saves you an afternoon of doom
scrolling, throw a couple bucks at the dev:

- **Cash App:** [$Dryeetsolutions](https://cash.app/$Dryeetsolutions)
- **GitHub Sponsors:** [github.com/sponsors/bendawg2010](https://github.com/sponsors/bendawg2010)

Every tip goes straight into Apple Developer renewal, code signing certs, and
more sprite generation credits.

---

## The Notchyverse

FocusDex is part of the **Notchyverse** — a family of indie macOS apps from
[@bendawg2010](https://github.com/bendawg2010):

- **[Notchy](https://notchy.app)** — the menubar app that started it all
- **[FocusDex](https://focusdex.pages.dev)** — you are here
- **[Brainrot-mon](https://github.com/bendawg2010)** — the cursed cousin
- *…more coming. The lore is real.*

---

## License

**MIT.** Free forever. Use it, fork it, ship a derivative, sell a paid version —
just keep the copyright notice. See [LICENSE](LICENSE).

---

<div align="center">

Made with caffeine + xcodegen by [@bendawg2010](https://github.com/bendawg2010).

*Catch creatures by focusing. The Pokedex is your year of work.*

</div>
