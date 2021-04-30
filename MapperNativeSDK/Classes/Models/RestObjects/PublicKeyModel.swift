//
//  PublicKeyModel.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 10.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

struct PublicKeyModel: Decodable {
    public let publicKey: String
    public let salt: String
}
