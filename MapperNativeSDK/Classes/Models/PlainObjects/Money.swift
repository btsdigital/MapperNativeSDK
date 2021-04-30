import Foundation
import UIKit

enum MoneyError: Error {
    case convertationError
}

public struct Money: Equatable, Codable {
    enum Constants {
        static let divisor: Decimal = 1_000_000_000
        static let separator: String = ","
        static let wrongSeparator: String = "."
    }

    public var amount: Decimal
    public var currency: Currency

    static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.groupingSeparator = ""
        return formatter
    }()

    static let spaceSeparatorFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = Constants.separator
        return formatter
    }()

    enum CodingKeys: String, CodingKey {
        case value, currencyCode
    }

    // MARK: - Computed properties

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        amount = try container.decode(Decimal.self, forKey: .value)
        let currencyCode = try container.decode(Int.self, forKey: .currencyCode)
        currency = Currency(code: currencyCode)
    }

    public init(amount: Decimal, currency: Currency = Currency.currentCurrency) {
        self.amount = amount
        self.currency = currency
    }

    init(units: Int64, nanos: Int32, currency: Currency = Currency.currentCurrency) {
        let fractionPart = Decimal(nanos) / Constants.divisor
        var notRoundedAmount = Decimal(units) + fractionPart

        amount = Decimal()
        self.currency = currency

        NSDecimalRound(&amount, &notRoundedAmount, 2, Decimal.RoundingMode.down)
    }

    public init?(amount: String) {
        guard let decimalAmount = Decimal(moneyString: amount) else {
            return nil
        }
        self = Money(amount: decimalAmount)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(amount, forKey: .value)
        try container.encode(currency.rawValue, forKey: .currencyCode)
    }

    public func getFormattedString(showingPlus: Bool = false, showingMinus: Bool = false) -> String {
        guard var formattedAmount = Money.spaceSeparatorFormatter.string(for: amount) else {
            return String(describing: amount)
        }

        if amount > 0, showingPlus {
            formattedAmount.insert(contentsOf: "+ ", at: formattedAmount.startIndex)
        } else if amount < 0 {
            if showingMinus {
                let index = String.Index(utf16Offset: 1, in: formattedAmount)
                formattedAmount.insert(" ", at: index)
            } else {
                formattedAmount.removeFirst()
            }
        }

        return formattedAmount + " \(currency.isoCode)"
    }

    var spaceFormattedString: String {
        guard var formattedAmount = Money.spaceSeparatorFormatter.string(for: amount) else {
            return String(describing: amount)
        }
        if amount < 0 {
            let index = String.Index(utf16Offset: 1, in: formattedAmount)
            formattedAmount.insert(" ", at: index)
        }

        return formattedAmount + " \(currency.isoCode)"
    }

    var fontSplitSpaceFormattedString: NSMutableAttributedString {
//        let nanosAttributes = [NSAttributedString.Key.font: UIFont.montserratMedium(36)]
        let nanosAttributes = [NSAttributedString.Key.font: ""]
        let formatter = Money.spaceSeparatorFormatter
        guard let formatedAmount = formatter.string(for: amount) else {
            return NSMutableAttributedString()
        }
//        let attributedText = NSMutableAttributedString(string: formatedAmount,
//                                                       attributes: [.font: UIFont.montserratSemiBold(36)])
        let attributedText = NSMutableAttributedString(string: formatedAmount)
        let commaLocation = formatter.minimumFractionDigits
        let range = NSRange(location: formatedAmount.count - commaLocation, length: commaLocation)
        attributedText.setAttributes(nanosAttributes, range: range)
//        attributedText.append(NSMutableAttributedString(string: " \(currency.isoCode)", attributes: nanosAttributes))
        attributedText.append(NSMutableAttributedString(string: " \(currency.isoCode)"))
        return attributedText
    }

    var units: Int64 {
        return (amount as NSDecimalNumber).int64Value
    }

    var nanos: Int32 {
        let value: Double = (amount as NSDecimalNumber).doubleValue
        let fractionalPart = value - floor(value)
        let divisor = (Constants.divisor as NSDecimalNumber).doubleValue
        guard let nanos = Int32(exactly: round(fractionalPart * divisor)) else {
            fatalError("Error map nanos from PayMoney. Amount value = \(amount)")
        }
        return nanos
    }

    var isEmpty: Bool {
        return amount == 0
    }
}

extension Money {
    static func + (left: Money, right: Money) -> Money? {
        if left.currency == right.currency {
            return Money(amount: abs(left.amount) + abs(right.amount), currency: left.currency)
        } else {
            return nil
        }
    }
}
