// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa
import Janus

// =======================================================

public protocol GithubAPIQueryCountsProviding {
    func getCounts(query query: String) -> SignalProducer<Int, GithubAPIError>
}

extension GithubAPI: GithubAPIQueryCountsProviding {
    public func getCounts(query query: String) -> SignalProducer<Int, GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: query, parameters: nil)
        return self.enqueueOnly(request: request)
            .flatMap(.Latest, transform: { response -> SignalProducer<Int, GithubAPIError> in
                return SignalProducer { observer, _ in
                    if let arr = response as? JSONArray {
                        observer.sendNext(arr.count)
                        observer.sendCompleted()
                    } else {
                        observer.sendFailed(GithubAPIError.Unknown)
                    }
                }
            })
    }
}