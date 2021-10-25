import Foundation

public class WillBeSet<T> {
    fileprivate var wrappedValue: T?
    public var value: T {
        get {
            guard let wrappedValue = wrappedValue else { fatalError("cannot access unset value for \(type(of: self))") }
            return wrappedValue
        }
        set {
            wrappedValue = newValue
        }
    }
    
    public var hasValue: Bool {
        return wrappedValue != nil
    }
    
    public init() { }
}

public class WillBeSetOnce<T>: WillBeSet<T> {
    override public var value: T {
        get {
            return super.value
        }
        set {
            guard wrappedValue == nil else { fatalError("cannot set \(type(of: self)) more than once") }
            super.value = newValue
        }
    }
}

public class Weak<T: AnyObject> {
    public weak var value: T?
    
    public init(value: T) {
        self.value = value
    }
}

public class WeakWillBeSet<T: AnyObject> {
    fileprivate weak var wrappedValue: T?
    public var value: T {
        get {
            guard let wrappedValue = wrappedValue else { fatalError("cannot access unset value for \(type(of: self))") }
            return wrappedValue
        }
        set {
            wrappedValue = newValue
        }
    }
    
    public var hasValue: Bool {
        return wrappedValue != nil
    }
    
    public init() { }
}

public class WeakWillBeSetOnce<T: AnyObject>: WeakWillBeSet<T> {
    private var wasSet = false
    
    override public var value: T {
        get {
            return super.value
        }
        set {
            guard !wasSet else { fatalError("cannot set \(type(of: self)) more than once") }
            super.value = newValue
            wasSet = true
        }
    }
}
