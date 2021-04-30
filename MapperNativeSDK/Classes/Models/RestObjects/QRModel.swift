//
//  QRModel.swift
//  AituPay
//
//  Created by Eduard Pyatnitsyn on 31.03.2020.
//  Copyright © 2020 BTS Digital. All rights reserved.
//

import Foundation

public enum ReceiverType {
    case account(id: String, organization: Bank)
    case merchant(name: String, accountId: String, organization: FOTransferData)
}

public struct ReceiverTransferFinancialData: Decodable {
    let id: String
    let organization: Bank
}

struct MerchantTransferData: Decodable {
    let name: String
    let accountId: String
    let organization: FOTransferData
}

public struct QRScanResponse: Decodable {
    
    public let amount: Money?
    public let comment: String?
    public let mcc: Mcc?
    public let details: ReceiverTransferFinancialData

    enum CodingKeys: String, CodingKey {
        case amount, comment, type, details, mcc
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        mcc = try? container.decodeIfPresent(Mcc.self, forKey: .mcc)
        amount = try? container.decodeIfPresent(Money.self, forKey: .amount)
        comment = try? container.decodeIfPresent(String.self, forKey: .comment)
        details = try container.decode(ReceiverTransferFinancialData.self, forKey: .details)
    }
}

public struct QRGenerateData: Decodable {
    public let data: String
}

struct QRGenerationParams: Codable {
    let amount: Money?
    let comment: String?

    enum CodingKeys: String, CodingKey {
        case amount, comment
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(Money.formatter.string(for: amount?.amount), forKey: .amount)
        try container.encode(comment, forKey: .comment)
    }
}
