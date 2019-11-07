//
//  NotificationCenter.swift
//  BluetoothScannerTester
//
//  Created by Marek Niedbach on 06/11/2019.
//  Copyright © 2019 Silvair. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let deviceFound = Notification.Name("deviceFound")
    static let adapterStateChanged = Notification.Name("adapterStateChanged")
}

extension NotificationCenter: EventNotifier {
    func notify(_ state: AdapterState) {
        NotificationCenter.default.post(name: .adapterStateChanged, object: state)
    }

    func notify(_ deviceUuid: UUID) {
        NotificationCenter.default.post(name: .deviceFound, object: deviceUuid)
    }
}
