import Foundation
import UIKit

/// Protocol describing auto generation accessibility identifiers for views
public protocol AccesibilityIdentifiersGenerator {
    /// Generate accesibility identifiers for all subviews
    ///
    /// - Parameter for: View for generation (self by default)
    func generateAccessibilityIdentifiers(for view: UIView?)
}

// swiftlint:disable extension_access_modifier
extension AccesibilityIdentifiersGenerator {
    public func generateAccessibilityIdentifiers(for view: UIView? = nil) {
        #if !PRODUCTION
            let mirror = view != nil ? Mirror(reflecting: view as Any) : Mirror(reflecting: self)

            if let currentView = self as? UIView {
                currentView.accessibilityIdentifier = "\(type(of: self))"
            }
            mirror.children.forEach { child in
                if let label = child.label, let view = child.value as? UIView, label != "some" {
                    view.accessibilityIdentifier = "\(type(of: self)).\(label)"
                    if !view.subviews.isEmpty {
                        view.subviews.forEach { view in
                            generateAccessibilityIdentifiers(for: view)
                        }
                    }
                }
            }
        #endif
    }
}

extension UIViewController: AccesibilityIdentifiersGenerator {}
extension UITableViewCell: AccesibilityIdentifiersGenerator {}
