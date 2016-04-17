// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import Janus

import HMCore

// =======================================================

public struct GithubIssueResponse: JSONDecodable {
    public let url: String
    public let repositoryURL: String
    public let labelsURL: String
    public let commentsURL: String
    public let eventsURL: String
    public let htmlURL: String
    public let issueID: String
    public let issueNumber: Int
    public let title: String
    public let state: String
    public let locked: Bool
    public let milestone: String
    public let comments: Int
    public let body: String
    
    public let user: GithubUserResponse?
    public let assignee: GithubUserResponse?
    public let repository: GithubRepoResponse?
    
    // labels
    // createdAt
    // updatedAt
    // closedAt
    
// =======================================================
// MARK: - Init, etc...
    
    public init?(json: JSONValue<JSONDictionary>) {
        if let issueID = json["id"].to(String.self) {
            self.issueID = issueID
        } else if let issueID = json["id"].to(Int.self) {
            self.issueID = "\(issueID)"
        } else {
            return nil
        }

        self.url = json["url"].stringValue(defaultValue: "")
        self.repositoryURL = json["repository_url"].stringValue(defaultValue: "")
        self.labelsURL = json["labels_url"].stringValue(defaultValue: "")
        self.commentsURL = json["comments_url"].stringValue(defaultValue: "")
        self.eventsURL = json["events_url"].stringValue(defaultValue: "")
        self.htmlURL = json["html_url"].stringValue(defaultValue: "")
        self.issueNumber = json["number"].intValue(defaultValue: 0)
        self.title = json["title"].stringValue(defaultValue: "")
        self.state = json["state"].stringValue(defaultValue: "open")
        self.locked = json["locked"].boolValue(defaultValue: false)
        self.milestone = json["milestone"].stringValue(defaultValue: "")
        self.comments = json["comments"].intValue(defaultValue: 0)
        self.body = json["body"].stringValue(defaultValue: "")
        
        if let userDict = json["user"].jsonDictionaryValue() {
            self.user = JSONParser.model(GithubUserResponse.self).from(userDict)
        } else {
            self.user = nil
        }
        
        if let assigneeDict = json["assignee"].jsonDictionaryValue() {
            self.assignee = JSONParser.model(GithubUserResponse.self).from(assigneeDict)
        } else {
            self.assignee = nil
        }
        
        if let repoDict = json["repository"].jsonDictionaryValue() {
            self.repository = JSONParser.model(GithubRepoResponse.self).from(repoDict)
        } else {
            self.repository = nil
        }
    }
}
