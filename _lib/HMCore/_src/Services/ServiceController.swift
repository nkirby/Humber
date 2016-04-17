// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

// =======================================================

public class ServiceContext {
    public let userIdentifier: String
    
    internal init(userIdentifier: String) {
        self.userIdentifier = userIdentifier
    }
}

// =======================================================

public class ServiceController: NSObject {
    private static let userDefaultsKey = "HMUserID"
    
    public static let sharedController = ServiceController()
    public static let container = ResolverContainer<ServiceContext>()
    
    public var currentUser: MutableProperty<ServiceContainer?>
    
// =======================================================
// MARK: - Init, etc...
    
    public override init() {
        self.currentUser = MutableProperty(nil)
        super.init()
        
    }
    
// =======================================================
// MARK: - Setup
    
    public func setup(@noescape block:((container: ResolverContainer<ServiceContext>) -> Void)) {
        // Register the building blocks
        block(container: ServiceController.container)
        
        self.fetchStoredServices()
    }

    private func fetchStoredServices() {
//        print("stored: \(NSUserDefaults.standardUserDefaults().dictionaryRepresentation())")
        
        if let userID = NSUserDefaults.standardUserDefaults().stringForKey(ServiceController.userDefaultsKey) {
            let context = ServiceContext(userIdentifier: userID)
            let user = ServiceContainer(context: context, container: ServiceController.container)
            self.currentUser.value = user
    
        } else {
            let context = ServiceContext(userIdentifier: "anon")
            let user = ServiceContainer(context: context, container: ServiceController.container)
            self.currentUser.value = user
            
        }
    }
    
// =======================================================
// MARK: - Login / Out
    
    public func login(userID userID: String) {
        NSUserDefaults.standardUserDefaults().setValue(userID, forKey: ServiceController.userDefaultsKey)
        NSUserDefaults.standardUserDefaults().synchronize()
//        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)

        let context = ServiceContext(userIdentifier: userID)
        let user = ServiceContainer(context: context, container: ServiceController.container)
        self.currentUser.value = user
    }
    
    public func logout() {
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: ServiceController.userDefaultsKey)
        CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)

        let context = ServiceContext(userIdentifier: "anon")
        let user = ServiceContainer(context: context, container: ServiceController.container)
        self.currentUser.value = user
    }
    
// =======================================================
// MARK: - Container
    
    public class func components<T: Any>(type: T.Type) -> [T]? {
        return self.sharedController.currentUser.value?.components(T)
    }
    
    public class func component<T: Any>(type: T.Type) -> T? {
        return self.sharedController.currentUser.value?.component(T)
    }

}
