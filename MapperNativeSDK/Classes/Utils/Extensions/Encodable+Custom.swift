//
//  Encodable+Custom.swift
//  mapper
//
//  Created by Никишин Ибрахим on 1/22/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

extension Encodable {
     func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}
