// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public class ServiceContainer: Resolver<ServiceContext> {
    internal(set) public var active = false
    public let userID: String
    public var loggedIn: Bool {
        return self.userID != "anon"
    }
    
    internal override init(context: ServiceContext, container: ResolverContainer<ServiceContext>) {
        self.userID = context.userIdentifier
        super.init(context: context, container: container)
    }
}
