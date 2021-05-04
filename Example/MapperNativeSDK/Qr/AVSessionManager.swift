import AVFoundation
import UIKit

/// Tells that manager finished qith QR result
protocol AVSessionManagerDelegate: AnyObject {
    func didFinish(with result: Result<String, Error>)
}

enum AVSessionError: Error {
    case permissionError
    case configurationError
}

final class AVSessionManager: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    private let previewView: AVPreviewView

    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "AVSessionManagerQueue")
    private var setupResult: SetupResult = .success

    var isSessionRunning = false

    private enum SetupResult {
        case success
        case failed
    }

    weak var delegate: AVSessionManagerDelegate?

    init(previewView: AVPreviewView, delegate: AVSessionManagerDelegate? = nil) {
        previewView.session = session
        self.previewView = previewView
        self.delegate = delegate
        super.init()
        checkPermission()
    }

    func startSession() {
        sessionQueue.async {
            if self.setupResult == .success, self.session.isRunning == false {
                self.session.startRunning()
                self.isSessionRunning = true
            }
        }
    }

    func stopSession() {
        sessionQueue.async {
            if self.setupResult == .success, self.session.isRunning == true {
                self.session.stopRunning()
                self.isSessionRunning = false
            }
        }
    }

    func readCode(from image: UIImage) -> String? {
        guard
            let ciImage = CIImage(image: image),
            let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil),
            let features = detector.features(in: ciImage) as? [CIQRCodeFeature],
            let feature = features.first else {
            return nil
        }
        return feature.messageString
    }
    
    // MARK: Private

    private func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                sessionQueue.async {
                    self.configureSession()
                }
            case .denied:
                didFailPermission()
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                    if granted {
                        self?.sessionQueue.async {
                            self?.configureSession()
                        }
                    } else {
                        self?.setupResult = .failed
                        DispatchQueue.main.async {
                            self?.didFailPermission()
                        }
                    }
                }
            case .restricted:
                didFailPermission()
            @unknown default:
                print("@unknown default- AVCaptureDevice.authorizationStatus have new case")
        }
    }

    private func configureSession() {
        guard setupResult == .success else {
            didFailConfiguration()
            return
        }
        session.beginConfiguration()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            didFailConfiguration()
            return
        }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            didFailConfiguration()
            return
        }

        if session.canAddInput(videoInput) == true {
            session.addInput(videoInput)
        } else {
            didFailConfiguration()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if session.canAddOutput(metadataOutput) == true {
            session.addOutput(metadataOutput)

            metadataOutput.metadataObjectTypes = [.qr]
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        } else {
            didFailConfiguration()
            return
        }
        session.commitConfiguration()
    }

    func metadataOutput(_: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from _: AVCaptureConnection) {
        session.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {
                return
            }
            guard let stringValue = readableObject.stringValue else {
                return
            }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            delegate?.didFinish(with: .success(stringValue))
        } else {
            session.startRunning()
            isSessionRunning = true
        }
    }

    private func didFailConfiguration() {
        setupResult = .failed
        let error = AVSessionError.configurationError
        delegate?.didFinish(with: .failure(error))
    }

    private func didFailPermission() {
        setupResult = .failed
        let error = AVSessionError.permissionError
        delegate?.didFinish(with: .failure(error))
    }
}
