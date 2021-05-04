//
//  RegistrationViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/11/21.
//

import UIKit
import MapperNativeSDK

class RegistrationViewController: UIViewController {

    @IBOutlet weak var phoneInput: UITextField!
    @IBOutlet weak var codeInput: UITextField!
    @IBOutlet weak var pinCodeInput: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onRegisterClick(_ sender: Any) {
        getMapperSDK().register(phoneNumber: phoneInput.text!) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .failure(error):
                if let error = error as? APIError, case .webExchangeBind = error.code {
                    self.showMessage("Неправильный номер телефона")
                } else {
                    self.showMessage(error.localizedDescription)
                }
            case .success:
                self.showMessage("Phone number is valid. Now send code from SMS")
            }
        }
    }

    @IBAction func onSendCodeClick(_ sender: Any) {
        getMapperSDK().confirmRegistration(code: codeInput.text!) { [weak self] result in
            switch result {
            case .success:
                self?.showMessage("Code is valid. Now set up PIN")
            case let .failure(error):
                if let error = error as? APIError, case .maxRegistrations = error.type {
                    // Here you should to show registered devices list, and the user of your app will select some devices to unregister
                    // To simplify we just unregister all devices to continue
                    self?.getAllRegistrations()
                } else {
                    self?.showMessage(error.localizedDescription)
                }
            }
        }
    }

    private func getAllRegistrations() {
        getMapperSDK().getRegistrations { [weak self] result in
            switch result {
            case let .success(value):
                self?.unregisterAllDevices(value.registrations)
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            }
        }
    }

    private func unregisterAllDevices(_ registrations: [Registration]) {
        getMapperSDK().deregister(registrationIds: registrations.map {
            $0.registrationId
        }) { [weak self]result in
            switch result {
            case .success:
                self?.showMessage("All devices unregistered")
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            }
        }
    }

    @IBAction func onCompleteRegistrationWithPinClick(_ sender: Any) {
        getMapperSDK().completeRegistration(pinCode: pinCodeInput.text!, withBiometry: false) { [weak self] result in
            switch result {
            case let .success(res):
                if res.identification == .notIdentified {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "IdentificationViewControllerID") as? IdentificationViewController
                    vc?.phoneNumber = (self?.phoneInput?.text!)!
                    self?.present(vc!, animated: true)
                } else {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerID") as? MainViewController
                    self?.present(vc!, animated: true)
                }
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            }
        }
    }

    @IBAction func onCompleteRegistrationWithBiometricClick(_ sender: Any) {
        getMapperSDK().completeRegistration(pinCode: pinCodeInput.text!, withBiometry: true) { [weak self] result in
            switch result {
            case let .success(res):
                if res.identification == .notIdentified {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "IdentificationViewControllerID") as? IdentificationViewController
                    vc?.phoneNumber = (self?.phoneInput?.text!)!
                    self?.present(vc!, animated: true)
                } else {
                    let vc = self?.storyboard?.instantiateViewController(withIdentifier: "MainViewControllerID") as? MainViewController
                    self?.present(vc!, animated: true)
                }
            case let .failure(error):
                self?.showMessage(error.localizedDescription)
            }
        }
    }
}
