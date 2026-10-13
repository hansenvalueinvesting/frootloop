# Frootloop — working notes

- iPhone-only clone of NOOP's iOS app for a WHOOP 5.0. Upstream: https://github.com/ryanbr/noop
- Git workflow: develop on the session branch, then merge everything into `main` and push `main`.
- No local Xcode: CI (`.github/workflows/ios.yml`, macos-26) is the compiler. Check the run after every push.
- Frootloop deviations from NOOP are marked with `Frootloop:` comments (onboarding removed in
  `StrandiOS/App/StrandiOSApp.swift`, corner button in `StrandiOS/App/RootTabView.swift`, connect gate
  `connectionConfiguredKey` in `Strand/BLE/BLEManager.swift`, demo data in `StrandiOS/App/DemoDataView.swift`
  + `Strand/Data/AppleDemoSeeder.swift`, now compiled into Release).
- Hansen installs with Sideloadly (computer-based); no in-app or SideStore update feed. New builds = install the latest-release .ipa via Sideloadly.
