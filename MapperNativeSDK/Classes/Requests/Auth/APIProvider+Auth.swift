public typealias RegisterResponseCompletion = (Result<RegisterResponse, Error>) -> Void
public typealias CompleteRegistrationResponseCompletion = (Result<CompleteRegistrationResponse, Error>) -> Void
public typealias RegistrationsResponseCompletion = (Result<RegistrationsResponse, Error>) -> Void
typealias ChangePinResponseCompletion = (Result<ChangePinResponse, Error>) -> Void
public typealias RegisterLegalResponseCompletion = (Result<RegisterLegalResponse, Error>) -> Void

protocol AuthAPI {
    func register(username: String, _ completion: @escaping RegisterResponseCompletion)
    func confirmRegistration(code: String, _ completion: @escaping EmptyResponseCompletion)
    func resendCode(_ completion: @escaping RegisterResponseCompletion)
    func completeRegistration(sharedSecret: String,
                              totp: String,
                              _ completion: @escaping CompleteRegistrationResponseCompletion)
    func changePin(sharedSecret: String, _ completion: @escaping ChangePinResponseCompletion)
    func login(registrationId: String, totp: String, deviceId: String, _ completion: @escaping LoginResponseCompletion)
    func getSMSCode(_ completion: @escaping (Result<[String], Error>) -> Void)
    func deregister(ids: [String], _ completion: @escaping RegistrationsResponseCompletion)
    func registerDeviceToken(_ deviceToken: String, _ completion: @escaping EmptyResponseCompletion)
    func registrationsList(completion: @escaping RegistrationsResponseCompletion)
    
    // DID
    func sendDocumentCode(code: String, redirectUrl: String, _ completion: @escaping EmptyResponseCompletion)
    func identify(username: String,
                  path: IdentifyRequest.Path,
                  completion: @escaping EmptyResponseCompletion)
    
    // LEGAL
    func registerLegal(_ type: LegalType, completion: @escaping RegisterLegalResponseCompletion)

    // AGREEMENT
    func acceptAgreement(_ completion: @escaping EmptyResponseCompletion)
}

extension APIProviderImpl {
    func register(username: String, _ completion: @escaping RegisterResponseCompletion) {
        let request = RegisterRequest(username: username, device: Device())
        requestManager.send(request: request, completion: completion)
    }
    
    func confirmRegistration(code: String, _ completion: @escaping EmptyResponseCompletion) {
        let request = ConfirmRegistrationRequest(code: code)
        requestManager.send(request: request, completion: completion)
    }
    
    func resendCode(_ completion: @escaping RegisterResponseCompletion) {
        let request = ResendCodeRequest()
        requestManager.send(request: request, completion: completion)
    }
    
    func completeRegistration(sharedSecret: String,
                              totp: String,
                              _ completion: @escaping CompleteRegistrationResponseCompletion) {
        let request = CompleteRegistrationRequest(sharedSecret: sharedSecret, totp: totp)
        requestManager.send(request: request, completion: completion)
    }
    
    func changePin(sharedSecret: String, _ completion: @escaping ChangePinResponseCompletion) {
        let request = ChangePinRequest(sharedSecret: sharedSecret)
        requestManager.send(request: request, completion: completion)
    }
    
    func login(registrationId: String,
               totp: String,
               deviceId: String,
               _ completion: @escaping LoginResponseCompletion) {
        let request = SignInRequest(registrationId: registrationId, totp: totp, device: Device(deviceId: deviceId))
        requestManager.send(request: request, completion: { (result: Result<LoginResponse, Error>) in
            if case let .failure(error) = result, let apiError = error as? APIError {
                if apiError.code == .notRegistered {
//                    self?.authDelegate?.didResetRegistration(animated: true)
                }
            }
            completion(result)
        })
    }
    
    func getSMSCode(_ completion: @escaping (Result<[String], Error>) -> Void) {
        let request = SmsCodeRequest()
        requestManager.send(request: request, completion: completion)
    }
    
    func deregister(ids: [String], _ completion: @escaping RegistrationsResponseCompletion) {
        let request = DeregisterRequest(ids: ids)
        requestManager.send(request: request, completion: completion)
    }
    
    func registerDeviceToken(_ deviceToken: String, _ completion: @escaping EmptyResponseCompletion) {
        let request = RegisterDeviceRequest(deviceToken: deviceToken)
        requestManager.send(request: request, completion: completion)
    }
    
    func registrationsList(completion: @escaping RegistrationsResponseCompletion) {
        let request = RegistrationsListRequest()
        requestManager.send(request: request, completion: completion)
    }
    
    func sendDocumentCode(code: String, redirectUrl: String, _ completion: @escaping EmptyResponseCompletion) {
        let request = RegisterDidCodeRequest(code: code, redirectUri: redirectUrl)
        requestManager.send(request: request, completion: completion)
    }
    
    func identify(username: String,
                  path: IdentifyRequest.Path,
                  completion: @escaping EmptyResponseCompletion) {
        let request = IdentifyRequest(username: username, path: path)
        requestManager.send(request: request, completion: completion)
    }
    
    func registerLegal(_ type: LegalType, completion: @escaping RegisterLegalResponseCompletion) {
        let request = RegisterLegalRequest(type: type)
        requestManager.send(request: request, completion: completion)
    }

    func acceptAgreement(_ completion: @escaping EmptyResponseCompletion) {
        let request = AcceptAgreementRequest()
        requestManager.send(request: request, completion: completion)
    }
}
