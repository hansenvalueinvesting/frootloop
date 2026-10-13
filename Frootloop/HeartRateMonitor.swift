import CoreBluetooth
import Observation

/// Finds a WHOOP 5.0 / MG strap and streams live heart rate from the standard BLE
/// Heart Rate Measurement characteristic (0x2A37), which works without a bond.
@Observable
final class HeartRateMonitor: NSObject {
    enum Status: Equatable {
        case bluetoothOff, unauthorized, idle, scanning, connecting, connected
    }

    private(set) var status: Status = .idle
    private(set) var bpm: Int?
    private(set) var deviceName: String?

    /// WHOOP 5.0 / MG vendor service, advertised by the strap (docs/PROTOCOL_WHOOP5.md in NOOP).
    private static let whoopService = CBUUID(string: "FD4B0001-CCE1-4033-93CE-002D5875F58A")
    private static let heartRateService = CBUUID(string: "180D")
    private static let heartRateMeasurement = CBUUID(string: "2A37")

    @ObservationIgnored private var central: CBCentralManager!
    @ObservationIgnored private var peripheral: CBPeripheral?
    @ObservationIgnored private var wantsConnection = true

    override init() {
        super.init()
        central = CBCentralManager(delegate: self, queue: .main)
    }

    func connect() {
        wantsConnection = true
        guard central.state == .poweredOn else { return }
        // A strap already held by iOS (e.g. a previous session) does not advertise, so attach to it first.
        if let existing = central.retrieveConnectedPeripherals(withServices: [Self.whoopService]).first {
            attach(existing)
            return
        }
        status = .scanning
        central.scanForPeripherals(withServices: [Self.whoopService])
    }

    func disconnect() {
        wantsConnection = false
        central.stopScan()
        if let peripheral { central.cancelPeripheralConnection(peripheral) }
        status = .idle
        bpm = nil
    }

    private func attach(_ peripheral: CBPeripheral) {
        central.stopScan()
        self.peripheral = peripheral
        peripheral.delegate = self
        deviceName = peripheral.name
        status = .connecting
        central.connect(peripheral)
    }

    /// Parses a Heart Rate Measurement value: flags bit 0 selects a UInt8 or UInt16 bpm field.
    static func parseBPM(_ data: Data) -> Int? {
        let bytes = [UInt8](data)
        guard let flags = bytes.first else { return nil }
        if flags & 0x01 == 0 {
            return bytes.count >= 2 ? Int(bytes[1]) : nil
        }
        return bytes.count >= 3 ? Int(bytes[1]) | Int(bytes[2]) << 8 : nil
    }
}

extension HeartRateMonitor: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            if wantsConnection { connect() }
        case .unauthorized:
            status = .unauthorized
        default:
            status = .bluetoothOff
            bpm = nil
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        attach(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        status = .connected
        peripheral.discoverServices([Self.heartRateService])
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if wantsConnection { connect() } else { status = .idle }
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        bpm = nil
        if wantsConnection { connect() } else { status = .idle }
    }
}

extension HeartRateMonitor: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let service = peripheral.services?.first(where: { $0.uuid == Self.heartRateService }) else { return }
        peripheral.discoverCharacteristics([Self.heartRateMeasurement], for: service)
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristic = service.characteristics?.first(where: { $0.uuid == Self.heartRateMeasurement }) else { return }
        peripheral.setNotifyValue(true, for: characteristic)
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic.uuid == Self.heartRateMeasurement, let data = characteristic.value,
              let value = Self.parseBPM(data), value > 0 else { return }
        bpm = value
    }
}
