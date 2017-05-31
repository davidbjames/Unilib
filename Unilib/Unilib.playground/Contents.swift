
import UIKit

public protocol OptionalType {
    associatedtype Wrapped
    var optional:Wrapped? { get }
}

extension Optional : OptionalType {
    public var optional:Wrapped? { return self }
}

public extension Sequence where Iterator.Element: OptionalType {
    var droppingNils:[Iterator.Element.Wrapped] {
        return flatMap({ $0.optional })
    }
}

public extension Array where Iterator.Element : OptionalType {
    
    var firstNonNil:Element.Wrapped? {
        return first { $0.optional != nil } as? Element.Wrapped
    }

    var countNonNils:Int {
        return self.filter({ $0.optional != nil }).count
    }
    
    /// One (and only one) item is non-nil
    /// This is roughly an 'xor boolean' function:
    /// if [x,y,z].onlyOneElementHasValue
    var containsOnlyOneNonNil:Bool {
        return countNonNils == 1
    }
    
    var containsNonNil:Bool {
        return countNonNils > 0
    }
    
    var containsAllNil:Bool {
        return countNonNils == 0
    }
    
    var containsAllNonNil:Bool {
        return countNonNils == count
    }
}

/// Nil-coalesce array
/// Take the first non-nil value, or if none, the default.
public func ?? <T>(array:Array<T?>, defaultValue:T) -> T {
    return array.droppingNils.first ?? defaultValue
}

var a:CGFloat? = nil
var b:CGFloat? = nil
var c:CGFloat? = 1.0

[a,b].firstNonNil ?? 2.0 // 2.0
[a,b,c].firstNonNil ?? 2.0 // 1.0

