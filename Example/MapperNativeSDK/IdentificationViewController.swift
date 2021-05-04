//
//  IdentificationViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 4/12/21.
//

import UIKit

class IdentificationViewController: UIViewController {
    
    private let redirectUrl = "ups://halyk"

    private var successObserver: NSObjectProtocol?
    private let center = NotificationCenter.default

    var phoneNumber: String = ""
    
    // Используется для проверки сессии. Подробнее тут https://auth0.com/docs/protocols/state-parameters
    private var state = ""
    
    override func viewDidLoad() {
        let onIdentificationSuccess = { [weak self] (notification: Notification) -> Void in
            let url = notification.object as! URL
            print(url)
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let error = urlComponents?.queryItems?.first(where: { $0.name == "error"})?.value {
                let descr = urlComponents?.queryItems?.first(where: { $0.name == "error_description"})
                self?.showMessage("Произошла ошибка: \(error), \(descr)")
                return
            }
            guard let code = urlComponents?.queryItems?.first(where: { $0.name == "code"})?.value else {
                self?.showMessage("No code in url")
                return
            }
            let state =  urlComponents?.queryItems?.first{ $0.name == "state"}?.value
            if state != self?.state {
                self?.showMessage("State isn't equals")
                return
            }
            self?.sendCode(code)
        }

        successObserver = center.addObserver(
            forName: .identificationSucceeded, object: nil,
            queue: nil, using: onIdentificationSuccess
        )
    }
    
    deinit {
        if let successObserver = successObserver {
            center.removeObserver(successObserver, name: .identificationSucceeded, object: nil)
        }
    }
    
    @IBAction func onIdentifyClicked(_ sender: Any) {
        state = random(count: 16)
        if let url = getMapperSDK().getIdentificationUrl(phoneNumber: phoneNumber, redirectUrl: redirectUrl, state: state) {
            print(url)
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    private func sendCode(_ code: String) {
        getMapperSDK().sendDocumentCode(code: code, redirectUrl: redirectUrl) { [weak self] result in
            switch result {
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            case .success:
                self?.navigationController?.popViewController(animated: false)
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerID") as? MainViewController
                self?.present(vc!, animated: true)
            }
        }
    }
    
    private func random(count: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<count).map { _ in
            return letters.randomElement() ?? Character("")
        })
    }
}
