//
//  Extensions.swift
//  MapperSdk
//
//  Created by Никишин Ибрахим on 10/6/20.
//

import Foundation
import CommonCrypto

extension String {
    /// Expanded encoding
    ///
    /// - bytesHexLiteral: Hex string of bytes
    /// - base64: Base64 string
    enum ExpandedEncoding {
        /// Hex string of bytes
        case bytesHexLiteral
        /// Base64 string
        case base64
    }

    /// Convert to `Data` with expanded encoding
    ///
    /// - Parameter encoding: Expanded encoding
    /// - Returns: data
    func data(using encoding: ExpandedEncoding) -> Data? {
        switch encoding {
        case .bytesHexLiteral:
            guard self.count % 2 == 0 else { return nil }
            var data = Data()
            var byteLiteral = ""
            for (index, character) in self.enumerated() {
                if index % 2 == 0 {
                    byteLiteral = String(character)
                } else {
                    byteLiteral.append(character)
                    guard let byte = UInt8(byteLiteral, radix: 16) else { return nil }
                    data.append(byte)
                }
            }
            return data
        case .base64:
            return Data(base64Encoded: self)
        }
    }

    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return ""
    }

    func md5() -> String? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        _ = data.withUnsafeBytes { body -> String in
            CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
            return ""
        }
        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
    
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func digest(input: NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }

    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)

        var hexString = ""
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }

        return hexString
    }
}

extension Data {
    var hexValue: String {
        return map { String(format: "%02x", $0) }.joined()
    }
    
    private var secp384r1header: [UInt8] {
        return [0x30, 0x76, 0x30, 0x10, 0x06, 0x07, 0x2A, 0x86, 0x48, 0xCE, 0x3D, 0x02, 0x01, 0x06, 0x05, 0x2B, 0x81,
                0x04, 0x00, 0x22, 0x03, 0x62, 0x00]
    }

    func convertToSecKey() -> SecKey? {
        var error: Unmanaged<CFError>?
        let options = [
            kSecAttrKeyType: kSecAttrKeyTypeECSECPrimeRandom,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: 384] as [CFString: Any]
        let key = SecKeyCreateWithData(self as CFData, options as NSDictionary, &error)
        return key
    }

    func addHeaderSecp384r1() -> Data {
        var dataWithHeader = Data(bytes: secp384r1header, count: secp384r1header.count)
        dataWithHeader.append(self)
        return dataWithHeader
    }

    func removeHeaderSecp384r1() -> Data {
        return self.dropFirst(secp384r1header.count)
    }
}

extension Date {
    var secondsSince1970: Int {
        return Int(timeIntervalSince1970.rounded())
    }
}
