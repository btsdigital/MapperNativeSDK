//
//  CharacterSet+Custom.swift
//  mapper
//
//  Created by Никишин Ибрахим on 3/13/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

extension CharacterSet {
    static var digitsAndPlus: CharacterSet {
        return CharacterSet(charactersIn: "0123456789+")
    }
    
    static var digitsAndMoneySeparator: CharacterSet {
        return CharacterSet(charactersIn: "0123456789\(Money.Constants.separator)")
    }
}
