import Foundation

final class SessionPinningDelegate: NSObject, URLSessionDelegate {
    func urlSession(_: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        /// Uncomment it to disable checking certificate
        #if DEBUG
            if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
                let serverTrust = challenge.protectionSpace.serverTrust {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
                return
            }
        #endif

        var secresult = SecTrustResultType.invalid
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
            let serverTrust = challenge.protectionSpace.serverTrust,
            errSecSuccess == SecTrustEvaluate(serverTrust, &secresult),
            let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        let serverCertificateData = SecCertificateCopyData(serverCertificate)
        let data = CFDataGetBytePtr(serverCertificateData)
        let size = CFDataGetLength(serverCertificateData)
        let serverCert = NSData(bytes: data, length: size)

        // To generate der file from pem, run openssl x509 -outform der -in XXX.pem -out pay.der
        let localCert = AppEnvironment.current.cert
        guard
            serverCert.isEqual(to: localCert),
            localCert.md5() == AppEnvironment.current.md5CheckSum else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}
