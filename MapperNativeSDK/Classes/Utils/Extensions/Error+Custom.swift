//
//  Error+Custom.swift
//  mapper
//
//  Created by Никишин Ибрахим on 1/24/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

extension Error {
    var message: String {
        guard let error = self as? APIError else {
            return localizedDescription
        }
        return error.message
    }
}
