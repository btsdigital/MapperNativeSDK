//
//  Bank.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 06.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

typealias BankClosure = (Bank) -> Void

public final class Bank: Decodable {
    public let bin: String
    public let name: String
    public let logo: String?

    public var isDefault: Bool = false
    public var accounts: [BankAccount] = []

    enum CodingKeys: String, CodingKey {
        case bin
        case name
        case logo
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bin = try container.decode(String.self, forKey: .bin)
        name = try container.decode(String.self, forKey: .name)
        logo = try! container.decodeIfPresent(String.self, forKey: .logo)
    }
}

struct ConnectedBanks: Decodable {
    let items: [Bank]
    let defaultBank: Bank?

    enum CodingKeys: String, CodingKey {
        case items = "organizations"
        case defaultBank = "defaultOrganization"
    }
}

public struct FOTransferData: Decodable {
    public let bin: String
}
