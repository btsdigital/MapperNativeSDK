//
//  AuthRequests.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 20.01.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

struct RegisterRequest: Request {
    let path = "sso/register"
    let method: Method =  .post
    
    let username: String
    let device: Device
    
    var bodyParameters: [String: Encodable]? {
        return [
            "username": username,
            "device": device
        ]
    }
}

struct ConfirmRegistrationRequest: Request {
    let code: String

    let path = "sso/confirm"
    let method: Method = .post

    var bodyParameters: [String: Encodable]? {
        return [
            "code": code
        ]
    }
}

struct ResendCodeRequest: Request {
    let path = "sso/code-resend"
}

struct CompleteRegistrationRequest: Request {
    let sharedSecret: String
    let totp: String

    let path = "sso/register-complete"
    let method: Method = .post

    var bodyParameters: [String: Encodable]? {
        return [
            "sharedSecret": sharedSecret,
            "totp": totp
        ]
    }
}

struct ChangePinRequest: PrivateRequest {
    let sharedSecret: String

    let path = "sso/reset-pin"
    let method: Method = .post

    var bodyParameters: [String: Encodable]? {
        return [
            "sharedSecret": sharedSecret
        ]
    }
}

struct SignInRequest: Request {
    let registrationId: String
    let totp: String
    let device: Device

    let path = "sso/signin"
    let method: Method = .post

    var bodyParameters: [String: Encodable]? {
        return [
            "registrationId": registrationId,
            "totp": totp,
            "device": device
        ]
    }
}

struct SmsCodeRequest: Request {
    let path = "sso/sms-codes"
}

struct DeregisterRequest: Request {
    let ids: [String]

    let path = "sso/deregister"
    let method: Method = .delete

    var queryParameters: [String: String]? {
        return [
            "ids": ids.joined(separator: ",")
        ]
    }
}

struct RegisterDeviceRequest: Request {
    let deviceToken: String

    let path = "sso/push/register"
    let method: Method = .put

    var queryParameters: [String: String]? {
        return [
            "token": deviceToken
        ]
    }
}

struct RegistrationsListRequest: Request {
    let path = "sso/registrations"
}

struct RegisterDidCodeRequest: PrivateRequest {
    let code: String
    let redirectUri: String

    let path = "documents/passport"
    let method: Method = .post

    var bodyParameters: [String: Encodable]? {
        return [
            "code": code,
            "redirectUri": redirectUri,
        ]
    }
}

struct IdentifyRequest: Request {
    enum Path: String {
        case mapper
        case sso
    }

    let username: String
    let path: String
    let method: Method =  .post

    init(username: String, path: Path) {
        self.username = username
        self.path = "\(path.rawValue)/internal/identify"
    }

    var bodyParameters: [String: Encodable]? {
        return [
            "username": username,
            "firstName": "Дорати",
            "lastName": "Джеймс",
            "iin": "870310300878",
            "dateOfBirth": "1987-03-10"
        ]
    }
}

struct RegisterLegalRequest: PrivateRequest {
    let path: String
    let method: Method = .get

    init(type: LegalType) {
        self.path = "documents/signature/code/\(type.rawValue)"
    }
}

struct AcceptAgreementRequest: PrivateRequest {
    let path: String
    let method: Method = .post

    init() {
        self.path = "sso/agreement/accept"
    }
}
