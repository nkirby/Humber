// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubAccountSyncProviding {
    func syncCurrentGithubAccount() -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubAccountSyncProviding {
    public func syncCurrentGithubAccount() -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIAccountResponseProviding.self),
            let data = ServiceController.component(GithubAccountDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getUserInfo()
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { response -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveCurrentUser(accountResponse: response, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}
