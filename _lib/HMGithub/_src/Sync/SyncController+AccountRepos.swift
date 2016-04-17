// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubAccountRepoSyncProviding {
    func syncAccountRepos(type type: GithubRepoType) -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubAccountRepoSyncProviding {
    public func syncAccountRepos(type type: GithubRepoType) -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIReposProviding.self),
            let data = ServiceController.component(GithubAccountRepoDataSaveProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getRepos(type: type.rawValue)
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    print("responses: \(responses.count)")
                    data.saveAccountRepos(repoResponses: responses, type: type, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}