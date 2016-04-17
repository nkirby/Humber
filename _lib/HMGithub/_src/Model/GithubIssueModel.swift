// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation
import RealmSwift

// =======================================================

public struct GithubIssueModel {
    public let issueID: String
    
    public let url: String
    public let issueNumber: Int
    public let title: String
    public let state: String
    public let locked: Bool
    public let milestone: String
    public let comments: Int
    public let body: String
    
    public let user: GithubUserModel?
    public let assignee: GithubUserModel?
    public let repository: GithubRepoModel?

// =======================================================
// MARK: - Response -> Model
    
    public init(response: GithubIssueResponse) {
        self.issueID = response.issueID
        self.url = response.url
        self.issueNumber = response.issueNumber
        self.title = response.title
        self.state = response.state
        self.locked = response.locked
        self.milestone = response.milestone
        self.comments = response.comments
        self.body = response.body
        
        if let user = response.user {
            self.user = GithubUserModel(response: user)
        } else {
            self.user = nil
        }
        
        if let assignee = response.assignee {
            self.assignee = GithubUserModel(response: assignee)
        } else {
            self.assignee = nil
        }
        
        if let repository = response.repository {
            self.repository = GithubRepoModel(response: repository)
        } else {
            self.repository = nil
        }
    }
    
// =======================================================
// MARK: - Object -> Model
    
    public init(object: GithubIssue) {
        self.issueID = object.issueID
        self.url = object.url
        self.issueNumber = object.issueNumber
        self.title = object.title
        self.state = object.state
        self.locked = object.locked
        self.milestone = object.milestone
        self.comments = object.comments
        self.body = object.body
        
        if let user = object.user {
            self.user = GithubUserModel(object: user)
        } else {
            self.user = nil
        }
        
        if let assignee = object.assignee {
            self.assignee = GithubUserModel(object: assignee)
        } else {
            self.assignee = nil
        }
        
        if let repository = object.repository {
            self.repository = GithubRepoModel(object: repository)
        } else {
            self.repository = nil
        }
    }
}
