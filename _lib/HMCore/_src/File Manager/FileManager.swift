// =======================================================
// DevKit: Core
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public enum FileStorageContainerType {
    case AppGroupContainer
    case ApplicationSupport
    case Documents
}

// =======================================================

public final class FileManager: NSObject {
    private let fileStorageContainer: FileStorageContainerType
    private let realmPrefix: String
    
    public init(fileStorageContainer: FileStorageContainerType, realmPrefix: String) {
        self.fileStorageContainer = fileStorageContainer
        self.realmPrefix = realmPrefix
        
        super.init()
    }
    
// =======================================================
// MARK: - App Group Container
    
    public func containerURL() -> NSURL? {
        switch self.fileStorageContainer {
        case .AppGroupContainer:
            if let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.projectspong") {
                return url
            }
            
        case .ApplicationSupport:
            return try? NSFileManager.defaultManager().URLForDirectory(.ApplicationSupportDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true).URLByAppendingPathComponent("Humber")
            
        case .Documents:
            let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            return paths.first
        }

        return nil
    }

    internal func storageContainerURL() -> NSURL {
        if let url = self.containerURL() {
            return url
        }
        
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return paths.first!
    }
    
    public func containerRealmURL() -> NSURL {
        let url = self.storageContainerURL()
        let realmUrl = url.URLByAppendingPathComponent(self.realmPrefix, isDirectory: true)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(realmUrl.path!) {
            let _ = try? NSFileManager.defaultManager().createDirectoryAtURL(realmUrl, withIntermediateDirectories: true, attributes: nil)
        }
        
        return realmUrl
    }
    
    internal func containerDataURL() -> NSURL {
        let url = self.containerRealmURL()
        let dataURL = url.URLByAppendingPathComponent("data", isDirectory: true)
        
        if !NSFileManager.defaultManager().fileExistsAtPath(dataURL.path!) {
            let _ = try? NSFileManager.defaultManager().createDirectoryAtURL(dataURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        return dataURL
    }
    
// =======================================================
// MARK: - Account Data
    
    public func accountDataURL() -> NSURL {
        return self.containerDataURL().URLByAppendingPathComponent("groups", isDirectory: false)
    }

// =======================================================
// MARK: - Realms
    
    public func realmFolder(realmIdentifier realmIdentifier: String) -> NSURL {
        let url = self.containerDataURL()
        let userPath = url.URLByAppendingPathComponent("\(realmIdentifier)", isDirectory: true)
        if !NSFileManager.defaultManager().fileExistsAtPath(userPath.path!) {
            let _ = try? NSFileManager.defaultManager().createDirectoryAtURL(userPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        return userPath
    }
    
    public func realm(realmIdentifier realmIdentifier: String) -> NSURL {
        return self.realmFolder(realmIdentifier: realmIdentifier).URLByAppendingPathComponent("data.realm", isDirectory: false)
    }
}
