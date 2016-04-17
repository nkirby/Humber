// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public enum BundleInfoKey: String {
    case DictionaryVersion = "CFBundleInfoDictionaryVersion"
    case DisplayName = "CFBundleDisplayName"
    case Executable = "CFBundleExecutable"
    case Identifier = "CFBundleIdentifier"
    case Name = "CFBundleName"
    case ShortVersion = "CFBundleShortVersionString"
    case Version = "CFBundleVersion"
}

public final class BundleInfoDictionary: NSObject {
    private let infoDict: [NSObject: AnyObject]?
    
    public init(infoDict: [NSObject: AnyObject]?) {
        self.infoDict = infoDict
        super.init()
    }
    
    public func value<T: Equatable>(key: BundleInfoKey) -> T? {
        return self.infoDict?[key.rawValue] as? T
    }
}