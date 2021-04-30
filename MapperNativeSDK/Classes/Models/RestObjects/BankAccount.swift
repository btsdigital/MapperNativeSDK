//
//  AccountInfo.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 25.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

typealias BankAccountClosure = (BankAccount) -> Void

public final class BankAccount: Decodable {
    public let accountNumber: String
    public let balance: Money
    public weak var bank: Bank?
}
