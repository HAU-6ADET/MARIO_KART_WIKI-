# AI usage

This project was built with AI assistance. This file is the record of it. It is
graded as the finals badge, and it is worth 100 points.

Start it in week 1 and keep it up as you go. The commit history of this file is
part of the evidence: a file written all at once the night before the deadline
looks exactly like what it is.

## 1. How I used AI

At least six entries. One per real use. Every entry needs a commit link.

## Development Log

### 2026-09-15- App-wide wallpaper

**Tool:** Claude (Anthropic), claude.ai chat.

**What I asked for:**  
Make my line-art image (`MAIN.jpg`) the main background of the whole Flutter app.

**What it gave back:**  
An `AppScaffold` widget that paints the image behind every screen, with a dark base color and adjustable opacity. It also added an `AppBackdrop` setting in `theme.dart` and a transparent app bar. Every screen's `Scaffold` was replaced with `AppScaffold`.

**What I kept, what I changed, and why:**  
I kept the overall implementation and tuned the `AppBackdrop.imageOpacity` so the wallpaper is visible while keeping the text and other UI elements readable.

**Commit:**  
https://github.com/THEBOI123bot/MARIO_KART_WIKI-/commit/SHA


### 2026-09-19 - Character screens redesign and driver profiles

**Tool:** Claude (Anthropic), claude.ai chat.

**What I asked for:**  
Fix the character design, add more information, and make the character screens match the racing-game theme.

**What it gave back:**  
Driver cards for the character list containing a picture, race-number plate, class tag, tagline, and mini stat bars.

It also created a full driver-profile screen containing:

- Driver biography
- Playstyle
- Strengths and weaknesses
- Speedometer-style overall gauge
- Stat bars with roster ranking
- Best kart setups
- Best tracks
- Trivia

A `CharacterExtras` data file was also added so the existing `Character` model could remain unchanged.

**What I kept, what I changed, and why:**  
I kept the racing-game themed design, driver cards, profile layout, and additional character information. I kept `CharacterExtras` separate from the original `Character` model because it allowed the existing data structure to remain compatible while adding more detailed information to each driver.

**Commit:**  
https://github.com/THEBOI123bot/MARIO_KART_WIKI-/commit/SHA


### 2026-10-04 - Fact-checking the Mario Kart information

**Tool:** Claude (Anthropic) with web search.

**What I asked for:**  
Make the track, character, and kart information detailed and accurate.

**What it gave back:**  
It searched for real game facts, including which cup each course belongs to, which vehicles are bikes, and the debut games of characters, tracks, and vehicles. Only information that could be confirmed was used.

It also identified that one of my track screenshots showed a different course from the course name assigned to it. It additionally flagged that the real Mach Rocket has a low top speed, while my current data listed its speed as `85`.

**What I kept, what I changed, and why:**  
I kept the fact-checked information and corrected information that did not match the actual games. For the Mach Rocket, I changed the incorrect statistics to better reflect its real in-game characteristics rather than keeping the original `85` value. I also corrected the incorrectly labeled track information so that the screenshots and course names match.

**Commit:**  
https://github.com/THEBOI123bot/MARIO_KART_WIKI-/commit/SHA

## 2. Where the AI got it wrong

I notice that the use AI is mostly known for its design pixels sometimes it goes higher within 16px which results to an logical error, another mistake of an AI also is the build of the workflow within the deployment of my website I had to make my own workflow just to deploy and download the right version of the independencies. Mostly The buttons of are not functionable which i had to fix it and the placement of the image like an Image Asset I had to put it one by one for the profile of each character, tracks, and kart

### Case 1 - short title

- **What it gave me:**
- **What was wrong with it:**
- **What I did instead:**
- **Commit:** https://github.com/YOUR-USERNAME/YOUR-REPO/commit/SHA

## 3. Who wrote what

At least a fifth of this project is code you wrote yourself. Name it, and explain
it in your own words.

> Group projects: give each member their own heading below, and use your GitHub
> handle as the heading. You are graded on your own section.

### Written by me

- **File:** `lib/models/character.dart`, `lib/models/kart.dart`, `lib/models/track.dart`, `lib/data/characters.dart`, `lib/data/karts.dart`, `lib/data/tracks.dart`, `lib/data/track_extras.dart`, `lib/theme.dart`
- **Commit:** `FILL IN`
- **What it does and why it is built this way:** These files contain the original data models, mock data, track information, character information, kart information, and theme configuration that I created for the Mario Kart World Wiki app. I separated the data from the UI so the screens can display the information without having the actual data hard-coded throughout the widgets. This makes the project easier to organize, update, and maintain. The `TrackExtras` data is kept separate from the main `Track` model so additional information can be added without changing the original model structure.

### The AI-written part I understand best

- **File:** `lib/widgets/overall_gauge.dart`
- **Commit:** `FILL IN`
- **What it does and why we kept it:** The `OverallGauge` widget displays a driver's overall rating using a speedometer-style circular gauge. It takes the driver's rating and turns it into a visual element that is easier to understand than showing only a number. We kept it because it fits the racing-game theme and makes the driver profile screens more visually interesting while still clearly showing the driver's overall performance.
