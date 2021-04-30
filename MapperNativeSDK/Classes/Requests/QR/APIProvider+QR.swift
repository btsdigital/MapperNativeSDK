//
//  APIProvider+QR.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 18.05.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

public typealias GenerateQRDataResponseCompletion = (Result<QRGenerateData, Error>) -> Void
public typealias DecodeQRDataResponseCompletion = (Result<QRScanResponse, Error>) -> Void

protocol QrAPI {
    func generateQRData(id: String,
                        organizationBin: String,
                        amount: Money?,
                        comment: String?,
                        mccCode: String?,
                        completion: @escaping GenerateQRDataResponseCompletion)
    func decodeQRData(_ data: String, completion: @escaping DecodeQRDataResponseCompletion)
}

extension APIProviderImpl {
    func generateQRData(id: String,
                        organizationBin: String,
                        amount: Money?,
                        comment: String?,
                        mccCode: String?,
                        completion: @escaping GenerateQRDataResponseCompletion) {
        let request = GenerateQRRequest(id: id, organizationBin: organizationBin, amount: amount, comment: comment, mccCode: mccCode)
        requestManager.send(request: request, completion: completion)
    }

    func decodeQRData(_ data: String, completion: @escaping DecodeQRDataResponseCompletion) {
        let request = DecodeQRDataRequest(data: data)
        requestManager.send(request: request, completion: completion)
    }
}
