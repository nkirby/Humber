// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubAccountFollowersSyncProviding {
    func syncAccountFollowers(username username: String) -> SignalProducer<Void, SyncError>
    func syncCurrentAccountFollowers() -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubAccountFollowersSyncProviding {
    public func syncAccountFollowers(username username: String) -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIUserFollowersProviding.self),
            let data = ServiceController.component(GithubAccountFollowersDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getFollowers(username: username)
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveAccountFollowers(userResponses: responses, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
        
    }
    
    public func syncCurrentAccountFollowers() -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIUserFollowersProviding.self),
            let data = ServiceController.component(GithubAccountFollowersDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getFollowers()
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveAccountFollowers(userResponses: responses, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}
