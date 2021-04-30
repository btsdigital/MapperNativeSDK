//
//  TransferRequest.swift
//  mapper
//
//  Created by Никишин Ибрахим on 3/3/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

private struct TransferRequestSum: Encodable {
    let value: Decimal
    let currencyCode: Int
}

private struct TransferRequestReceiver: Encodable {
    let identifier: String
    let organization: [String: String]
}

struct FeeRequest: PrivateRequest, BankRequest {
    
    var path: String {
        return "mapper/organization/\(bin)/transfer/individual/fee"
    }
    let method: Method = .post
    
    var bin: String
    let senderAccountNumber: String
    let sum: Money
    let receiverId: String
    let receiverBankBin: String
    let mcc: Mcc?
    
    var bodyParameters: [String: Encodable]? {
        let parameters: [String: Encodable] = [
            "senderAccountNumber": senderAccountNumber,
            "amount": TransferRequestSum(value: sum.amount, currencyCode: sum.currency.rawValue),
            "receiver": TransferRequestReceiver(identifier: receiverId, organization: ["bin": receiverBankBin]),
            "mcc": mcc?.code
        ]
        return parameters
    }
}

struct TransferValidationRequest: PrivateRequest, BankRequest {
    
    var path: String {
        return "mapper/organization/\(bin)/transfer/individual/validate"
    }
    let method: Method = .post
    
    var bin: String
    let senderAccountNumber: String
    let sum: Money
    let receiverId: String
    let receiverBankBin: String
    let mcc: Mcc?
    
    var bodyParameters: [String: Encodable]? {
        let parameters: [String: Encodable] = [
            "senderAccountNumber": senderAccountNumber,
            "amount": TransferRequestSum(value: sum.amount, currencyCode: sum.currency.rawValue),
            "receiver": TransferRequestReceiver(identifier: receiverId, organization: ["bin": receiverBankBin]),
            "mcc": mcc?.code
        ]
        return parameters
    }
}

struct TransferRequest: PrivateRequest, BankRequest {
    var path: String {
        return "mapper/organization/\(bin)/transfer/individual/perform"
    }
    let method: Method = .post
    
    let bin: String
    let senderAccountNumber: String
    let sum: Money
    let receiverId: String
    let receiverBankBin: String
    let mcc: Mcc?
    let txId: String
    
    var bodyParameters: [String: Encodable]? {
        let parameters: [String: Encodable] = [
            "senderAccountNumber": senderAccountNumber,
            "amount": TransferRequestSum(value: sum.amount, currencyCode: sum.currency.rawValue),
            "receiver": TransferRequestReceiver(identifier: receiverId, organization: ["bin": receiverBankBin]),
            "mcc": mcc?.code,
            "txId": txId
        ]
        return parameters
    }
}

struct ConfirmTransferRequest: PrivateRequest, BankRequest {
    var path: String {
        return "mapper/organization/\(bin)/transfer/individual/confirm"
    }
    let method: Method = .post
    
    let bin: String
    let txId: String
    let confirmationCode: String
    
    var bodyParameters: [String: Encodable]? {
        return [
            "code": confirmationCode,
            "txId": txId
        ]
    }
}

struct CheckUserInBankRequest: PrivateRequest {
    var path: String {
        return "mapper/organization/\(alias)/account/\(userId)"
    }
    let method: Method = .get

    let alias: String
    let userId: String
}
