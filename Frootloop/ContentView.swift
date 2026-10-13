import SwiftUI

struct ContentView: View {
    let monitor: HeartRateMonitor

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "heart.fill")
                .font(.system(size: 48))
                .foregroundStyle(.red)
                .symbolEffect(.pulse, isActive: monitor.bpm != nil)
            Text(monitor.bpm.map(String.init) ?? "--")
                .font(.system(size: 96, weight: .bold, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
                .animation(.default, value: monitor.bpm)
            Text("BPM")
                .font(.title3)
                .foregroundStyle(.secondary)
            Spacer()
            Text(statusText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button(monitor.status == .idle ? "Connect" : "Disconnect") {
                if monitor.status == .idle { monitor.connect() } else { monitor.disconnect() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(monitor.status == .bluetoothOff || monitor.status == .unauthorized)
        }
        .padding()
    }

    private var statusText: String {
        switch monitor.status {
        case .bluetoothOff: "Bluetooth is off"
        case .unauthorized: "Allow Bluetooth for Frootloop in Settings"
        case .idle: "Not connected"
        case .scanning: "Looking for your WHOOP…"
        case .connecting: "Connecting…"
        case .connected: "Connected to \(monitor.deviceName ?? "WHOOP")"
        }
    }
}
