#if os(iOS)
import SwiftUI
import StrandDesign

/// Frootloop: loads NOOP's synthetic 120-day demo dataset (`AppleDemoSeeder`) so every screen can be
/// tried without a strap, and removes it again before real strap data is collected.
struct DemoDataView: View {
    @EnvironmentObject private var repo: Repository
    @AppStorage("frootloop.demoDataLoaded") private var demoLoaded = false
    @State private var working = false
    @State private var message: String?

    var body: some View {
        ScreenScaffold(title: "Demo data", subtitle: "Try every screen without a strap") {
            NoopCard {
                VStack(alignment: .leading, spacing: 14) {
                    Text(demoLoaded
                         ? "Demo data is loaded: 120 days of synthetic recovery, sleep, strain, workouts and Apple Health rows."
                         : "Fills an empty app with 120 days of synthetic recovery, sleep, strain, workouts and Apple Health rows. Nothing here is real.")
                        .font(.subheadline)
                        .foregroundStyle(StrandPalette.textSecondary)
                    if demoLoaded {
                        Text("Remove it before pairing your WHOOP. Removing also deletes any strap or Apple Health data stored since.")
                            .font(.footnote)
                            .foregroundStyle(StrandPalette.textSecondary)
                    }
                    Button(demoLoaded ? "Remove demo data" : "Load demo data") {
                        Task { await run() }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(demoLoaded ? .red : StrandPalette.accent)
                    .disabled(working)
                    if working { ProgressView() }
                    if let message {
                        Text(message)
                            .font(.footnote)
                            .foregroundStyle(StrandPalette.textSecondary)
                    }
                }
            }
        }
    }

    private func run() async {
        guard let store = await repo.storeHandle() else {
            message = "The data store isn't ready yet. Try again in a moment."
            return
        }
        working = true
        defer { working = false }
        do {
            if demoLoaded {
                try await AppleDemoSeeder.removeDemo(from: store)
                demoLoaded = false
                message = "Demo data removed."
            } else if try await AppleDemoSeeder.loadDemo(into: store) {
                demoLoaded = true
                message = "Demo data loaded. Open Today, Sleep or Trends."
            } else {
                message = "Real data is already stored, so demo data was not loaded."
            }
            await repo.refresh()
        } catch {
            message = "Failed: \(error.localizedDescription)"
        }
    }
}
#endif
