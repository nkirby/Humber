// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubOverviewSyncProviding {
    var didChangeOverviewNotification: String { get }
    
    func addOverviewItem(type type: String) -> SignalProducer<Void, SyncError>
    func deleteOverviewItem(itemID itemID: String) -> SignalProducer<Void, SyncError>
    func moveOverviewItem(itemID itemID: String, toPosition position: Int) -> SignalProducer<Void, SyncError>
    
    func editOverviewItem(itemID itemID: String, title: String) -> SignalProducer<Void, SyncError>
    func editOverviewItem(itemID itemID: String, title: String, repoName: String, repoOwner: String, type: String, threshold: Int) -> SignalProducer<Void, SyncError>
    
    func syncOverviewItem(itemID itemID: String) -> SignalProducer<Void, SyncError>
}

// =======================================================

extension SyncController: GithubOverviewSyncProviding {
    public var didChangeOverviewNotification: String {
        return "HMDidChangeOverviewNotification"
    }
    
    public func addOverviewItem(type type: String) -> SignalProducer<Void, SyncError> {
        return SignalProducer { observer, _ in
            guard let data = ServiceController.component(GithubOverviewDataProviding.self) else {
                observer.sendFailed(SyncError.Unknown)
                return
            }
            
            data.newOverviewItem(type: type, write: true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(self.didChangeOverviewNotification, object: nil)
            
            observer.sendNext()
            observer.sendCompleted()
        }
    }
    
    public func deleteOverviewItem(itemID itemID: String) -> SignalProducer<Void, SyncError> {
        return SignalProducer { observer, _ in
            guard let data = ServiceController.component(GithubOverviewDataProviding.self) else {
                observer.sendFailed(SyncError.Unknown)
                return
            }
            
            data.removeOverviewItem(itemID: itemID, write: true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(self.didChangeOverviewNotification, object: nil)
            
            observer.sendNext()
            observer.sendCompleted()
        }
    }
    
    public func moveOverviewItem(itemID itemID: String, toPosition position: Int) -> SignalProducer<Void, SyncError> {
        return SignalProducer { observer, _ in
            guard let data = ServiceController.component(GithubOverviewDataProviding.self) else {
                observer.sendFailed(.Unknown)
                return
            }
            
            data.moveOverviewItem(itemID: itemID, toPosition: position, write: true)

            NSNotificationCenter.defaultCenter().postNotificationName(self.didChangeOverviewNotification, object: nil)
            
            observer.sendNext()
            observer.sendCompleted()
        }
    }
    
    public func editOverviewItem(itemID itemID: String, title: String) -> SignalProducer<Void, SyncError> {
        return SignalProducer { observer, _ in
            guard let data = ServiceController.component(GithubOverviewDataProviding.self) else {
                observer.sendFailed(.Unknown)
                return
            }
            
            data.editOverviewItem(itemID: itemID, title: title, write: true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(self.didChangeOverviewNotification, object: nil)
            
            observer.sendNext()
            observer.sendCompleted()
        }
    }
    
    public func editOverviewItem(itemID itemID: String, title: String, repoName: String, repoOwner: String, type: String, threshold: Int) -> SignalProducer<Void, SyncError> {
        return SignalProducer { observer, _ in
            guard let data = ServiceController.component(GithubOverviewDataProviding.self) else {
                observer.sendFailed(.Unknown)
                return
            }
            
            data.editOverviewItem(itemID: itemID, title: title, repoName: repoName, repoOwner: repoOwner, type: type, threshold: threshold, write: true)
            
            NSNotificationCenter.defaultCenter().postNotificationName(self.didChangeOverviewNotification, object: nil)
            
            observer.sendNext()
            observer.sendCompleted()
        }
    }
    
    public func syncOverviewItem(itemID itemID: String) -> SignalProducer<Void, SyncError> {
        return SignalProducer { observer, disposable in
            guard let api = ServiceController.component(GithubAPIQueryCountsProviding.self),
                let data = ServiceController.component(GithubOverviewDataProviding.self),
                let item = data.overviewItem(itemID: itemID) else {
                    observer.sendFailed(SyncError.Unknown)
                    return
            }
            
            let disp = api.getCounts(query: item.query)
                .on(failed: { _ in observer.sendFailed(.Unknown) })
                .startWithNext { count in
                    data.editOverviewItem(itemID: item.itemID, value: count, write: true)
                    observer.sendNext()
                    observer.sendCompleted()
                }
            
            disposable.addDisposable(disp)
        }
    }
}
