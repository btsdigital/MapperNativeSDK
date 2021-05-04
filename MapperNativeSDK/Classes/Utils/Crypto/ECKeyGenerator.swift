//
//  ECKeyGenerator.swift
//  MapperSdk
//
//  Created by Никишин Ибрахим on 10/6/20.
//

import Foundation
import UIKit

final class ECKeyGenerator {
    struct Key {
        let key: Data
        let encryptedPublicKey: String
        let salt: String
    }

    private var publicKey: SecKey?
    private var privateKey: SecKey?

    init() {
        generateKeys()
    }

    private func generateKeys() {
        let parameters: [String: Any] = [
            kSecAttrKeySizeInBits as String: 384,
            kSecAttrKeyType as String: kSecAttrKeyTypeEC,
            kSecPrivateKeyAttrs as String: [
                kSecAttrIsPermanent as String: false
            ]
        ]

        SecKeyGeneratePair(parameters as CFDictionary, &publicKey, &privateKey)
    }

    func getPublicKey() -> Data? {
        guard let publicKey = publicKey else {
            return nil
        }
        return publicKey.exportPEMKey()
    }

    //@available(*, deprecated, message: "Don't use it. Use `createSharedKey` instead")
    func getSecretKey(otherPublic: String, code: String) -> Data? {
        guard !otherPublic.isEmpty,
              let otherKey = otherPublic.data(using: .base64),
              let codeData = code.data(using: .utf8) else {
            assertionFailure("Wrong input")
            return nil
        }

        let plainOtherKey = otherKey.removeHeaderSecp384r1()
        guard let publicKey2 = plainOtherKey.convertToSecKey() else {
            assertionFailure("Can't convert to SecKey")
            return nil
        }

        guard let privateKey = privateKey else {
            assertionFailure("Private key is empty")
            return nil
        }

        let algorithm = SecKeyAlgorithm.ecdhKeyExchangeCofactor
        let dict: [String: Any] = [:]
        var error: Unmanaged<CFError>?
        guard let cfShared = SecKeyCopyKeyExchangeResult(privateKey,
                algorithm,
                publicKey2,
                dict as CFDictionary,
                &error) else {
            fatalError("Shared key generation failed")
        }

        let sharedKey = cfShared as Data

        let hasher = SHA256()
        hasher.update(data: sharedKey)

        guard let ourKey = getPublicKey() else {
            assertionFailure("Public key is empty")
            return nil
        }

        hasher.update(data: ourKey)
        hasher.update(data: otherKey)
        hasher.update(data: codeData)

        let secretKey = hasher.final()
        return secretKey
    }

    func createMasterKey(otherPublic: String, code: String, salt: String) -> Key? {
        guard
                let encryptionKey = CryptoUtils.pbkdf2Data(password: code, salt: salt),
                let aes256 = try? AES256(key: encryptionKey)
                else {
            return nil
        }
        return createSharedKey(otherPublic: otherPublic, aes256: aes256)
    }

    func refreshMasterKey(otherPublic: String, oldMasterKey: Data) -> Key? {
        guard let aes256 = try? AES256(key: oldMasterKey) else {
            return nil
        }
        return createSharedKey(otherPublic: otherPublic, aes256: aes256)
    }

    func createSessionKey(otherPublic: String, masterKey: Data) -> Key? {
        guard let aes256 = try? AES256(key: masterKey) else {
            return nil
        }
        return createSharedKey(otherPublic: otherPublic, aes256: aes256)
    }

    func createSharedKey(otherPublic: String, aes256: AES256) -> Key? {
        do {
            guard let data = otherPublic.data(using: .base64) else {
                return nil
            }

            let decryptedPublic = try aes256.decrypt(data)
            Logger.log("decryptedPublic: \(decryptedPublic.base64EncodedString())", type: .crypto, level: .info)
            let plainOtherKey = decryptedPublic.removeHeaderSecp384r1()

            guard let publicKey2 = plainOtherKey.convertToSecKey(), let privateKey = privateKey else {
                assertionFailure("Can't convert to SecKey or Private key is empty")
                return nil
            }

            let algorithm = SecKeyAlgorithm.ecdhKeyExchangeCofactor
            let dict: [String: Any] = ["requestedSize": SecKeyKeyExchangeParameter(rawValue: "384" as CFString)]
            var error: Unmanaged<CFError>?
            guard let cfShared = SecKeyCopyKeyExchangeResult(privateKey,
                    algorithm,
                    publicKey2,
                    dict as CFDictionary,
                    &error) else {
                assertionFailure("Shared key generation failed, error: \(error.debugDescription)")
                return nil
            }

            let sharedKey = cfShared as Data

            Logger.log("sharedKey: \(sharedKey.base64EncodedString())", type: .crypto, level: .info)

            let salt = UUID().uuidString.replacingOccurrences(of: "-", with: "")
            let password = sharedKey.base64EncodedString()

            guard
                    let encodedSalt = salt.base64Encoded(),
                    let resultKey = CryptoUtils.pbkdf2Data(password: password, salt: encodedSalt),
                    let publicKey = getPublicKey() else {
                return nil
            }

            let encryptedPublicKey = try aes256.encrypt(publicKey)

            Logger.log("salt: \(salt.base64Encoded() ?? "nil")", type: .crypto, level: .info)
            Logger.log("encryptedPublicKey: \(encryptedPublicKey.base64EncodedString())", type: .crypto, level: .info)
            Logger.log("resultKey: \(resultKey.base64EncodedString())", type: .crypto, level: .info)

            let key = Key(key: resultKey,
                    encryptedPublicKey: encryptedPublicKey.base64EncodedString(),
                    salt: encodedSalt)
            return key
        } catch {
            Logger.log("Error \(error)", type: .crypto, level: .error)
        }
        return nil
    }
}

extension SecKey {
    func exportPEMKey() -> Data {
        var error: Unmanaged<CFError>?
        guard let publicKeyData = SecKeyCopyExternalRepresentation(self, &error) as Data? else {
            fatalError(error?.takeRetainedValue().localizedDescription ?? "")
        }
        return publicKeyData.addHeaderSecp384r1()
    }
}
