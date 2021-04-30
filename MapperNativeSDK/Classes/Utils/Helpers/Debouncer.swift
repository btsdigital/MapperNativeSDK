//
//  Debouncer.swift
//  AituPay
//
//  Created by Eduard Pyatnitsyn on 14/11/2019.
//  Copyright © 2019 BTS Digital. All rights reserved.
//

import Foundation

public protocol DebounceItemState {
    var isCancelled: Bool { get }
}

final class Debouncer {
    enum Constants {
        static let defaultDelay = 0.3
    }

    private let delay: TimeInterval
    private let queue: DispatchQueue
    private var item: DispatchWorkItem?

    public init(seconds: TimeInterval = Constants.defaultDelay, qos: DispatchQoS = .default) {
        queue = DispatchQueue(label: "Debounce \(Date())", qos: qos)

        guard seconds > 0 else {
            assertionFailure("seconds should be greater then 0")
            delay = Constants.defaultDelay
            return
        }

        delay = seconds
    }

    deinit {
        abort()
    }

    public func debounce(_ block: @escaping () -> Void) {
        queue.async { [weak self] in
            let item = DispatchWorkItem { [weak self] in
                self?.abort()
                DispatchQueue.main.async {
                    block()
                }
            }
            self?.dispatch(item)
        }
    }

    public func debounce(block: @escaping (DebounceItemState) -> Void) {
        queue.async { [weak self] in
            let item = DispatchWorkItem { [weak self] in
                guard let self = self, let item = self.item else {
                    return
                }
                self.abort()
                DispatchQueue.main.async {
                    block(item)
                }
            }
            self?.dispatch(item)
        }
    }

    func cancel() {
        queue.async { [weak self] in
            self?.abort()
        }
    }

    private func dispatch(_ item: DispatchWorkItem) {
        abort()
        self.item = item
        queue.asyncAfter(deadline: .now() + delay, execute: item)
    }

    private func abort() {
        item?.cancel()
        item = nil
    }
}

extension DispatchWorkItem: DebounceItemState {}
