//
//  ViewController.swift
//  BluetoothScannerTester
//
//  Created by Marek Niedbach on 06/11/2019.
//  Copyright © 2019 Silvair. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let centralManager = CentralManager(notifier: NotificationCenter.default)
    private var stateObserver: NotificationObserver<AdapterState>?
    private var deviceObserver: NotificationObserver<UUID>?

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
        print("state: \(newState)")
        if case .poweredOn = newState {
            centralManager.startScan()
        }
    }

    private func onDeviceFound(_ uuid: UUID) {
        print("device: \(uuid)")
    }
}
