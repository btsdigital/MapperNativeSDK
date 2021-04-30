//
//  TimeInterval.swift
//  mapper
//
//  Created by Никишин Ибрахим on 6/9/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

extension TimeInterval {
    func hasPassed(since: TimeInterval) -> Bool {
        return Date.timeIntervalSinceReferenceDate - self > since
    }
}
