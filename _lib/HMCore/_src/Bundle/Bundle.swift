// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

private class CoreBundle {}

public class Bundle: NSObject {
    public static func mainBundle() -> NSBundle {
        return NSBundle.mainBundle()
    }
    
    public static func coreBundle() -> NSBundle {
        return NSBundle(forClass: CoreBundle.self)
    }
    
// =======================================================
// MARK: - Info Dict
    
    public static func infoDictionary() -> BundleInfoDictionary {
        return BundleInfoDictionary(infoDict: self.mainBundle().infoDictionary)
    }

}
