// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Номер счета скопирован в буфер обмена
  internal static let accountCopied = L10n.tr("Localizable", "account_copied")
  /// Бизнес-аккаунт не найден. Для добавления необходимо пройти идентификацию посредством ЭЦП
  internal static let accountNotFound = L10n.tr("Localizable", "account_not_found")
  /// Переименовать счёт
  internal static let accountRename = L10n.tr("Localizable", "account_rename")
  /// Добавить аккаунт
  internal static let addAccount = L10n.tr("Localizable", "add_account")
  /// Откройте веб-страницу %s и введите 6-значный код
  internal static func addAccountCode(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "add_account_code", p1)
  }
  /// Идентификация с ЭЦП
  internal static let addAccountDigitalSignatureIdentification = L10n.tr("Localizable", "add_account_digital_signature_identification")
  /// Для добавления бизнес-счетов необходимо пройти идентификацию посредством ЭЦП на сайте %s
  internal static func addAccountInfo(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "add_account_info", p1)
  }
  /// Выберите тип аккаунта
  internal static let addAccountType = L10n.tr("Localizable", "add_account_type")
  /// Инд. предприниматель
  internal static let addAccountTypeBusinessman = L10n.tr("Localizable", "add_account_type_businessman")
  /// Юридическое лицо
  internal static let addAccountTypeLegalEntity = L10n.tr("Localizable", "add_account_type_legal_entity")
  /// Нажимая «Далее», вы \nсоглашаетесь с
  internal static let authAgreeWith = L10n.tr("Localizable", "auth_agree_with")
  /// Правилами сервиса
  internal static let authAgreement = L10n.tr("Localizable", "auth_agreement")
  /// Подтвердите вход в приложение
  internal static let authBiometricsDescription = L10n.tr("Localizable", "auth_biometrics_description")
  /// С возвращением!
  internal static let authComebackResult = L10n.tr("Localizable", "auth_comeback_result")
  /// Введите номер телефона для входа в систему
  internal static let authEnterNumber = L10n.tr("Localizable", "auth_enter_number")
  /// Введите код безопасности
  internal static let authEnterPin = L10n.tr("Localizable", "auth_enter_pin")
  /// Введите код из SMS, \nотправленный на номер %@
  internal static func authEnterSmsCode(_ p1: String) -> String {
    return L10n.tr("Localizable", "auth_enter_sms_code", p1)
  }
  /// Отправить новый код
  internal static let authEnterSmsCodeRequestNew = L10n.tr("Localizable", "auth_enter_sms_code_request_new")
  /// Новый код через %s
  internal static func authEnterSmsCodeTimeout(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "auth_enter_sms_code_timeout", p1)
  }
  /// Надо выйти из аккаунта, снова ввести номер и пароль, затем – придумать новый код
  internal static let authForgotPin = L10n.tr("Localizable", "auth_forgot_pin")
  /// Забыли код?
  internal static let authForgotPinTitle = L10n.tr("Localizable", "auth_forgot_pin_title")
  /// Введите казахстанский номер телефона
  internal static let authIncorrectPhoneNumber = L10n.tr("Localizable", "auth_incorrect_phone_number")
  /// Введен неверный код. Попробуйте еще раз или запросите новый код
  internal static let authInvalidCode = L10n.tr("Localizable", "auth_invalid_code")
  /// Ошибка входа
  internal static let authPinCodeError = L10n.tr("Localizable", "auth_pin_code_error")
  /// Перейти к регистрации
  internal static let authRegister = L10n.tr("Localizable", "auth_register")
  /// Необходимо выйти из одного устройств, удалив его, чтобы зарегистрировать новое
  internal static let authRegisteredDevicesInfo = L10n.tr("Localizable", "auth_registered_devices_info")
  /// Вы были зарегистрированы на следующих устройствах:
  internal static let authRegisteredDevicesList = L10n.tr("Localizable", "auth_registered_devices_list")
  /// Повторите код
  internal static let authRepeatEnterPin = L10n.tr("Localizable", "auth_repeat_enter_pin")
  /// Добро пожаловать!
  internal static let authResult = L10n.tr("Localizable", "auth_result")
  /// Установите код безопасности
  internal static let authSetupPin = L10n.tr("Localizable", "auth_setup_pin")
  /// Остановить процесс верификации?
  internal static let authStopVerification = L10n.tr("Localizable", "auth_stop_verification")
  /// Приложение заблокировано
  internal static let authTooManyAttemptsErrorTitle = L10n.tr("Localizable", "auth_too_many_attempts_error_title")
  /// Превышено количество попыток ввода кода. Необходимо заново зарегистрироваться в приложении
  internal static let authUserIsBlocked = L10n.tr("Localizable", "auth_user_is_blocked")
  /// Заблокирован
  internal static let authUserIsBlockedTitle = L10n.tr("Localizable", "auth_user_is_blocked_title")
  /// Чтобы снимать фото и видео, перейдите в настройки телефона и разрешите \nдоступ к камере
  internal static let cameraPermissionAlertMessage = L10n.tr("Localizable", "camera_permission_alert_message")
  /// Разрешите доступ к камере
  internal static let cameraPermissionAlertTitle = L10n.tr("Localizable", "camera_permission_alert_title")
  /// Разрешите доступ, чтобы оплачивать по QR-коду
  internal static let cameraPermissionInfo = L10n.tr("Localizable", "camera_permission_info")
  /// Отмена
  internal static let cancel = L10n.tr("Localizable", "cancel")
  /// Закрыть
  internal static let close = L10n.tr("Localizable", "close")
  /// Не удалось выполнить операцию. Попробуйте позже.
  internal static let commonErrorMessage = L10n.tr("Localizable", "common_error_message")
  /// Ошибка
  internal static let commonErrorTitle = L10n.tr("Localizable", "common_error_title")
  /// Идет загрузка
  internal static let commonLoadingHeader = L10n.tr("Localizable", "common_loading_header")
  /// Пожалуйста, подождите
  internal static let commonLoadingText = L10n.tr("Localizable", "common_loading_text")
  /// Подтвердить
  internal static let confirm = L10n.tr("Localizable", "confirm")
  /// Разрешить доступ к контактам
  internal static let contactAllowPermission = L10n.tr("Localizable", "contact_allow_permission")
  /// Чтобы выбрать контакт из контактной книги, перейдите в настройки телефона и разрешите \nдоступ к контактам
  internal static let contactPermissionAlertMessage = L10n.tr("Localizable", "contact_permission_alert_message")
  /// Разрешите доступ к контактам
  internal static let contactPermissionAlertTitle = L10n.tr("Localizable", "contact_permission_alert_title")
  /// Разрешите доступ к контактам, чтобы продолжить
  internal static let contactPermissionInfo = L10n.tr("Localizable", "contact_permission_info")
  /// Контакты
  internal static let contactPickerTitle = L10n.tr("Localizable", "contact_picker_title")
  /// Поиск по имени или счету
  internal static let contactSearchHint = L10n.tr("Localizable", "contact_search_hint")
  /// Выберите номер
  internal static let contactSelectOne = L10n.tr("Localizable", "contact_select_one")
  /// Удалить аккаунт
  internal static let deleteAccount = L10n.tr("Localizable", "delete_account")
  /// Ваш бизнес-аккаунт %@ был удален, так как ЭЦП является недействительной. Для восстановления необходимо пройти идентификацию посредством ЭЦП
  internal static func deleteAccountDialog(_ p1: String) -> String {
    return L10n.tr("Localizable", "delete_account_dialog", p1)
  }
  /// Ваш аккаунт и все привязанные к нему счета будут удалены из приложения
  internal static let deleteAccountInfo = L10n.tr("Localizable", "delete_account_info")
  /// Удалить аккаунт %@?
  internal static func deleteAccountTitle(_ p1: String) -> String {
    return L10n.tr("Localizable", "delete_account_title", p1)
  }
  /// Удалить и продолжить
  internal static let deleteAndContinue = L10n.tr("Localizable", "delete_and_continue")
  /// Модерация
  internal static let didStatusIdentifyModeration = L10n.tr("Localizable", "did_status_identify_moderation")
  /// Модерация может занять от 1 до 3 дней. После надо Проверить статус.
  internal static let didStatusIdentifyModerationActiveDescription = L10n.tr("Localizable", "did_status_identify_moderation_active_description")
  /// Проверить статус
  internal static let didStatusIdentifyModerationActiveTitle = L10n.tr("Localizable", "did_status_identify_moderation_active_title")
  /// Здесь показан ваш прогресс и следующие шаги идентификации
  internal static let didStatusIdentifyProgressDescription = L10n.tr("Localizable", "did_status_identify_progress_description")
  /// Регистрация
  internal static let didStatusIdentifyRegistration = L10n.tr("Localizable", "did_status_identify_registration")
  /// Отправить заявку
  internal static let didStatusIdentifyRequest = L10n.tr("Localizable", "did_status_identify_request")
  /// Заявка отправлена
  internal static let didStatusIdentifyRequestSend = L10n.tr("Localizable", "did_status_identify_request_send")
  /// Идентификация пройдена успешно!
  internal static let didStatusIdentifyResult = L10n.tr("Localizable", "did_status_identify_result")
  /// Готово
  internal static let done = L10n.tr("Localizable", "DONE")
  /// Поле не может быть пустым
  internal static let errorEmptyField = L10n.tr("Localizable", "error_empty_field")
  /// Соединение с сервером прервано. Проверьте ваше подключение к интернету
  internal static let errorNoInternet = L10n.tr("Localizable", "error_no_internet")
  /// Вы уверены что хотите выйти из приложения?
  internal static let exitTheApplication = L10n.tr("Localizable", "exit_the_application")
  /// Введите код доступа к телефону, чтобы активировать Face ID
  internal static let faceIdInfo = L10n.tr("Localizable", "face_id_info")
  /// Поместите лицо в камеру, чтобы войти в приложение
  internal static let faceIdScanInfo = L10n.tr("Localizable", "face_id_scan_info")
  /// Комиссия %s
  internal static func fee(_ p1: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "fee", p1)
  }
  /// Комиссия
  internal static let feeTitle = L10n.tr("Localizable", "fee_title")
  /// Далее
  internal static let further = L10n.tr("Localizable", "further")
  /// Не удалось загрузить данные
  internal static let generalErrorMessageNoData = L10n.tr("Localizable", "general_error_message_no_data")
  /// Идентификация
  internal static let identificationTitle = L10n.tr("Localizable", "identification_title")
  /// Узнать больше
  internal static let learnMore = L10n.tr("Localizable", "learn_more")
  /// RU
  internal static let locale = L10n.tr("Localizable", "locale")
  /// Выйти из приложения
  internal static let logout = L10n.tr("Localizable", "logout")
  /// Выйти
  internal static let logoutText = L10n.tr("Localizable", "logout_text")
  /// Недостаточно средств
  internal static let lowBalanceError = L10n.tr("Localizable", "low_balance_error")
  /// Куда?
  internal static let mainAccountBank = L10n.tr("Localizable", "main_account_bank")
  /// Счета не загрузились
  internal static let mainAccountDidNotLoadResult = L10n.tr("Localizable", "main_account_did_not_load_result")
  /// Не все счета загрузились. \nОбновите страницу.
  internal static let mainAccountError = L10n.tr("Localizable", "main_account_error")
  /// Загружаем счета...
  internal static let mainAccountLoadingResult = L10n.tr("Localizable", "main_account_loading_result")
  /// Получатель не найден. \nВыберите другую организацию.
  internal static let mainAccountNotFound = L10n.tr("Localizable", "main_account_not_found")
  /// Счета не найдены.
  internal static let mainAccountNotFoundResult = L10n.tr("Localizable", "main_account_not_found_result")
  /// Ваши счета
  internal static let mainAccounts = L10n.tr("Localizable", "main_accounts")
  /// Добавить счёт
  internal static let mainAddAccount = L10n.tr("Localizable", "main_add_account")
  /// Выберите организацию
  internal static let mainAddAccountFi = L10n.tr("Localizable", "main_add_account_fi")
  /// Готово!
  internal static let mainAddAccountResult = L10n.tr("Localizable", "main_add_account_result")
  /// Счета в выбранном банке не найдены. Выберите другой.
  internal static let mainAddAccountResultUnsuccessful = L10n.tr("Localizable", "main_add_account_result_unsuccessful")
  /// Добавьте счёт
  internal static let mainAddAccountTitle = L10n.tr("Localizable", "main_add_account_title")
  /// По умолчанию
  internal static let mainBankDefault = L10n.tr("Localizable", "main_bank_default")
  /// Перевод будет осуществлен на банк получателя выбранный по умолчанию
  internal static let mainBankDefaultInfo = L10n.tr("Localizable", "main_bank_default_info")
  /// Перевод будет совершен на счет в организации, выбранной получателем как основная
  internal static let mainDefaultAccountInfo = L10n.tr("Localizable", "main_default_account_info")
  /// У вас ещё нет счёта для проведения транзакции
  internal static let mainInfo = L10n.tr("Localizable", "main_info")
  /// Не удалось привязать счета
  internal static let mainLinkError = L10n.tr("Localizable", "main_link_error")
  /// По умолчанию транзакции будут производиться через эту организацию
  internal static let mainPrimaryBankInfo = L10n.tr("Localizable", "main_primary_bank_info")
  /// Выбрать основной банк
  internal static let mainSelectPrimaryBank = L10n.tr("Localizable", "main_select_primary_bank")
  /// Сделать основной
  internal static let mainSetAsMain = L10n.tr("Localizable", "main_set_as_main")
  /// Отвязать
  internal static let mainUnlinkAccount = L10n.tr("Localizable", "main_unlink_account")
  /// Мы отвяжем эту организацию из приложения. При необходимости можете добавить снова
  internal static let mainUnlinkAccountInfo = L10n.tr("Localizable", "main_unlink_account_info")
  /// Отвязать этот счёт?
  internal static let mainUnlinkAccountQuestion = L10n.tr("Localizable", "main_unlink_account_question")
  /// %d
  internal static func minutesCount(_ p1: Int) -> String {
    return L10n.tr("Localizable", "MINUTES_COUNT", p1)
  }
  /// Нет контактов
  internal static let noContactsFound = L10n.tr("Localizable", "no_contacts_found")
  /// OK
  internal static let ok = L10n.tr("Localizable", "ok")
  /// БИН
  internal static let profileAccountBin = L10n.tr("Localizable", "profile_account_bin")
  /// Данные аккаунта
  internal static let profileAccountDetails = L10n.tr("Localizable", "profile_account_details")
  /// Снять фото
  internal static let profileAccountDetailsAvatarFromCamera = L10n.tr("Localizable", "profile_account_details_avatar_from_camera")
  /// Выбрать из галереи
  internal static let profileAccountDetailsAvatarFromGallery = L10n.tr("Localizable", "profile_account_details_avatar_from_gallery")
  /// Править
  internal static let profileAccountDetailsEdit = L10n.tr("Localizable", "profile_account_details_edit")
  /// ИИН
  internal static let profileAccountDetailsIin = L10n.tr("Localizable", "profile_account_details_iin")
  /// Имя
  internal static let profileAccountDetailsName = L10n.tr("Localizable", "profile_account_details_name")
  /// Номер телефона
  internal static let profileAccountDetailsPhonenumber = L10n.tr("Localizable", "profile_account_details_phonenumber")
  /// Роль
  internal static let profileAccountDetailsRole = L10n.tr("Localizable", "profile_account_details_role")
  /// Управление аккаунтами
  internal static let profileAccountManagement = L10n.tr("Localizable", "profile_account_management")
  /// Название
  internal static let profileAccountName = L10n.tr("Localizable", "profile_account_name")
  /// Правила и условия
  internal static let profileAgreement = L10n.tr("Localizable", "profile_agreement")
  /// Выбрать фото
  internal static let profileChoosePhoto = L10n.tr("Localizable", "profile_choose_photo")
  /// Данные пользователя
  internal static let profileDetails = L10n.tr("Localizable", "profile_details")
  /// Безопасность
  internal static let profileSecurity = L10n.tr("Localizable", "profile_security")
  /// Face ID не используется. Рекомендуем установить его в настройках системы
  internal static let profileSecurityFaceidInfo = L10n.tr("Localizable", "profile_security_faceid_info")
  /// Введите текущий код доступа для активации функции отпечатка пальца
  internal static let profileSecurityFingerprintActivate = L10n.tr("Localizable", "profile_security_fingerprint_activate")
  /// Отпечаток пальца не используется. Рекомендуем установить его в настройках системы
  internal static let profileSecurityFingerprintInfo = L10n.tr("Localizable", "profile_security_fingerprint_info")
  /// Перейти в Настройки
  internal static let profileSecurityFingerprintLinkSettings = L10n.tr("Localizable", "profile_security_fingerprint_link_settings")
  /// Язык приложения
  internal static let profileSettingsLanguage = L10n.tr("Localizable", "profile_settings_language")
  /// Системный
  internal static let profileSettingsLanguageDefault = L10n.tr("Localizable", "profile_settings_language_default")
  /// Язык приложения выставляется системными настройками телефона
  internal static let profileSettingsLanguageDefaultInfo = L10n.tr("Localizable", "profile_settings_language_default_info")
  /// Казахский
  internal static let profileSettingsLanguageKz = L10n.tr("Localizable", "profile_settings_language_kz")
  /// Русский
  internal static let profileSettingsLanguageRu = L10n.tr("Localizable", "profile_settings_language_ru")
  /// Служба поддержки
  internal static let profileSupport = L10n.tr("Localizable", "profile_support")
  /// Добавить поле суммы
  internal static let qrAddAmount = L10n.tr("Localizable", "qr_add_amount")
  /// Выберите код МCС, чтобы сгенерировать QR-код
  internal static let qrChooseMcc = L10n.tr("Localizable", "qr_choose_mcc")
  /// QR-код
  internal static let qrCode = L10n.tr("Localizable", "qr_code")
  /// Код МСС
  internal static let qrMcc = L10n.tr("Localizable", "qr_mcc")
  /// Список МCС кодов
  internal static let qrMccList = L10n.tr("Localizable", "qr_mcc_list")
  /// MCC–%@
  internal static func qrMccSelected(_ p1: String) -> String {
    return L10n.tr("Localizable", "qr_mcc_selected", p1)
  }
  /// Мой QR
  internal static let qrMyQrCode = L10n.tr("Localizable", "qr_my_qr_code")
  /// Не выбран
  internal static let qrNotSelected = L10n.tr("Localizable", "qr_not_selected")
  /// Наведите на QR-код, сканирование пройдет автоматически
  internal static let qrScanInfo = L10n.tr("Localizable", "qr_scan_info")
  /// Сканер QR-кода
  internal static let qrScanQrCode = L10n.tr("Localizable", "qr_scan_qr_code")
  /// Поиск
  internal static let qrSearch = L10n.tr("Localizable", "qr_search")
  /// Установить QR
  internal static let qrSetMcc = L10n.tr("Localizable", "qr_set_mcc")
  /// Поделиться QR-кодом
  internal static let qrShare = L10n.tr("Localizable", "qr_share")
  /// Не удалось распознать данный QR-код
  internal static let qrTryAgain = L10n.tr("Localizable", "qr_try_again")
  /// Обновить
  internal static let refresh = L10n.tr("Localizable", "refresh")
  /// Восстановить
  internal static let restore = L10n.tr("Localizable", "restore")
  /// Восстановить аккаунт
  internal static let restoreWs = L10n.tr("Localizable", "restore_ws")
  /// Ваш аккаунт будет восстановлен после прохождения идентификации посредством ЭЦП
  internal static let restoreWsInfo = L10n.tr("Localizable", "restore_ws_info")
  /// Восстановить аккаунт %@?
  internal static func restoreWsTitle(_ p1: String) -> String {
    return L10n.tr("Localizable", "restore_ws_title", p1)
  }
  /// Повторить
  internal static let retry = L10n.tr("Localizable", "retry")
  /// Повторить запрос
  internal static let retryRequest = L10n.tr("Localizable", "retry_request")
  /// Подтвердите новый код доступа
  internal static let securityChangeConfirmPin = L10n.tr("Localizable", "security_change_confirm_pin")
  /// Введите текущий код доступа
  internal static let securityChangeEnterOldPin = L10n.tr("Localizable", "security_change_enter_old_pin")
  /// Введите новый код доступа
  internal static let securityChangeEnterPin = L10n.tr("Localizable", "security_change_enter_pin")
  /// Введите код доступа
  internal static let securityEnterPinTitle = L10n.tr("Localizable", "security_enter_pin_title")
  /// Код доступа успешно изменен
  internal static let securityPinChangeResultSuccess = L10n.tr("Localizable", "security_pin_change_result_success")
  /// Сменить код доступа
  internal static let securitySettingsChangePin = L10n.tr("Localizable", "security_settings_change_pin")
  /// Face ID для входа
  internal static let securitySettingsFaceid = L10n.tr("Localizable", "security_settings_faceid")
  /// Touch ID для входа
  internal static let securitySettingsTouchid = L10n.tr("Localizable", "security_settings_touchid")
  /// Использовать Touch ID для быстрого входа в приложение
  internal static let securitySettingsTouchidInfo = L10n.tr("Localizable", "security_settings_touchid_info")
  /// Сервис недоступен. Повторите запрос или попробуйте позже.
  internal static let serviceUnavailable = L10n.tr("Localizable", "service_unavailable")
  /// Сервис недоступен
  internal static let serviceUnavailableResult = L10n.tr("Localizable", "service_unavailable_result")
  /// Для дальнейшей работы необходимо авторизоваться в приложении
  internal static let sessionDeleted = L10n.tr("Localizable", "session_deleted")
  /// В целях безопасности время работы истекло. Для продолжения работы необходимо авторизоваться
  internal static let sessionTimedOut = L10n.tr("Localizable", "session_timed_out")
  /// Настройки
  internal static let settings = L10n.tr("Localizable", "settings")
  /// Поделиться
  internal static let share = L10n.tr("Localizable", "share")
  /// Поделиться ссылкой
  internal static let shareLink = L10n.tr("Localizable", "share_link")
  /// Остановить
  internal static let stop = L10n.tr("Localizable", "stop")
  /// Чтобы использовать фото и видео из памяти вашего телефона, перейдите в настройки телефона и разрешите доступ к хранилищу
  internal static let storagePermissionAlertMessage = L10n.tr("Localizable", "storage_permission_alert_message")
  /// Разрешите доступ к хранилищу
  internal static let storagePermissionAlertTitle = L10n.tr("Localizable", "storage_permission_alert_title")
  /// Продолжить
  internal static let toContinue = L10n.tr("Localizable", "to_continue")
  /// Удалить
  internal static let toDelete = L10n.tr("Localizable", "to_delete")
  /// Перевести
  internal static let toTransfer = L10n.tr("Localizable", "to_transfer")
  /// Использовать
  internal static let toUse = L10n.tr("Localizable", "to_use")
  /// Сегодня
  internal static let today = L10n.tr("Localizable", "today")
  /// Введите код доступа к телефону, чтобы активировать Touch ID
  internal static let touchIdInfo = L10n.tr("Localizable", "touch_id_info")
  /// Приложите палец, чтобы войти в приложение
  internal static let touchIdScanInfo = L10n.tr("Localizable", "touch_id_scan_info")
  /// Сумма на счету
  internal static let transferAccountAmount = L10n.tr("Localizable", "transfer_account_amount")
  /// Доступные счета
  internal static let transferAccountList = L10n.tr("Localizable", "transfer_account_list")
  /// Номер счета
  internal static let transferAccountNumber = L10n.tr("Localizable", "transfer_account_number")
  /// Владелец
  internal static let transferAccountOwner = L10n.tr("Localizable", "transfer_account_owner")
  /// Продолжая, вы \nсоглашаетесь с
  internal static let transferAgreeWith = L10n.tr("Localizable", "transfer_agree_with")
  /// условиями сервиса
  internal static let transferAgreement = L10n.tr("Localizable", "transfer_agreement")
  /// Сколько?
  internal static let transferAmount = L10n.tr("Localizable", "transfer_amount")
  /// Организация получателя
  internal static let transferBankRecipient = L10n.tr("Localizable", "transfer_bank_recipient")
  /// Счёта
  internal static let transferByAccount = L10n.tr("Localizable", "transfer_by_account")
  /// Номер счёта
  internal static let transferByAccountTitle = L10n.tr("Localizable", "transfer_by_account_title")
  /// ИИН
  internal static let transferByIin = L10n.tr("Localizable", "transfer_by_iin")
  /// Перевод по номеру ИИН
  internal static let transferByIinTitle = L10n.tr("Localizable", "transfer_by_iin_title")
  /// Перевести по номеру
  internal static let transferByNumber = L10n.tr("Localizable", "transfer_by_number")
  /// Перевод по номеру
  internal static let transferByNumberTitle = L10n.tr("Localizable", "transfer_by_number_title")
  /// Телефона
  internal static let transferByPhonenumber = L10n.tr("Localizable", "transfer_by_phonenumber")
  /// Выбрать валюту
  internal static let transferChooseCurrency = L10n.tr("Localizable", "transfer_choose_currency")
  /// Подтверждение перевода
  internal static let transferConfirm = L10n.tr("Localizable", "transfer_confirm")
  /// Невозможно перевести указанному Пользователю
  internal static let transferConfirmIncorrectUserError = L10n.tr("Localizable", "transfer_confirm_incorrect_user_error")
  /// Подтвердить перевод
  internal static let transferConfirmRemittance = L10n.tr("Localizable", "transfer_confirm_remittance")
  /// Подтвердите перевод
  internal static let transferConfirmRemittanceTitle = L10n.tr("Localizable", "transfer_confirm_remittance_title")
  /// Код из СМС для подтверждения операции
  internal static let transferConfirmSms = L10n.tr("Localizable", "transfer_confirm_sms")
  /// Более одного номера
  internal static let transferContactsMoreThanOneNumber = L10n.tr("Localizable", "transfer_contacts_more_than_one_number")
  /// Российский рубль
  internal static let transferCurrencyRur = L10n.tr("Localizable", "transfer_currency_rur")
  /// Казахстанский тенге
  internal static let transferCurrencyTkz = L10n.tr("Localizable", "transfer_currency_tkz")
  /// Доллар США
  internal static let transferCurrencyUsd = L10n.tr("Localizable", "transfer_currency_usd")
  /// KZT
  internal static let transferDefaultCurrency = L10n.tr("Localizable", "transfer_default_currency")
  /// %1$s %2$s комиссия
  internal static func transferFeeFormat(_ p1: UnsafePointer<CChar>, _ p2: UnsafePointer<CChar>) -> String {
    return L10n.tr("Localizable", "transfer_fee_format", p1, p2)
  }
  /// Счёт списания
  internal static let transferFromAccount = L10n.tr("Localizable", "transfer_from_account")
  /// Номер ИИН
  internal static let transferIinNumber = L10n.tr("Localizable", "transfer_iin_number")
  /// Введены некорректные данные
  internal static let transferInvalidData = L10n.tr("Localizable", "transfer_invalid_data")
  /// Некорректный номер телефона
  internal static let transferInvalidPhoneNumber = L10n.tr("Localizable", "transfer_invalid_phone_number")
  /// Счёт получателя
  internal static let transferReceiptAccount = L10n.tr("Localizable", "transfer_receipt_account")
  /// Получатель
  internal static let transferRecipient = L10n.tr("Localizable", "transfer_recipient")
  /// Успешно переведено!
  internal static let transferResult = L10n.tr("Localizable", "transfer_result")
  /// Выберите счёт
  internal static let transferSelectAccount = L10n.tr("Localizable", "transfer_select_account")
  /// Сумма
  internal static let transferSum = L10n.tr("Localizable", "transfer_sum")
  /// Итого
  internal static let transferTotal = L10n.tr("Localizable", "transfer_total")
  /// Перевод принят в обработку
  internal static let transferUnderProcess = L10n.tr("Localizable", "transfer_under_process")
  /// Пользователь не найден
  internal static let transferUserNotFound = L10n.tr("Localizable", "transfer_user_not_found")
  /// Подождите…
  internal static let wait = L10n.tr("Localizable", "wait")
  /// Вчера
  internal static let yesterday = L10n.tr("Localizable", "yesterday")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

