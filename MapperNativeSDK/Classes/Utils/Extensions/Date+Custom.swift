import Foundation

extension Date {
    init(timeStamp: Int64) {
        self.init(timeIntervalSince1970: TimeInterval(timeStamp) / 1_000.0)
    }

    func iso8601() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        return formatter.string(from: self)
    }
}
