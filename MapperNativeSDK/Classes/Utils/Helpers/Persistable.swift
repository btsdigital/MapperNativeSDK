import Foundation

protocol Persistable {
    associatedtype ObjectType
    func set(_ object: ObjectType, key: String)
    func get(_ key: String) -> ObjectType?
    func delete(_ key: String)
}

final class InMemoryPersister: Persistable {
    private let queue = DispatchQueue(label: "InMemoryPersisterQueue")
    private var dict = [String: String]()

    func set(_ object: String, key: String) {
        queue.async {
            self.dict[key] = object
        }
    }

    func get(_ key: String) -> String? {
        var object: String?
        queue.sync {
            object = self.dict[key]
        }
        return object
    }

    func delete(_ key: String) {
        queue.async {
            self.dict[key] = nil
        }
    }
}

class LocalCache: Persistable {
    private var cache = NSCache<NSString, AnyObject>()

    func set(_ object: AnyObject, key: String) {
        cache.setObject(object, forKey: NSString(string: key))
    }

    func get(_ key: String) -> AnyObject? {
        return cache.object(forKey: NSString(string: key))
    }

    func delete(_ key: String) {
        cache.removeObject(forKey: NSString(string: key))
    }
}
