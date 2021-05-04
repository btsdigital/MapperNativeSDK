import AVFoundation
import UIKit

final class AVPreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Look at AVPreviewView.layerClass")
        }
        return layer
    }

    var session: AVCaptureSession? {
        get {
            return videoPreviewLayer.session
        }
        set {
            videoPreviewLayer.session = newValue
            videoPreviewLayer.videoGravity = .resizeAspectFill
        }
    }

    // MARK: UIView

    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
