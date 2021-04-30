//
//  BankRequest.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 05.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

protocol BankRequest: Request {
    var bin: String { get }
    var shouldDecryptRequest: Bool { get }
    var shouldEncryptResponse: Bool { get }
}

extension BankRequest {
    var contentType: ContentType {
        return .plain
    }
    var shouldDecryptRequest: Bool {
        return true
    }
    var shouldEncryptResponse: Bool {
        return true
    }
}
