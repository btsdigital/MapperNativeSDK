//
//  LoginViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/11/21.
//

import UIKit
import MapperNativeSDK

class LoginViewController: UIViewController {

    @IBOutlet weak var pinCodeInput: UITextField!
    @IBOutlet weak var signInWithBiometryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        signInWithBiometryButton.isEnabled = getMapperSDK().isBiometryEnabled()
    }

    @IBAction func signInByPinClick(_ sender: Any) {
        getMapperSDK().signInByPinCode(pinCode: pinCodeInput.text!) { [weak self] result in
            self?.handleResult(result)
        }
    }

    @IBAction func signInByBiometryClick(_ sender: Any) {
        getMapperSDK().signInByBiometry { [weak self] result in
            self?.handleResult(result)
        }
    }

    private func handleResult(_ result: Result<LoginResponse, Error>) {
        switch result {
        case let .success(res):
            if res.identification == .notIdentified {
                let vc = storyboard?.instantiateViewController(withIdentifier: "IdentificationViewControllerID") as? IdentificationViewController
                vc?.phoneNumber = res.phone
                present(vc!, animated: true)
            } else {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MainViewControllerID") as? MainViewController
                present(vc!, animated: true)
            }
        case let .failure(error):
            showMessage(error.localizedDescription)
        }
    }
}
