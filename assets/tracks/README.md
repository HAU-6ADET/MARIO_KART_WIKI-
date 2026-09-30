# Track map images

No track images ship with this project yet — every track currently falls
back to its colored flag tile (see `imageAsset` in `lib/data/mock_data.dart`,
mirroring how `Character.imageAsset` works for characters).

If you add real course maps/screenshots, check you have the rights to
include them before sharing this app beyond your own personal/coursework
use -- that's not something this README (or an AI) can clear for you.

## To add a track's map image

1. Save the image here, e.g. `assets/tracks/rainbow_road.png`. A roughly
   4:3 image works best — that's the aspect ratio used in both the track
   list row and the Track Detail header.
2. In `lib/data/mock_data.dart`, set that track's `imageAsset`:
   ```dart
   Track(
     id: 'rainbow_road',
     ...
     imageAsset: 'assets/tracks/rainbow_road.png',
   ),
   ```
3. Run `flutter pub get` (this folder is already declared in pubspec.yaml)
   and hot-reload.

`TrackMapImage` (see `lib/widgets/track_map_image.dart`) shows the image
wherever a track map appears -- list rows and Track Detail's header -- and
automatically falls back to the flag tile for any track whose `imageAsset`
is `null` or whose file fails to load. It also decodes each image at the
size it's actually shown at (via `cacheWidth`/`cacheHeight`) instead of at
the source file's full resolution, so dropping in large PNGs won't bloat
memory use in the scrolled track list.
