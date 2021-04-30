//
//  AnyEncodable.swift
//  mapper
//
//  Created by Никишин Ибрахим on 1/22/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

struct AnyEncodable: Encodable {
    let value: Encodable
    
    init(_ value: Encodable) {
        self.value = value
    }
    
    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
