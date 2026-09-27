<!--
  This is your project's front page. Replace every placeholder below.
  It is the first thing your instructor and any future employer will read, and
  the live link in it is how your project gets opened for grading.

  New here? Read START-HERE.md first. Delete this comment when you are done.
-->

# Mario Kart World Wiki

> A mobile reference app for Mario Kart World: browse every racer, track, and
> kart/bike, check unlock requirements and stats, and save favorites — for
> players who want a fast, offline companion with no accounts and no online
> multiplayer features.

**Live demo:** https://YOURUSERNAME.github.io/YOUR-REPO/ <!-- GitHub Pages is set up already; replace once you've created the repo from this template and turned Pages on -->
**Demo video:** `docs/demo.mp4` (link it here once it exists)
**Course:** Applications Development and Emerging Technologies (6ADET), Holy Angel University
**Author:** Your Name <!-- replace -->

This repository lives in the author's own GitHub account and is public on
purpose. There is no `student.json` here and there should not be one: see
`docs/06-security-and-privacy.md` for what a public repo means for secrets and
personal data.

---

## Screenshots

⚠️ **The images below are the *mockup*, not screenshots of the running app** —
this project was assembled without a Flutter SDK available to actually build
and run it, so no real screenshot exists yet. **Before you submit:** run the
app yourself (`flutter run -d chrome`, or open the deployed link), capture
2–5 real screens at phone size, drop them in `docs/assets/` as
`screen-*.png`, and swap the table below to point at those instead. Screenshots
in the README must be real and current — see the checklist in `START-HERE.md`.

| Home | Character Guide | Character Detail |
| --- | --- | --- |
| ![Home](docs/assets/mockup-home.png) | ![Character Guide](docs/assets/mockup-characters.png) | ![Character Detail](docs/assets/mockup-character-detail.png) |

| Track Guide | Favorites |
| --- | --- |
| ![Track Guide](docs/assets/mockup-tracks.png) | ![Favorites](docs/assets/mockup-favorites.png) |

## What it does

- Browse all racers, filter by weight class (Speed / Balanced / Heavy), and
  see each one's stats, unlock requirement, and best-paired kart.
- Browse all tracks by cup, with a difficulty badge (Easy / Medium / Hard).
- Star any character, track, or kart to save it to Favorites.
- See recently-viewed characters on the Home screen.
- Everything works fully offline — all data is bundled locally, no backend.

## Built with

| | |
| --- | --- |
| Framework | Flutter (Dart), Material 3 |
| State | Plain `ChangeNotifier` + `InheritedNotifier` (`lib/data/app_state.dart`) — no external state package |
| Storage | None yet — favorites are in-memory only and do not survive a restart (see Status below) |
| Other packages | `google_fonts` (Poppins, per the design system) · `device_preview` (this template's phone-frame preview, kept on for the deployed build) |

## Running it yourself

```bash
flutter pub get
flutter run -d web-server --web-port 8080
```

Then open http://localhost:8080. Requires Flutter (run `flutter --version` and
put yours here). <!-- replace with your actual version -->

On success you should land on the Home screen: the "Mario Kart World Wiki"
title, a search bar, four category cards, and a "Recently viewed" row, inside
the DevicePreview phone frame.

### Environment variables

None. This app has no backend and needs no API keys — `.env.example` is
template boilerplate and can be ignored (or deleted) for this project.

## Privacy and secrets

- This app stores no personal data at all. Favorites and "recently viewed"
  live in memory only, are local to each visitor's browser tab, and are lost
  on refresh — nothing is sent anywhere.
- There are no secrets: no API keys, no backend, nothing in `.env`.
- All character/track/kart data is bundled sample data; no real names, faces,
  or personal information appear anywhere in the app, its screenshots, or its
  video.

## Project documentation

| Document | |
| --- | --- |
| [Proposal](docs/01-proposal.md) | the problem, the users, the scope |
| [Mockup and wireframes](docs/02-mockup.md) | what it looks like, and the screen flow |
| [Design system](docs/03-design-system.md) | colors, type, spacing, components |
| [Weekly reports](docs/04-weekly-reports.md) | what happened each week |
| [Demo video](docs/05-demo-video.md) | the recording and what it shows |
| [Start here](START-HERE.md) | how this repo works (delete once you have read it) |
| [Security and privacy](docs/06-security-and-privacy.md) | the checklist, filled in |

## Status and what is next

**Working:** Home, Character Guide (with class filters), Character Detail
(stats, unlock info, best-paired karts), Track Guide, Favorites (with
star/unstar and an empty state). Five characters (Luigi, Peach, Bowser,
Yoshi, Toad) show a real face image; Mario still shows initials pending an
image.

**Known gaps, honestly:**
- **Not yet compiled or run.** This code was written without a Flutter SDK
  available, so it has not been built or tested end to end. Run
  `flutter analyze` and `flutter test` and fix whatever the real toolchain
  flags before you submit.
- **Karts & Bikes and Track Detail screens are extrapolated**, not from the
  original mockup — no mockup frame existed for either. See the `NOTE:`
  comments at the top of `lib/screens/kart_guide_screen.dart`,
  `lib/screens/kart_detail_screen.dart`, and `lib/screens/track_detail_screen.dart`.
- **Search is a no-op.** The search bar/icon appears on three screens but has
  no results screen behind it yet.
- **No persistence.** Favorites and "recently viewed" are lost on refresh —
  next step would be `shared_preferences` for a purely local, no-backend fix.
- **Locked characters aren't blocked.** Toad shows a lock icon in the list
  but tapping still opens his detail screen instead of being stopped.

## Credits

- Packages: see `pubspec.yaml` (Flutter, `google_fonts`, `device_preview`,
  `cupertino_icons`)
- Character images (`assets/characters/*.png`): official Mario Kart character
  renders, © Nintendo. Used here for a personal/coursework project — confirm
  your own rights before using them anywhere this app is distributed beyond
  that.
- People who helped, and how: <!-- fill in -->

## AI use

This project was built with **extensive AI assistance** (Claude, by
Anthropic) — the app's architecture, all screens and widgets, the theme
implementation, the image-avatar system, a runtime-overflow bug fix, and this
documentation were all produced with heavy AI involvement across a single
conversation. That conversation did not have a Flutter SDK available, so
**none of the code has actually been compiled, run, or tested** — treat this
as a strong first draft to verify, not a finished, verified app.

![Built with AI assistance](https://img.shields.io/badge/built%20with-AI%20assistance-0b5fff)

See [AI-USAGE.md](AI-USAGE.md) for the full, dated, commit-linked account —
**you still need to fill that file in yourself**, with your own specific
prompts, what you kept vs. changed, and where the AI got it wrong. This
summary is not a substitute for that.

## Licence

MIT, see [LICENSE](LICENSE). Change it if you want different terms.
