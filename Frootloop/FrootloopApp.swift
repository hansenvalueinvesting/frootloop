import SwiftUI

@main
struct FrootloopApp: App {
    @State private var monitor = HeartRateMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView(monitor: monitor)
        }
    }
}
