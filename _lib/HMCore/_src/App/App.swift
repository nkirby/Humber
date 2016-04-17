// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

//public enum AppIdentifier {
//    case Humber
//}

// =======================================================

public final class AppInfo: NSObject {
    public let identifier: String
    public let appGroup: String
    public let bundleIdentifier: String
    public let version: String

// =======================================================
// MARK: - Current
    
    internal(set) public static var currentApp: AppInfo!
    
// =======================================================
// MARK: - Init, etc...
    
    internal init(appIdentifier: String) {
        self.identifier = appIdentifier
        self.appGroup = "com.projectspong"
        self.bundleIdentifier = Bundle.infoDictionary().value(.Identifier) ?? ""
        self.version = Bundle.infoDictionary().value(.Version) ?? ""
        
        super.init()
    }
}
