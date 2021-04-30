import Foundation

extension Array {
    /// SwifterSwift: Safely subscript array with index.
    ///
    ///        [1,2,3][safe: 2] -> 3
    ///        [1,2,3][safe: 3] -> nil
    ///
    /// - Parameter safe: index.
    subscript(safe index: Int) -> Element? {
        guard index >= 0, index < endIndex else {
            return nil
        }
        return self[index]
    }
}
