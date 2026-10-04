# Demo video

**File:** `demo.mp4` in this folder, or the hosted link (see below)
FILE LINK: https://drive.google.com/file/d/1gxJtzw4TVuFHfKFSobKS_KBr1Bs-sfSO/view?usp=drive_link
**Length:** aim for 3 to 5 minutes
**Recorded on:**
OBS

## What it shows

A short list, in order, so a viewer can skip to what they need:

- 0:23 what the app is and who it is for
- 1:05 The app screen categories
- 4:40 Inside the racer Profile
- 4:48 Inside the course page
- 5:10 How is it build
- 6:18 Where it stands what I am working now, Known gaps, Next steps or what are the things to do

Cover, in this order: the main user journey end to end, anything that only works
on a real device (camera, GPS, sensors), and the thing you are proudest of.

## Getting it into the repo

GitHub **blocks any file over 100 MB** and warns over 50 MB, so compress before
you commit:

```bash
ffmpeg -i raw.mp4 -vcodec libx264 -crf 28 -preset slow \
       -vf scale=-2:720 -acodec aac -b:a 96k demo.mp4
```

Raise `-crf` (28 to 32) or drop to `-2:480` if it is still too large. If it still
does not fit, attach it to a **GitHub Release** or upload it unlisted and link it
here. Never commit the raw capture: git keeps it forever even after you delete
it.

## Before you record

- Real data off the screen: no classmates' names, numbers, faces or messages.
- Notifications off.
- Sensible sample data, not "asdf".
- One unbroken take per feature. Say what you are doing while you do it.
