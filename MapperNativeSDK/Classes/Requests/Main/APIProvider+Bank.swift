//
//  APIProvider+FO.swift
//  mapper
//
//  Created by Eduard Pyatnitsyn on 06.02.2020.
//  Copyright © 2020 btsdigital. All rights reserved.
//

import Foundation

typealias GetUserBanksResponseCompletion = (Result<ConnectedBanks, Error>) -> Void
public typealias GetBanksResponseCompletion = (Result<[Bank], Error>) -> Void
typealias AddBankResponseCompletion = (Result<PublicKeyModel, Error>) -> Void
typealias  UpdateSessionKeyResponseCompletion = (Result<UpdateSessionKeyModel, Error>) -> Void
typealias GetBankAccountsCompletion = (Result<[BankAccount], Error>) -> Void
typealias SetDefaultBankResponseCompletion = (Result<ConnectedBanks, Error>) -> Void
public typealias GetProfileResponseCompletion = (Result<User, Error>) -> Void
public typealias GetMccResponseCompletion = (Result<[Mcc], Error>) -> Void
public typealias SearchUserCompletion = (Result<UserResult, Error>) -> Void

protocol BankAPI {
    func getUserBanks(_ completion: @escaping GetUserBanksResponseCompletion)
    func getBanks(_ completion: @escaping GetBanksResponseCompletion)

    func addBank(bin: String, _ completion: @escaping AddBankResponseCompletion)
    func confirmMasterKey(bin: String, encryptedSecret: String, sharedKeyResult: ECKeyGenerator.Key, _ completion: @escaping EmptyResponseCompletion)
    func updateSessionKey(bin: String, _ completion: @escaping UpdateSessionKeyResponseCompletion)
    func confirmSessionKey(bin: String, encryptedContent: String, publicClientKey: String, salt: String, _ completion: @escaping EmptyResponseCompletion)

    func removeBank(bin: String, phone: String, _ completion: @escaping GetUserBanksResponseCompletion)
    func setDefaultBank(bin: String, _ completion: @escaping SetDefaultBankResponseCompletion)
    func getUserAccounts(bin: String, _ completion: @escaping GetBankAccountsCompletion)
    func getUser(_ completion: @escaping GetProfileResponseCompletion)
    func searchUser(userId: String, completion: @escaping SearchUserCompletion)
    func getMcc(_ completion: @escaping GetMccResponseCompletion)
}

extension APIProviderImpl {
    func getUserBanks(_ completion: @escaping GetUserBanksResponseCompletion) {
        let request = UserBanksRequest()
        requestManager.send(request: request, completion: completion)
    }
    
    func getBanks(_ completion: @escaping GetBanksResponseCompletion) {
        let request = BankListRequest()
        requestManager.send(request: request, completion: completion)
    }
    
    func addBank(bin: String, _ completion: @escaping AddBankResponseCompletion) {
        let request = AddBankRequest(bin: bin)
        requestManager.send(request: request, completion: completion)
    }
    
    func confirmMasterKey(bin: String, encryptedSecret: String, sharedKeyResult: ECKeyGenerator.Key, _ completion: @escaping EmptyResponseCompletion) {
        let request = ConfirmMasterKeyData(bin: bin, publicKeyBase64: sharedKeyResult.encryptedPublicKey, secret: encryptedSecret, saltBase64: sharedKeyResult.salt)
        requestManager.send(request: request, completion: completion)
    }

    func updateSessionKey(bin: String, _ completion: @escaping UpdateSessionKeyResponseCompletion) {
        let request = UpdateSessionKeyData(bin: bin)
        requestManager.send(request: request, completion: completion)
    }

    func confirmSessionKey(bin: String, encryptedContent: String, publicClientKey: String, salt: String, _ completion: @escaping EmptyResponseCompletion) {
        let request = ConfirmSessionKeyData(bin: bin, encryptedContentBase64: encryptedContent, publicClientKeyBase64: publicClientKey, saltBase64: salt)
        requestManager.send(request: request, completion: completion)
    }
    
    func removeBank(bin: String, phone: String, _ completion: @escaping GetUserBanksResponseCompletion) {
        let request = RemoveBankRequest(bin: bin, phone: phone)
        requestManager.send(request: request, completion: completion)
    }
    
    func setDefaultBank(bin: String, _ completion: @escaping SetDefaultBankResponseCompletion) {
        let request = SetDefaultBankRequest(bin: bin)
        requestManager.send(request: request, completion: completion)
    }
    
    func getUserAccounts(bin: String, _ completion: @escaping GetBankAccountsCompletion) {
        let request = GetCurrentUserAccountsRequest(bin: bin)
        requestManager.send(request: request, completion: completion)
    }
    
    func getUser(_ completion: @escaping GetProfileResponseCompletion) {
        let request = ProfileRequest()
        requestManager.send(request: request, completion: completion)
    }
    
    func searchUser(userId: String, completion: @escaping SearchUserCompletion) {
        let request = SearchUserRequest(userId: userId)
        requestManager.send(request: request, completion: completion)
    }
    
    func getMcc(_ completion: @escaping GetMccResponseCompletion) {
        let request = MccRequest()
        requestManager.send(request: request, completion: completion)
    }
}
