// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubAccountIssuesSyncProviding {
    func syncAccountIssues() -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubAccountIssuesSyncProviding {
    public func syncAccountIssues() -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIIssueProviding.self),
            let data = ServiceController.component(GithubAccountIssuesDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getIssues()
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveCurrentIssues(issueResponses: responses, write: true)
                    
                    for response in responses {
                        if let repo = response.repository, let owner = repo.owner {
                            //issues/:username/:repoName/issues/:issueNumber
                            let item = SpotlightIndexableItem(title: response.title, contentDescription: response.body, identifier: "\(owner.login)/\(repo.name)/issues/\(response.issueNumber)", domain: "com.projectspong.Humber")
                            ServiceController.component(SpotlightIndexProviding.self)?.indexItem(item: item)
                        }
                    }
                    

                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}