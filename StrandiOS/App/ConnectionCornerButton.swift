#if os(iOS)
import SwiftUI
import StrandDesign

/// Frootloop: the always-available connection control, pinned to the top-right corner over every tab
/// (`RootTabView`). Shows whether the strap link is up and opens the Devices manager, where a strap is
/// paired, connected, disconnected or switched.
struct ConnectionCornerButton: View {
    @EnvironmentObject private var live: LiveState
    @EnvironmentObject private var router: NavRouter

    var body: some View {
        Button { router.openDevices() } label: {
            HStack(spacing: 6) {
                Circle()
                    .fill(live.connected ? Color.green : StrandPalette.textSecondary)
                    .frame(width: 8, height: 8)
                Image(systemName: live.connected
                      ? "antenna.radiowaves.left.and.right"
                      : "antenna.radiowaves.left.and.right.slash")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(StrandPalette.textPrimary)
            .padding(.horizontal, 12)
            .frame(height: 34)
            .background(.ultraThinMaterial, in: Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(live.connected
                            ? "Strap connected. Configure connection"
                            : "Not connected. Configure connection")
    }
}
#endif
