import Foundation

typealias GetURLResponseCompletion = (Result<URL, Error>) -> Void

protocol LoadAPI {
    /// Requests for PDF's URL
    ///
    /// - Parameters:
    ///   - transferId: The transfer id
    ///   - completion: GetURLResponseCompletion
    func getOperationPDF(transferId: String, _ completion: @escaping GetURLResponseCompletion)

    /// Downloads image with URL
    ///
    /// - Parameters:
    ///   - imagePath: Image's URL path
    ///   - completion: GetURLResponseCompletion
    func getImage(imagePath: String, _ completion: @escaping GetURLResponseCompletion)
}

extension APIProviderImpl {
    func getOperationPDF(transferId: String, _ completion: @escaping GetURLResponseCompletion) {
        requestManager.download("processing/transfer/\(transferId)/pdf", filetype: ".pdf") { result in
            completion(result)
        }
    }

    func getImage(imagePath: String, _ completion: @escaping GetURLResponseCompletion) {
        requestManager.download(imagePath) { result in
            completion(result)
        }
    }
}
