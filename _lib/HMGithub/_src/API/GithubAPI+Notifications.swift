// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

// =======================================================

public protocol GithubAPINotificationProviding {
    func getNotifications() -> SignalProducer<[GithubNotificationResponse], GithubAPIError>
}

extension GithubAPI: GithubAPINotificationProviding {
    public func getNotifications() -> SignalProducer<[GithubNotificationResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/notifications", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubNotificationResponse.self)
    }
}
