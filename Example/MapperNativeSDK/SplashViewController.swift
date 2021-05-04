//
//  ViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/10/21.
//

import UIKit
import MapperNativeSDK
import SafariServices

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onClearClick(_ sender: Any) {
        getMapperSDK().clearSession { [weak self] _ in
            self?.showMessage("Session is cleared")
        }
    }
    
    @IBAction func showNextScreen(_ sender: UIButton) {
        var vc: UIViewController?
        if (getMapperSDK().isRegistered()) {
            vc = storyboard?.instantiateViewController(withIdentifier: "LoginViewControllerID") as? LoginViewController
        } else {
            vc = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewControllerID") as? RegistrationViewController
        }
        present(vc!, animated: true)
    }
}

public extension UIViewController {
    
    func getMapperSDK() -> MapperSDK {
        return (UIApplication.shared.delegate as! AppDelegate).mapperSDK
    }
    
    func showMessage(_ message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

