// =======================================================
// HMCore
// Nathaniel Kirby
// =======================================================

import Foundation
import FDKeychain

// =======================================================

public protocol KeychainStorageProviding: class {
    static func itemForKey(key: String!, forService service: String!, inAccessGroup accessGroup: String!) throws -> AnyObject
    static func itemForKey(key: String!, forService service: String!) throws -> AnyObject
    
    static func saveItem(item: NSCoding!, forKey key: String!, forService service: String!, inAccessGroup accessGroup: String!, withAccessibility accessibility: FDKeychainAccessibility) throws
    static func saveItem(item: NSCoding!, forKey key: String!, forService service: String!) throws

    static func deleteItemForKey(key: String!, forService service: String!, inAccessGroup accessGroup: String!) throws
    static func deleteItemForKey(key: String!, forService service: String!) throws
}

extension FDKeychain: KeychainStorageProviding {}

// =======================================================

public final class KeychainStore: NSObject {
    internal var keychainProvider: KeychainStorageProviding.Type = FDKeychain.self
    
    private let tokenKey: String
    private let accessGroup: String
    
    public init(accessGroup: String = "") {
        self.tokenKey = "token"
        self.accessGroup = accessGroup
        
        super.init()
    }
    
// =======================================================
// MARK: - Token Retrieval

    public func keychainItem(query queryItem: KeychainStoreQuery?) -> [String: AnyObject]? {
        guard let query = queryItem else {
            return nil
        }
        
        do {
            let useAccessGroup = query.useAccessGroup
            let item: [String: AnyObject]?
            
            if useAccessGroup {
                item = try self.keychainProvider.itemForKey(self.tokenKey, forService: query.serviceKey, inAccessGroup: self.accessGroup) as? [String: AnyObject]
            } else {
                item = try self.keychainProvider.itemForKey(self.tokenKey, forService: query.serviceKey) as? [String: AnyObject]
            }

            return item
            
        } catch {
            let errorCode = (error as NSError).code
            
            if errorCode != -25300 {
                print("KeychainStore Error: \(error)")
            }
        }
        
        return nil
    }
    
// =======================================================
// MARK: - Token Saving
    
    public func saveKeychainItem(dict: [String: AnyObject], forQuery query: KeychainStoreQuery) -> Bool {
        do {
            let useAccessGroup = query.useAccessGroup
            if useAccessGroup {
                try self.keychainProvider.saveItem(dict, forKey: self.tokenKey, forService: query.serviceKey, inAccessGroup: self.accessGroup, withAccessibility: FDKeychainAccessibility.AccessibleAfterFirstUnlock)
            } else {
                try self.keychainProvider.saveItem(dict, forKey: self.tokenKey, forService: query.serviceKey)
            }
            
            return true
            
        } catch {
            return false
        }
    }
    
// =======================================================
// MARK: - Token Deletion
    
    public func deleteKeychainItem(forQuery query: KeychainStoreQuery) -> Bool {
        do {
            let useAccessGroup = query.useAccessGroup
            if useAccessGroup {
                try self.keychainProvider.deleteItemForKey(self.tokenKey, forService: query.serviceKey, inAccessGroup: self.accessGroup)
            } else {
                try self.keychainProvider.deleteItemForKey(self.tokenKey, forService: query.serviceKey)
            }
            
            return true
            
        } catch {
            return false
            
        }
    }
}
