//
//  Content-Type.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 17.01.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

enum ContentType {
    case json
    case plain
    case multipart(String)
    case none
}

extension ContentType: RawRepresentable {
    public typealias RawValue = String

    init?(rawValue: String) {
        return nil
    }

    public var rawValue: RawValue {
        switch self {
        case .json:
            return "application/json"
        case .plain:
            return "text/plain"
        case .multipart(let boundary):
            return "multipart/form-data; boundary=" + boundary
        case .none:
            return ""
        }
    }
}
