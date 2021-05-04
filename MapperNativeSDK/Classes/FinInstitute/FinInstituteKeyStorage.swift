//
// Created by Askar Syzdykov on 3/25/21.
//

import Foundation
import KeychainAccess

class FinInstituteKeyStorage {
    enum Constant {
        static let sessionPrefix = "session_"
    }

    private let generator = ECKeyGenerator()
    private let authStorage: AuthStorage
    private let keychain = Keychain(service: "\(Bundle.main.infoDictionary!["Service"] ?? "")",
            accessGroup: "\(Bundle.main.infoDictionary!["AccessGroup"] ?? "")")

    init(authStorage: AuthStorage) {
        self.authStorage = authStorage
    }

    func createMasterKey(
            fiBin: String,
            encryptedServerKey: String,
            verificationCode: String,
            verificationCodeSalt: String
    ) -> ECKeyGenerator.Key? {
        guard let masterKey = generator.createMasterKey(
                otherPublic: encryptedServerKey,
                code: verificationCode,
                salt: verificationCodeSalt
        ) else {
            return nil
        }
        try! keychain.set(masterKey.key, key: getAlias(fiBin))
        return masterKey
    }

    func createSessionKey(
            fiBin: String,
            encryptedServerKey: String
    ) -> ECKeyGenerator.Key? {
        let alias = getAlias(fiBin)
        guard
                let masterKey = try? getMasterKey(alias: alias),
                let sessionKey = generator.createSessionKey(otherPublic: encryptedServerKey, masterKey: masterKey) else {
            return nil
        }
        do {
            try setSessionKey(sessionKey.key, alias: alias)
        } catch {
            Logger.log("Error: \(error)", type: .crypto, level: .error)
            return nil
        }
        return sessionKey
    }

    func containsKeys(fiBin: String) -> Bool {
        do {
            return try keychain.contains(getAlias(fiBin)) && keychain.contains(getSessionAlias(getAlias(fiBin)))
        } catch {
            return false
        }
    }

    func encryptMasterData(fiBin: String, dataJson: String) -> String? {
        guard
                let masterKey = try? getMasterKey(alias: getAlias(fiBin)),
                let encrypted = encrypt(dataJson: dataJson, key: masterKey) else {
            return nil
        }
        return encrypted.base64EncodedString()
    }

    func encryptSessionData(fiBin: String, dataJson: String) -> String? {
        guard
                let sessionKey = try? getSessionKey(alias: getAlias(fiBin)),
                let encrypted = encrypt(dataJson: dataJson, key: sessionKey) else {
            return nil
        }
        return encrypted.base64EncodedString()
    }

    func decryptSessionData(fiBin: String, encryptedBase64: String) -> String? {
        guard
                let sessionKey = try? getSessionKey(alias: getAlias(fiBin)),
                let decrypted = decrypt(encryptedBase64: encryptedBase64, key: sessionKey) else {
            return nil
        }
        return decrypted
    }

    private func encrypt(dataJson: String, key: Data) -> Data? {
        do {
            guard let data = dataJson.data(using: .utf8) else {
                return nil
            }
            let aes = try AES256(key: key)
            let encrypted = try aes.encrypt(data)
            return encrypted
        } catch {
            Logger.log("Error: \(error)", type: .crypto, level: .error)
            return nil
        }
    }

    private func decrypt(encryptedBase64: String, key: Data) -> String? {
        do {
            guard let data = encryptedBase64.data(using: .base64) else {
                return nil
            }
            let aes = try AES256(key: key)
            let decrypted = try aes.decrypt(data)
            return String(data: decrypted, encoding: .utf8)
        } catch {
            Logger.log("Error: \(error)", type: .crypto, level: .error)
            return nil
        }
    }

    private func getMasterKey(alias: String) throws -> Data? {
        return try keychain.getData(alias)
    }

    private func setMasterKey(_ masterKey: Data, alias: String) throws {
        try keychain.set(masterKey, key: alias)
    }

    private func getSessionKey(alias: String) throws -> Data? {
        return try keychain.getData(getSessionAlias(alias))
    }

    private func setSessionKey(_ sessionKey: Data, alias: String) throws {
        try keychain.set(sessionKey, key: getSessionAlias(alias))
    }

    private func getSessionAlias(_ alias: String) -> String {
        return Constant.sessionPrefix + alias
    }

    private func getAlias(_ bin: String) -> String {
        let workspaceId = authStorage.get(.currentWorkspaceId)!
        return "\(workspaceId)_\(bin)"
    }

    func removeFinInstituteKey(fiBin: String) {
        try? keychain.remove(getAlias(fiBin))
    }
}
