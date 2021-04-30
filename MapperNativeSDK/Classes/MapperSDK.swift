//
//  MapperSDK.swift
//  MapperNativeSDK
//
//  Created by Askar Syzdykov on 3/10/21.
//

import Foundation
import UIKit

public class MapperSDK {

    private let api: APIProvider
    private let authStorage: AuthStorage
    private let biometricIdAuth: BiometricIdAuth
    private let finInstituteInteractor: FinInstituteInteractor
    private let finInstituteKeyStorage: FinInstituteKeyStorage
    private let mainContext: MainContext = MainContext()

    init() {
        authStorage = AuthStorageImpl()
        finInstituteKeyStorage = FinInstituteKeyStorage(authStorage: authStorage)
        api = MapperSDK.buildApiProvider(
                authStorage: authStorage,
                finInstituteKeyStorage: finInstituteKeyStorage
        )
        finInstituteInteractor = FinInstituteInteractor(api: api, authStorage: authStorage, finInstituteKeyStorage: finInstituteKeyStorage, mainContext: mainContext)
        biometricIdAuth = BiometricIdAuthImpl()
        print("MapperSDK is initialized...")
    }

    /**
     Инициализация MapperSDK. Данный метод должен быть вызван перед вызовом методов объекта класса MapperSDK
     */
    public static func initialize() -> MapperSDK {
        MapperSDK()
    }

    // region Registration
    /**
     Данный метод предназначен для определения наличия сохраненной сессии на данном устройстве.
     - Returns:
      Возвращает `true` если есть ранее сохраненная сессия на устройстве.
       Следующим вызовом должен быть один из следующих методов: signInByPinCode, signInByBiometric.
      Возвращает `false` если нет сохраненной сессии на устройстве.
       Следующим вызовом должен быть метод `register`
     */
    public func isRegistered() -> Bool {
        authStorage.get(.registrationId) != nil
    }

    /**
     Данный метод предназначен для определения статуса биометрии на устройстве.
     - Returns:
      Возвращает `true` если биометрия есть и включена.
      Возвращает `false` если биометрии нет или пользователь отклонил предложение использовать вход с помощью биометрии.
     */
    public func isBiometryEnabled() -> Bool {
        biometricIdAuth.isAvailable && authStorage.isBioIdOn
    }

    /**
     Очистка сессии. Удаляет данные в защищенном хранилище
     */
    public func clearSession(_ completion: @escaping EmptyResponseCompletion) {
        authStorage.clearData()
        completion(.success(EmptyResponse()))
    }

    /**
      Регистрация по номеру телефона
      - Parameter phoneNumber: Номер телефона пользователя. Должен быть в международном формате, пример: +77001234567
     */
    public func register(phoneNumber: String, _ completion: @escaping RegisterResponseCompletion) {
        api.register(username: phoneNumber) { response in
            completion(response)
            #if DEBUG
            self.getSMSCode()
            #endif
        }
    }

    /**
      Регистрация по номеру телефона
      - Parameter code: код подтверждения отправленный через SMS на номер телефона, указанный в методе `register`
     */
    public func confirmRegistration(code: String, _ completion: @escaping EmptyResponseCompletion) {
        api.confirmRegistration(code: code, completion)
    }

    /**
      Завершение регистрации, установка PIN кода и, опционально, включение входа по биометрии.
      - Parameter pinCode: PIN код, используемый для быстрого входа в приложении на данном устройстве.
      - Parameter withBiometry: `true` - с использованием биометрии. `false` - без биометрии, т.е. вход только по PIN коду.
      - Returns: объект CompleteRegistrationResponse.
     */
    public func completeRegistration(pinCode: String, withBiometry: Bool, _ completion: @escaping CompleteRegistrationResponseCompletion) {
        guard let sharedSecret = generateSharedSecret(with: pinCode) else {
            return
        }
        let totp = generateTOTP(with: sharedSecret)
        api.completeRegistration(sharedSecret: sharedSecret, totp: totp) { [weak self] result in
            switch result {
            case let .success(value):
                let useBiometry = withBiometry && self?.biometricIdAuth.biometryType != BiometryType.none
                self?.authStorage.set(String(useBiometry), key: .isBioIdOn)
                
                self?.saveToken(value.sessionToken.token)
                self?.authStorage.set(pinCode, key: .passcode)
                self?.authStorage.store(registrationResponse: value)
                
                self?.handleIdentificationState(value.identification) { result in
                    switch result {
                    case .success:
                        completion(.success(value))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case .failure:
                completion(result)
            }
        }
    }

    private func saveToken(_ sessionToken: String) {
        authStorage.set(sessionToken, key: .token)
    }

    /**
     Вход по PIN коду.
     - Parameter pinCode: PIN код пользователя на текущем устройстве.
     - Returns: Объект LoginResponse
     */
    public func signInByPinCode(pinCode: String, _ completion: @escaping LoginResponseCompletion) {
        actualSignIn(pinCode: pinCode, completion)
    }

    /**
     Вход по биометрии (Touch ID, Face ID, etc.).
     - Returns: Объект LoginResponse
     */
    public func signInByBiometry(_ completion: @escaping LoginResponseCompletion) {
        biometricIdAuth.authenticateUser { result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case let .failure(error):
                    completion(.failure(error))
                case .success:
                    if let passcode = self?.authStorage.get(.passcode) {
                        self?.actualSignIn(pinCode: passcode, completion)
                    }
                }
            }
        }
    }

