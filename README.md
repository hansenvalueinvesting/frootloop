# Frootloop

A personal, offline iPhone app for the WHOOP 5.0 strap. No account, no cloud.

Protocol facts come from [NOOP](https://github.com/ryanbr/noop) (`docs/PROTOCOL_WHOOP5.md`).

## Status
- **Step 1 (current):** connect to the strap and show live heart rate (standard BLE 0x2A37, no bond needed).

## Build
GitHub Actions builds an unsigned `Frootloop.ipa` on every push (macOS runner, XcodeGen from `project.yml`).
Pushes to `main` publish it to the `latest` release.

## Install on iPhone
Sideload the `.ipa` with SideStore (or AltStore), which signs it on-device with your free Apple ID.
The free signature lasts 7 days; SideStore refreshes it.

## Using it
Close the official WHOOP app (or turn off Bluetooth on any other phone paired to the strap), open Frootloop, tap **Connect**.
