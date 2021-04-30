//
//  VerifyMessageUrlBuilder.swift
//  mapper
//
//  Created by Никишин Ибрахим on 7/10/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

public struct DidUrlBuilder {
    
    private let clientID: String
    private let state: String
    private let phone: String
    private let baseUrl: String
    
    public init(baseUrl: String, clientID: String, state: String, phone: String) {
        self.baseUrl = baseUrl
        self.clientID = clientID
        self.state = state
        self.phone = phone
    }
    
    public func makeUrl(redirectUrl: String) -> URL? {
        var components = URLComponents(string: baseUrl)
        components?.path = "/oauth2/auth"
        components?.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "scope", value: "first_name last_name id_card_manual phone"),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "redirect_uri", value: redirectUrl),
            URLQueryItem(name: "phone", value: phone)
        ]
        return components?.url
    }
}
