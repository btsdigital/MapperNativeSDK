import Foundation

extension String {
    /// Check if string contains only digits or plus
    ///
    var isDigitsOrPlus: Bool {
        return CharacterSet.digitsAndPlus.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    /// Check if string contains only digits or money decimal separator
    ///
    var isDigitsOrMoneySeparator: Bool {
        return CharacterSet.digitsAndMoneySeparator.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    /// Check if string only contains digits.
    ///
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    /// Check if string only contains letters or/and digits.
    ///
    var isAlphaNumeric: Bool {
        let set = CharacterSet.letters.union(CharacterSet.decimalDigits)
        return set.isSuperset(of: CharacterSet(charactersIn: self))
    }

    var isLatinNumeric: Bool {
        return self.range(of: "[^A-Za-z0-9]+", options: .regularExpression) == nil
    }

    /// - return first letter as a capital letter
    var firstCapital: String {
        guard let firstLetter = self.first else {
            return ""
        }
        return String(firstLetter).uppercased()
    }

    /// Check if string only contains Latin symbols and whitespaces
    ///
    var isLatinAndSpaceOnly: Bool {
        return range(of: "[^A-Za-z\\s]", options: .regularExpression) == nil
    }

    /// Check if string doesn't contains double whitespaces consecutively
    ///
    var isContainDoubleSpace: Bool {
        return range(of: "\\s\\s", options: .regularExpression) != nil
    }

    /// SwifterSwift: Sliced string from a start index with length.
    ///
    ///        "Hello World".slicing(from: 6, length: 5) -> "World"
    ///
    /// - Parameters:
    ///   - i: string index the slicing should start from.
    ///   - length: amount of characters to be sliced after given index.
    /// - Returns: sliced substring of length number of characters (if applicable) (example: "Hello World".slicing(from: 6, length: 5) -> "World")
    func slicing(from idx: Int, length: Int) -> String? {
        guard length >= 0, idx >= 0, idx < count else {
            return nil
        }
        guard idx.advanced(by: length) <= count else {
            return self[safe: idx..<count]
        }
        guard length > 0 else {
            return ""
        }
        return self[safe: idx..<idx.advanced(by: length)]
    }

    /// SwifterSwift: Safely subscript string with index.
    ///
    ///        "Hello World!"[safe: 3] -> "l"
    ///        "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter i: index.
    subscript(safe idx: Int) -> Character? {
        guard idx >= 0, idx < count else {
            return nil
        }
        return self[index(startIndex, offsetBy: idx)]
    }

    /// SwifterSwift: Safely subscript string within a half-open range.
    ///
    ///        "Hello World!"[safe: 6..<11] -> "World"
    ///        "Hello World!"[safe: 21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(safe range: CountableRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex,
                                     offsetBy: max(0, range.lowerBound),
                                     limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex,
                                     offsetBy: range.upperBound - range.lowerBound,
                                     limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }

    /// SwifterSwift: Safely subscript string within a closed range.
    ///
    ///        "Hello World!"[safe: 6...11] -> "World!"
    ///        "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    subscript(safe range: ClosedRange<Int>) -> String? {
        guard let lowerIndex = index(startIndex,
                                     offsetBy: max(0, range.lowerBound),
                                     limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex,
                                     offsetBy: range.upperBound - range.lowerBound + 1,
                                     limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }

    /// return masked value
    /// format: name prefixXXXlastComponent
    ///
    func getMaskedWithName(prefix: String,
                           lastComponent: String,
                           lastPartLength: Int) -> String {
        let last = String(lastComponent.suffix(lastPartLength))

        return "\(self) \(prefix)\(String(last))"
    }

    func indexOf(char: Character) -> Int? {
        return firstIndex(of: char)?.utf16Offset(in: self)
    }
    
    static func random(count: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<count).map { _ in
            return letters.randomElement() ?? Character("")
        })
    }
}
