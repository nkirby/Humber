// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

// =======================================================

public protocol GithubAPIIssueProviding {
    func getIssues() -> SignalProducer<[GithubIssueResponse], GithubAPIError>
    func getIssue(repoOwner repoOwner: String, repoName: String, issueNumber: String) -> SignalProducer<GithubIssueResponse, GithubAPIError>
}

extension GithubAPI: GithubAPIIssueProviding {
    public func getIssues() -> SignalProducer<[GithubIssueResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/user/issues", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubIssueResponse.self)
    }
    
    public func getIssue(repoOwner repoOwner: String, repoName: String, issueNumber: String) -> SignalProducer<GithubIssueResponse, GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/repos/\(repoOwner)/\(repoName)/issues/\(issueNumber)", parameters: nil)
        return self.enqueueAndParse(request: request, toType: GithubIssueResponse.self)
    }
}
