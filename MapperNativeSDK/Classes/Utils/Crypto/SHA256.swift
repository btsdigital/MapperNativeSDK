//
//  Sha256.swift
//  MapperSdk
//
//  Created by Никишин Ибрахим on 10/6/20.
//

import Foundation
import CommonCrypto

struct SHA256 {
    let context = UnsafeMutablePointer<CC_SHA256_CTX>.allocate(capacity: 1)

    init() {
        CC_SHA256_Init(context)
    }

    func update(data: Data) {
        data.withUnsafeBytes { (b: UnsafeRawBufferPointer) -> Void in
            guard let bytes = b.baseAddress?.assumingMemoryBound(to: Int8.self) else {
                return
            }
            let end = bytes.advanced(by: data.count)
            for dataToBeHashed in sequence(first: bytes,
                                           next: { $0.advanced(by: Int(CC_LONG.max)) })
                .prefix(while: { (current) -> Bool in current < end }) {
                    _ = CC_SHA256_Update(context,
                                         dataToBeHashed,
                                         CC_LONG(Swift.min(dataToBeHashed.distance(to: end), Int(CC_LONG.max))))
            }
        }
    }

    func final() -> Data {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256_Final(&digest, context)

        return Data(digest)
    }
}

