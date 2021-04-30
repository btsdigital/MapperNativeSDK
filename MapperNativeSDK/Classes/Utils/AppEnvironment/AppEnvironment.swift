//
//  AppEnvironment.swift
//  Mapper
//
//  Created by Никишин Ибрахим on 7/8/20.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

final class AppEnvironment {
    enum AppType {
        case dev, prod
    }
    
    var baseURL: URL {
        switch environment {
        case .dev:
            return buildURL(string: "https://dev-api-app.ups.aitupay.kz")
        case .prod:
            return buildURL(string: "https://ups-api.aitupay.kz")
        }
    }

    var md5CheckSum: String {
        switch environment {
        case .dev:
            return "8f6ae4547508ff87785b48d802283a53"
        case .prod:
            return "cc9042e22f083e0db68cfb94f9a88464"
        }
    }
    
    let testUser = "+77777777777"
    let backgroundTimeout: TimeInterval = 1 * 60

    lazy var agreementURL: URL = buildURL(string: baseURL.absoluteString + "/sso/agreement")
    
    var cert: Data {
        switch environment {
        case .dev:
            return Asset.dev.data.data
        case .prod:
            return Asset.prod.data.data
        }
    }
    
    let didEndpoint = "https://passport.stage.btsdapps.net"
    let didClientId = "9ed00d14-9e05-40b2-bcbb-234a7cca303b"
    
    let environment: AppType
    
    init(environment: AppType) {
        self.environment = environment
    }
    
    private func buildURL(string: String) -> URL {
        guard let url = URL(string: string) else {
            fatalError("Invalid URL: \(string)")
        }
        return url
    }
}
