//
//  Throttler.swift
//  mapper
//
//  Created by Никишин Ибрахим on 6/9/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

final class Throttler {
    private var lastFire: TimeInterval = 0
    private let delay: TimeInterval
    private let queue: DispatchQueue

    init(delay: TimeInterval = 1, queue: DispatchQueue = DispatchQueue.main) {
        self.delay = delay
        self.queue = queue
    }

    func throttle(action: @escaping VoidClosure, onDelay: VoidClosure? = nil) {
        if delay.hasPassed(since: lastFire) {
            queue.async { [weak self] in
                action()
                self?.lastFire = Date.timeIntervalSinceReferenceDate
            }
        } else {
            queue.async {
                onDelay?()
            }
        }
    }
}
