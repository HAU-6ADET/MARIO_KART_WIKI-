# Character face images

Five characters already have images wired up: **Luigi, Peach, Bowser, Yoshi,
Toad** (see `imageAsset` in `lib/data/mock_data.dart`). **Mario** still has
no image and falls back to the initials circle.

These are official Mario Kart character renders, provided by the project
owner. If this app is ever shared beyond your own personal/coursework use,
double-check you have the rights to include them -- that's not something
this README (or an AI) can clear for you.

## To add Mario's (or replace any) image

1. Save a square-ish PNG/JPG here, e.g. `assets/characters/mario.png`.
2. In `lib/data/mock_data.dart`, set that character's `imageAsset`:
   ```dart
   Character(
     id: 'mario',
     ...
     imageAsset: 'assets/characters/mario.png',
   ),
   ```
3. Run `flutter pub get` (the folder is already declared in pubspec.yaml)
   and hot-reload.

`CharacterAvatar` (see `lib/widgets/character_avatar.dart`) shows the image
wherever an avatar appears -- list rows, "recently viewed" on Home, and
Character Detail's header -- and automatically falls back to the initials
circle for any character whose `imageAsset` is `null` or whose file fails to
load.
