//
//  Keychain+Extensions.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 27.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import KeychainAccess

extension Keychain {
    static func isExistKey(for alias: String) -> Bool {
        let keychain = Keychain()
        let data = try? keychain.getData(alias)
        return data != nil
    }

    static func removeKeys(for alias: String) {
        let keychain = Keychain()
        try? keychain.remove(alias)
    }
}
