//
//  WorkspaceViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 3/13/21.
//

import UIKit
import MapperNativeSDK

class WorkspaceViewController: UIViewController {
    
    @IBOutlet weak var outputLabel: UILabel!
    @IBOutlet weak var workspacesLabel: UILabel!
    
    override func viewDidLoad() {
        getMapperSDK().getProfile{[weak self] result in
            switch result {
            case let .failure(error): self?.showMessage(error.localizedDescription)
            case let .success(value):
                self?.workspacesLabel.text = "\(value.workspaces)"
            }
        }
    }
    
    @IBAction func loadSignatureClick(_ sender: Any) {
        getMapperSDK().getSignature(type: .entrepreneur) { [weak self] result in
            switch result {
            case let .failure(error): self?.showMessage(error.localizedDescription)
            case let .success(value):
                self?.outputLabel.text = "Open in browser \(value.url) and input code \(value.code)"
            }
        }
    }
}
