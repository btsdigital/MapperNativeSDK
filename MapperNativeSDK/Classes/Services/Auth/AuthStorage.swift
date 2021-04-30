import KeychainAccess

/// Keys for quick access for stored data
enum AuthKey: String, CaseIterable {
    case deviceId, registrationId, passcode, token, isBioIdOn, lastActivityTime, isTestUser, currentWorkspaceId

    enum StorageType {
        case userDefaults, keychain, inMemory
    }

    var storageType: StorageType {
        switch self {
        case .deviceId, .passcode:
            return .keychain
        case .registrationId, .isBioIdOn, .isTestUser, .currentWorkspaceId:
            return .userDefaults
        case .token, .lastActivityTime:
            return .inMemory
        }
    }
}

// sourcery:begin: AutoMockable
protocol AuthStorage {
    var isBioIdOn: Bool { get }
    
    func set(_ value: String, key: AuthKey)
    func get(_ key: AuthKey) -> String?
    func delete(_ key: AuthKey)
    func store(registrationResponse: CompleteRegistrationResponse)
    func clearData()
    func getKeyData(alias: String) throws -> Data?
}

final class AuthStorageImpl: AuthStorage {
    private let keychain: Keychain
    private let userDefaults: UserDefaults
    private let inMemoryPersister = InMemoryPersister()
    
    var isBioIdOn: Bool {
        return Bool(get(.isBioIdOn) ?? "true") ?? true
    }

    init(keychain: Keychain = Keychain(), userDefaults: UserDefaults = UserDefaults.standard) {
        self.keychain = keychain
        self.userDefaults = userDefaults
    }

    func set(_ value: String, key: AuthKey) {
        switch key.storageType {
            case .keychain:
                keychain[key.rawValue] = value
            case .userDefaults:
                userDefaults.set(value, forKey: key.rawValue)
            case .inMemory:
                inMemoryPersister.set(value, key: key.rawValue)
        }
    }

    func get(_ key: AuthKey) -> String? {
        switch key.storageType {
            case .keychain:
                return keychain[string: key.rawValue]
            case .userDefaults:
                return userDefaults.object(forKey: key.rawValue) as? String
            case .inMemory:
                return inMemoryPersister.get(key.rawValue)
        }
    }

    func delete(_ key: AuthKey) {
        switch key.storageType {
            case .keychain:
                keychain[key.rawValue] = nil
            case .userDefaults:
                return userDefaults.removeObject(forKey: key.rawValue)
            case .inMemory:
                return inMemoryPersister.delete(key.rawValue)
        }
    }

    func store(registrationResponse: CompleteRegistrationResponse) {
        set(registrationResponse.deviceId, key: .deviceId)
        set(registrationResponse.registrationId, key: .registrationId)
        set(registrationResponse.sessionToken.token, key: .token)
    }

    func clearData() {
        for key in AuthKey.allCases {
            delete(key)
        }
        let keychain = Keychain()
        try? keychain.removeAll()
    }
    
    func getKeyData(alias: String) throws -> Data? {
        return try keychain.getData(alias)
    }
}
