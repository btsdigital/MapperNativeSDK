import Contacts
import Foundation
import UIKit

typealias ContactsPermissionCompletion = (_ granted: Bool) -> Void
typealias ContactsFetchCompletion = ([Contact]) -> Void

protocol ContactBookService: AnyObject {
    /// Requests permission for device's contact book
    ///
    /// - Parameter completion: response completion with boolean value
    func requestContactsPermission(completion: @escaping ContactsPermissionCompletion)

    /// Checks permission status for device's contact book
    ///
    /// - Parameter completion: response completion with boolean value
    func checkContactsPermissionStatus(completion: @escaping ContactsPermissionCompletion)

    /// Fetchs contacts from device's contact book
    ///
    /// - Parameter completion: array of Contact
    func fetchContacts(completion: @escaping ContactsFetchCompletion)
}

final class ContactBookServiceImpl: ContactBookService {
    private let store = CNContactStore()

    // MARK: - ContactBookService

    func fetchContacts(completion: @escaping ContactsFetchCompletion) {
        DispatchQueue.global(qos: .userInitiated).async {
            let contacts = self.fetchAndConvertToContact()
            DispatchQueue.main.async {
                completion(contacts)
            }
        }
    }

    func requestContactsPermission(completion: @escaping ContactsPermissionCompletion) {
        store.requestAccess(for: CNEntityType.contacts) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
                if let error = error {
                    Logger.log("Error: \(error)", type: .basic, level: .error)
                }
            }
        }
    }

    func checkContactsPermissionStatus(completion: @escaping ContactsPermissionCompletion) {
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch status {
            case .authorized:
                completion(true)
            default:
                completion(false)
        }
    }
    
    func getContactsPermissionStatus() -> CNAuthorizationStatus {
        return CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    }

    // MARK: - Private methods

    private func fetchAndConvertToContact() -> [Contact] {
        let request = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor,
                                                          CNContactFamilyNameKey as CNKeyDescriptor,
                                                          CNContactPhoneNumbersKey as CNKeyDescriptor,
                                                          CNContactThumbnailImageDataKey as CNKeyDescriptor])
        var contacts: [Contact] = []
        let characterSet = CharacterSet.digitsAndPlus.inverted
        do {
            try store.enumerateContacts(with: request) { cnContact, _ in
                let firstName = cnContact.givenName
                let lastName = cnContact.familyName
                var avatar: UIImage?
                if let data = cnContact.thumbnailImageData {
                    avatar = UIImage(data: data)
                }
                contacts += cnContact.phoneNumbers.map {
                    let phoneNumber = $0.value
                        .stringValue
                        .components(separatedBy: characterSet)
                        .joined()
                    return Contact(phoneNumber: phoneNumber,
                                   firstName: firstName,
                                   lastName: lastName,
                                   avatar: avatar)
                }
            }
        } catch {
            print(error)
        }
        return contacts.sorted(by: <)
    }
}
