//
//  ResponseHandler.swift
//  Mapper
//
//  Created by Никишин Ибрахим on 8/10/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation
import KeychainAccess

final class ResponseHandler {
    private let finInstituteKeyStorage: FinInstituteKeyStorage
    private let specialErrorCompletions: [ErrorCode: VoidClosure]

    init(finInstituteKeyStorage: FinInstituteKeyStorage, specialErrorCompletions: [ErrorCode: VoidClosure]) {
        self.finInstituteKeyStorage = finInstituteKeyStorage
        self.specialErrorCompletions = specialErrorCompletions
    }

    func handleResponse<T: Decodable>(request: Request,
                                      data: Data?,
                                      response: URLResponse?,
                                      error: Error?,
                                      completion: @escaping (Result<T, Error>) -> Void) {
        if let error = error {
            handleError(error, completion: completion)
            return
        }
        guard let response = response as? HTTPURLResponse, var data = data else {
            return completion(.failure(NetworkError.noJSONData))
        }

        if let request = request as? BankRequest, request.shouldEncryptResponse {
            if finInstituteKeyStorage.containsKeys(fiBin: request.bin),
               let incomingString = String(data: data, encoding: .utf8),
               let decrypted = finInstituteKeyStorage.decryptSessionData(fiBin: request.bin, encryptedBase64: incomingString) {
                data = decrypted.data(using: .utf8)!
            }
        }

        #if DEBUG
        log(response, with: data)
        #endif

        self.handleResponse(response, data: data, completion: completion)
    }

    private func handleResponse<T: Decodable>(_ response: HTTPURLResponse,
                                              data: Data,
                                              completion: @escaping (Result<T, Error>) -> Void) {
        switch response.statusCode {
        case 200...299:
            if let model = EmptyResponse() as? T {
                return completion(.success(model))
            }
            if let model = PlainResponse(body: data) as? T {
                return completion(.success(model))
            }
            guard let model = try? data.decoded() as T else {
                return completion(.failure(NetworkError.invalidModel))
            }
            completion(.success(model))
        default:
            guard let model = try? data.decoded() as APIError, let errors = model.errors else {
                return completion(.failure(NetworkError.unknown))
            }
            if !handleSpecialErrorCode(errors: errors) {
                completion(.failure(model))
            }
        }
    }

    private func handleError<T: Decodable>(_ error: Error,
                                           completion: @escaping (Result<T, Error>) -> Void) {
        let networkError: NetworkError
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
//                    networkError = NetworkError.custom(L10n.errorNoInternet)
                networkError = NetworkError.custom("")
            case .timedOut:
//                    networkError = NetworkError.custom(L10n.errorNoInternet)
                networkError = NetworkError.custom("")
            case .cancelled:
                networkError = NetworkError.cancelled
            default:
                networkError = NetworkError.custom(error.localizedDescription)
            }
        } else {
            networkError = NetworkError.custom(error.localizedDescription)
        }
        Logger.log(networkError.description, type: .network, level: .error)
        completion(.failure(networkError))
    }

    private func handleSpecialErrorCode(errors: [APIError.Error]) -> Bool {
        let errorCodes = errors.compactMap {
            ErrorCode(rawValue: $0.errorCode)
        }
        guard
                let errorCode = errorCodes.first(where: { specialErrorCompletions.keys.contains($0) }),
                let completion = specialErrorCompletions[errorCode] else {
            return false
        }
        DispatchQueue.main.async {
            completion()
        }
        return true
    }

    private func log(_ response: HTTPURLResponse, with data: Data) {
        let responseUrl = response.url?.absoluteString ?? ""
        let message = "Status code:\n\(response.statusCode)\nEndpoint:\n\(responseUrl)\nResponse:\n\(data.prettyJSON)"
        Logger.log(message, type: .network, level: .error)
    }
}
