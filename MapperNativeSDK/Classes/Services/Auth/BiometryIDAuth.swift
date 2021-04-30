import LocalAuthentication
import UIKit

typealias AuthenticateUserCompletion = (Result<Bool, Error>) -> Void

enum BiometryType {
    case none
    case touchId
    case faceId
}

enum BiometryAccessError: Error {
    case none
    case notAvailable
    case notEnrolled
    case lockout
    case unknown
}

protocol BiometricIdAuth {
    var biometryType: BiometryType { get }
    var isAvailable: Bool { get }
    
    func authenticateUser(completion: @escaping AuthenticateUserCompletion)
}

final class BiometricIdAuthImpl: BiometricIdAuth {
    private let context = LAContext()

    var biometryType: BiometryType {
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
            case .touchID:
                return .touchId
            case .faceID:
                return .faceId
            case .none:
                return .none
            @unknown default:
                return .none
        }
    }
    
    var isAvailable: Bool {
        switch accessError {
        case .none, .lockout:
            return true
        default:
            return false
        }
    }
    
    var accessError: BiometryAccessError {
        var error: NSError?
        let canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        switch error?.code {
        case Int(kLAErrorBiometryNotEnrolled):
            return .notEnrolled
        case Int(kLAErrorBiometryLockout):
            return .lockout
        case Int(kLAErrorBiometryNotAvailable):
            return .notAvailable
        case nil:
            return canEvaluatePolicy == true ? .none : .unknown
        default:
            return .unknown
        }
    }

    func authenticateUser(completion: @escaping AuthenticateUserCompletion) {
        switch accessError {
        case .none:
            evaluateWithBiometrics(completion: completion)
        case .lockout:
            evaluate(completion: completion)
        default:
            completion(.failure(accessError))
        }
    }
    
    private func evaluate(completion: @escaping AuthenticateUserCompletion) {
//        let localizedReason = biometryType == .touchId ? L10n.touchIdInfo : L10n.faceIdInfo
        let localizedReason = ""
        context.evaluatePolicy(.deviceOwnerAuthentication,
                               localizedReason: localizedReason) { success, error in
            if success {
                completion(.success(success))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    private func evaluateWithBiometrics(completion: @escaping AuthenticateUserCompletion) {
        let localizedReason = biometryType == .touchId ? L10n.touchIdScanInfo : L10n.faceIdScanInfo
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                               localizedReason: localizedReason) { [weak self] success, error in
            if success {
                completion(.success(success))
            } else if let nserror = error as NSError?, nserror.code == Int(kLAErrorBiometryLockout) {
                self?.authenticateUser(completion: completion)
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
}
