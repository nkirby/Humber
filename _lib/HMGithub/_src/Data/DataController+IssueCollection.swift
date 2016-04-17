// =======================================================
// HMGithub
// Nathaniel Kirby
// =======================================================

import Foundation

import HMCore

// =======================================================

extension DataController {
    internal func currentIssueCollection() -> GithubIssueCollection? {
        return self.realm().objects(GithubIssueCollection.self).filter("userID == %@", self.userID).first
    }
    
    internal func newIssueCollection(write write: Bool = true) -> GithubIssueCollection {
        let collection = GithubIssueCollection()
        let block = {
            collection.userID = self.userID
            self.realm().add(collection, update: true)
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
        
        return collection
    }
}

// =======================================================

public protocol GithubAccountIssuesDataProviding {
    func currentAccountIssues() -> [GithubIssueModel]
    func saveCurrentIssues(issueResponses responses: [GithubIssueResponse], write: Bool)
}

extension DataController: GithubAccountIssuesDataProviding {
    public func currentAccountIssues() -> [GithubIssueModel] {
        return self.currentIssueCollection()?.issues.map { GithubIssueModel(object: $0) } ?? []
    }
    
    public func saveCurrentIssues(issueResponses responses: [GithubIssueResponse], write: Bool = true) {
        let block = {
            let collection: GithubIssueCollection
            if let obj = self.currentIssueCollection() {
                collection = obj
            } else {
                collection = self.newIssueCollection(write: false)
            }
            
            collection.issues.removeAll()
            
            for response in responses {
                self.saveIssue(issueResponse: response, write: false)
                
                if let issue = self.issueObj(issueID: response.issueID) {
                    collection.issues.append(issue)
                }
            }
        }
        
        if write {
            self.withRealmTransaction(block)
        } else {
            block()
        }
    }
}
