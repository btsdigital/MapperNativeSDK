import Foundation
import KeychainAccess

protocol RequestTask {
    func cancel()
}

extension URLSessionDataTask: RequestTask {
}

public struct EmptyResponse: Decodable {
}

public struct PlainResponse: Decodable {
    let body: Data?
}

public typealias EmptyResponseCompletion = (Result<EmptyResponse, Error>) -> Void
public typealias PlainResponseCompletion = (Result<PlainResponse, Error>) -> Void

protocol NetworkManager: AnyObject {
    @discardableResult
    func send<T: Decodable>(request: Request,
                            completion: @escaping (Result<T, Error>) -> Void) -> RequestTask?

    func download(_ path: String,
                  filetype: String,
                  method: Method,
                  completion: @escaping (Result<URL, Error>) -> Void)
}

extension NetworkManager {
    func download(_ path: String,
                  filetype: String = "",
                  method: Method = .get,
                  completion: @escaping (Result<URL, Error>) -> Void) {
        download(path, filetype: filetype, method: method, completion: completion)
    }
}

class RequestManager: NetworkManager {
    typealias DownloadCompletion = (Result<URL, Error>) -> Void

    let authStorage: AuthStorage
    let finInstituteKeyStorage: FinInstituteKeyStorage
    private var session: URLSession
    private var sessionId: String?
    private var baseURL: URL
    private let responseHandler: ResponseHandler
    var downloads = [String: [DownloadCompletion]]()
    let downloadsQueue = DispatchQueue.global(qos: .utility)

    init(session: URLSession,
         authStorage: AuthStorage,
         finInstituteKeyStorage: FinInstituteKeyStorage,
         baseURL: URL = AppEnvironment.current.baseURL,
         responseHandler: ResponseHandler) {
        self.session = session
        self.authStorage = authStorage
        self.finInstituteKeyStorage = finInstituteKeyStorage
        self.responseHandler = responseHandler
        self.baseURL = baseURL
    }

    // MARK: - Request

    @discardableResult
    func send<T: Decodable>(request: Request,
                            completion: @escaping (Result<T, Error>) -> Void) -> RequestTask? {
        var urlRequest = request.buildUrlRequest()

        if request is PrivateRequest {
            getAuthHeaders().forEach {
                urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }

        if let data = urlRequest.httpBody,
           let request = request as? BankRequest,
           request.shouldDecryptRequest,
           finInstituteKeyStorage.containsKeys(fiBin: request.bin) {
            if let dataJson = String(data: data, encoding: .utf8),
               let encrypted = finInstituteKeyStorage.encryptSessionData(fiBin: request.bin, dataJson: dataJson) {
                urlRequest.httpBody = Data(base64Encoded: encrypted.base64Encoded() ?? "")
            } else {
                completion(.failure(NetworkError.unknown))
                return nil
            }
        }

        getCommonHeaders().forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            self?.setSessionIdIfNeeded(response: response)
            Logger.log("Headers: \(urlRequest.allHTTPHeaderFields)", type: .network, level: .info)
            self?.responseHandler.handleResponse(request: request,
                    data: data,
                    response: response,
                    error: error) { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
        task.resume()
        return task
    }

// MARK: Private

    private func getAuthHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        if let token = authStorage.get(.token) {
            headers["Authorization"] = "Bearer \(token)"
        }
        if let workspaceId = authStorage.get(.currentWorkspaceId) {
            headers["X-Workspace-ID"] = workspaceId
        }
        return headers
    }

    private func getCommonHeaders() -> [String: String] {
        var headers: [String: String] = [:]
        headers["X-Request-Time"] = Date().iso8601()
        headers["X-Request-ID"] = UUID().uuidString
        return headers
    }

    // MARK: For debugging. To be removed

    func setSessionIdIfNeeded(response: URLResponse?) {
        guard
                sessionId == nil,
                let response = response as? HTTPURLResponse,
                let fields = response.allHeaderFields as? [String: String],
                let url = response.url else {
            return
        }
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
        for cookie in cookies where cookie.name == "SESSIONID" {
            sessionId = cookie.value
        }
    }
}

extension RequestManager {
    func download(_ path: String,
                  filetype: String = "",
                  method: Method = .get,
                  completion: @escaping (Result<URL, Error>) -> Void) {
        let url = baseURL.appendingPathComponent(path)
        Logger.log(url.debugDescription, type: .network, level: .info)
        guard
                let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                let requestURL = urlComponents.url,
                let md5 = path.md5() else {
            return completion(.failure(NetworkError.wrongURL))
        }
        guard let destinationPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Error in fetching cachesDirectory")
        }
        let md5path = md5 + filetype
        let destinationURL = destinationPath.appendingPathComponent(md5path)
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            return completion(.success(destinationURL))
        }

        var urlRequest = URLRequest(url: requestURL)
        urlRequest.httpMethod = method.rawValue
        getCommonHeaders().forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        if let completions = getCompletions(for: md5path) {
            appendCompletion(completion, to: completions, for: md5path)
        } else {
            setCompletions([completion], for: md5path)

            let task = session.downloadTask(with: urlRequest) { [weak self] url, _, error in
                if let completions = self?.getCompletions(for: md5path) {
                    completions.forEach {
                        self?.fireCompletion($0, url: url, destinationURL: destinationURL, error: error)
                    }
                    self?.deleteCompletions(for: md5path)
                }
            }
            task.resume()
        }
    }

    private func fireCompletion(_ completion: @escaping DownloadCompletion,
                                url: URL?,
                                destinationURL: URL,
                                error: Error?) {
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            DispatchQueue.main.async {
                completion(.success(destinationURL))
            }
        } else if let url = url {
            do {
                try FileManager.default.copyItem(at: url, to: destinationURL)
                DispatchQueue.main.async {
                    completion(.success(destinationURL))
                }
            } catch {
                DispatchQueue.main.async {
                    let error = NetworkError.custom(error.localizedDescription)
                    completion(.failure(error))
                }
            }
        } else {
            let networkError = NetworkError.custom(error?.localizedDescription)
            Logger.log(networkError.description, type: .network, level: .error)
            DispatchQueue.main.async {
                completion(.failure(networkError))
            }
        }
    }

    private func getCompletions(for key: String) -> [DownloadCompletion]? {
        var completions: [DownloadCompletion]?
        downloadsQueue.sync {
            completions = self.downloads[key]
        }
        return completions
    }

    private func appendCompletion(_ completion: @escaping DownloadCompletion,
                                  to completions: [DownloadCompletion],
                                  for key: String) {
        downloadsQueue.async(flags: .barrier) {
            var completions = completions
            completions.append(completion)
            self.downloads[key] = completions
        }
    }

    private func setCompletions(_ completions: [DownloadCompletion], for key: String) {
        downloadsQueue.async(flags: .barrier) {
            self.downloads[key] = completions
        }
    }

    private func deleteCompletions(for key: String) {
        downloadsQueue.async(flags: .barrier) {
            self.downloads[key] = nil
        }
    }
}
