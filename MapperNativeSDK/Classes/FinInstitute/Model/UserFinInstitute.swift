//
// Created by Askar Syzdykov on 3/29/21.
//

import Foundation

public protocol UserFinInstitute {
    var bank: Bank { get }
}

public struct BoundUserFinInstitute: UserFinInstitute {
    public var bank: Bank
    public let accounts: [BankAccount]
}

public struct NotBoundUserFinInstitute: UserFinInstitute {
    public var bank: Bank
}

public struct NotLoadedUserFinInstitute: UserFinInstitute {
    public var bank: Bank
}