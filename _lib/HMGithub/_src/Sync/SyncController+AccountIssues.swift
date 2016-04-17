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
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}