    private func actualSignIn(pinCode: String, _ completion: @escaping LoginResponseCompletion) {
        guard let sharedSecret = generateSharedSecret(with: pinCode),
              let deviceId = authStorage.get(.deviceId),
              let registrationId = authStorage.get(.registrationId) else {
            return
        }
        let totp = generateTOTP(with: sharedSecret)
        api.login(registrationId: registrationId, totp: totp, deviceId: deviceId) { [weak self] result in
            switch result {
            case let .success(value):
                self?.saveToken(value.sessionToken.token)
                self?.handleIdentificationState(value.identification) { result in
                    switch result {
                    case .success:
                        completion(.success(value))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func handleIdentificationState(_ level: IdentificationLevel, completion: @escaping EmptyResponseCompletion) {
        if level == .identified {
            getProfile { result in
                switch result {
                case .success:
                    completion(.success(EmptyResponse.init()))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.success(EmptyResponse.init()))
        }
    }

    /**
     Получение списка регистраций на разных устройствах.
     - Returns: Список регистраций
     */
    public func getRegistrations(completion: @escaping RegistrationsResponseCompletion) {
        api.registrationsList(completion: completion)
    }

    /**
     Дерегистрация устройств.
     - Parameter registrationIds: список идентификаторов регистраций, которые должны быть дерегистрированы.
     */
    public func deregister(registrationIds: [String], _ completion: @escaping RegistrationsResponseCompletion) {
        api.deregister(ids: registrationIds, completion)
    }

    /**
     Принятие последнего актуального пользовательского соглашения.
     */
    public func acceptAgreement(completion: @escaping EmptyResponseCompletion) {
        api.acceptAgreement(completion)
    }

    // endregion

    // region Profile
    /**
     Получение профиля текущего пользователя.
     - Returns: Возвращает объект User с информацией о текущем пользователе
     */
    public func getProfile(_ completion: @escaping GetProfileResponseCompletion) {
        api.getUser { [weak self] result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(user):
                self?.mainContext.user = user
                self?.getWorkspace(user: user)
                completion(.success(user))
            }
        }
    }

    /**
     Получение воркспейсов текущего пользователя.
     - Parameter type: тип Workspace. Может быть двух вариантов: .legal или .entrepreneur.
     - Returns: Возвращает объект RegisterLegalResponse, содержащий ссылку и код, которые необходимо отобразить пользователю.
     */
    public func getSignature(type: LegalType, _ completion: @escaping RegisterLegalResponseCompletion) {
        api.registerLegal(type, completion: completion)
    }

    private func getWorkspace(user: User) {
        guard let firstWorkspace = user.workspaces.first else {
            fatalError("User doesn't have workspaces")
        }
        guard
                let currentWorkspaceId = authStorage.get(.currentWorkspaceId),
                let workspace = user.getWorkspace(with: currentWorkspaceId),
                workspace.id != firstWorkspace.id else {
            authStorage.set(firstWorkspace.id, key: .currentWorkspaceId)
            return
        }
        authStorage.set(workspace.id, key: .currentWorkspaceId)
    }

    // endregion

    // region MCC
    /**
     Возвращает список MCC.
     - Returns: Возвращает массив объектов MCC
     */
    public func getAllMccCodes(_ completion: @escaping GetMccResponseCompletion) {
        api.getMcc(completion)
    }

    // endregion

    // region Financial institutes
    /**
     Список всех финансовых институтов.
     - Returns: Возвращает список верифицированных финансовых институтов.
     */
    public func getAllFinInstitutes(_ completion: @escaping GetBanksResponseCompletion) {
        finInstituteInteractor.getAllFinInstitutes(completion)
    }

    /**
     Список финансовых институтов текущего пользователя.
     - Returns: Возвращает список финансовых институтов текущего пользователя.
     */
    public func getUserFinInstitutes(_ completion: @escaping GetUserFinInstitutesCompletion) {
        finInstituteInteractor.getUserFinInstitutes(completion)
    }

    /**
     Привязка финансового института к текущему устройству.
     - Parameter finInstitute Верифицированный финансовый институт, который необходимо привязать к устройству.
     - Returns: Возвращает объект CreatedMasterPublicKey, который должен быть передан в метод `confirmFinInstitute`.
     */
    public func bindFinInstitute(bank: Bank, _ completion: @escaping CreateMasterPublicKeyCompletion) {
        finInstituteInteractor.bindFinInstitute(bank: bank, completion)
    }

    /**
     Подтверждение привязки финансового института к текущему устройству.
     - Parameter masterPublicKey: объект полученный в результате вызова метода `bindFinInstitute`.
     - Parameter smsCode: код подтверждения, полученный через SMS.
     */
    public func confirmFinInstitute(masterPublicKey: CreatedMasterPublicKey, smsCode: String, _ completion: @escaping GetUserFinInstitutesCompletion) {
        finInstituteInteractor.confirmFinInstitute(masterPublicKey: masterPublicKey, smsCode: smsCode, completion)
    }

    /**
     Отвязка (удаление) финансового института от текущего устройства.
     - Parameter finInstitute: Привязанный к устройству финансовый институт.
     */
    public func removeFinInstitute(finInstitute: BoundUserFinInstitute, _ completion: @escaping GetUserFinInstitutesCompletion) {
        finInstituteInteractor.removeFinInstitute(finInstitute, completion)
    }

    // endregion

    // region Transfer
    /**
     Поиск пользователя по UserId.
     - Parameter userId: идентификатор пользователя. Может быть номером счета, номером телефона или ИИН.
     - Returns: Возвращает объект UserResult.
     */
    public func getUserById(userId: String, _ completion: @escaping SearchUserCompletion) {
        api.searchUser(userId: userId, completion: completion)
    }

    /**
     Проверка данных перевода на сервере.
     - Parameter from: счет, с которого будет произведено списание денежных стредств.
     - Parameter amount: сумма перевода.
     - Parameter targetUserId: идентификатор пользователя (номер телефона в международном формате, IBAN или номер счета в формате системы используемой в `targetBank`(см. следующий параметр).
     - Parameter targetBank: финансовый институт, на счет которого будет произведен перевод.
     - Parameter mcc: Merchant category code (код категории продавца), необходимо указать при переводе в пользу юридического лица.
     - Returns: Возвращает объект ValidateTransferResponse, содержаший идентификатор транзакции `txId`, комиссию `amount`
     */
    public func validate(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, _ completion: @escaping ValidateTransferResponseCompletion) {
        api.validateTransfer(from: from, amount: amount, targetUserId: targetUserId, targetBank: targetBank, mcc: mcc, completion: completion)
    }

    /**
     Получение комиссии.
     - Parameter from: счет, с которого будет произведено списание денежных стредств.
     - Parameter amount: сумма перевода.
     - Parameter targetUserId: идентификатор пользователя (номер телефона в международном формате, IBAN или номер счета в формате системы используемой в `targetBank`(см. следующий параметр).
     - Parameter targetBank: финансовый институт, на счет которого будет произведен перевод.
     - Parameter mcc: Merchant category code (код категории продавца), необходимо указать при переводе в пользу юридического лица.
     - Returns: Возвращает комиссию. Поле `amount`
     */
    public func requestFee(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, _ completion: @escaping GetFeeResponseCompletion) {
        api.getFee(from: from, amount: amount, targetUserId: targetUserId, targetBank: targetBank, mcc: mcc, completion: completion)
    }

    /**
     Осущестлвение денежного перевода.
     - Parameter from: счет, с которого будет произведено списание денежных стредств.
     - Parameter amount: сумма перевода.
     - Parameter targetUserId: идентификатор пользователя.
     - Parameter targetBank: финансовый институт, на счет которого будет произведен перевод.
     - Parameter mcc: Merchant category code (код категории продавца),
                  необходимо указать при переводе в пользу юридического лица.
     - Parameter txId: Идентификатор транзакции, полученный в запросе `validate`.
     - Returns: Возвращает объект TransferResponse с информацией о переводе.
             Если ConfirmationCodeScheme.delivery == nil, то подтверждение не требуется.
             Если ConfirmationCodeScheme.delivery == .sms, то код будет отправлен по SMS,
             в данном объекте есть поле length, определяющее длину отправленного кода.
             Если ConfirmationCodeScheme.delivery == .push, то код будет отправлен в виде push-уведомления,
             в данном объекте есть поле length, определяющее длину отправленного кода.
     */
    public func transfer(from: BankAccount, amount: Money, targetUserId: String, targetBank: Bank, mcc: Mcc?, txId: String, _ completion: @escaping TransferResponseCompletion) {
        api.transfer(from: from, amount: amount, targetUserId: targetUserId, targetBank: targetBank, mcc: mcc, txId: txId, completion: completion)
    }

    /**
     Подтверждение денежного перевода.
     - Parameter code: код полученный по SMS или в push-уведомлении.
     - Parameter from: счет отправителя.
     - Parameter txId: идентификатор транзакции из объекта TransferResult, полученного из метода `transfer`.
     */
    public func confirmTransfer(senderBank: Bank, code: String, txId: String, _ completion: @escaping EmptyResponseCompletion) {
        api.confirmTransfer(senderBank: senderBank, txId: txId, confirmationCode: code, completion: completion)
    }

    // endregion

    // region QR
    /**
     Генерация QR кода.
     - Parameter account: счет, на который будет направлен перевод
     - Parameter amount: сумма перевода
     - Parameter qrColors: цвет QR кода, состоящий из цвета контента и фона
     - Parameter comment: комментарий. Необязательный параметр
     - Returns: QRGenerateData
     */
    public func generateQrCode(account: BankAccount, bank: Bank, amount: Money, comment: String?, mcc: Mcc?, _ completion: @escaping GenerateQRDataResponseCompletion) {
        api.generateQRData(id: account.accountNumber, organizationBin: bank.bin, amount: amount, comment: comment, mccCode: mcc?.code, completion: completion)
    }

    /**
     Сканирование QR кода.
     - Parameter data: данные полученные в результате сканирования QR кода
     - Returns: Возвращает QRScanResponse с информацией о переводе и получателе.
     */
    public func decodeQRData(data: String, _ completion: @escaping DecodeQRDataResponseCompletion) {
        api.decodeQRData(data.base64Encoded() ?? data, completion: completion)
    }

    // endregion
    
    // region Identification
    /**
     Получение ссылки для идентификации пользователя. Необходимо вызывать при успешной регистрации или авторизации, если поле SignUpResult.Success::identification или SignInResult.Success::identification равно NOT_IDENTIFIED
     - Parameter phoneNumber: номер телефона текущего пользователя
     - Parameter redirectUrl: ссылка, которая будет открыта после идентификации пользователя. Приложение должно быть
     - Parameter state: сгенерированная случайным образом строка, используемая для проверки ссылки, полученной после успешной идентификации. Подробнее https://auth0.com/docs/protocols/state-parameters
     - Returns ссылку, которую необходимо открыть в Safari view controller или браузер
     */
    public func getIdentificationUrl(
        phoneNumber: String,
        redirectUrl: String,
        state: String
    ) -> URL? {
        let builder = DidUrlBuilder(baseUrl: AppEnvironment.current.didEndpoint,
                clientID: AppEnvironment.current.didClientId,
                state: state,
                phone: phoneNumber)
        guard let url = builder.makeUrl(redirectUrl: redirectUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) else {
            return nil
        }
        return url
    }

    /**
     Отправка кода для завершения процесса идентификации
     - Parameter code: код полученный после авторизации в Aitu Passort
     - Parameter redirectUrl: ссылка, которая была передана в метод getIdentificationUrl
     */
    public func sendDocumentCode(code: String, redirectUrl: String, _ completion: @escaping EmptyResponseCompletion) {
        api.sendDocumentCode(code: code, redirectUrl: redirectUrl) { [weak self] result in
            switch result {
            case .success:
                self?.handleIdentificationState(.identified, completion: completion)
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    // endregion

    private func generateSharedSecret(with secret: String) -> String? {
        let salt = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return CryptoUtils.pbkdf2(password: secret, salt: salt)
    }

    private func generateTOTP(with secret: String) -> String {
        let time = Date().secondsSince1970
        let totp = CryptoUtils.totp(for: time, with: secret)
                .enumerated()
                .filter {
                    $0.offset % 2 == 0
                }
                .map {
                    String($1)
                }
                .joined()
        return totp
    }

    private static func buildApiProvider(authStorage: AuthStorage, finInstituteKeyStorage: FinInstituteKeyStorage) -> APIProvider {
        var specialErrorCompletions: [ErrorCode: VoidClosure] {
            let expiredSessionCompletion: VoidClosure = {
                authStorage.clearData()
            }
            return [ErrorCode.expiredSession: expiredSessionCompletion]
        }
        let sessionPinningDelegate = SessionPinningDelegate()
        let session = URLSession(configuration: .ephemeral,
                delegate: sessionPinningDelegate,
                delegateQueue: nil)

        let requestManager: NetworkManager
        let responseHandler = ResponseHandler(finInstituteKeyStorage: finInstituteKeyStorage,
                specialErrorCompletions: specialErrorCompletions)
        requestManager = RequestManager(session: session,
                authStorage: authStorage,
                finInstituteKeyStorage: finInstituteKeyStorage,
                responseHandler: responseHandler)
        return APIProviderImpl(requestManager: requestManager/*, authDelegate: self*/)
    }

    // region DEBUG
    private func getSMSCode() {
        api.getSMSCode { result in
            if case let .success(value) = result, let smsCode = value.last {
                print("SMS code = " + smsCode)
            }
        }
    }

    // endregion
}
