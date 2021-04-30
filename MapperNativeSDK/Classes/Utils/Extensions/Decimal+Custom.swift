import Foundation
import UIKit

extension Decimal {
    init?(moneyString: String) {
        let formattedString = moneyString.replacingOccurrences(of: ",", with: ".")
        guard let decimalAmount = Decimal(string: formattedString, locale: Locale(identifier: "en_US")) else {
            return nil
        }
        self = decimalAmount
    }
    
    var moneyFormatSpaceSeparator: String {
        guard var formattedAmount = NumberFormatter.decimalMoney.string(for: self) else {
            return String(describing: self)
        }
        if self < 0 {
            let index = String.Index(utf16Offset: 1, in: formattedAmount)
            formattedAmount.insert(" ", at: index)
        }

        return formattedAmount + " \(Currency.currentCurrencySymbol)"
    }

    var moneyFormatVariousFonts: NSMutableAttributedString {
//        let nanosAttributes = [NSAttributedString.Key.font: UIFont.montserratMedium(36)]
        let nanosAttributes = [NSAttributedString.Key.font: ""]
        guard let formatedAmount = NumberFormatter.decimalMoney.string(for: self) else {
            return NSMutableAttributedString()
        }
//        let attributedText = NSMutableAttributedString(string: formatedAmount,
//                                                       attributes: [.font: UIFont.montserratSemiBold(36)])
        let attributedText = NSMutableAttributedString(string: formatedAmount)
        let commaLocation = NumberFormatter.decimalMoney.minimumFractionDigits
        let range = NSRange(location: formatedAmount.count - commaLocation, length: commaLocation)
        attributedText.setAttributes(nanosAttributes, range: range)
        attributedText.append(NSMutableAttributedString(string: " \(Currency.currentCurrencySymbol)",
                                                        attributes: nanosAttributes))
        return attributedText
    }
    
    func moneyFormatCommaSeparator(signed: Bool = false) -> String {
        guard var formattedAmount = NumberFormatter.decimalEnUs.string(for: self) else {
            return String(describing: self)
        }

        if self > 0, signed {
            formattedAmount.insert(contentsOf: "+ ", at: formattedAmount.startIndex)
        } else if self < 0 {
            if signed {
                let index = String.Index(utf16Offset: 1, in: formattedAmount)
                formattedAmount.insert(" ", at: index)
            } else {
                formattedAmount.removeFirst()
            }
        }

        return formattedAmount + " \(Currency.currentCurrencySymbol)"
    }
}
