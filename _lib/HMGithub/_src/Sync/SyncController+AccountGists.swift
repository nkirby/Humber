// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubAccountGistsSyncProviding {
    func syncCurrentAccountGists() -> SignalProducer<Void, SyncError>
    func syncAccountGists(username username: String) -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubAccountGistsSyncProviding {
    public func syncCurrentAccountGists() -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIGistResponseProviding.self),
            let data = ServiceController.component(GithubAccountGistDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getGists()
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveAccountGists(gistResponses: responses, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
    
    public func syncAccountGists(username username: String) -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIGistResponseProviding.self),
            let data = ServiceController.component(GithubAccountGistDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getGists(username: username)
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveAccountGists(gistResponses: responses, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}
