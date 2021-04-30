//
//  BankListRequest.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 06.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

struct ProfileRequest: PrivateRequest {
    let path: String = "mapper/profile"
    let method: Method = .get
}

struct UserBanksRequest: PrivateRequest {
    let path = "mapper/profile/organizations"
}

struct BankListRequest: PrivateRequest {
    let path = "mapper/organizations"
}

struct AddBankRequest: PrivateRequest {
    var path: String {
        return "mapper/organization/\(bin)/registration/bind"
    }
    let method: Method = .post

    let bin: String

    let contentType: ContentType = .plain
}

struct ConfirmMasterKeyData: PrivateRequest {
    var path: String {
        return "mapper/organization/\(bin)/registration/key/master/confirm"
    }
    let method: Method = .post

    let bin: String
    let publicKeyBase64: String
    let secret: String
    let saltBase64: String

    var bodyParameters: [String: Encodable]? {
        return [
            "publicClientKey": publicKeyBase64,
            "encryptedContent": secret,
            "salt": saltBase64
        ]
    }
}

struct UpdateSessionKeyData: PrivateRequest {
    var path: String {
        return "mapper/organization/\(bin)/registration/key/session/update"
    }
    let method: Method = .post

    let bin: String

    var contentType: ContentType = .plain
}

struct ConfirmSessionKeyData: PrivateRequest {
    var path: String {
        return "mapper/organization/\(bin)/registration/key/session/confirm"
    }
    let method: Method = .post

    let bin: String
    let encryptedContentBase64: String
    let publicClientKeyBase64: String
    let saltBase64: String

    var bodyParameters: [String: Encodable]? {
        return [
            "encryptedContent": encryptedContentBase64,
            "publicClientKey": publicClientKeyBase64,
            "salt": saltBase64
        ]
    }
}

struct RemoveBankRequest: PrivateRequest, BankRequest {
    var path: String {
        return "mapper/organization/\(bin)/registration/unbind"
    }
    let method: Method = .post

    let bin: String
    let phone: String

    var bodyParameters: [String: Encodable]? {
        return [
            "phone": phone
        ]
    }

    var shouldEncryptResponse: Bool {
        return false
    }
}

struct GetCurrentUserAccountsRequest: PrivateRequest, BankRequest {
    var path: String {
        return "mapper/organization/\(bin)/registration/info"
    }

    let method: Method = .post

    let bin: String
}

struct SetDefaultBankRequest: PrivateRequest {
    let path: String = "mapper/profile/organizations"
    let method: Method = .put
    let bin: String

    var bodyParameters: [String: Encodable]? {
        return [
            "bin": bin
        ]
    }
}

struct SearchUserRequest: PrivateRequest {
    var path: String {
        return "mapper/profile/\(userId)"
    }
    var method: Method = .get
    let userId: String
}

struct MccRequest: PrivateRequest {
    let path: String = "mapper/workspace/mccs"
    let method: Method = .get
}
