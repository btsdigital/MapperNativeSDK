/// Server errors mapping
///
/// - unknown: Unknown error code
/// - methodArgumentNotValid: Invalid arguments
/// - webExchangeBind: No arguments
/// - notFound: Resource/Endpoint not found
/// - balance: Balance error
/// - card: Card error
/// - userCredentials: Invalid login or password
/// - notRegistered: User not registered
/// - methodNotAllowed: Restricted method
/// - mediaTypeNotSupported: Unsupported media type
/// - methodArgumentTypeMismatch: Argument type mismatch
public enum ErrorCode: Int {
    case unknown = 0
    case methodArgumentNotValid = 400_000
    case webExchangeBind = 400_001
    case notFound = 400_101
    case balance = 400_102
    case card = 400_104
    case userCredentials = 401_000
    case expiredSession = 401_009
    case invalidSession = 401_010
    case maxRegistrations = 403_002
    case workspaceNotActive = 403_003
    case notRegistered = 404_000
    case workspaceNotFound = 404_003
    case methodNotAllowed = 405_000
    case pincodeBlockedForPeriod = 406_000
    case timeParameterPincodeBlockedForPeriod = 406_001
    case pincodeBlocked = 406_002
    case mediaTypeNotSupported = 415_000
    case methodArgumentTypeMismatch = 500_000
}

public enum APIErrorType {
    case unknown
    case methodArgumentNotValid
    case userCredentials
    case maxRegistrations
    case notRegistered
    case methodNotAllowed
    case pincodeBlockedForPeriod(seconds: Int)
    case pincodeBlocked
    case mediaTypeNotSupported
    case methodArgumentTypeMismatch

    init(apiError: APIError) {
        switch apiError.code {
        case .methodArgumentNotValid:
            self = .methodArgumentNotValid
        case .userCredentials:
            self = .userCredentials
        case .maxRegistrations:
            self = .maxRegistrations
        case .notRegistered:
            self = .notRegistered
        case .methodNotAllowed:
            self = .methodNotAllowed
        case .pincodeBlockedForPeriod:
            guard let error = apiError
                    .errors?
                    .first(where: { $0.errorCode == ErrorCode.timeParameterPincodeBlockedForPeriod.rawValue }),
                  let seconds = Int(error.description) else {
                self = .unknown
                return
            }
            self = .pincodeBlockedForPeriod(seconds: seconds)
        case .pincodeBlocked:
            self = .pincodeBlocked
        case .mediaTypeNotSupported:
            self = .mediaTypeNotSupported
        case .methodArgumentTypeMismatch:
            self = .methodArgumentTypeMismatch
        default:
            self = .unknown
        }
    }
}

/// API response with error
public struct APIError: Decodable, Error {
    /// Information about error
    struct Error: Decodable {
        /// Field identifier (optional value, required for validation errors)
        let field: String?
        /// Error code for error identification
        let errorCode: Int
        /// Message for user
        let description: String
    }

    /// Error description for user (contains global description)
    let message: String
    /// Request identifier for session debug in backend
    let requestTicket: String
    /// Errors list (now in 99% always one, but we can receive many in validation)
    let errors: [Error]?
    /// Calculated error code
    public var code: ErrorCode {
        return ErrorCode(rawValue: errors?.first?.errorCode ?? 0) ?? .unknown
    }

    public var type: APIErrorType {
        return APIErrorType(apiError: self)
    }

    public var errorMessage: String? {
        return errors?.first?.description
    }
}
