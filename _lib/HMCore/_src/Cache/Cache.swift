// =======================================================
// DevKit: Core
// Nathaniel Kirby
// =======================================================

import Foundation
import PINCache
import Async

// =======================================================

public struct CacheableItem {
    public let identifier: String
    public let item: NSCoding
    
    public init(identifier: String, item: NSCoding) {
        self.identifier = identifier
        self.item = item
    }
}

// =======================================================

public class Cache: NSObject {
    internal let cache: PINCache
    
// =======================================================
// MARK: - Init, etc...
    
    public init(identifier: String) {
        self.cache = PINCache(name: identifier)
        super.init()
        
        self.deleteOldItems()
    }
    
// =======================================================
// MARK: - Saving
    
    public final func saveItem(item cacheableItem: CacheableItem) {
        self.cache.setObject(cacheableItem.item, forKey: cacheableItem.identifier)
    }
    
// =======================================================
// MARK: - Retrieval
    
    public final func item(identifier identifier: String) -> CacheableItem? {
        guard let object = self.cache.objectForKey(identifier) as? NSCoding else {
            return nil
        }
        
        return CacheableItem(identifier: identifier, item: object)
    }

// =======================================================
// MARK: - Removal
    
    public final func deleteItem(identifier identifer: String) {
        self.cache.removeObjectForKey(identifer)
    }
    
    public final func deleteAllItems() {
        self.cache.removeAllObjects()
    }
    
    public final func deleteOldItems() {
        Async.background {
            let date = NSDate(timeIntervalSinceNow: (-2 * 86400))
            self.cache.trimToDate(date)
        }
    }
}
