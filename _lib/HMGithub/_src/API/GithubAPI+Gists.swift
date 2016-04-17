// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

// =======================================================

public protocol GithubAPIGistResponseProviding {
    func getGists() -> SignalProducer<[GithubGistResponse], GithubAPIError>
    func getGists(username username: String) -> SignalProducer<[GithubGistResponse], GithubAPIError>
}

extension GithubAPI: GithubAPIGistResponseProviding {
    public func getGists() -> SignalProducer<[GithubGistResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/gists", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubGistResponse.self)
    }
    
    public func getGists(username username: String) -> SignalProducer<[GithubGistResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/user/\(username)/gists", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubGistResponse.self)
    }
}
