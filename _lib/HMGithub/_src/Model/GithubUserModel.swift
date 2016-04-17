// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public struct GithubUserModel {
    public let login: String
    public let userID: String
    public let url: String
    public let type: String
    public let siteAdmin: Bool

// =======================================================
// MARK: - Response -> Model
    
    public init(response: GithubUserResponse) {
        self.login = response.login
        self.userID = response.userID
        self.url = response.url
        self.type = response.type
        self.siteAdmin = response.siteAdmin
    }
    
// =======================================================
// MARK: - Realm -> Model
    
    public init(object: GithubUser) {
        self.login = object.login
        self.userID = object.userID
        self.url = object.url
        self.type = object.type
        self.siteAdmin = object.siteAdmin
    }
}
