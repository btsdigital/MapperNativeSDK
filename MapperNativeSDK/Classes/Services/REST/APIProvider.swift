import Foundation

protocol APIProvider: AuthAPI, BankAPI, TransferAPI, LoadAPI, QrAPI {
    var requestManager: NetworkManager { get }
}

class APIProviderImpl: APIProvider {
    var requestManager: NetworkManager
//    var authDelegate: AuthDelegate?

    init(requestManager: NetworkManager/*, authDelegate: AuthDelegate?*/) {
        self.requestManager = requestManager
//        self.authDelegate = authDelegate
    }
}
