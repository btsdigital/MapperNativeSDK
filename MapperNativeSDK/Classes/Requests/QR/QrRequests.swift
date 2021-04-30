//
//  QrRequests.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 18.05.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

struct GenerateQRRequest: PrivateRequest {
    private struct Organization: Encodable {
        let bin: String
    }
    
    let path = "mapper/transfer/qr"
    let method: Method = .post

    let id: String
    let organizationBin: String
    let amount: Money?
    let comment: String?
    let mccCode: String?

    var bodyParameters: [String: Encodable]? {
        var parameters: [String: Encodable] = [
            "id": id,
            "organization": Organization(bin: organizationBin)
        ]
        if let amount = amount {
            parameters["amount"] = amount
        }
        if let comment = comment {
            parameters["comment"] = comment
        }
        if let mccCode = mccCode {
            parameters["mccCode"] = mccCode
        }
        return parameters
    }
}

struct DecodeQRDataRequest: PrivateRequest {
    let path = "mapper/transfer/qr"
    let method: Method = .put

    let data: String

    var bodyParameters: [String: Encodable]? {
        return [
            "data": data
        ]
    }
}
