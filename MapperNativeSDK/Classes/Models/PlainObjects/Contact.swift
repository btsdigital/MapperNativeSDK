import UIKit

typealias ContactClosure = (Contact) -> Void

struct Contact: Hashable {
    let phoneNumber: String
    let firstName: String
    let lastName: String
    let fullname: String
    var avatar: UIImage?

    public init(phoneNumber: String, firstName: String, lastName: String, avatar: UIImage?) {
        self.phoneNumber = phoneNumber
        self.firstName = firstName
        self.lastName = lastName
        self.avatar = avatar
        fullname = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension Contact: Comparable {
    public static func < (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.fullname.localizedCaseInsensitiveCompare(rhs.fullname) == ComparisonResult.orderedAscending
    }

    private static func compare(_ lhs: String?, lessThan rhs: String?) -> Bool {
        guard let lhs = lhs else {
            return false
        }
        guard let rhs = rhs else {
            return true
        }
        return lhs < rhs
    }
}
