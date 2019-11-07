//
//  NotificationObserver.swift
//  BluetoothScannerTester
//
//  Created by Marek Niedbach on 06/11/2019.
//  Copyright © 2019 Silvair. All rights reserved.
//

import Foundation

class NotificationObserver<Type> {
    private let onReceived: (Type) -> Void

    init(_ name: Notification.Name, onReceived: @escaping (Type) -> Void) {
        self.onReceived = onReceived
        NotificationCenter.default.addObserver(self, selector: #selector(onNotificationReceived), name: name,
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func onNotificationReceived(_ notification: Notification) {
        guard let value = notification.object as? Type else { return }

        onReceived(value)
    }
}
