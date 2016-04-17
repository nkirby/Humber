// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

public protocol GithubIssueDataProviding {
    //repoOwner: self.repoOwner, repoName: self.repoName, issueNumber: self.issueNumber
    func issue(issueID issueID: String) -> GithubIssueModel?
    func issue(repoName repoName: String, issueNumber: Int) -> GithubIssueModel?
    func saveIssue(issueResponse response: GithubIssueResponse, write: Bool)
    func saveIssues(issueResponses responses: [GithubIssueResponse], write: Bool)
}

extension DataController: GithubIssueDataProviding {
    internal func issueObj(issueID issueID: String) -> GithubIssue? {
        return self.realm().objects(GithubIssue.self).filter("issueID == %@", issueID).first
    }
    
    internal func issueObj(repoName repoName: String, issueNumber: Int) -> GithubIssue? {
        return self.realm().objects(GithubIssue.self).filter("repository.name == %@ && issueNumber = %d", repoName, issueNumber).first
    }

    public func issue(issueID issueID: String) -> GithubIssueModel? {
        if let issue = self.issueObj(issueID: issueID) {
            return GithubIssueModel(object: issue)
        }
        
        return nil
    }
    
    public func issue(repoName repoName: String, issueNumber: Int) -> GithubIssueModel? {
        if let issue = self.issueObj(repoName: repoName, issueNumber: issueNumber) {
            return GithubIssueModel(object: issue)
        }
        
        return nil
    }
    
    public func saveIssue(issueResponse response: GithubIssueResponse, write: Bool) {
        let block = {
            let issue: GithubIssue
            if let obj = self.issueObj(issueID: response.issueID) {
                issue = obj
            } else {
                issue = GithubIssue()
                issue.issueID = response.issueID
                self.realm().add(issue, update: true)
            }
            
            issue.url = response.url
            issue.issueNumber = response.issueNumber
            issue.title = response.title
            issue.state = response.state
            issue.locked = response.locked
            issue.milestone = response.milestone
            issue.comments = response.comments
            issue.body = response.body
            
            if let userResponse = response.user {
                self.saveUser(response: userResponse, write: false)
                
                if let obj = self.userObj(userID: userResponse.userID) {
                    issue.user = obj
                }
            }
            
            if let assigneeResponse = response.assignee {
                self.saveUser(response: assigneeResponse, write: false)
                
                if let obj = self.userObj(userID: assigneeResponse.userID) {
                    issue.assignee = obj
                }
            }
            
            if let repoResponse = response.repository {
                self.saveRepo(repoResponse: repoResponse, write: false)
                
                if let obj = self.repoObj(repoID: repoResponse.repoID) {
                    issue.repository = obj
                }
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
    
    public func saveIssues(issueResponses responses: [GithubIssueResponse], write: Bool) {
        let block = {
            for response in responses {
                self.saveIssue(issueResponse: response, write: false)
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}
