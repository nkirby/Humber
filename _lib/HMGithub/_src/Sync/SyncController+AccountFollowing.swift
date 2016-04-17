// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubAccountFollowingSyncProviding {
    func syncAccountFollowing(username username: String) -> SignalProducer<Void, SyncError>
    func syncCurrentAccountFollowing() -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubAccountFollowingSyncProviding {
    public func syncAccountFollowing(username username: String) -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIUserFollowingProviding.self),
            let data = ServiceController.component(GithubAccountFollowingDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getFollowing(username: username)
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveAccountFollowing(userResponses: responses, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
        
    }
    
    public func syncCurrentAccountFollowing() -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIUserFollowingProviding.self),
            let data = ServiceController.component(GithubAccountFollowingDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getFollowing()
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveAccountFollowing(userResponses: responses, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}
