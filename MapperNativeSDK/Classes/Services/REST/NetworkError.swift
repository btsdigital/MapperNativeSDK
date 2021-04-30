import Foundation

enum NetworkError: Error, Equatable, LocalizedError {
    case unknown, noJSONData, wrongURL, badRequest, invalidModel, cancelled
    case custom(String?)

    var description: String {
        switch self {
            case let .custom(message):
                return message ?? ""
            default:
                return "\(self) \(localizedDescription)"
        }
    }

    var errorDescription: String? {
        switch self {
            case let .custom(message):
                return message
            default:
                return failureReason
        }
    }
    
    var isCancelled: Bool {
        guard case .cancelled = self else {
            return false
        }
        return true
    }
}
