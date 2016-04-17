// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Result

import HMCore

// =======================================================

public protocol GithubNotificationsSyncProviding {
    func syncAccountNotifications() -> SignalProducer<Void, SyncError>
}

extension SyncController: GithubNotificationsSyncProviding {
    public func syncAccountNotifications() -> SignalProducer<Void, SyncError> {
        guard let api = ServiceController.component(GithubAPINotificationProviding.self),
            let data = ServiceController.component(GithubNotificationDataProviding.self) else {
                return SignalProducer.empty
        }
        
        return api.getNotifications()
            .observeOn(CoreScheduler.background())
            .mapError { _ in return SyncError.Unknown }
            .flatMap(.Latest, transform: { responses -> SignalProducer<Void, SyncError> in
                return SignalProducer { observer, _ in
                    data.saveAccountNotifications(notificationResponses: responses, write: true)
                    
                    observer.sendNext()
                    observer.sendCompleted()
                }
            })
    }
}
