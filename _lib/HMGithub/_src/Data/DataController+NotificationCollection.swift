// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

extension DataController {
    internal func currentNotificationCollection() -> GithubNotificationCollection? {
        return self.realm().objects(GithubNotificationCollection.self).filter("userID == %@", self.userID).first
    }
    
    internal func newNotificationCollection(write write: Bool) -> GithubNotificationCollection {
        let collection = GithubNotificationCollection()
        let block = {
            collection.userID = self.userID
            self.realm().add(collection, update: true)
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
        
        return collection
    }
}
