import Foundation

// swiftlint:disable all
/**
 *  `MulticastDelegate` lets you easily create a "multicast delegate" for a given protocol or class.
 */
public class MulticastDelegate<T> {
    /// lock for thread safety
    private var lock = NSRecursiveLock()
    /// The delegates hash table.
    private let delegates: NSHashTable<AnyObject>

    /**
     *  Use the property to check if no delegates are contained there.
     *
     *  - returns: `true` if there are no delegates at all, `false` if there is at least one.
     */
    public var isEmpty: Bool {
        let result: Bool
        lock.lock()
        result = delegates.allObjects.isEmpty
        defer {
            lock.unlock()
        }
        return result
    }

    /**
     *  Use this method to initialize a new `MulticastDelegate` specifying whether delegate references should be weak or
     *  strong.
     *
     *  - parameter strongReferences: Whether delegates should be strongly referenced, false by default.
     *
     *  - returns: A new `MulticastDelegate` instance
     */
    public init(strongReferences: Bool = false) {
        delegates = strongReferences ? NSHashTable<AnyObject>() : NSHashTable<AnyObject>.weakObjects()
    }

    /**
     *  Use this method to initialize a new `MulticastDelegate` specifying the storage options yourself.
     *
     *  - parameter options: The underlying storage options to use
     *
     *  - returns: A new `MulticastDelegate` instance
     */
    public init(options: NSPointerFunctions.Options) {
        delegates = NSHashTable<AnyObject>(options: options, capacity: 0)
    }

    /**
     *  Use this method to register a delelgate.
     *
     *  Alternatively, you can use the `+=` operator to add a delegate.
     *
     *  - parameter delegate:  The delegate to be added.
     */
    public func register(_ delegate: T) {
        lock.lock()
        if !delegates.contains(delegate as AnyObject) {
            delegates.add(delegate as AnyObject)
        }
        lock.unlock()
    }

    /**
     *  Use this method to remove a previously-added delegate.
     *
     *  Alternatively, you can use the `-=` operator to add a delegate.
     *
     *  - parameter delegate:  The delegate to be removed.
     */
    public func unregister(_ delegate: T) {
        lock.lock()
        delegates.remove(delegate as AnyObject)
        lock.unlock()
    }

    /**
     *  Use this method to invoke a closure on each delegate.
     *
     *  Alternatively, you can use the `|>` operator to invoke a given closure on each delegate.
     *
     *  - parameter invocation: The closure to be invoked on each delegate.
     */
    public func invoke(_ invocation: (T) -> Void) {
        lock.lock()
        for delegate in delegates.allObjects {
            // swiftlint:disable force_cast
            invocation(delegate as! T)
        }
        lock.unlock()
    }

    /**
     *  Use this method to determine if the multicast delegate contains a given delegate.
     *
     *  - parameter delegate:   The given delegate to check if it's contained
     *
     *  - returns: `true` if the delegate is found or `false` otherwise
     */
    public func contains(_ delegate: T) -> Bool {
        let result: Bool
        lock.lock()
        result = delegates.contains(delegate as AnyObject)
        defer {
            lock.unlock()
        }
        return result
    }
}

/**
 *  Use this operator to add a delegate.
 *
 *  This is a convenience operator for calling `addDelegate`.
 *
 *  - parameter left:   The multicast delegate
 *  - parameter right:  The delegate to be added
 */
public func += <T>(left: MulticastDelegate<T>, right: T) {
    left.register(right)
}

/**
 *  Use this operator to remove a delegate.
 *
 *  This is a convenience operator for calling `removeDelegate`.
 *
 *  - parameter left:   The multicast delegate
 *  - parameter right:  The delegate to be removed
 */
public func -= <T>(left: MulticastDelegate<T>, right: T) {
    left.unregister(right)
}

/**
 *  Use this operator invoke a closure on each delegate.
 *
 *  This is a convenience operator for calling `invokeDelegates`.
 *
 *  - parameter left:   The multicast delegate
 *  - parameter right:  The closure to be invoked on each delegate
 *
 *  - returns: The `MulticastDelegate` after all its delegates have been invoked
 */
precedencegroup MulticastPrecedence {
    associativity: left
    higherThan: TernaryPrecedence
}

infix operator |>: MulticastPrecedence
public func |> <T>(left: MulticastDelegate<T>, right: (T) -> Void) {
    left.invoke(right)
}
