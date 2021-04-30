//
//  AES256.swift
//  MapperSdk
//
//  Created by Никишин Ибрахим on 10/6/20.
//

import CommonCrypto
import Foundation
import CryptoSwift

struct AES256 {
    private var key: Data
    private var iv: Data

    static func defaultIv() -> Data {
        let iv: [UInt8] = Array(repeating: 0x00, count: 12)
        return Data(bytes: iv, count: iv.count)
    }

    init(key: Data, iv: Data = AES256.defaultIv()) throws {
        guard key.count == kCCKeySizeAES256 else {
            throw Error.badKeyLength
        }
//        guard iv.count == kCCBlockSizeAES128 else {
//            throw Error.badInputVectorLength
//        }
        self.key = key
        self.iv = iv
    }

    enum Error: Swift.Error {
        case keyGeneration(status: Int)
        case badKeyLength
        case badInputVectorLength
    }

    func encrypt(_ digest: Data) throws -> Data {
        let iv = AES256.defaultIv()
        let gcm = GCM(iv: iv.bytes, mode: .combined)
        let cs = try? AES(key: key.bytes, blockMode: gcm, padding: .noPadding)

        guard let csEnc = try cs?.encrypt(digest.bytes) else {
            return Data()
        }
        return Data(bytes: csEnc, count: csEnc.count)
    }

    func decrypt(_ encrypted: Data) throws -> Data {
        let iv = AES256.defaultIv()
        let cs = try? AES(key: key.bytes, blockMode: GCM(iv: iv.bytes, mode: .combined), padding: .noPadding)

        guard let csEnc = try cs?.decrypt(encrypted.bytes) else {
            return Data()
        }
        return Data(bytes: csEnc, count: csEnc.count)
    }

    static func createKey(password: Data, salt: Data) throws -> Data {
        let length = kCCKeySizeAES256
        var status = Int32(0)
        var derivedBytes = [UInt8](repeating: 0, count: length)
        password.withUnsafeBytes { (passwordBytes) in
            salt.withUnsafeBytes { (saltBytes) in
                status = CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                              passwordBytes.bindMemory(to: Int8.self).baseAddress,
                                              password.count,
                                              saltBytes.bindMemory(to: UInt8.self).baseAddress,
                                              salt.count,
                                              CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
                                              10000,
                                              &derivedBytes,
                                              length)
            }
        }
        guard status == 0 else {
            throw Error.keyGeneration(status: Int(status))
        }
        return Data(bytes: derivedBytes, count: length)
    }
}
