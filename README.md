# Frootloop

A personal, offline iPhone app for the WHOOP 5.0 strap — a clone of [NOOP](https://github.com/ryanbr/noop)'s iOS app
(PolyForm Noncommercial 1.0.0, see `LICENSE` / `NOTICE`). Personal, non-commercial use only.

## Changes from NOOP
- **No onboarding.** No first-run wizard, Terms gate or automatic What's New sheet; launch goes straight to the dashboard.
- **Starts disconnected.** The app never scans for or connects to a strap until you connect one yourself; until then it shows whatever data is already stored.
- **Connection control in the top-right corner** of every tab. It shows link status and opens the Devices manager (pair / connect / disconnect / switch).
- **Demo data.** More → Demo data loads NOOP's synthetic 120-day dataset to try every screen without a strap, and removes it again.
- iPhone only (macOS, Android and Watch targets removed). Bundle prefix `com.hansen.frootloop`.

## Layout
| Path | Contents |
|---|---|
| `Strand/` | Shared app code (screens, BLE, data); macOS-only files are excluded in `project.yml` |
| `StrandiOS/` | iOS app shell (`App/StrandiOSApp.swift`, `App/RootTabView.swift`, `App/ConnectionCornerButton.swift`) |
| `StrandiOSWidgets/`, `StrandiOSShared/` | Widgets / Live Activity extension and code shared with it |
| `Packages/` | Protocol, storage, analytics, import, design packages |

## Build
GitHub Actions (`.github/workflows/ios.yml`) generates the project with XcodeGen and builds an unsigned `Frootloop.ipa`
on every push. Pushes to `main` also publish it to the `latest` release.

## Install on iPhone
Sideload the `.ipa` with SideStore (or AltStore), which signs it on-device with your free Apple ID (needs a computer once
for SideStore's initial setup; it re-signs every 7 days on the phone).

## Pairing a WHOOP 5.0
Close the official WHOOP app, tap the band until its LEDs flash blue, then use the top-right control → add a WHOOP 5.0 / MG.
