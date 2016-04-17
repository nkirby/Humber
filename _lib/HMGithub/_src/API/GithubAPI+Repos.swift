// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

// =======================================================

public protocol GithubAPIReposProviding {
    func getRepos(type type: String) -> SignalProducer<[GithubRepoResponse], GithubAPIError>
}

extension GithubAPI: GithubAPIReposProviding {
    public func getRepos(type type: String) -> SignalProducer<[GithubRepoResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/user/repos", parameters: ["type": type])
        return self.enqueueAndParseFeed(request: request, toType: GithubRepoResponse.self)
    }
}
