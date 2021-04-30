public struct LoginResponse: Codable {
    public let sessionToken: SessionToken
    public let identification: IdentificationLevel
    public let phone: String
}

public struct SessionToken: Codable {
    public let token: String
    public let idleTime: Int64
}

public typealias LoginResponseCompletion = (Result<LoginResponse, Error>) -> Void
