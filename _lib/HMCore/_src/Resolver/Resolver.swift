// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public class ResolverContainer<Context: AnyObject> {
    public typealias ResolverBlock = ((Context) -> AnyObject?)
    private var blocks = [ResolverBlock]()
    
    public init() {
    }
    
    public func registerBuilder(block block: ResolverBlock) {
        self.blocks.append(block)
    }
    
    internal func build(context context: Context) -> [AnyObject] {
        return self.blocks.flatMap { $0(context) }
    }
}

// =======================================================

public class Resolver<Context: AnyObject>: NSObject {
    public typealias ResolverBlock = ((Context) -> AnyObject?)
    private var owned = [AnyObject]()
    
    public init(context: Context, container: ResolverContainer<Context>) {
        self.owned = container.build(context: context)
        super.init()
    }
    
    public func components<T: Any>(type: T.Type) -> [T] {
        return self.owned.flatMap { return ($0 as? T) }
    }
    
    public func component<T: Any>(type: T.Type) -> T? {
        return self.components(type).first
    }
}
