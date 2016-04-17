// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

import HMCore

// =======================================================

public protocol GithubOverviewDataProviding {
    func sortedOverviewItems() -> [GithubOverviewItemModel]
    func newOverviewItem(type type: String, write: Bool) -> GithubOverviewItemModel
    func removeOverviewItem(itemID itemID: String, write: Bool)
    func moveOverviewItem(itemID itemID: String, toPosition position: Int, write: Bool)
    func editOverviewItem(itemID itemID: String, title: String, write: Bool)
    func editOverviewItem(itemID itemID: String, title: String, repoName: String, repoOwner: String, type: String, threshold: Int, write: Bool)
}

extension DataController: GithubOverviewDataProviding {
    internal func currentOverview(write write: Bool = true) -> GithubOverview {
        let overview: GithubOverview
        if let obj = self.realm().objects(GithubOverview.self).filter("userID == %@", self.userID).first {
            overview = obj
        } else {
            overview = GithubOverview()
            overview.userID = self.userID
            
            if write {
                self.withRealmTransaction {
                    self.realm().add(overview, update: true)
                }
            } else {
                self.realm().add(overview, update: true)
            }
        }
        
        return overview
    }
    
    internal func overviewItem(itemID itemID: String) -> GithubOverviewItem? {
        return self.realm().objects(GithubOverviewItem.self).filter("itemID == %@", itemID).first
    }

    public func sortedOverviewItems() -> [GithubOverviewItemModel] {
        return self.currentOverview().items.map { GithubOverviewItemModel(object: $0) }
    }
    
    public func newOverviewItem(type type: String, write: Bool) -> GithubOverviewItemModel {
        let overview = GithubOverviewItem()
        let block = {
            overview.itemID = NSUUID().UUIDString
            overview.type = type
            self.realm().add(overview, update: true)
            
            overview.sortOrder =  self.currentOverview(write: false).items.count
            self.currentOverview(write: false).items.append(overview)
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
        
        return GithubOverviewItemModel(object: overview)
    }
    
    
    public func removeOverviewItem(itemID itemID: String, write: Bool) {
        let block = {
            if let obj = self.overviewItem(itemID: itemID) {
                self.realm().delete(obj)
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
    
    public func moveOverviewItem(itemID itemID: String, toPosition position: Int, write: Bool) {
        let block = {
            let overviewItems = self.currentOverview(write: false).items
            if let obj = self.overviewItem(itemID: itemID), let idx = overviewItems.indexOf(obj) {
                overviewItems.removeAtIndex(idx)
                overviewItems.insert(obj, atIndex: position)
                
                var idx = 0
                for item in overviewItems {
                    item.sortOrder = idx
                    idx += 1
                }
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
    
    public func editOverviewItem(itemID itemID: String, title: String, write: Bool) {
        let block = {
            if let obj = self.overviewItem(itemID: itemID) {
                obj.title = title
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
    
    public func editOverviewItem(itemID itemID: String, title: String, repoName: String, repoOwner: String, type: String, threshold: Int, write: Bool) {
        let block = {
            if let obj = self.overviewItem(itemID: itemID) {
                obj.title = title
                obj.repoName = repoName
                obj.repoOwner = repoOwner
                obj.threshold = threshold
                obj.action = type
                obj.query = "\(repoOwner)/\(repoName)/\(type)".lowercaseString
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}
