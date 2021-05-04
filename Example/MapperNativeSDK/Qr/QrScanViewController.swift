//
//  QrScanViewController.swift
//  MapperNativeSDKSample
//
//  Created by Askar Syzdykov on 4/1/21.
//

import Foundation
import UIKit

class QrScanViewController: UIViewController, AVSessionManagerDelegate {
    func togglePermissionButton(isHidden: Bool) {
        
    }
    
    func addBarCloseButton() {
        
    }
    
    private var sessionManager: AVSessionManager?
    private lazy var qrScanView = QRView()
    private let previewView = AVPreviewView()
    
    override func viewDidLoad() {
        configureScanView()
        sessionManager = AVSessionManager(previewView: previewView, delegate: self)
    }
    
    private func configureScanView() {
        view.addSubview(previewView)
        previewView.makeAnchors {
            $0.edges.equalToSuperview()
        }
        view.addSubview(qrScanView)
        qrScanView.backgroundColor = .clear
        qrScanView.makeAnchors {
            $0.edges.equalToSuperview()
        }
        view.sendSubviewToBack(qrScanView)
        view.sendSubviewToBack(previewView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopSession()
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func startSession() {
        sessionManager?.startSession()
    }
    
    func stopSession() {
        sessionManager?.stopSession()
    }
    
    func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true, completion: nil)
    }
    
    func didFinish(with result: Result<String, Error>) {
        switch result {
            case let .failure(error):
                if case AVSessionError.configurationError = error {
                    print(error)
                } else if case AVSessionError.permissionError = error {
                    togglePermissionButton(isHidden: false)
                }
            case let .success(qrData):
                stopSession()
                togglePermissionButton(isHidden: true)
                didFindQrData(qrData)
        }
    }
    
    private func didFindQrData(_ qrData: String) {
        getMapperSDK().decodeQRData(data: qrData) { [weak self] result in
            switch result {
            case let .success(response):
                self?.showMessage(String(describing: response))
            case .failure(_):
                self?.showMessage("Wrong QR")
                self?.startSession()
            }
        }
    }
}

extension QrScanViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard
            let image = info[.originalImage] as? UIImage,
            let _ = sessionManager?.readCode(from: image) else {
            picker.dismiss(animated: true) { [weak self] in
                self?.stopSession()
                self?.startSession()
            }
            return
        }
        picker.dismiss(animated: true) { [weak self] in
            self?.stopSession()
//            self?.presenter.didFindQrData(result)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
