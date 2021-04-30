//
// Created by Askar Syzdykov on 3/16/21.
//

import Foundation

public struct CreatedMasterPublicKey {
    public let bank: Bank
    public let encryptedServerPublicKey: String
    public let salt: String
}

public typealias CreateMasterPublicKeyCompletion = (Result<CreatedMasterPublicKey, Error>) -> Void
public typealias GetUserFinInstitutesCompletion = (Result<[UserFinInstitute], Error>) -> Void
typealias GetUserFinInstituteCompletion = (Result<UserFinInstitute, Error>) -> Void

public enum FinInstituteError: Error {
    case unableToCreateMasterKey
    case unableToCreateSessionKey
}

class FinInstituteInteractor {

    private let api: APIProvider
    private let authStorage: AuthStorage
    private let generator = ECKeyGenerator()
    private let finInstituteKeyStorage: FinInstituteKeyStorage
    private let mainContext: MainContext

    init(api: APIProvider, authStorage: AuthStorage, finInstituteKeyStorage: FinInstituteKeyStorage, mainContext: MainContext) {
        self.api = api
        self.authStorage = authStorage
        self.mainContext = mainContext
        self.finInstituteKeyStorage = finInstituteKeyStorage
    }

    func getAllFinInstitutes(_ completion: @escaping GetBanksResponseCompletion) {
        api.getBanks(completion)
    }

