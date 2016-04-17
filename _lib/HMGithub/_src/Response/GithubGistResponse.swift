// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus

import HMCore

// =======================================================

public struct GithubGistResponse: JSONDecodable {
    public let url: String
    public let forksURL: String
    public let commitsURL: String
    public let gistID: String
    public let gitPullURL: String
    public let gitPushURL: String
    public let htmlURL: String
    public let gistPublic: Bool
    public let gistDescription: String
    public let comments: Int
    public let commentsURL: String
    public let owner: GithubUserResponse
    public let truncated: Bool
    
    // createdAt
    // updatedAt
    
// =======================================================
// MARK: - Init, etc...
    
    public init?(json: JSONValue<JSONDictionary>) {
        guard let gistID = json["id"].stringValue(),
            let ownerDict = json["owner"].jsonDictionaryValue(),
            let owner = JSONParser.model(GithubUserResponse.self).from(ownerDict) else {
                return nil
        }
        
        self.url = json["url"].stringValue(defaultValue: "")
        self.forksURL = json["forks_url"].stringValue(defaultValue: "")
        self.commitsURL = json["commits_url"].stringValue(defaultValue: "")
        self.gistID = gistID
        self.gitPullURL = json["git_pull_url"].stringValue(defaultValue: "")
        self.gitPushURL = json["git_push_url"].stringValue(defaultValue: "")
        self.htmlURL = json["html_url"].stringValue(defaultValue: "")
        self.gistPublic = json["public"].boolValue(defaultValue: true)
        self.gistDescription = json["description"].stringValue(defaultValue: "")
        self.comments = json["comments"].intValue(defaultValue: 0)
        self.commentsURL = json["comments_url"].stringValue(defaultValue: "")
        self.truncated = json["truncated"].boolValue(defaultValue: false)
        self.owner = owner
    }
}
