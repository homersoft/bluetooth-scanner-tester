//
//  CentralManager.swift
//  BluetoothScannerTester
//
//  Created by Marek Niedbach on 06/11/2019.
//  Copyright © 2019 Silvair. All rights reserved.
//

import Foundation
import CoreBluetooth

protocol EventNotifier {
    func notify(_ state: AdapterState)
    func notify(_ deviceUuid: UUID)
}

enum AdapterState {
    case poweredOn
    case poweredOff
    case resetting
    case unauthorized
    case unsupported
    case unknown
}

class CentralManager: NSObject {
    private var central: CBCentralManager?
    private let notifier: EventNotifier

    init(notifier: EventNotifier) {
        self.notifier = notifier
    }

    func initialize() {
        central = CBCentralManager(delegate: self, queue: nil, options: nil)
    }

    func startScan() {
        central?.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScan() {
        central?.stopScan()
    }
}

extension CentralManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            notifier.notify(.poweredOn)
        case .poweredOff:
            notifier.notify(.poweredOff)
        case .resetting:
            notifier.notify(.resetting)
        case .unauthorized:
            notifier.notify(.unauthorized)
        case .unsupported:
            notifier.notify(.unsupported)
        case .unknown:
            notifier.notify(.unknown)
        @unknown default:
            fatalError("Unknown central manager state")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        notifier.notify(peripheral.identifier)
    }
}
