//
//  Request.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 17.01.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

protocol PrivateRequest: Request {}

protocol Request {
    var path: String { get }
    var version: String { get }
    var method: Method { get }
    var contentType: ContentType { get }
    var bodyParameters: [String: Encodable]? { get }
    var queryParameters: [String: String]? { get }

    func buildUrlRequest() -> URLRequest
}

extension Request {
    var method: Method {
        return .get
    }

    var version: String {
        return "v1"
    }

    var contentType: ContentType {
        return .json
    }
    
    var bodyParameters: [String: Encodable]? {
        return nil
    }

    var queryParameters: [String: String]? {
        return nil
    }
}

extension Request {
    func buildUrlRequest() -> URLRequest {
        let url = buildURL(path: path)
        guard
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }

        components.queryItems = buildQueryParameters()

        guard let requestUrl = components.url?.absoluteURL else {
            fatalError("Unable to create URL request")
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        if contentType != .none {
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        Logger.log("\(request.httpMethod ?? "") : \(request.url?.absoluteString ?? "")", type: .network, level: .info)
        if let body = buildBodyParameters() {
            request.httpBody = body
        }

        return request
    }

    func buildURL(path: String) -> URL {
        var url = AppEnvironment.current.baseURL

        url.appendPathComponent("api")
        url = url.appendingPathComponent(version)
        url = url.appendingPathComponent(path)

        return url
    }

    private func buildQueryParameters() -> [URLQueryItem]? {
        guard let queryParameters = queryParameters else {
            return nil
        }
        let items = queryParameters.compactMap { keyValue -> URLQueryItem? in
            return URLQueryItem(name: keyValue.key, value: keyValue.value.description)
        }
        Logger.log(items.description, type: .network, level: .info)
        return items
    }

    private func buildBodyParameters() -> Data? {
        let anyEncodableDict = bodyParameters?.mapValues { AnyEncodable($0) }
        let jsonEncoder = JSONEncoder()
        guard let dict = anyEncodableDict else {
            return nil
        }
        var bodyData: Data?
        if #available(iOS 13.0, *) {
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
            bodyData = try? jsonEncoder.encode(dict)
        } else {
            guard let data = try? jsonEncoder.encode(dict) else {
                return nil
            }
            guard let string = String(data: data, encoding: .utf8) else {
                return nil
            }
            let fixedString = string.replacingOccurrences(of: "\\/", with: "/")
            bodyData = fixedString.data(using: .utf8)
        }
        guard let data = bodyData else {
            return nil
        }
        Logger.log(data.prettyJSON, type: .network, level: .info)
        return data
    }
}
