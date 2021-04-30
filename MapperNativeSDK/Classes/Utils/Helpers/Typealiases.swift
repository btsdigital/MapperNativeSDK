//
//  Typealiases.swift
//  AituPay
//
//  Created Eduard Pyatnitsyn on 18/10/2019.
//  Copyright © 2019 BTS Digital. All rights reserved.
//

import Foundation

enum VoidResult {
    case success
    case failure(Error)
}

typealias VoidClosure = () -> Void
typealias StringResult = Result<String, Error>
typealias BoolResult = Result<Bool, Error>
