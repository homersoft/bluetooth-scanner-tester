//
//  ViewController.swift
//  BluetoothScannerTester
//
//  Created by Marek Niedbach on 06/11/2019.
//  Copyright © 2019 Silvair. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var logTextView: UITextView!

    private let centralManager = CentralManager(notifier: NotificationCenter.default)
    private var stateObserver: NotificationObserver<AdapterState>?
    private var deviceObserver: NotificationObserver<UUID>?
    private var uniqueDeviceUuids = Set<UUID>()
    private var lastUniqueDevicesCount = 0 {
        didSet { countLabel.text = "\(lastUniqueDevicesCount)" }
    }
    private var lastDeviceFoundDate: Date = Date.distantFuture
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        stateObserver = NotificationObserver(.adapterStateChanged) { [weak self] newState in
            self?.onAdapterStateChanged(newState)
        }
        deviceObserver = NotificationObserver(.deviceFound) { [weak self] uuid in
            self?.onDeviceFound(uuid)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        centralManager.initialize()
    }

    private func onAdapterStateChanged(_ newState: AdapterState) {
        log(newState)
        stateLabel.text = "\(newState)"
        if case .poweredOn = newState {
            centralManager.startScan()
        }
    }

    private func onDeviceFound(_ uuid: UUID) {
        uniqueDeviceUuids.insert(uuid)

        let elapsedTime = Date().timeIntervalSince(lastDeviceFoundDate)
        lastDeviceFoundDate = Date()
        lastUniqueDevicesCount = uniqueDeviceUuids.count

        if elapsedTime > 2 {
            log(String(format: "gap: %.2f \twhen \(lastUniqueDevicesCount) devices", elapsedTime))
        }
    }

    private func log(_ log: Any) {
        let logToDisplay = "\(dateFormatter.string(from: Date()))  \t\(log)"
        displayLog(logToDisplay)
    }

    private func displayLog(_ log: String) {
        logTextView.text += "\n\(log)"
    }
}
