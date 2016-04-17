// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubIssueSyncProviding {
    func syncIssue(repoOwner repoOwner: String, repoName: String, issueNumber: String) -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubIssueSyncProviding {
    public func syncIssue(repoOwner repoOwner: String, repoName: String, issueNumber: String) -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPIIssueProviding.self),
            let data = ServiceController.component(GithubIssueDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getIssue(repoOwner: repoOwner, repoName: repoName, issueNumber: issueNumber)
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { response -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveIssue(issueResponse: response, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}
