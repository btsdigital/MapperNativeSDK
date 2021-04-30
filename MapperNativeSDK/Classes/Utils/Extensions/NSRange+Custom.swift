import Foundation

extension NSRange {
    init(with range: Range<String.Index>, string: String) {
        let location = range.lowerBound.utf16Offset(in: string)
        let length = range.upperBound.utf16Offset(in: string) - location
        self = NSRange(location: location, length: length)
    }
}
