public struct RegisterResponse: Decodable {
    let smsTtl: Int64
    let continuously: Bool
}

public struct CompleteRegistrationResponse: Decodable {
    public let registrationId: String
    public let deviceId: String
    public let sessionToken: SessionToken
    public let identification: IdentificationLevel
}

public struct RegistrationsResponse: Decodable {
    public let registrations: [Registration]
}

public struct Registration: Decodable {
    public let registrationId: String
    public let username: String
    public let deviceId: String
    public let deviceType: String
    public let osVersion: String
    public let model: String
    public let updatedAt: Int64
}

struct ChangePinResponse: Decodable {
    let registrationId: String
}

public enum LegalType: String {
    case legal = "LEGAL"
    case entrepreneur = "ENTREPRENEUR"
}

public struct RegisterLegalResponse: Decodable {
    public let code: String
    public let url: String
}
