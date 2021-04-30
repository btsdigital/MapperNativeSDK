//
//  TransferModels.swift
//  mapper
//
//  Created by Никишин Ибрахим on 3/3/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

public struct FeeResponse: Decodable {
    public let amount: Money
    public let type: String
}

public struct ValidateTransferResponse: Decodable {
    public let txId: String
    public let amount: Money
    public let type: String
}

public struct TransferResponse: Decodable {
    public let txId: String
    public let confirmationScheme: ConfirmationCodeScheme?
}

public struct ConfirmationData {
    let targetUserId: String
    let targetName: String
    let targetFinInstitute: Bank
    let from: BankAccount
    let amount: Money
    let fee: Money
    let txId: String
    let mcc: Mcc?
}

public struct ConfirmationCodeScheme: Decodable {
    enum CodingKeys: String, CodingKey {
        case codeLength, channel
    }
    
    public enum ConfirmationCodeSchemeDelivery: String, Decodable {
        case sms = "SMS"
        case push = "PUSH"
    }
    
    public let length: Int
    public let delivery: ConfirmationCodeSchemeDelivery
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        length = try container.decode(Int.self, forKey: .codeLength)
        let delivery = try container.decode(String.self, forKey: .channel)
        self.delivery = ConfirmationCodeSchemeDelivery(rawValue: delivery) ?? .sms
    }
}
