// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

// =======================================================

public struct GithubGistModel {
    public let url: String
    public let gistID: String
    public let htmlURL: String
    public let gistPublic: Bool
    public let gistDescription: String
    public let comments: Int
    public let commentsURL: String
    public let truncated: Bool
    
    public let owner: GithubUserModel

// =======================================================
// MARK: - Response -> Model
    
    public init(response: GithubGistResponse) {
        self.url = response.url
        self.gistID = response.gistID
        self.htmlURL = response.htmlURL
        self.gistPublic = response.gistPublic
        self.gistDescription = response.gistDescription
        self.comments = response.comments
        self.commentsURL = response.commentsURL
        self.truncated = response.truncated
        
        self.owner = GithubUserModel(response: response.owner)
    }
    
    public init?(object: GithubGist) {
        self.url = object.url
        self.gistID = object.gistID
        self.htmlURL = object.htmlURL
        self.gistPublic = object.gistPublic
        self.gistDescription = object.gistDescription
        self.comments = object.comments
        self.commentsURL = object.commentsURL
        self.truncated = object.truncated
        
        if let owner = object.owner {
            self.owner = GithubUserModel(object: owner)
        } else {
            print("nope!")
            return nil
        }
    }
}
