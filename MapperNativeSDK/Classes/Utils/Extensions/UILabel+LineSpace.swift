import Foundation
import UIKit

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat = 0.0,
                        lineHeightMultiple: CGFloat = 0.0,
                        textAlignment: NSTextAlignment = .center) {
        guard let labelText = self.text else {
            return
        }

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.alignment = textAlignment

        let attributedString: NSMutableAttributedString

        if let labelAttributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        let range = NSRange(location: 0, length: attributedString.length)

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: range)

        attributedText = attributedString
    }
}
