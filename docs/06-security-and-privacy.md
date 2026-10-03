# Security and privacy

This repository is public. The following security and privacy checks were
reviewed for the Mario Kart Wiki project.

**Last checked:** 2026-10-03

## What this app stores

| Data | Where it lives | Who can see it |
| --- | --- | --- |
| Mario Kart game information | Local application data | Anyone using the app |
| Character information | Local application data | Anyone using the app |
| Track information | Local application data | Anyone using the app |
| Vehicle information | Local application data | Anyone using the app |
| Item information | Local application data | Anyone using the app |
| Images and descriptions | Project assets / local application data | Anyone using the app |

The application does not currently collect or store personal user information.

## Secrets

- Values my app needs at run time: **None**
- Where they live locally: **N/A — no runtime secrets are currently required**
- Where the deploy workflow gets them: **N/A — no deployment secrets are currently required**
- Anything my deployed web build carries that a visitor could read, and why
  that is acceptable: **Nothing sensitive. The application currently does not
  contain private API keys, authentication credentials, or other secrets.**

## What protects the data on the service side

Nothing leaves the device or application for a backend service at this stage.
The Mario Kart Wiki currently does not use Firestore, Supabase, or another
backend database.

## Checklist

- [x] `.env` (or `env.json`) is in `.gitignore`, and `.env.example` is committed
- [x] `git log -p | grep -i "api_key\|secret\|password\|token"` finds nothing real
- [x] No service account file, keystore or `service_role` key anywhere in the repo
- [x] Security rules or RLS policies written and tested, not left open — **N/A because the app has no backend service**
- [x] No real personal data in sample data, screenshots or the video
- [x] No course or university credentials anywhere
- [x] Anyone whose data appears in a test was asked first — **N/A because no real personal data is used**

No keys were found or revoked during this security review.
