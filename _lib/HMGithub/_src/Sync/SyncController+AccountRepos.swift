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
                    data.saveAccountRepos(repoResponses: responses, type: type, write: true)
                    
                    for response in responses {
                        if let owner = response.owner {
                            let item = SpotlightIndexableItem(title: response.fullName, contentDescription: response.repoDescription, identifier: "repos/\(owner.login)/\(response.name)", domain: "com.projectspong.Humber")
                            ServiceController.component(SpotlightIndexProviding.self)?.indexItem(item: item)
                        }
                    }
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}