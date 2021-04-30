//
//  CryptoUtils.swift
//  MapperSdk
//
//  Created by Никишин Ибрахим on 10/6/20.
//

import Foundation
import CommonCrypto

/// Crypto helper for common hashing operations
final class CryptoUtils {
    /// Hash-based Message Authentication Code is a specific type of message authentication code (MAC)
    /// involving a cryptographic hash function and a secret cryptographic key
    ///
    /// - Parameters:
    ///   - message: Message for hashing
    ///   - secret: Secret cryptographic key
    /// - Returns: Hashed value
    static func hmac(for message: String, with secret: String) -> String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256),
               secret,
               secret.count,
               message,
               message.count,
               &digest)
        return Data(digest).hexValue
    }

    /// The Time-based One-Time Password algorithm (TOTP) is an extension of the HMAC-based One-time Password algorithm (HOTP)
    /// generating a one-time password by instead taking uniqueness from the current time
    ///
    /// - Parameters:
    ///   - time: Current time in ms (UNIX Time)
    ///   - secret: Secret cryptographic key
    ///   - timestep: Duration of the timestep valid. (by default 10 second)
    /// - Returns: TOTP hash
    static func totp(for time: Int, with secret: String, and timestep: Int = 10) -> String {
        let newTime = time / timestep
        return hmac(for: String(newTime), with: secret)
    }

    /// Password-Based Key Derivation Function 2
    ///
    /// PBKDF2 applies a pseudorandom function, such as hash-based message authentication code (HMAC),
    /// to the input password or passphrase along with a salt value and repeats the process many times to produce a derived key,
    /// which can then be used as a cryptographic key in subsequent operations.
    /// The added computational work makes password cracking much more difficult, and is known as key stretching.
    ///
    /// DK = PBKDF2(PRF, Password, Salt, c, dkLen)
    ///
    /// PRF is a pseudorandom function of two parameters with output length hLen (e.g., a keyed HMAC)
    /// Password is the master password from which a derived key is generated
    /// Salt is a sequence of bits, known as a cryptographic salt
    /// c is the number of iterations desired
    /// dkLen is the desired bit-length of the derived key
    /// DK is the generated derived key
    ///
    /// - Parameters:
    ///   - secret: The text password used as input to the derivation function.
    ///   - salt: Cryptographic salt
    ///   - derivedKeyLen: The expected length of the derived key in bytes
    ///   - rounds: The number of rounds of the Pseudo Random Algorithm to use. It cannot be zero.
    /// - Returns: PBKDF2
    static func pbkdf2(password: String, salt: String, derivedKeyLen: Int = 32, rounds: UInt32 = 5_000) -> String? {
        guard let passwordData = password.data(using: .utf8), !password.isEmpty else {
            return nil
        }
        var derivedKeyData = Data(repeating: 0, count: derivedKeyLen)
        let localDerivedKeyData = derivedKeyData

        derivedKeyData.withUnsafeMutableBytes { (body: UnsafeMutableRawBufferPointer) in
            if let baseAddress = body.baseAddress, !body.isEmpty {
                let pointer = baseAddress.assumingMemoryBound(to: UInt8.self)

                CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                     password,
                                     passwordData.count,
                                     salt,
                                     salt.count,
                                     CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
                                     rounds,
                                     pointer,
                                     localDerivedKeyData.count)
            }
        }

        return derivedKeyData.hexValue
    }
    
    static func pbkdf2Data(password: String, salt: String, derivedKeyLen: Int = 32, rounds: UInt32 = 5_000) -> Data? {
        guard let passwordData = password.data(using: .utf8), !password.isEmpty else {
            return nil
        }
        var derivedKeyData = Data(repeating: 0, count: derivedKeyLen)
        let localDerivedKeyData = derivedKeyData

        derivedKeyData.withUnsafeMutableBytes { (body: UnsafeMutableRawBufferPointer) in
            if let baseAddress = body.baseAddress, !body.isEmpty {
                let pointer = baseAddress.assumingMemoryBound(to: UInt8.self)
                
                guard let data = salt.data(using: .base64) else {
                    return
                }
                let dataMutablePointer = UnsafeMutablePointer<UInt8>.allocate(capacity: data.count)
                data.copyBytes(to: dataMutablePointer, count: data.count)
                let dataPointer = UnsafePointer<UInt8>(dataMutablePointer)

                CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                     password,
                                     passwordData.count,
                                     dataPointer,
                                     data.count,
                                     CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA1),
                                     rounds,
                                     pointer,
                                     localDerivedKeyData.count)
            }
        }
        Logger.log("derivedKeyData: \(derivedKeyData.base64EncodedString())", type: .crypto, level: .info)
        return derivedKeyData
    }
}
