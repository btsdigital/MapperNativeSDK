//
//  PhotoUploadRequest.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 17.01.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

protocol PhotoUploadRequest: Request {
    var data: Data { get }
}

extension PhotoUploadRequest {
    func buildUrlRequest() -> URLRequest {
        let newLine = "\r\n"

        let url = buildURL(path: path)
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = method.rawValue
        let boundary = generateBoundary()
        var data = Data()
        guard let photos = data.photoData(boundary: boundary, fileName: "avatar") else {
            assertionFailure("Incorrect image")
            return request as URLRequest
        }

        data.append(photos)

        let boundaryClose = newLine + "--" + boundary + "--" + newLine
        if let boundaryCloseData = boundaryClose.data(using: .utf8, allowLossyConversion: false) {
            data.append(boundaryCloseData)
        }

        request.setValue("multipart/form-data; boundary=" + boundary,
                         forHTTPHeaderField: "Content-Type")

        request.setValue(String(data.count), forHTTPHeaderField: "Content-Length")

        request.httpBody = data as Data
        return request as URLRequest
    }

    private func generateBoundary() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
