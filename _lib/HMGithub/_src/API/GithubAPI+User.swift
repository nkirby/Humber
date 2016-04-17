// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import ReactiveCocoa

// =======================================================
// MARK: - User Info

public protocol GithubAPIAccountResponseProviding {
    func getUserInfo() -> SignalProducer<GithubAccountResponse, GithubAPIError>
}

extension GithubAPI: GithubAPIAccountResponseProviding {
    public func getUserInfo() -> SignalProducer<GithubAccountResponse, GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/user", parameters: nil)
        return self.enqueueAndParse(request: request, toType: GithubAccountResponse.self)
    }
}

// =======================================================
// MARK: - Followers

public protocol GithubAPIUserFollowersProviding {
    func getFollowers() -> SignalProducer<[GithubUserResponse], GithubAPIError>
    func getFollowers(username username: String) -> SignalProducer<[GithubUserResponse], GithubAPIError>
}

extension GithubAPI: GithubAPIUserFollowersProviding {
    public func getFollowers() -> SignalProducer<[GithubUserResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/user/followers", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubUserResponse.self)
    }
    
    public func getFollowers(username username: String) -> SignalProducer<[GithubUserResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/users/\(username)/followers", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubUserResponse.self)
    }
}

// =======================================================
// MARK: - Following

public protocol GithubAPIUserFollowingProviding {
    func getFollowing() -> SignalProducer<[GithubUserResponse], GithubAPIError>
    func getFollowing(username username: String) -> SignalProducer<[GithubUserResponse], GithubAPIError>
}

extension GithubAPI: GithubAPIUserFollowingProviding {
    public func getFollowing() -> SignalProducer<[GithubUserResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/user/following", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubUserResponse.self)
    }
    
    public func getFollowing(username username: String) -> SignalProducer<[GithubUserResponse], GithubAPIError> {
        let request = GithubRequest(method: .GET, endpoint: "/users/\(username)/following", parameters: nil)
        return self.enqueueAndParseFeed(request: request, toType: GithubUserResponse.self)
    }
}