# Character face images go here

This project ships with **no image files** in this folder on purpose:
Mario, Luigi, Peach, Bowser, Yoshi, and Toad's character art is Nintendo's
copyrighted IP, so it can't be generated or bundled by an AI tool (or really
by anyone without a license). Every avatar currently falls back to a colored
initials circle (see `lib/widgets/character_avatar.dart`), which is fully
functional and copyright-safe on its own.

## To turn on real face images

1. Get an image for a character — your own artwork, an image you have
   rights to use, or (for a school/personal project) a screenshot you've
   captured yourself. Save it here as a square-ish PNG or JPG, e.g.:
   ```
   assets/characters/mario.png
   assets/characters/luigi.png
   ```
2. In `lib/data/mock_data.dart`, set that character's `imageAsset`:
   ```dart
   Character(
     id: 'mario',
     name: 'Mario',
     ...
     imageAsset: 'assets/characters/mario.png',
   ),
   ```
3. Run `flutter pub get` (picks up the new asset from pubspec.yaml, which
   already declares `assets/characters/`) and hot-reload.

That's it — no other code changes needed. `CharacterAvatar` shows the image
wherever an avatar appears (list rows, "recently viewed", Character Detail's
header) and automatically falls back to the initials circle for any
character whose `imageAsset` is still `null` or whose file fails to load, so
you can convert characters one at a time.