    public func getUserFinInstitutes(_ completion: @escaping GetUserFinInstitutesCompletion) {
        api.getUserBanks { [weak self] (result) in
            switch result {
            case .success(let connectedBanks):
                self?.processBanks(connectedBanks, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func bindFinInstitute(bank: Bank, _ completion: @escaping CreateMasterPublicKeyCompletion) {
        api.addBank(bin: bank.bin) { result in
            switch result {
            case let .success(value):
                let masterPublicKey = CreatedMasterPublicKey(
                        bank: bank,
                        encryptedServerPublicKey: value.publicKey,
                        salt: value.salt
                )
                completion(.success(masterPublicKey))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func confirmFinInstitute(
            masterPublicKey: CreatedMasterPublicKey,
            smsCode: String,
            _ completion: @escaping GetUserFinInstitutesCompletion) {
        confirmCreatedMasterKey(key: masterPublicKey, verificationCode: smsCode) { [weak self] result in
            switch result {
            case .success:
                self?.updateSessionKey(masterPublicKey.bank.bin) { [weak self] result in
                    self?.tryLoadBoundFinInstituteAccounts(bank: masterPublicKey.bank) { result in
                        switch result {
                        case let .success(userFinInstitute):
                            self?.saveFinInstituteToInMemoryCache(userFinInstitute)
                            completion(.success(self?.mainContext.userFinInstitutes ?? []))
                        case let .failure(error):
                            completion(.failure(error))
                        }
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func saveFinInstituteToInMemoryCache(_ userFinInstitute: UserFinInstitute) {
        let index = mainContext.userFinInstitutes.firstIndex { $0.bank.bin == userFinInstitute.bank.bin } ?? -1
        if index >= 0 {
            mainContext.userFinInstitutes.remove(at: index)
        }
        mainContext.userFinInstitutes.append(userFinInstitute)
    }

    private func tryLoadBoundFinInstituteAccounts(bank: Bank, _ completion: @escaping GetUserFinInstituteCompletion) {
        api.getUserAccounts(bin: bank.bin) { result in
            switch result {
            case let .success(accounts):
                accounts.forEach {
                    $0.bank = bank
                }
                completion(.success(BoundUserFinInstitute(bank: bank, accounts: accounts)))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func updateSessionKey(_ bin: String, _ completion: @escaping EmptyResponseCompletion) {
        api.updateSessionKey(bin: bin) { [weak self] result in
            switch result {
            case let .success(sessionKey):
                self?.confirmSessionKey(bin, key: sessionKey, completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func confirmSessionKey(_ bin: String, key: UpdateSessionKeyModel, _ completion: @escaping EmptyResponseCompletion) {
        guard
                let sharedKeyResult = finInstituteKeyStorage.createSessionKey(
                        fiBin: bin,
                        encryptedServerKey: key.publicKey
                ),
                let secret = finInstituteKeyStorage.encryptSessionData(
                        fiBin: bin,
                        dataJson: getPhoneNumberJson()
                )
                else {
            completion(.failure(FinInstituteError.unableToCreateSessionKey))
            return
        }

        api.confirmSessionKey(
                bin: bin,
                encryptedContent: secret,
                publicClientKey: sharedKeyResult.encryptedPublicKey,
                salt: sharedKeyResult.salt,
                completion
        )
    }

    private func confirmCreatedMasterKey(key: CreatedMasterPublicKey, verificationCode: String, _ completion: @escaping EmptyResponseCompletion) {
        guard let masterKey = finInstituteKeyStorage.createMasterKey(
                fiBin: key.bank.bin,
                encryptedServerKey: key.encryptedServerPublicKey,
                verificationCode: verificationCode,
                verificationCodeSalt: key.salt
        ) else {
            completion(.failure(FinInstituteError.unableToCreateMasterKey))
            return
        }
        confirmMasterKey(bank: key.bank, masterKey: masterKey, completion)
    }

    private func confirmMasterKey(bank: Bank, masterKey: ECKeyGenerator.Key, _ completion: @escaping EmptyResponseCompletion) {
        let secret = finInstituteKeyStorage.encryptMasterData(fiBin: bank.bin, dataJson: getPhoneNumberJson())
        api.confirmMasterKey(bin: bank.bin, encryptedSecret: secret!, sharedKeyResult: masterKey, completion)
    }

    public func removeFinInstitute(_ finInstitute: BoundUserFinInstitute, _ completion: @escaping GetUserFinInstitutesCompletion) {
        api.removeBank(bin: finInstitute.bank.bin, phone: mainContext.user?.phone ?? "") { [weak self] result in
            switch result {
            case .success:
                self?.finInstituteKeyStorage.removeFinInstituteKey(fiBin: finInstitute.bank.bin)
                self?.getUserFinInstitutes(completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    private func processBanks(_ connectedBanks: ConnectedBanks, completion: @escaping GetUserFinInstitutesCompletion) {
        var banks: [Bank] = []
        if let defaultBank = connectedBanks.defaultBank {
            defaultBank.isDefault = true
            banks.append(defaultBank)
        }
        banks.append(contentsOf: connectedBanks.items)

        getUserAccounts(banks, completion)
    }

    private func getUserAccounts(_ connectedBanks: [Bank], _ completion: @escaping GetUserFinInstitutesCompletion) {
        let downloadGroup = DispatchGroup()
        var userFinInstitutes = [UserFinInstitute]()
        connectedBanks.forEach { (connectedBank) in
            downloadGroup.enter()
            loadVerifiedUserFinInstitute(bank: connectedBank) { result in
                switch result {
                case let .success(userFinInstitute):
                    userFinInstitutes.append(userFinInstitute)
                case .failure(_):
                    userFinInstitutes.append(NotBoundUserFinInstitute(bank: connectedBank))
                }
                downloadGroup.leave()
            }
        }
        downloadGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard self != nil else {
                return
            }
            userFinInstitutes.forEach { self?.saveFinInstituteToInMemoryCache($0) }
            completion(.success(userFinInstitutes))
            NotificationCenter.default.post(name: .didUpdateBanks, object: nil)
        }
    }

    private func loadVerifiedUserFinInstitute(bank: Bank, _ completion: @escaping GetUserFinInstituteCompletion) {
        if !finInstituteKeyStorage.containsKeys(fiBin: bank.bin) {
            return completion(.success(NotBoundUserFinInstitute(bank: bank)))
        } else {
            api.updateSessionKey(bin: bank.bin) { [weak self] result in
                switch result {
                case let .success(updateSessionKeyModel):
                    self?.confirmSessionKey(bank.bin, key: updateSessionKeyModel) { result in
                        self?.tryLoadBoundFinInstituteAccounts(bank: bank, completion)
                    }
                case .failure:
                    self?.finInstituteKeyStorage.removeFinInstituteKey(fiBin: bank.bin)
                    return completion(.success(NotBoundUserFinInstitute(bank: bank)))
                }
            }

        }
    }

    private func getPhoneNumberJson() -> String {
        guard let phoneNumber = mainContext.user?.phone else {
            return "{}"
        }
        return "{\"phone\":\"\(phoneNumber)\"}"
    }
}
