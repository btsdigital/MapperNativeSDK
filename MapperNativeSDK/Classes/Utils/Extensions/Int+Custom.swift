import Foundation

extension Int {
    /// Converts seconds to minutes
    /// - Parameter rounded: Rounding rules for converting (up or down, for example)
    func toMinutes(rounded: FloatingPointRoundingRule) -> Int {
        return Int((Double(self) / 60.0).rounded(rounded))
    }
}
