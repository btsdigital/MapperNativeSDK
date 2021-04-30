import Foundation

extension NumberFormatter {
    static let decimalEnUs: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()

    static let decimalMoney: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = " "
        formatter.decimalSeparator = Money.Constants.separator
        return formatter
    }()
}
