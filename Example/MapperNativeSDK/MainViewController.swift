//
//  MainViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/11/21.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var outputLabel: UILabel!
    
    @IBAction func loadProfileClick(_ sender: Any) {
        getMapperSDK().getProfile { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showMessage(error.localizedDescription)
            case .success(let user):
                self?.outputLabel.text = "\(user.firstName) \(user.lastName) \(user.iin) \(user.phone)"
            }
        }
    }
    
    @IBAction func loadMccClick(_ sender: Any) {
        getMapperSDK().getAllMccCodes { [weak self] result in
            switch result {
            case .failure(let error):
                self?.showMessage(error.localizedDescription)
            case .success(let mccList):
                self?.outputLabel.text = "\(mccList)"
            }
        }
    }
}
