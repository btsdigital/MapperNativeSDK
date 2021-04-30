import CommonCrypto
import Foundation

extension Data {
    private enum Constants {
        static let newLine = "\r\n"
    }

    /// Convert Data object with JSON structure in human readable format
    var prettyJSON: String {
        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let prettyString = String(data: jsonData, encoding: .utf8) else {
            return "Data \(String(describing: String(data: self, encoding: .utf8))) is not valid JSON"
        }
        return prettyString
    }

    /// Data decoder from JSON to specific type
    ///
    /// - Returns: A value of the requested type
    /// - Throws: Decoding error
    func decoded<T: Decodable>() throws -> T {
        let decoded: T
        do {
            decoded = try JSONDecoder().decode(T.self, from: self)
        } catch {
            guard let json = (try? JSONSerialization.jsonObject(with: self, options: .allowFragments)) as? T else {
                throw NetworkError.invalidModel
            }
            return json
        }
        return decoded
    }

    /// The MD5 message-digest algorithm is a hash function producing a 128-bit hash value.
    ///
    /// - Returns: Hashed value
    func md5() -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digestData = Data(count: length)

        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            self.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress,
                    let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(self.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.hexValue
    }

    func photoData(boundary: String, fileName: String) -> Data? {
        var imgData = Data()

        let boundaryOpen = "--" + boundary + Constants.newLine
        let contentDisposition = "Content-Disposition: form-data; name= \"file\"; filename=\"" +
            fileName + "\"" + Constants.newLine
        let contentType = "Content-Type: image/png" + Constants.newLine + Constants.newLine

        guard
            let boundaryOpenData = boundaryOpen.data(using: .utf8, allowLossyConversion: false),
            let contentDispositionData = contentDisposition.data(using: .utf8, allowLossyConversion: false),
            let contentTypeData = contentType.data(using: .utf8, allowLossyConversion: false),
            let newLineData = Constants.newLine.data(using: .utf8, allowLossyConversion: false) else {
                return nil
        }

        imgData.append(boundaryOpenData)
        imgData.append(contentDispositionData)
        imgData.append(contentTypeData)
        imgData.append(self)
        imgData.append(newLineData)

        return imgData
    }

    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }

    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { String(format: format, $0) }.joined()
    }
}
