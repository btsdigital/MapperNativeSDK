//
//  Notification+Extensions.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 28.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didAddBank = Notification.Name("didAddBank")
    static let didUpdateBanks = Notification.Name("didUpdateBanks")
    static let didChangeWorkspace = Notification.Name("didChangeWorkspace")
}
